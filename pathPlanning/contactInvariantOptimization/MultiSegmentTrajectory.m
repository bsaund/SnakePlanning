classdef MultiSegmentTrajectory < handle
    methods(Access = public)
        function this = MultiSegmentTrajectory(varargin)
            p = inputParser;
            p.addParameter('numJoints', 0);
            p.addParameter('numTimeSteps', 0);
            p.addParameter('numContacts', 0);
            p.addParameter('world', []);
            
            p.parse(varargin{:});

            this.pointOptimizer = ...
                CioTrajectory('numJoints', p.Results.numJoints,...
                              'numTimeSteps', 1,...
                              'numContacts', 1,...
                              'world', p.Results.world);
            
            this.trajOptimizer = ...
                CioTrajectory('numJoints', p.Results.numJoints,...
                              'numTimeSteps', p.Results.numTimeSteps,...
                              'numContacts', p.Results.numContacts,...
                              'world', p.Results.world);
        end
        
        function setStartConfig(this, config)
            this.trajectory = config;
        end
        
        function addSegment(this, goal, numTimeSteps)
            initialAngles = this.trajectory(:,end);
            prevNumTS = this.trajOptimizer.numTimeSteps;
            prevNumC = this.trajOptimizer.numContacts;
            
            if(nargin == 3)
                this.trajOptimizer.numTimeSteps = numTimeSteps;
                this.trajOptimizer.numContacts = numTimeSteps;
            end
            
            
            ts = this.trajOptimizer.numTimeSteps;
            nj = this.trajOptimizer.numJoints;
            goalAngles = ...
                this.pointOptimizer.optimizePoint('EndEffectorGoal', goal,...
                                                  'initialAngles', initialAngles);
            this.trajOptimizer.arm.plot(goalAngles);
            disp('plotted goal angles');
            
            seedAngles = interpolateTrajectory(...
                [initialAngles, goalAngles], ts-1);
                
            seedAngles = reshape(seedAngles, nj*ts, 1);
            
            angles = this.trajOptimizer.optimizeTrajectory(...
                'EndEffectorGoal', goal, ...
                'display', 'progress',...
                'initialAngles', initialAngles,...
                'seedAngles', seedAngles,...
                'maxIter', 10)

            this.trajectory = [this.trajectory, angles(:,2:end)];
            
            this.trajOptimizer.numTimeSteps = prevNumTS;
            this.trajOptimizer.numContacts = prevNumC;

        end
        
        function showTrajectory(this, interpFactor)
            extraAngles = interpolateTrajectory(this.trajectory, interpFactor);        
            loopTrajectory(this.trajOptimizer.arm, ...
                           this.trajOptimizer.world, ...
                           10000, extraAngles, true);
        end
        
        function setBaseFrame(this,fr)
            this.trajOptimizer.arm.setBaseFrame(fr);
            this.pointOptimizer.arm.setBaseFrame(fr);
        end
        
        function reset(this)
            
            this.trajOptimizer.arm.remakeKin();
            this.pointOptimizer.arm.remakeKin();
            showWorld(this.trajOptimizer.world);
        end
    end
    
     properties(Access = public, Hidden = false)
         trajOptimizer
         pointOptimizer
         trajectory
     end
end
    