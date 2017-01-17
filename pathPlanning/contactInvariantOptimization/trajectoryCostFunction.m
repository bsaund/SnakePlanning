function c = trajectoryCostFunction(state, debug)
    if(nargin < 2)
        debug = false;
    end
    [angles, con] = this.separateState(state);

    fk = this.arm.getKin.getFK('EndEffector', angles(:,end));
    p_closest = closestPoints(arm, world, angles);
    p_arm_center = arm.getPoints(angles);
    
    
    pointErr = fk(1:3, 4) - goal_xyz;


    cPh = costPhysics(this.arm, this.world, ...
                      [this.startAngles, angles],...
                      con);
    cCI = 100*costContactViolation(this.arm, p_arm_center, p_closest, ...
                                   angles, con);
    cTask = 1000*pointErr;
    cDistance = 10*costDistErr([this.startAngles, angles]).^2;
    cObstacle = 1000*costObjectViolation(p_arm_center, p_closest, this.world, angles);
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



function cost = costContactViolation(arm, world, p_arm_center, p_closest, all_angles, con)
%Cost of claiming to be in contact when in reality not in contact
    cost = [];
    %For each time step sum the cost
    for i = 1:size(all_angles,2)
        cs = repelem(con(:,i), 3).^(.5);
        angles = all_angles(:,i);
        % p_arm_center = arm.getPoints(angles);
        % p_closest = closestPoints(arm, world, angles);
        % p_closest = closestSoftPoints(arm, world, angles);
        
        % p_closest_act = closestPoints(arm, world, angles);
        % p_closest - p_closest_act
        
        %Subtract the joint radius to get the distance from the
        %point on the world to the edge of the sphere, not the
        %center of the sphere
        for joint=1:size(p_arm_center,2)
            p_tmp = p_arm_center(:,joint);
            p_cl_tmp = p_closest(:,joint);
            v = p_tmp - p_cl_tmp;
            v = v/(v'*v)^.5;
            p_closest(:,joint) = p_cl_tmp + v*(arm.radius);
        end
        p_diff = p_arm_center - p_closest;
        p_diff = reshape(p_diff, numel(p_diff), 1);
        cost = [cost; cs .* p_diff];
    end
end

function cost = costObjectViolation(p_center, p_closest, world, angles)
%I am adding this as a cost term for when the arm arm is inside
%an obstacle. 
    cost = [];
    for i=1:size(angles,2)
        p = arm.getPoints(angles(:,i));
        [p_closest, face] = closestPoints(arm, world, angles(:,i));
        normals = world.normals(face,:);
        c=sum((p_closest'-p'+normals*.025) .* normals,2);
        c = max(c,0);
        cost = [cost; c];
    end
    
    % if(sum(c)>0)
    %     costObjViolation = c
    % end
end
