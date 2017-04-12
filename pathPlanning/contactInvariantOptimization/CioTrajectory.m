classdef CioTrajectory < handle
    
    
    methods(Access = public)
        
        function this = CioTrajectory(varargin)
            p = inputParser;
            p.addParameter('arm', []);
            p.addParameter('numTimeSteps', 0);
            p.addParameter('numContacts', 0);
            p.addParameter('world', []);
            
            p.parse(varargin{:});
            

            this.numTimeSteps = p.Results.numTimeSteps;
            this.numContacts = p.Results.numContacts;
            this.world = p.Results.world;
            this.arm = p.Results.arm;
            
            % showWorld(this.world);
            
            this.numJoints = this.arm.kin.getNumDoF;
            this.numConLoc = this.arm.kin.getNumBodies;
            this.closestPointCalculator = ClosestPointCalculator(this.world);
        end
        
        function [angles, contacts] = ...
                separateStateWithInitial(this, state)
            [angles, c] = this.separateState(state);
            angles = [this.startAngles, angles];
            contacts = [zeros(size(c,1),1), c];

        end
        
        function [angles, contacts] = separateState(this, state)
            n = this.numJoints * this.numTimeSteps;
            angles = reshape(state(1:n),...
                            this.numJoints,...
                            this.numTimeSteps);
            contacts = reshape(state(n+1:end),...
                              this.numConLoc,...
                              this.numContacts);
            contacts = repelem(contacts, 1, ceil(this.numTimeSteps/...
                                              this.numContacts));
            contacts = contacts(:, 1:this.numTimeSteps);
            % contacts(8:10) = 0;
        end
        
        function [x] = combineState(this, angles, contacts)
            angles = reshape(angles, this.numJoints * size(angles,2), ...
                             1);
            contacts = reshape(contacts, this.numConLoc * size(contacts,2), ...
                               1);
            x = [angles; contacts];
        end
        
        function [optimizedAngles, contacts] = optimizeTrajectory(this, varargin)
            [options, initial_angles, initial_c, goal_xyz] = ...
                this.parseOptimizeInput(varargin{:});
                
            func = this.getTrajectoryCostFunction(goal_xyz);
            [lb, ub] = this.getBounds(initial_angles, initial_c);
            initial_state = [initial_angles; initial_c];

            [x,resnorm,residual,exitflag,output] = ... 
                lsqnonlin(func, initial_state, lb, ub, options);
            [optimizedAngles, contacts] = this.separateStateWithInitial(x);
            final_cost = func(x, true)

        end
        
        function [optimizedAngles, contacts, eePoint] = optimizePoint(this, varargin)
            [options, initial_angles, initial_c, goal_xyz] = ...
                this.parseOptimizeInput(varargin{:});
                
            func = this.getStaticCostFunction(goal_xyz);
            [lb, ub] = this.getBounds(initial_angles, initial_c);
            initial_state = [initial_angles; initial_c];
            [x,resnorm,residual,exitflag,output] = ... 
                lsqnonlin(func, initial_state, lb, ub, options);
            [optimizedAngles, contacts] = this.separateState(x);

            fk = this.arm.getKin.getFK('EndEffector', optimizedAngles);
            eePoint = fk(1:3,4);
            final_cost = func(x, true);
            final_cost_val = final_cost'*final_cost
        end
    end
    
    methods(Access = public, Hidden = true)
        function [options, initial_angles, initial_c, goal_xyz] = ...
                parseOptimizeInput(this, varargin)
            p = inputParser;
            
            expectedDisplayTypes = {'raw', 'optimized', 'progress', ...
                                'none'};
            p.addParameter('EndEffectorGoal', []);
            p.addParameter('InitialAngles', zeros(this.numJoints,1));
            p.addParameter('SeedAngles', ...
                           zeros(this.numJoints * this.numTimeSteps,1));
            p.addParameter('maxIter', 1000);
            p.addParameter('display', false, ...
                           @(x) any(validatestring(x, ...
                                                   expectedDisplayTypes)));
            p.parse(varargin{:});
            
            goal_xyz = p.Results.EndEffectorGoal;
            this.startAngles = p.Results.InitialAngles;

            if(strmatch('SeedAngles', p.UsingDefaults))
                initial_angles = repmat(p.Results.InitialAngles, ...
                                        this.numTimeSteps,1);
            else
                initial_angles = p.Results.SeedAngles;
            end
            % initial_c = repmat(0*p.Results.InitialAngles, ...
            %                    this.numContacts,1) + 10;
            initial_c = 10*ones(this.numConLoc * this.numContacts, 1);

            
            maxIter = p.Results.maxIter;
            display = p.Results.display;
            if(strcmpi('raw',display) || strcmpi('optimized',display))
                options = optimoptions('lsqnonlin','maxIter', maxIter, ...
                                       'maxFunEvals', maxIter,...
                                       'OutputFcn', ...
                                       this.getPlotFunc(display),...
                                       'display', 'iter');
            elseif(strcmpi('progress', display))
                options = optimoptions('lsqnonlin','maxIter', maxIter,...
                                       'display','iter');
            else
                options = optimoptions('lsqnonlin','maxIter', maxIter,...
                                       'maxFunEvals', maxIter, ...
                                       'display','none');
            end
        end
        
        function [lb, ub] = getBounds(this, angles, c)
            lb = [ones(numel(angles),1)*-pi/2;
                  zeros(numel(c),1);];
            ub = [ones(numel(angles),1)*pi/2;
                  ones(numel(c),1)*100];
        end

        function func = getTrajectoryCostFunction(this, goal_xyz)
            function c = cost(state, debug)
                if(nargin < 2)
                    debug = false;
                end
                [angles, con] = this.separateState(state);

                fk = this.arm.getKin.getFK('EndEffector', angles(:,end));
                pointErr = fk(1:3, 4) - goal_xyz;

                cPh = costPhysics(this.arm, this.world, ...
                                  [this.startAngles, angles],...
                                  con);
                cDistance = 10*costDistErr([this.startAngles, angles]).^2;
                cTask = 1000*pointErr;
                
                
                cCI = [];
                cObstacle = [];
                for angleSet = 1:size(angles,2)
                    fkCom = this.arm.getKin.getFK('CoM', angles(:,angleSet));                
                    pCenter = squeeze(fkCom(1:3,4,:));
                    [pClosest, closestFace] = ...
                        this.closestPointCalculator.getClosestPointsFast(pCenter);
                    
                    cCI = [cCI;
                           100*costContactViolation(pCenter, pClosest, ...
                                   this.arm.radius, con(:,angleSet))];
                    
                    % cCI = 100*costContactViolation(this.arm, this.world, ...
                    %                                angles, con);
                    
                    
                    % cObstacle = 1000*costObjectViolation(this.arm, ...
                    %                                      this.world, angles);
                    cObstacle = [cObstacle;
                                 1000*costObjectViolation(pCenter, pClosest, ...
                                      this.world.normals(closestFace,:))];
                end
                    % c = [cPh; cCI; cTask; cObstacle; cDistance];
                c = [cPh; cCI; cTask; cObstacle];
                % c = [cPh; cTask; cObstacle];
                if(debug)
                    cPh = reshape(cPh, this.numJoints, this.numTimeSteps)
                    cCI = reshape(cCI, this.numConLoc*3, this.numTimeSteps)
                    cTask
                    cObstacle = reshape(cObstacle, this.numConLoc, this.numTimeSteps)
                end
            end
            func = @cost;
        end

        function func = getStaticCostFunction(this, goal_xyz);
            function c = cost(state, debug)
                if(nargin < 2)
                    debug = false;
                end

                [angles, con] = this.separateState(state);

                fk = this.arm.getKin.getFK('EndEffector', angles);
                fkCom = this.arm.getKin.getFK('CoM', angles);

                pCenter = squeeze(fkCom(1:3,4,:));
                % [pClosest, closestFace] = closestPoints(pCenter, this.world);
                [pClosest, closestFace] = ...
                    this.closestPointCalculator.getClosestPointsFast(pCenter);
                
                
                pointErr = fk(1:3, 4) - goal_xyz;

                cPh = costPhysicsStatic(this.arm, this.world, angles, con);
                % cPh = costPhysics(this.arm, this.world, angles, c);

                cCI = 100*costContactViolation(pCenter, pClosest, ...
                                               this.arm.radius, con);
                
                
                cTask = 100*pointErr;
                cObstacle = 1000*costObjectViolation(pCenter, pClosest, ...
                                                     this.world.normals(closestFace,:));

                c = [cPh; cCI; cTask; cObstacle;];

                if(debug)
                    cPh = reshape(cPh, this.numJoints, this.numTimeSteps)
                    cCI = reshape(cCI, this.numTimeSteps*3, this.numConLoc)'
                    cTask
                    cObstacle = reshape(cObstacle, this.numConLoc, this.numTimeSteps)
                end

                % c = [cPh; cCI; cTask];
            end
            func = @cost;
        end

        function plotFunc = getPlotFunc(this, displayType)
            function stop = plotter(x, varargin)
                [angles, c] = this.separateState(x);
                
                if(strcmpi(displayType, 'optimized'))
                    optAngles = optimizeSinglePoint(this.arm, ...
                                                    this.world, ...
                                                    angles, false);
                end
                if(size(angles,2) > 1)
                    [angles, c] = this.separateStateWithInitial(x);
                    for i=1:size(angles,2)
                        this.arm.plotTorques(angles(:,i), this.world, ...
                                             10000);
                        pause(.4)
                    end
                else
                    this.arm.plotTorques(angles, this.world, ...
                                         10000);
                end

                stop = false;
            end
            plotFunc = @plotter;
        end
        
    end
    methods(Static)
        function m = roty(theta)
        %Homogeneous transform matrix for a rotation about y
            m = [cos(theta),  0, sin(theta), 0;
                 0,           1, 0,          0;
                 -sin(theta), 0, cos(theta), 0;
                 0,           0, 0,          1];
        end

    end
    
    properties(Access = public, Hidden = false)
        arm
        closestPointCalculator;
        numJoints
        numConLoc
        numTimeSteps
        numContacts
        world
        startAngles;
    end
    
end