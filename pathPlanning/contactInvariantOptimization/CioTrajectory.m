classdef CioTrajectory < handle
    
    
    methods(Access = public)
        function this = CioTrajectory(varargin)
            p = inputParser;
            p.addParameter('numJoints', 0);
            p.addParameter('numTimeSteps', 0);
            p.addParameter('numContacts', 0);
            p.addParameter('world', []);
            
            p.parse(varargin{:});
            
            this.numJoints = p.Results.numJoints;
            this.numTimeSteps = p.Results.numTimeSteps;
            this.numContacts = p.Results.numContacts;
            this.world = p.Results.world;
            
            showWorld(this.world);
            
            this.arm = SpherePlotter();
            this.arm.getPoints(zeros(1,this.numJoints));
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
                              this.numJoints,...
                              this.numContacts);
            contacts = repelem(contacts, 1, ceil(this.numTimeSteps/...
                                              this.numContacts));
            contacts = contacts(:, 1:this.numTimeSteps);
            % contacts(8:10) = 0;
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
            final_cost = func(x)
        end
    end
    
    methods(Access = private, Hidden = true)
        function [options, initial_angles, initial_c, goal_xyz] = ...
                parseOptimizeInput(this, varargin)
            p = inputParser;
            
            expectedDisplayTypes = {'raw', 'optimized', 'none'};
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
            initial_c = repmat(0*p.Results.InitialAngles, this.numContacts,1) + 10;
            
            maxIter = p.Results.maxIter;
            display = p.Results.display;
            if(strcmpi('raw',display) || strcmpi('optimized',display))
                options = optimoptions('lsqnonlin','maxIter', maxIter, ...
                                       'maxFunEvals', maxIter,...
                                       'OutputFcn', this.getPlotFunc(display));
            else
                options = optimoptions('lsqnonlin','maxIter', maxIter,...
                                       'display','none');
            end
        end
        
        function [lb, ub] = getBounds(this, angles, c)
            lb = [ones(numel(angles),1)*-pi/2;
                  zeros(numel(c),1);];
            ub = [ones(numel(angles),1)*pi/2;
                  ones(numel(c),1)*100];
        end

        function func = getTrajectoryCostFunction(this, goal_xyz);
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
                cCI = 100*costContactViolation(this.arm, this.world, ...
                                               angles, con);
                cTask = 1000*pointErr;
                cDistance = 10*costDistErr([this.startAngles, angles]).^2;
                cObstacle = 1000*costObjectViolation(this.arm, this.world, angles);
                % c = [cPh; cCI; cTask; cObstacle; cDistance];
                c = [cPh; cCI; cTask; cObstacle];
                % c = [cPh; cCI; cTask];
                if(debug)
                    cPh = reshape(cPh, this.numJoints, this.numTimeSteps)
                    cCI = reshape(cCI, this.numJoints*3, this.numTimeSteps)
                    cTask
                    cObstacle = reshape(cObstacle, this.numJoints, this.numTimeSteps)
                end
            end
            func = @cost;
        end

        function func = getStaticCostFunction(this, goal_xyz);
            function c = cost(state)
                [angles, c] = this.separateState(state);
                fk = this.arm.getKin.getFK('EndEffector', angles);

                pointErr = fk(1:3, 4) - goal_xyz;

                cPh = costPhysicsStatic(this.arm, this.world, angles, c);
                % cPh = costPhysics(this.arm, this.world, angles, c);
                cCI = 100*costContactViolation(this.arm, this.world, ...
                                               angles, c);
                cTask = 100*pointErr;
                cObstacle = 100*costObjectViolation(this.arm, this.world, angles);
                c = [cPh; cCI; cTask; cObstacle;];
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
    
    properties(Access = public, Hidden = true)
        arm
        numJoints
        numTimeSteps
        numContacts
        world
        startAngles;
    end
    
end