classdef CylinderPlotter < handle
    
    methods(Access = public)
        %Constructor
        function this=CylinderPlotter(varargin)
            this.moduleData.length = .0639;
            this.moduleData.diameter = 0.0540;
            this.firstRun = true;
            this.kin = HebiKinematics();
        end
        
        function plot(this,angles)
            if(this.firstRun)
                this.initialPlot(angles);
                this.firstRun = false;
            else
                this.updatePlot(angles);
            end
        end
        
        function setBaseFrame(this, frame)
            this.kin.setBaseFrame(frame);
        end
    end
    
    methods(Access = private, Hidden = true)
        
        function updatePlot(this, angles)
            fk = this.kin.getFK('Output', angles);
            fk = fk(:,:,end:-1:1);
            this.animateStruct = ...
                draw_snake(this.animateStruct,fk,...
                           this.moduleData.length, ...
                           this.moduleData.diameter); 

        end
        
        function initialPlot(this, angles)

            for i=1:length(angles)
                this.kin.addBody('FieldableElbowJoint');
            end
            fk = this.kin.getFK('Output', angles);
            fk = fk(:,:,end:-1:1);
            this.animateStruct = ...
                draw_snake(struct(),fk,...
                           this.moduleData.length, ...
                           this.moduleData.diameter); 
        end
    end
    
    properties(Access = private, Hidden = true)
        moduleData;
        animateStruct;
        firstRun;
        kin;
    end
    
end