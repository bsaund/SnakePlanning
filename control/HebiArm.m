classdef HebiArm
%MinJerkTrajectory generates nice trajectories for SEAs
%   Detailed explanation goes here ...
    
    properties(Access = public)
        minMoveTime = 2.0;
        maxSpeeds = [];
        damperGains = [];  % N or Nm / m/s
        springGains = [];  % N/m or Nm/rad
        maxTorqueLimit = 20; % Nm
        maxTorqueError = 10; % Nm
        dtSample = .001; % sec
        torqueOffsets = [];
        gravityVector;
        interpMethod = 'spline';
        joystick;
        
        tocHist = 0;
    end
    
    properties(SetAccess = private)
        group;
        kin;
    end
    
    properties(Access = private)
        % avoid unnecessary java allocations
        reusableCmd; 
        reusableFbk;
    end
    
    methods
        
        function this = HebiArm(group, kin, gravityVector)
            if(nargin < 3)
                gravityVector = [0;0;1];
            end
            
            % HebiGroup
            this.group = group; 
            this.reusableCmd = CommandStruct();
            this.reusableFbk = group.getNextFeedbackFull();
            
            % HebiKinematics
            this.kin = kin;
            
            % Other
            this.gravityVector = gravityVector;
            
        end
        
        function [ abortFlag ] = moveJoint(this, waypoints, moveTime)
        % Follows waypoints by interpolating in jointspace 
            if nargin < 3
                moveTime = []; 
            end
            
            % New heuristic that respects joint speed limits
            numWaypoints = size(waypoints,1);
            poseDiff = abs( diff( waypoints ) );
            timeDiff = max( poseDiff ./ repmat(this.maxSpeeds,numWaypoints-1,1), [], 2 );
            
            phaseDiff = cumsum(timeDiff) / sum(timeDiff);
            regPhase = [ 0 phaseDiff' ];
            
            if isempty(moveTime)
                moveTime = max(sum(timeDiff), this.minMoveTime);
            end
            
            % follow trajectory
            abortFlag = this.minJerkMove(regPhase, waypoints, moveTime);
        end
        
        function [abortFlag] = moveLinear(this, waypoints, moveTime)
        % Follows a line in XYZ space between 2 waypoints
            if nargin < 3
                moveTime = []; 
            end
            
            % Interpolate between XYZ endpoint positions 
            T0 = this.kin.getFK('EndEffector', waypoints(1,:));
            T1 = this.kin.getFK('EndEffector', waypoints(end,:));
            
            xyzWaypoints = nan(3,2);
            xyzWaypoints(:,1) = T0(1:3,4);
            xyzWaypoints(:,2) = T1(1:3,4);
            regPhase = [ 0 1 ];
            
            upSamplePoints = 20;
            upSampledPhase = linspace(0,1,upSamplePoints);
            upSampledXYZ = interp1(regPhase, xyzWaypoints', upSampledPhase, 'linear' );
            upSampledAngles = interp1(regPhase, waypoints, upSampledPhase, 'linear' );
            
            % Disable so3 IK on 'large' rotations
            diffDCM = T0(1:3,1:3) * T1(1:3,1:3)';
            axisAngle = SpinCalc('DCMtoEV',diffDCM,[],0);
            if abs(axisAngle(4))>180
                axisAngle(4) = axisAngle(4) - sign(axisAngle(4))*360;
            end
            
            looseIK = abs(axisAngle(4)) > 45;
            if looseIK
                display('Large Orientation Change.  Doing "Loose" IK.');
            end

            % Get the joint angles for each waypoint
            IKAngles = nan(upSamplePoints,this.kin.getNumDoF());
            for i=1:upSamplePoints
                
                initAngles = upSampledAngles(i,:);

                if looseIK
                    IKAngles(i,:) = getInverseKinematics( this.kin, ...
                                                          'xyz', upSampledXYZ(i,:)', ...
                                                          'initial', initAngles );
                else
                    cmdDCM = this.kin.getFK('EndEffector', initAngles);
                    IKAngles(i,:) = getInverseKinematics( this.kin, ...
                                                          'xyz', upSampledXYZ(i,:)', ...
                                                          'so3', cmdDCM, ...
                                                          'initial', initAngles );
                end
            end
            
            % Heuristic that respects joint speed limits
            if isempty(moveTime)
                
                angleDiff = abs( diff( IKAngles ) );
                timeDiff = max( abs(angleDiff) ./ ...
                                repmat(this.maxSpeeds,upSamplePoints-1,1), [], 2 );
                
                moveTime = max(sum(timeDiff), this.minMoveTime);
            end
            
            % follow trajectory
            abortFlag = this.minJerkMove(upSampledPhase, IKAngles, moveTime);
            
        end
        
    end
    
    methods(Access = private)
        
        function abortFlag = minJerkMove(this, upSampledPhase, upSampledAngles, moveTime)
        % follows a set of waypoints by interpolating in joint space
        % and commanding a minimum jerk trajectory
            
            jerkCoeffs = minimumJerk( 0, 0, 0, ... % Starting Phase/Vel/Accel
                                      1, 0, 0, ... % Ending Phase/Vel/Accel
                                      moveTime);  % Time to touchdown
            
            abortFlag = false;
            
            t = tic;
            tocNow = 0;
            tocLast = 0;
            
            % Initialize fields that get used in loop
            cmd = this.reusableCmd;

            while tocNow < moveTime
                
                % Timekeeping
                tocNow = toc(t);
                dt = tocNow - tocLast;
                tocLast = tocNow;
                
                % Get the latest Feedback
                fbk = this.group.getNextFeedback(this.reusableFbk);
                
                %%%%%%%%%%%%%%%%%%
                % Abort Checks   %
                %%%%%%%%%%%%%%%%%%
                if isempty(fbk) || any(isnan(fbk.position))
                    display('Stopping motions due to empty feedback!');
                    abortFlag = true;
                    this.setEmptyCommand();
                    break;
                end
                if this.isAbortedByUser()
                    display('Stopping motions due to user request!');
                    abortFlag = true;
                    this.setEmptyCommand();
                    break;
                end
                if this.exceedsTorqueError(fbk)
                    display('Stopping motions due to large torque error!');
                    abortFlag = true;
                    this.setEmptyCommand();
                    break;
                end
                
                % Shared variables
                fbkAngles = fbk.position;
                fbkVelocity = fbk.velocity;
                JendEffector = this.kin.getJacobian('EndEffector', fbkAngles);
                
                %%%%%%%%%%%%%%%%%%
                % Trajectory     %
                %%%%%%%%%%%%%%%%%%
                [cmdAngles, cmdVelocities, cmdTorques] = this.calculateMinJerkCommands( ...
                    jerkCoeffs, upSampledPhase, upSampledAngles, fbkAngles, tocNow);
                
                %%%%%%%%%%%%%%%%%%
                % Virtual Damper %
                %%%%%%%%%%%%%%%%%%
                if ~isempty(this.damperGains)
                    [dampTorques] = this.calculateVirtualDamper(fbk.velocityCmd, fbkVelocity, JendEffector);
                    cmdTorques = cmdTorques + dampTorques;
                end
                
                %%%%%%%%%%%%%%%%%%
                % Virtual Spring %
                %%%%%%%%%%%%%%%%%%
                if ~isempty(this.springGains)
                    [springTorques] = this.calculateVirtualSpring(cmdAngles, fbkAngles, JendEffector);
                    cmdTorques = cmdTorques + springTorques;
                end
                
                %%%%%%%%%%%%%%%%%%
                % Manual Fudging %
                %%%%%%%%%%%%%%%%%%
                if ~isempty(this.torqueOffsets)
                    cmdTorques = cmdTorques + this.torqueOffsets;
                end
                
                %%%%%%%%%%%%%%%%%%
                % Safety Checks  %
                %%%%%%%%%%%%%%%%%% 
                % Stop Sending Commands if commanded torques go insance
                if this.exceedsTorqueLimit(cmdTorques)
                    display('Stopping motions due to torque limits!');
                    abortFlag = true;
                    this.setEmptyCommand();
                    break;
                end

                % Send the Commands
                cmd.position = cmdAngles;
                cmd.velocity = cmdVelocities;
                cmd.torque = cmdTorques;
                this.group.set(cmd);

            end

        end
        
        function [cmdAngles, cmdVelocities, cmdTorques] = calculateMinJerkCommands(this, ...
                                                              jerkCoeffs, phase, angles, fbkPosition, tocNow)
            
            % Simplified, knowing first 3 coeffs = 0
            phaseNow = jerkCoeffs(4)*tocNow.^3 + ...
                jerkCoeffs(5)*tocNow.^4 + ...
                jerkCoeffs(6)*tocNow.^5;
            %phaseNow = max(min(phaseNow,1),0);
            
            phaseNext = jerkCoeffs(4)*(tocNow+this.dtSample).^3 + ...
                jerkCoeffs(5)*(tocNow+this.dtSample).^4 + ...
                jerkCoeffs(6)*(tocNow+this.dtSample).^5;
            %phaseNext = max(min(phaseNext,1),0);
            
            phaseLast = jerkCoeffs(4)*(tocNow-this.dtSample).^3 + ...
                jerkCoeffs(5)*(tocNow-this.dtSample).^4 + ...
                jerkCoeffs(6)*(tocNow-this.dtSample).^5;
            %phaseLast = max(min(phaseLast,1),0);
            
            % MATLAB interp1
            % Get the positions/velocities/accelerations along the trajectory
            sampleAnglesNow = ...
                interp1(phase, angles, phaseNow, this.interpMethod);
            sampleAnglesNext = ...
                interp1(phase, angles, phaseNext, this.interpMethod);
            sampleAnglesLast = ...
                interp1(phase, angles, phaseLast, this.interpMethod);

            %             % Faster interp from Matlab File Exchange
            %             % Get the positions/velocities/accelerations along the trajectory
            %             sampleAnglesNow = ...
            %                 interp1qr(phase', angles, phaseNow);
            %             sampleAnglesNext = ...
            %                 interp1qr(phase', angles, phaseNext);
            %             sampleAnglesLast = ...
            %                 interp1qr(phase', angles, phaseLast);
            %             
            cmdAngles = sampleAnglesNow;
            cmdVelocities = (sampleAnglesNext - sampleAnglesLast) / (2*this.dtSample);
            cmdAccels = (sampleAnglesNext + sampleAnglesLast - 2*sampleAnglesNow) / (this.dtSample^2);
            
            % Get the desired forces to compensate for gravity
            % and joint accelerations
            accelCompTorque = this.kin.getDynamicCompTorques(fbkPosition, cmdAngles, cmdVelocities, cmdAccels);
            gravCompTorque = this.kin.getGravCompTorques(fbkPosition, this.gravityVector);
            cmdTorques = gravCompTorque + accelCompTorque;

        end
        
        function springTorques = calculateVirtualSpring(this, cmdAngles, fbkAngles, JendEffector)
            cmdT = this.kin.getFK('EndEffector', cmdAngles);
            fbkT = this.kin.getFK('EndEffector', fbkAngles);

            % XYZ Compensation
            endEffectorXYZError = fbkT(1:3,4) - cmdT(1:3,4);
            
            springWrenchVec = zeros(6,1);
            springWrenchVec(1:3) = -this.springGains(1:3) .* endEffectorXYZError;
            
            % Orientation Compensation
            DCM_EndEffector = fbkT(1:3,1:3);
            DCM_Target = cmdT(1:3,1:3);
            
            % Get the rotation error
            SO3_Error = DCM_Target * DCM_EndEffector';
            

            % Get axis-angle representation to get the correcting wrench
            axisAngle = SpinCalc('DCMtoEV',SO3_Error,[],0);
            if abs(axisAngle(4))>180
                axisAngle(4) = axisAngle(4) - sign(axisAngle(4))*360;
            end
            
            axisError = deg2rad(axisAngle(4)) * axisAngle(1:3)';
            springWrenchVec(4:6) = -this.springGains(4:6) .* axisError;
            
            springTorques = (JendEffector' * springWrenchVec)';
            
        end
        
        function dampTorques = calculateVirtualDamper(this, cmdVelocity, fbkVelocity, JendEffector)

            endEffectorVelCmd = JendEffector * cmdVelocity';
            endEffectorVelFbk = JendEffector * fbkVelocity';
            
            endEffectorVelError = endEffectorVelFbk - endEffectorVelCmd;
            
            dampWrenchVec = -this.damperGains .* endEffectorVelError;
            
            dampTorques = (JendEffector' * dampWrenchVec)';

        end
        
        function abort = isAbortedByUser(this)
        % Click Left Joystick to end
            if ~isempty(this.joystick)
                [axes, buttons, povs] = read( this.joystick );
                abort = buttons(11);
            else
                abort = 0;
            end
        end
        
        function abort = exceedsTorqueError(this, fbk)
        % Checks whether the max torque error is too big
        % max(abs(fbk.torque - fbk.torqueCmd))
            abort = max(abs(fbk.torque - fbk.torqueCmd)) > this.maxTorqueError;
        end
        
        function abort = exceedsTorqueLimit(this, torque)
            abort = max(abs(torque)) > this.maxTorqueLimit;
        end
        
        function [] = setEmptyCommand(this)
        % Stops all velocity/position/torque commands on the group
            cmd = this.reusableCmd;
            cmd.torque = [];
            cmd.velocity = [];
            cmd.position = [];
            
            for i=1:100;
                this.group.set(cmd);
                pause(.01);
            end
        end
        
    end
    
end

