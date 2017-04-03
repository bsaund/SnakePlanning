classdef NoContactsPolicy < handle
    methods
        function this = NoContactsPolicy(world, arm_joint_types)
            this.world = world;
            this.sphereModel = SpherePlotter('jointTypes', arm_joint_types);
            this.sphereModel.setWorld(world);
            this.useAngleGoal = false;
            this.goal = [0;0;0];
        end
        
        % function [u, success] = getAction(this, x)
            
        %     [u, failureReason] = this.getActionFixedContacts(x);
        %     success = ~failureReason;
        %     if(success)
        %         if(~isempty(this.u_prev))
        %             u = .7*u + .3*this.u_prev;
        %         end
        %         u = bound(x+u, -1.57, 1.57) - x;
                
        %         this.u_prev = u;
        %         success = norm(u) > 0.001;
        %         return;
        %     end
            
        %     [new_contacts, success] = adjustContacts(this, x,...
        %                                              failureReason);
        %     if(~success)
        %         return;
        %     end
        %     [angles, contacts] = this.separateState(x);
        %     x = this.combineState(angles, new_contacts);
        %     [u, success] = this.getAction(x);
        %     if(success)
        %         angle_u = this.separateState(u);
        %         u = this.combineState(angle_u, new_contacts - contacts);
        %         % n = length(u);
        %         % u((n/2+1):end) = new_contacts - contacts;
        %     end
        % end
        
                                                        
            
        function [u, success]=getAction(this, angles)
        %Returns the action u 
            grad = this.gradient(angles);
            c = this.cost(angles);
            q = angles;
            
            %%            scalePolicy
            J = this.sphereModel.getKin().getJacobian('EndEffector', q);
            J = sqrt(sum(J(1:3,:).^2));
            
            maxMove = 0.011;
            if(~this.useAngleGoal)
                maxMove = min(maxMove, norm(this.sphereModel.getFK(q)- ...
                                            this.goal));
            end
            
            u = maxMove/(abs(grad)*J')*grad;
            % u;
            
            q_new = q+u;
            q_new = bound(q_new, -1.57, 1.57);
            u = q_new - q;

            c_new = this.cost(q_new);
            
            % norm(u)
            decrease_iter = 0;
            while (c_new > c && decrease_iter < 10)
                c
                this.cost(angles)
                
                
                u = u*.5;
                q_new = q+u;
                q_new = bound(q_new, -1.57, 1.57);
                
                c_new = this.cost(q_new)
                decrease_iter = decrease_iter + 1
                % pause(.5)
            end
            
            if(c_new > c)
                success = 0;

                c_new
                c
                % for(i=1:10)
                %     this.sphereModel.plot(q)
                %     pause(.3)
                %     this.sphereModel.plot(q_new)                
                %     pause(1)
                % end
                disp('Ending: cost increasing');
                return;
            end

            success = 1;
        end
        
        function c = cost(this, angles)
        %Returns the cost of point angles with contacts c

            cObstacle = 40*this.sphereModel.getObstacleDistance(angles)';
            if(this.useAngleGoal)
                cGoal = 200*(angles - this.goalAngles);
            else
                fk = this.sphereModel.getFK(angles);                
                cGoal = 200*(fk - this.goal);
            end
            
            goalDist = norm(cGoal);
            cObstacle = norm(cObstacle)^2;
            % cObstacle = 0;            

            c = cObstacle + goalDist;
        end
        
        function g = gradient(this, angles)
        %Returns the gradient of the cost function
            eps = 0.0001;
            c = this.cost(angles);
            g = zeros(size(angles));
            for i=1:length(g)
                a_new = angles;
                a_new(i) = a_new(i) + eps;
                g(i) = (c-this.cost(a_new))/eps;
            end
        end
        
        
        function goal_reached = reachedGoal(this, angles)

            if(this.useAngleGoal)
                goal_reached = max(abs(angles - this.goalAngles)) < 0.05;
                return
            end
            fk = this.sphereModel.getFK(angles);
            err = fk - this.goal;
            
            goal_reached = sqrt(sumsqr(err)) < .01;

        end
        
        function setGoal(this, goal)
            this.goal = goal;
            this.useAngleGoal = false;
            this.u_prev = [];
        end
        
        function setGoalAngles(this, goal)
            this.goalAngles = goal;
            this.useAngleGoal = true;
            this.u_prev = [];
        end
        
    end
    
    
    properties
        goal
        goalAngles
        useAngleGoal
        world
        sphereModel
        
        u_prev;
    end
    
end