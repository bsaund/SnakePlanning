classdef SpringTorquePolicy < handle
    methods
        function this = SpringTorquePolicy(world)
            this.world = world
            this.sphereModel = SpherePlotter()
        end
        
        function u=getPolicy(this, x)
        %Returns the action u 
            grad = this.gradient(x)
            c = this.cost(x)
            scale = c/norm(grad)
            u = grad*scale/norm(grad)
            if(norm(u) > .1)
                u = .1*u/norm(u)
            end
        end
        
        function c = cost(this, x)
        %Returns the cost of point x
            tau = this.sphereModel.getTorques(x, this.world, ...
                                                 10000);
            % c = max(abs(tau));
            c = tau'*tau;
        end
        
        function g = gradient(this, x)
        %Returns the gradient of the cost function
            eps = 0.000001;
            c = this.cost(x);
            g = zeros(size(x));
            for i=1:length(g)
                xnew = x;
                xnew(i) = x(i) + eps;
                g(i) = (c-this.cost(xnew))/eps;
            end
        end
        
        function h = diagHessian(this, x)
            eps = 0.000001;
            c = this.cost(x);
            g = zeros(size(x));
            h = zeros(size(x));
            for i=1:length(g)
                xForward = x;
                xBack = x;
                xForward(i) = x(i) + eps;
                xBack(i) = x(i) - eps;
                cForward = this.cost(xForward);
                cBack = this.cost(xBack);
                g(i) = (cForward-cBack)/(2*eps);
                h(i) = (cForward + c(Back) - 2*c)/(eps^2);
            end
        end            
    end
    
    properties
        goal
        world
        sphereModel
    end
    
end