classdef SpecifiedContactsPolicy < handle
    methods
        function this = SpecifiedContactsPolicy(world)
            this.world = world
            this.sphereModel = SpherePlotter()
            this.sphereModel.setWorld(world);
        end
        
        function u=getPolicy(this, x, contacts)
        %Returns the action u 
            grad = this.gradient(x, contacts)
            % hess = this.diagHessian(x)
            c = this.cost(x, contacts)
            scale = c/norm(grad)
            u = grad*.0001;
            if(norm(u) > .1)
                u = .1*u/norm(u);
            end
        end
        
        function c = cost(this, angles, contacts)
        %Returns the cost of point angles with contacts c
            fk = this.sphereModel.getKin().getFK('EndEffector',angles);
            cTorque = 100*this.sphereModel.getMinTorques(angles, contacts)
            cContact = 100*this.sphereModel.getContactDistance(angles, contacts)'
            cGoal = 100*(fk(1:3,4) - this.goal)
            c = [cTorque; cContact; cGoal];
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
        
        function setGoal(this, goal)
            this.goal = goal;
        end
    end
    
    properties
        goal
        world
        sphereModel
    end
    
end