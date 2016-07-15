classdef SpecifiedContactsPolicy < handle
    methods
        function this = SpecifiedContactsPolicy(world)
            this.world = world;
            this.sphereModel = SpherePlotter();
            this.sphereModel.setWorld(world);
        end
        
        function [u, contacts, success] = getPolicy(this, x, contacts)
            [u, success] = this.getPolicyFixedContacts(x, contacts);
            if(~isempty(this.u_prev))
                u = .7*u + .3*this.u_prev;
            end
            this.u_prev = u;
            if(success)
                return;
            end
            
            lastCon = max(find(contacts))
            new_contacts = contacts;
            new_contacts(lastCon) = 0;
            if(lastCon <= 1)
                return
            end
            new_contacts(lastCon-1) = 1

            [u, new_contacts, success] = this.getPolicy(x,new_contacts);
            if(success)
                contacts = new_contacts;
            end
        end
            
        function [u, success]=getPolicyFixedContacts(this, x, contacts)
        %Returns the action u 
            grad = this.gradient(x, contacts);
            % hess = this.diagHessian(x)
            c = this.cost(x, contacts);
            scale = c/norm(grad);
            % u = grad*.0001;
            u = grad;
            % if(norm(u) > .1)
                u = .01*u/norm(u);
            % end
            x_new = x+u;
            
            success = false;
            
            c_new = this.cost(x_new, contacts);
            if(c_new > c)
                disp('Ending: cost increasing');
                return;
            end
            
            tau = this.sphereModel.getMinTorques(x_new, contacts);
            if(max(abs(tau) > 1))
                disp('Ending: Torque too high')
                tau
                return
            end
            
            success = true;
        end
        
        function c = cost(this, angles, contacts)
        %Returns the cost of point angles with contacts c
            % this.sphereModel.getPoints(angles);
            fk = this.sphereModel.getKin().getFK('EndEffector',angles);
            cTorque = 0*this.sphereModel.getMinTorques(angles, contacts);
            cContact = ((100*this.sphereModel.getContactDistance(angles, contacts)))';
            cObstalce = 100*this.sphereModel.getObstacleDistance(angles)';
            cGoal = 20*(fk(1:3,4) - this.goal);
            numGoal = norm(cGoal);
            % c = [cTorque; cContact; cObstalce; cGoal];
            c = [cTorque; cContact; cObstalce; 10*sqrt(numGoal)];
            c = c'*c;

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
            fk = this.sphereModel.getKin().getFK('EndEffector', ...
                                                 angles);
            err = fk(1:3,4) - this.goal;
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
        end
    end
    
    properties
        goal
        world
        sphereModel
        
        u_prev;
    end
    
end