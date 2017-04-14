classdef MultiSegmentTrajectory < handle
    methods(Access = public)
        function this = MultiSegmentTrajectory(varargin)
            p = inputParser;
            p.addParameter('arm', []);
            p.addParameter('numTimeSteps', 0);
            p.addParameter('numContacts', 0);
            p.addParameter('world', []);
            
            p.parse(varargin{:});

            this.pointOptimizer = ...
                CioTrajectory('arm', p.Results.arm,...
                              'numTimeSteps', 1,...
                              'numContacts', 1,...
                              'world', p.Results.world);
            
            this.trajOptimizer = ...
                CioTrajectory('arm', p.Results.arm,...
                              'numTimeSteps', p.Results.numTimeSteps,...
                              'numContacts', p.Results.numContacts,...
                              'world', p.Results.world);
        end
        
        function setStartConfig(this, config)
            this.trajectory = config;
            this.contacts = zeros(this.trajOptimizer.arm.kin.getNumBodies(),1);
            this.torques = zeros(size(config));
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
            
            [angles, c] = this.trajOptimizer.optimizeTrajectory(...
                'EndEffectorGoal', goal, ...
                'display', 'progress',...
                'initialAngles', initialAngles,...
                'seedAngles', seedAngles,...
                'maxIter', 10);

            angles
            c
            
            torques = costPhysics(this.trajOptimizer.arm, ...
                                  this.trajOptimizer.world, ...
                                  angles, c(:,2:end));
            torques = reshape(torques, this.trajOptimizer.numJoints, [])

            
            this.trajectory = [this.trajectory, angles(:,2:end)];
            this.contacts = [this.contacts, c(:,2:end)];
            this.torques = [this.torques, torques];
            
            this.trajOptimizer.numTimeSteps = prevNumTS;
            this.trajOptimizer.numContacts = prevNumC;

        end
        
        function optimizeSegment(this, trajectory)
            initialAngles = trajectory(:,1);
            goal = this.trajOptimizer.arm.getFK(trajectory(:,end));

            ts = size(trajectory,2);
            nj = size(trajectory,1);
            this.trajOptimizer.numTimeSteps = ts
            this.trajOptimizer.numContacts = ts;
            
            seedAngles = reshape(trajectory, nj*ts, 1);
            
            [angles, c] = this.trajOptimizer.optimizeTrajectory(...
                'EndEffectorGoal', goal, ...
                'display', 'progress',...
                'initialAngles', initialAngles,...
                'seedAngles', seedAngles,...
                'maxIter', 10)

            this.trajectory = [this.trajectory, angles(:,2:end)];
            this.contacts = [this.contacts, c(:,2:end)];            
        end
        
        function showTrajectory(this, interpFactor)
            extraAngles = interpolateTrajectory(this.trajectory, interpFactor);        
            % loopTrajectory(this.trajOptimizer.arm, ...
            %                this.trajOptimizer.world, ...
            %                10000, extraAngles, true);
            arm = this.trajOptimizer.arm;
            loopTrajectory(@arm.plot, extraAngles)
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
         contacts
         torques
     end
end
    