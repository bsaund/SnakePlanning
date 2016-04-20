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
        
        function optimizeTrajectory()
        end
        
        function [optimizedAngles, contacts, eePoint] = optimizePoint(this, varargin)
            p = inputParser;
            
            expectedDisplayTypes = {'raw', 'optimized'};
            p.addParameter('EndEffectorGoal', []);
            p.addParameter('InitialAngles', zeros(this.numJoints,1));
            p.addParameter('display', false, ...
                           @(x) any(validatestring(x, ...
                                                   expectedDisplayTypes)));
            
            
            p.parse(varargin{:});
            
            goal_xyz = p.Results.EndEffectorGoal;
            c = 0*p.Results.InitialAngles + 10;
            initial_state = [p.Results.InitialAngles; c];
            
            maxIter = 1000;
            display = p.Results.display;
            if(display)
                options = optimoptions('lsqnonlin','maxIter', maxIter, ...
                                       'maxFunEvals', maxIter,...
                                       'OutputFcn', this.getPlotFunc(display));
            else
                options = optimoptions('lsqnonlin','maxIter', maxIter,...
                                       'display','none');
            end
    
            func = this.getStaticCostFunction(goal_xyz);
            [lb, ub] = this.getBounds(p.Results.InitialAngles, c);
            [x,resnorm,residual,exitflag,output]  =... 
                lsqnonlin(func, initial_state, lb, ub, options);
            [optimizedAngles, contacts] = this.separateState(x);
            fk = this.arm.getKin.getFK('EndEffector', optimizedAngles);
            eePoint = fk(1:3,4);
        end
    end
    
    methods(Access = private, Hidden = true)
        function [lb, ub] = getBounds(this, angles, c)
            lb = [ones(size(angles))*-pi/2;
                  zeros(size(c));];
            ub = [ones(size(angles))*pi/2;
                  ones(size(c))*100];
        end

        function func = getStaticCostFunction(this, goal_xyz);
            function c = cost(state)

                [angles, c] = this.separateState(state);
                fk = this.arm.getKin.getFK('EndEffector', angles);

                pointErr = fk(1:3, 4) - goal_xyz;

                cPh = costPhysicsStatic(this.arm, this.world, angles, ...
                                        c);
                cCI = 100*costContactViolation(this.arm, this.world, ...
                                             angles, c);
                cTask = 100*pointErr;
                cObstacle = 10*costObjectViolation(this.arm, this.world, state);
                c = [cPh; cCI; cTask; cObstacle];
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
                this.arm.plotTorques(angles, this.world, ...
                                     10000);

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
    end
    
end