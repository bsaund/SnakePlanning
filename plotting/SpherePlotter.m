classdef SpherePlotter < handle
    % SPHEREPLOTTER was copied from HebiPlotter
    % The intention is to visualize a hebi linkage as spheres
    %
    %   Currently only the HEBI elbow joints (snake links) and pipe
    %   joints can be plotted
    %
    %   HebiPlotter Methods (constructor):
    %      HebiPlotter  - constructor
    %
    %   HebiPlotter Methods:
    %      plot         - plots the robot in the specified configuation
    %      setBaseFrame - sets the frame of the first link
    %
    %   Examples:n
    %      plt = HebiPlotter();
    %      plt.plot([.1,.1]);
    %
    %      plt = HebiPlotter(16, 'resolution', 'high');
    %      plt.plot(zeros(16,1));
    
    methods(Access = public)
        %Constructor
        function this = SpherePlotter(varargin)
        %HEBIPLOTTER
        %Arguments:
        %
        %Optional Parameters:
        %  'resolution'        - 'low' (default), 'high' 
        %  'lighting'          - 'on' (default), 'off'
        %  'frame'             - 'base' (default), 'VC'
        %  'JointTypes'        - cell array of joint types
        %
        %Examples:
        %  plt = HebiPlotter(16)
        %  plt = HebiPlotter(4, 'resolution', 'high')
        %
        %  links = {{'FieldableElbowJoint'},
        %           {'FieldableStraightLink', 'ext1', .1, 'twist', 0}};
        %  plt = HebiPlotter('JointTypes', links)  


        
            p = inputParser;
            expectedResolutions = {'low', 'high'};
            expectedLighting = {'on','off', 'far'};
            expectedFrames = {'Base', 'VC'};
            
            % addRequired(p, 'numLinks', @isnumeric);
            addParameter(p, 'resolution', 'low', ...
                         @(x) any(validatestring(x, ...
                                                 expectedResolutions)));
            addParameter(p, 'frame', 'Base',...
                         @(x) any(validatestring(x, expectedFrames)));

            addParameter(p, 'lighting', 'on',...
                         @(x) any(validatestring(x, ...
                                                 expectedLighting)));
            addParameter(p, 'JointTypes', {});
            addParameter(p, 'drawWhen', 'now');

            parse(p, varargin{:});
            
            
            this.lowResolution = strcmpi(p.Results.resolution, 'low');

            this.firstRun = true;
            this.lighting = p.Results.lighting;
            this.setKinematicsFromJointTypes(p.Results.JointTypes);
            this.frameType = p.Results.frame;
            this.drawNow = strcmp(p.Results.drawWhen, 'now');
            this.radius = .028;
            this.frame = eye(4);
        end
        
        function plot(this, angles)
        % PLOT plots the robot in the configuration specified by
        % angles
            
            if(~isnumeric(angles))
                try
                    angles = angles.position;
                catch
                    error(['Input needs to be either a list of angles ' ...
                           'or feedback']);
                end
            end
                


                
            if(this.firstRun)
                initialPlot(this, angles);
                this.firstRun = false;
            else
                updatePlot(this, angles);
            end
            if(this.drawNow)
                drawnow
            end
        end
        
        function setBaseFrame(this, frame)
        %SETBASEFRAME sets the frame of the first link in the kinematics
        %chain
        %
        % Arguments:
        % frame (required)    -  a 4x4 homogeneous matrix 
            this.frame = frame;
            this.kin.setBaseFrame(frame);
        end
        
        function [tau, grav] = getTorques(this, angles, world, spring)
            J = this.kin.getJacobian('CoM', angles);
            p = this.getPoints(angles);
            z_axis = this.frame(1:3, 1:3) * [0;0;1];
            grav = this.kin.getGravCompTorques(angles, -z_axis)';
            stl.faces = world.faces;
            stl.vertices = world.vertices;
            tau = snakeContactTorques(p, stl, this.radius, spring, ...
                                              J);
            tau = tau+grav;
            
        end
        
        function plotTorques(this, angles, world, spring, ...
                             torque_limit)
            if(nargin < 5)
                torque_limit = 2;
            end
            tau = this.getTorques(angles, world, spring);
            this.drawNow = false;
            this.plot(angles);
            this.updatePlotColors(abs(tau)/torque_limit);
            this.drawNow = true;
            drawnow;
        end
        
        function [p, r] = getPoints(this, angles)
            if(this.firstRun)
                this.plot(angles);
            end
            fk = this.kin.getForwardKinematics('CoM',angles);
            for i = 1:this.kin.getNumBodies()
                p(1:3,i) = fk(1:3,4,i);
            end
            r = this.radius;
        end
        
        function kin = getKin(this)
            kin = this.kin;
        end
        
        function remakeKin(this)
            this.setKinematicsFromJointTypes(this.jointTypes);
            this.setBaseFrame(this.frame);
            this.firstRun = true;
        end
        
        function J = getJacobian(this, angles)
            if (length(angles) == length(this.prevJacobianAngles) && ...
                max(abs(angles - this.prevJacobianAngles)) < 0.01)
                J = this.prevJacobian;
                return;
            end
            this.prevJacobianAngles = angles;
            J = this.kin.getJacobian('CoM', angles);
            this.prevJacobian = J;
        end
        
        function tau = getGravTorques(this, angles)
            if (length(angles) == length(this.prevGravTorqueAngles) && ...
                max(abs(angles - this.prevGravTorqueAngles)) < 0.01)
                tau = this.prevGravTorques;
                return;
            end
            
            this.prevGravTorqueAngles = angles;
            this.prevGravTorques = ...
                this.kin.getGravCompTorques(angles, [0 0 -1])';
            tau = this.prevGravTorques;
        end
        
    end
    
    methods(Access = private, Hidden = true)
        
        function updatePlotColors(this, weights)
            red = [1,0,0];
            grey = [.7,.7,.7];
            black = [0,0,0];
            
            h = this.handles;
            for i=1:this.kin.getNumBodies()
                w = weights(i);
                color = red*w + grey*(1-w);
                if(w>1)
                    color = black;
                end
                set(h(i,1), 'FaceColor', color);
            end
        end
        
        function updatePlot(this, angles)
        %UPDATEPLOT updates the link patches that were previously plotted
            fk = this.kin.getForwardKinematics('CoM',angles);
            
            h = this.handles;
            if(~ishandle(h(1,1)))
                error('Plotting window has been closed. Exiting program.');
            end
            angleInd = 1;
            for i=1:this.kin.getNumBodies()
                
                fv = this.getSphere(fk(1:3,4,i));

                set(h(i,1), 'Vertices', fv.vertices(:,:));
                set(h(i,1), 'Faces', fv.faces);

            end
        end
        
        function initializeKinematics(this, numLinks)
        %INITIALIZEKINEMATICS creates a default kinematics object
        %if one has not already been assigned.
            if(this.kin.getNumBodies > 0)
                return;
            end
            
            for i=1:numLinks
                this.kin.addBody('FieldableElbowJoint');
                this.jointTypes{i} = {'FieldableElbowJoint'};
            end
        end
        
        function setKinematicsFromJointTypes(this, types)
            this.kin = HebiKinematics();
            this.jointTypes = types;
            if(length(types) == 0)
                return;
            end
            for i = 1:length(types)
                this.kin.addBody(types{i}{:});
            end
        end

        function this = initialPlot(this, angles)
        %INITIALPLOT creates patches representing the CAD of the
        %manipulator
            

            this.initializeKinematics(length(angles));
            n = this.kin.getNumBodies();

            
            fk = this.kin.getForwardKinematics('CoM', angles);
            
            this.handles = zeros(n, 1);

            
            if(strcmp(this.lighting, 'on'))
                light('Position',[0,0,10]);
                light('Position',[5,0,10]);
                light('Position',[-5,0,10]);
                lightStyle = 'gouraud';
                strength = .3;
            elseif(strcmp(this.lighting, 'far'))
                c = [.7,.7,.7];
                light('Position',[0,0,100],'Color',c);
                light('Position',[-100,0,0],'Color',c);
                light('Position',[100,0,0],'Color',c);
                light('Position',[0,-100,0], 'Color',c);
                light('Position',[0,100,0],'Color',c);
                lightStyle = 'flat';
                strength = 1.0;
            else
                lightStyle = 'flat';
                strength = 1.0;
            end
            
            angleInd = 1;
            for i=1:this.kin.getNumBodies
                this.handles(i,1) = ...
                    this.patchSphere(fk(:,:,i));

            end
            axis('image');
            view([45, 35]);
            xlabel('x');
            ylabel('y');
            zlabel('z');
        end
        
        
        
        function h = patchSphere(this, fk)
            h = patch(this.getSphere(fk(1:3,4)),...
                      'FaceColor', [.5, .5, .5],...
                      'EdgeColor', 'none',...
                      'FaceLighting', 'gouraud',...
                      'AmbientStrength',.1);
        end
        
        function cyl = getSphere(this, p0)
            r = this.radius;
            [x,y,z] = sphere;
            cyl = surf2patch(r*x + p0(1), r*y + p0(2), r*z + p0(3));
        end
        
    end
    
    properties(Access = public, Hidden = true)
        kin;
        jointTypes;
        handles;
        lowResolution;
        firstRun;
        lighting;
        frameType;
        frame;
        drawNow;
        radius;
    end
    
    properties(Access = private, Hidden = true)
        prevGravTorqueAngles;
        prevGravTorques;
        prevJacobianAngles;
        prevJacobian;
    end

end