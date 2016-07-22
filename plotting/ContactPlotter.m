classdef ContactPlotter < handle
% CONTACTPLOTTER was copied from SpherePlotter
% The intention is to visualize a hebi linkage as spheres
%
    
    methods(Access = public)
        %Constructor
        function this = ContactPlotter(cpCalc);
            this.cpCalc = cpCalc;
            this.plotInitialized = false;
            this.radius = 0.02;
        end
        
        function plot(this, points, inContact)
        % PLOT plots the robot in the configuration specified by
        % angles
            
            if(~this.plotInitialized)
                initialPlot(this, points);
            end

            updatePlot(this, points, inContact);
            drawnow
        end
        
        function clearPlot(this)
        %Clears the plot
            h = this.handles;
            if(~ishandle(h(1,1)))
                error('Plotting window has been closed. Exiting program.');
            end
            for i=1:size(h,1)
                delete(h(i,1));
            end
            this.plotInitialized = false;
        end
        
    end
    
    methods(Access = private, Hidden = true)

        function updatePlot(this, points, inContact)
        %UPDATEPLOT updates the link patches that were previously plotted
            h = this.handles;
            if(~ishandle(h(1,1)))
                error('Plotting window has been closed. Exiting program.');
            end
            n = length(inContact);
            cp = this.cpCalc.getClosestPoints(points);
            for i=1:n
                set(h(i,1), 'Vertices', this.getCircle(cp(:,i)));
                if(inContact(i) > 0.5)
                    set(h(i,1), 'FaceColor', 'r');
                else
                    set(h(i,1), 'FaceColor', 'none');
                end
            end
        end

        function this = initialPlot(this, points)
        %INITIALPLOT creates patches representing the CAD of the
        %manipulator
            n = size(points,2);
            this.handles = zeros(n, 1);
            cp = this.cpCalc.getClosestPoints(points);
            for i=1:n
                vert = this.getCircle(cp(:,i))
                this.handles(i,1) = ...
                    fill3(vert(:,1), vert(:,2), vert(:,3), 'r',...
                          'EdgeColor', 'none');
            end

            this.plotInitialized = true;
        end
        
        function vert = getCircle(this, p0)
            r = this.radius;
            t = 0:.1:1;
            x = sin(t*2*pi)*r + p0(1);
            y = cos(t*2*pi)*r + p0(2);
            z = 0*t + p0(3) + 0.001;
            vert = [x', y', z'];
        end
        
        
    end
    
    properties(Access = public, Hidden = true)
        handles;
        plotInitialized;
        radius;
    end
    
    properties(Access = public, Hidden = true)
        cpCalc
    end

end