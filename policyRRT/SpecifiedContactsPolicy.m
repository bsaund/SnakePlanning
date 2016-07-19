classdef SpecifiedContactsPolicy < handle
    methods
        function this = SpecifiedContactsPolicy(world)
            this.world = world;
            this.sphereModel = SpherePlotter();
            this.sphereModel.setWorld(world);
            this.useAngleGoal = false;
            this.goal = [0;0;0];
        end
        
        function [u, contacts, success] = getPolicy(this, x, contacts)
            [u, success] = this.getPolicyFixedContacts(x, contacts);
            if(~isempty(this.u_prev))
                % u = .7*u + .3*this.u_prev;
            end
            this.u_prev = u;
            if(success)
                return;
            end
            
            lastCon = max(find(contacts));
            new_contacts = contacts;
            new_contacts(lastCon) = 0;
            if(lastCon <= 1)
                return
            end
            new_contacts(lastCon-1) = 1;

            [u, new_contacts, success] = this.getPolicy(x,new_contacts);
            if(success)
                contacts = new_contacts
            end
        end
            
        function [u, success]=getPolicyFixedContacts(this, q, contacts)
        %Returns the action u 
            grad = this.gradient(q, contacts);
            % hess = this.diagHessian(q)
            c = this.cost(q, contacts);
            scale = c/norm(grad);
            % u = grad*.0001;
            u = grad;
            % if(norm(u) > .1)
                % u = .05*u/norm(u);
            % end
            
            %%            scalePolicy
            J = this.sphereModel.getKin().getJacobian('EndEffector', q);
            J = sqrt(sum(J(1:3,:).^2));
            
            maxMove = 0.01;
            if(~this.useAngleGoal)
                maxMove = min(maxMove, norm(this.sphereModel.getFK(q)- ...
                                            this.goal))
            end
            
            u = maxMove/(abs(u)*J')*u;
            
            
            q_new = q+u;
                        
            success = false;
            
            c_new = this.cost(q_new, contacts);
            if(c_new > c)
                disp('Ending: cost increasing');
                return;
            end
            
            
            tau = this.sphereModel.getMinTorques(q_new, contacts);
            if(max(abs(tau) > 1))
                disp('Ending: Torque too high')
                tau
                return
            end
            
            % func = @(p) norm(q_new-p);
            % function [c, ceq] = nonlinConst(p)
            %     ceq = [];
            %     c = this.sphereModel.getContactDistance(p, contacts) ...
            %         - 0.1;
            % end
            % nonlcon = @nonlinConst;
            % % nonlcon = [];
            % q_opt = fmincon(func, q_new, [], [], [], [], [], [], nonlcon)
            % u = q_opt - q;
            success = true;
        end
        
        function c = cost(this, angles, contacts)
        %Returns the cost of point angles with contacts c
            % this.sphereModel.getPoints(angles);
            fk = this.sphereModel.getFK(angles);
            % cTorque = 0*this.sphereModel.getMinTorques(angles, contacts);
            cContact = ((30*this.sphereModel.getContactDistance(angles, contacts)))';
            cObstacle = 30*this.sphereModel.getObstacleDistance(angles)';
            if(this.useAngleGoal)
                cGoal = 200*(angles - this.goalAngles);
            else
                cGoal = 200*(fk - this.goal);
            end
            
            numGoal = norm(cGoal);
            % c = [cTorque; cContact; cObstalce; cGoal];
            % c = [cTorque; cContact; cObstalce; sqrt(numGoal)];

            cContact = norm(cContact)^6
            cObstacle = norm(cObstacle)^6
            
            
            % c = [cContact; cObstalce; sqrt(numGoal)];
            c = cContact + cObstacle + numGoal;
            % c = [cContact; sqrt(numGoal)];
            % c = c'*c
            % c = norm(c);
        end
        
        function g = gradient(this, x, contacts)
        %Returns the gradient of the cost function
            eps = 0.0001;
            c = this.cost(x,contacts);
            g = zeros(size(x));
            for i=1:length(g)
                xnew = x;
                xnew(i) = x(i) + eps;
                g(i) = (c-this.cost(xnew, contacts))/eps;
            end
        end
        
        function y = reachedGoal(this, angles)
            fk = this.sphereModel.getFK(angles);
            err = fk - this.goal;
            % err
            % sqrt(sumsqr(err))
            if(sqrt(sumsqr(err)) < .01)
                y = true;
                return;
            end
            y = false;
        end
        
        function setGoal(this, goal)
            this.goal = goal;
            this.useAngleGoal = false;
        end
        
        function setGoalAngles(this, goal)
            this.goalAngles = goal;
            this.useAngleGoal = true;
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