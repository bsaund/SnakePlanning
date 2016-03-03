classdef HebiPlotter < handle
    % HebiPlotter visualize realistic looking HEBI modules
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
    %   Examples:
    %      plt = HebiPlotter();
    %      plt.plot([.1,.1]);
    %
    %      plt = HebiPlotter(16, 'resolution', 'high');
    %      plt.plot(zeros(16,1));
    
    methods(Access = public)
        %Constructor
        function this = HebiPlotter(varargin)
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
            this.kin.setBaseFrame(frame);
        end
        
    end
    
    methods(Access = private, Hidden = true)
        
        function updatePlot(this, angles)
        %UPDATEPLOT updates the link patches that were previously plotted
            fk = this.kin.getForwardKinematics('CoM',angles);
            [upper, lower] = this.loadMeshes();
            
            if(strcmpi(this.frameType, 'VC'))
                this.frame = this.frame*unifiedVC(fk, eye(3), eye(3));
                this.setBaseFrame(inv(this.frame));
            end


            h = this.handles;
            if(~ishandle(h(1,1)))
                error('Plotting window has been closed. Exiting program.');
            end
            angleInd = 1;
            for i=1:this.kin.getNumBodies()
                if(strcmp(this.jointTypes{i}{1}, 'FieldableElbowJoint'))
                    fv = this.transformSTL(lower, fk(:,:,i));
                    set(h(i,1), 'Vertices', fv.vertices(:,:));
                    set(h(i,1), 'Faces', fv.faces);

                    fv = this.transformSTL(upper, fk(:,:,i)*this.roty(angles(angleInd)));
                    set(h(i,2), 'Vertices', fv.vertices(:,:));
                    set(h(i,2), 'Faces', fv.faces);
                    angleInd = angleInd + 1;
                else
                    fv = this.transformSTL(this.getCylinder(this.jointTypes{i}),...
                                           fk(:,:,i));
                    set(h(i,1), 'Vertices', fv.vertices(:,:));
                    set(h(i,1), 'Faces', fv.faces);
                end
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
            
            this.handles = zeros(n, 2);
            [upper, lower] = this.loadMeshes();
            
            if(strcmpi(this.frameType, 'VC'))
                this.frame = unifiedVC(fk, eye(3));
                this.setBaseFrame(inv(this.frame));
                fk = this.kin.getForwardKinematics('CoM', angles);
            end
            
            
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
                if(strcmp(this.jointTypes{i}{1}, 'FieldableElbowJoint'))
                    this.handles(i,:) = ...
                        this.patchHebiElbow(lower, upper, fk(:,:,i), ...
                                       angles(angleInd), lightStyle, ...
                                            strength);
                    angleInd = angleInd + 1;
                else
                    this.handles(i,1) = ...
                        this.patchCylinder(fk(:,:,i), this.jointTypes{i});
                end
            end
            axis('image');
            view([45, 35]);
            xlabel('x');
            ylabel('y');
            zlabel('z');
        end
        
        function h = patchHebiElbow(this,lower, upper, fk, angle, ...
                                    lightStyle, strength)
            h(1,1) =  ...
                patch(this.transformSTL(lower, fk), ...
                      'FaceColor', [.5,.1,.2],...
                      'EdgeColor', 'none',...
                      'FaceLighting', lightStyle, ...
                      'AmbientStrength', strength);
            h(1,2) = ...
                patch(this.transformSTL(upper, fk*this.roty(angle)), ...
                'FaceColor', [.5,.1,.2],...
                'EdgeColor', 'none',...
                'FaceLighting', lightStyle, ...
                'AmbientStrength', strength);
        end
        
        function [upper, lower] = loadMeshes(this)
        %Returns the relevent meshes
        %Based on low_res different resolution meshes will be loaded
            stldir = [fileparts(mfilename('fullpath')), '/stl'];
            
            if(this.lowResolution)
                meshes = load([stldir, '/FieldableKinematicsPatchLowRes.mat']);
            else
                meshes = load([stldir, './stl/FieldableKinematicsPatch.mat']);
            end
            lower = meshes.lower;
            upper = meshes.upper;

        end
        
        function h = patchCylinder(this, fk, types)
            
            h = patch(this.transformSTL(this.getCylinder(types), fk), ...
                      'FaceColor', [.5, .5, .5],...
                      'EdgeColor', 'none',...
                      'FaceLighting', 'gouraud',...
                      'AmbientStrength',.1);
        end
        
        function cyl = getCylinder(this, types)
            p = inputParser();
            p.addParameter('ext1', .4);
            p.addParameter('twist', 0);
            parse(p, types{2:end});
            r = .025;
            h = p.Results.ext1 + .015; %Add a bit for connection section
            [x,y,z] = cylinder;
            cyl = surf2patch(r*x, r*y, h*(z -.5));
        end
        
        function fv = transformSTL(this, fv, trans)
        %Transforms from the base frame of the mesh to the correctly
        %location in space
            fv.vertices = (trans * [fv.vertices, ones(size(fv.vertices,1), ...
                                                      1)]')';
            fv.vertices = fv.vertices(:,1:3);

        end
        

        function m = roty(this, theta)
        %Homogeneous transform matrix for a rotation about y
            m = [cos(theta),  0, sin(theta), 0;
                 0,           1, 0,          0;
                 -sin(theta), 0, cos(theta), 0;
                 0,           0, 0,          1];
        end
    end
    
    properties(Access = private, Hidden = true)
        kin;
        jointTypes;
        handles;
        lowResolution;
        firstRun;
        lighting;
        frameType;
        frame;
        drawNow;
    end
end