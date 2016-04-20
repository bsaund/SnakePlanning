function c = costObjectViolation(arm, world, angles)
%I am adding this as a cost term for when the arm arm is inside
%an obstacle. 
    cost = 0;
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
