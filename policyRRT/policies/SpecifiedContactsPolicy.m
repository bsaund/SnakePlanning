classdef SpecifiedContactsPolicy < handle
    methods
        function this = SpecifiedContactsPolicy(world, arm_joint_types)
            this.world = world;
            this.sphereModel = SpherePlotter('jointTypes', arm_joint_types);
            this.sphereModel.setWorld(world);
            this.useAngleGoal = false;
            this.goal = [0;0;0];
        end
        
        function [u, success] = getAction(this, x)
            
            [u, failureReason] = this.getActionFixedContacts(x);
            success = ~failureReason;
            if(success)
                if(~isempty(this.u_prev))
                    u = .7*u + .3*this.u_prev;
                end
                u = bound(x+u, -1.57, 1.57) - x;
                
                this.u_prev = u;
                success = norm(u) > 0.001;
                return;
            end
            
            [new_contacts, success] = adjustContacts(this, x,...
                                                     failureReason);
            if(~success)
                return;
            end
            [angles, contacts] = this.separateState(x);
            x = this.combineState(angles, new_contacts);
            [u, success] = this.getAction(x);
            if(success)
                n = length(u);
                u((n/2+1):end) = new_contacts - contacts;
            end
        end
        
        function [contacts, success] = adjustContacts(this, x, ...
                                                      adjustDirection)
            [angles, contacts] = this.separateState(x);
            success = true;
            lastCon = max(find(contacts));
            
            if(~isempty(this.contactDirection) &&...
               adjustDirection ~= this.contactDirection)
                %was adding contacts, now needing to remove
                %or was removing now needing to add contacts
                success = false;
            end
            this.contactDirection = adjustDirection;

            if(adjustDirection == 1) %Cost increasing, reduce contacts
                if(lastCon <= 1)
                    success = false;
                    return
                end
                contacts(lastCon) = 0;
                contacts(lastCon-1) = 1;
                return;
            end
            
            if(adjustDirection == 2)  %Torque too high
                if(lastCon == length(angles))
                    success = false;
                    return;
                end
                contacts(lastCon) = 0;
                contacts(lastCon+1) = 1;
                return;
            end
            
            disp('called adjust direction when not needed');                
        end
                                                        
            
        function [u, failureReason]=getActionFixedContacts(this, x)
        %Returns the action u 
            grad = this.gradient(x);
            c = this.cost(x);
            [q, contacts] = this.separateState(x);
            
            %%            scalePolicy
            J = this.sphereModel.getKin().getJacobian('EndEffector', q);
            J = sqrt(sum(J(1:3,:).^2));
            
            maxMove = 0.01;
            if(~this.useAngleGoal)
                maxMove = min(maxMove, norm(this.sphereModel.getFK(q)- ...
                                            this.goal));
            end
            
            u = maxMove/(abs(grad)*J')*grad;
            
            q_new = q+u;
            q_new = bound(q_new, -1.57, 1.57);
            u = q_new - q;
            
            u = [u, zeros(size(contacts))];
            c_new = this.cost(this.combineState(q_new, contacts));
            if(c_new > c)
                failureReason = 1;
                % disp('Ending: cost increasing');
                return;
            end
            
            tau = this.sphereModel.getMinTorques(q_new, contacts);
            if(max(abs(tau) > 1))
                failureReason = 2;
                % disp('Ending: Torque too high')
                % tau
                return
            end
            failureReason = 0;
        end
        
        function c = cost(this, x)
        %Returns the cost of point angles with contacts c
            [angles, contacts] = this.separateState(x);
            % this.sphereModel.getPoints(angles);
            fk = this.sphereModel.getFK(angles);
            % cTorque = 0*this.sphereModel.getMinTorques(angles, contacts);
            cContact = ((30*this.sphereModel.getContactDistance(angles, contacts)))';
            cObstacle = 40*this.sphereModel.getObstacleDistance(angles)';
            if(this.useAngleGoal)
                cGoal = 200*(angles - this.goalAngles);
            else
                cGoal = 200*(fk - this.goal);
            end
            
            goalDist = norm(cGoal);
            % c = [cTorque; cContact; cObstalce; cGoal];
            % c = [cTorque; cContact; cObstalce; sqrt(numGoal)];

            cContact = norm(cContact)^6;
            cObstacle = norm(cObstacle)^6;
            
            
            % c = [cContact; cObstalce; sqrt(numGoal)];
            c = cContact + cObstacle + goalDist;
            % c = [cContact; sqrt(numGoal)];
            % c = c'*c
            % c = norm(c);
        end
        
        function g = gradient(this, x)
        %Returns the gradient of the cost function
            eps = 0.0001;
            c = this.cost(x);
            [a, contacts] = this.separateState(x);
            g = zeros(size(a));
            for i=1:length(g)
                anew = a;
                anew(i) = a(i) + eps;
                g(i) = (c-this.cost(this.combineState(anew, contacts)))/eps;
            end
        end
        
        function y = reachedGoal(this, x)
            angles = this.separateState(x);
            if(this.useAngleGoal)
                y = max(abs(angles - this.goalAngles)) < 0.05;
                return
            end
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
            this.u_prev = [];
        end
        
        function setGoalAngles(this, goal)
            this.goalAngles = goal;
            this.useAngleGoal = true;
            this.u_prev = [];
        end
        
    end
    
    methods
        function [angles, contacts] = separateState(this, state)
            % n_angles = length(state);
            n_angles = this.sphereModel.kin.getNumDoF;
            angles = state(1:n_angles);
            contacts = state((n_angles+1):end);
        end
        
        function state = combineState(this, angles, contacts)
            state = [angles, contacts];
        end
    end
    
    properties
        goal
        goalAngles
        useAngleGoal
        world
        sphereModel
        
        u_prev;
        contactDirection;
    end
    
end