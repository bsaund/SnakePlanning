classdef CylinderPlotter < handle
%CYLINDERPLOTTER visualize modular kinematics chains as cylinders
%
%   This wraps draw_snake to provide a simple interface to 
%    plot snakes (SEA-snake) as cylinders.
%
%   CylinderPlotter Methods (constructor):
%      CylinderPlotter  - constructor
%
%   CylinderPlotter Methods:
%      plot             - plots the robot in the specified
%                         configuration
%      setBaseFrame     - sets the frame of the first link
%
%    Examples:
%        plt = CylinderPlotter();
%        plt.plt([.1,.1]);
    
    methods(Access = public)
        %Constructor
        function this=CylinderPlotter(varargin)
            p = inputParser;
            expectedFrames = {'Base', 'VC'};
            
            addParameter(p, 'frame', 'Base');
            parse(p, varargin{:});
            
            this.moduleData.length = .0639;
            this.moduleData.diameter = 0.0540;
            this.firstRun = true;
            this.kin = HebiKinematics();
            this.frameType = p.Results.frame;
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
            if(strcmpi(this.frameType, 'VC'))
                this.frame = this.frame*unifiedVC(fk, eye(3), eye(3));
                this.setBaseFrame(inv(this.frame));
            end

            this.animateStruct = ...
                draw_snake(this.animateStruct,fk,...
                           this.moduleData.length, ...
                           this.moduleData.diameter); 
            drawnow();
        end
        
        function initialPlot(this, angles)

            for i=1:length(angles)
                this.kin.addBody('FieldableElbowJoint');
            end
            fk = this.kin.getFK('Output', angles);
            fk = fk(:,:,end:-1:1);
            if(strcmpi(this.frameType, 'VC'))
                this.frame = unifiedVC(fk, eye(3));
                this.setBaseFrame(inv(this.frame));
                fk = this.kin.getForwardKinematics('CoM', angles);
            end

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
        frame;
        frameType;
    end
    
end