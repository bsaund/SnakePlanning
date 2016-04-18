function cost = costContactViolation(arm, world, all_angles, c)
%Cost of claiming to be in contact when in reality not in contact

% 
    cost = [];
    %For each time step sum the cost
    for i = 1:size(all_angles,2)
        
        cs = repelem(c(:,i), 3).^(.5);
        angles = all_angles(:,i);
        p_arm_center = arm.getPoints(angles);
        p_closest = closestPoints(arm, world, angles);
        
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
