classdef HebiPlotter < handle
    methods(Access = public)
        function this = HebiPlotter(numLinks, varargin)
            p = inputParser;
            expectedResolutions = {'low', 'high'};
            
            addRequired(p, 'numLinks', @isnumeric);
            addParameter(p, 'resolution', 'low', ...
                         @(x) any(validatestring(x, expectedResolutions)));
            parse(p, numLinks, varargin{:})
            
            this.kin = HebiKinematics();
            for i=1:numLinks
                this.kin.addBody('FieldableElbowJoint');
            end
            
            this.lowResolution = strcmpi(p.Results.resolution, 'low');
            % this = this.initialPlot();
            this.firstRun = true;
        end
        
        function plot(this, angles)
            if(this.firstRun)
                initialPlot(this, angles);
                this.firstRun = false;
            else
                updatePlot(this, angles);
            end
            drawnow
        end
        
    end
    
    methods(Access = private, Hidden = true)
        
        function updatePlot(this, angles)
        %Updates the link patches that were previously plotted
            fk = this.kin.getForwardKinematics('CoM',angles);
            [upper, lower] = this.loadMeshes();

            h = this.handles;
            for i=1:this.kin.getNumBodies()
                fv = this.transformSTL(lower, fk(:,:,i));
                set(h(i,1), 'Vertices', fv.vertices(:,:));
                set(h(i,1), 'Faces', fv.faces);

                fv = this.transformSTL(upper, fk(:,:,i)*this.roty(angles(i)));
                set(h(i,2), 'Vertices', fv.vertices(:,:));
                set(h(i,2), 'Faces', fv.faces);
            end
        end

        function this = initialPlot(this, angles)
            n = this.kin.getNumBodies();

            fk = this.kin.getForwardKinematics('CoM', angles);
            this.handles = zeros(n, 2);
            [upper, lower] = this.loadMeshes();
            for i=1:n
                this.handles(i,1) =  ...
                    patch(this.transformSTL(lower, fk(:,:,i)), ...
                          'FaceColor', [.5,.1,.2],...
                          'EdgeColor', 'none',...
                          'FaceLighting', 'gouraud', ...
                          'AmbientStrength', 0.3);
                this.handles(i,2) = ...
                    patch(this.transformSTL(upper, fk(:,:,i)*...
                                            this.roty(angles(i))), ...
                          'FaceColor', [.5,.1,.2],...
                          'EdgeColor', 'none',...
                          'FaceLighting', 'gouraud', ...
                          'AmbientStrength', 0.3);
            end
            light('Position',[0,0,10]);
            light('Position',[5,0,10]);
            light('Position',[-5,0,10]);
            axis('image');
            view([45, 35]);
            xlabel('x');
            ylabel('y');
            zlabel('z');
        end
        
        function [upper, lower] = loadMeshes(this)
        %Returns the relevent meshes
        %Based on low_res different resolution meshes will be loaded
            
            if(this.lowResolution)
                meshes = load('FieldableKinematicsPatchLowRes');
            else
                meshes = load('FieldableKinematicsPatch');
            end
            lower = meshes.lower;
            upper = meshes.upper;

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
        handles;
        lowResolution;
        firstRun
    end
end