function cost = costObjectViolation(p_center, p_closest, normals)
%I am adding this as a cost term for when the arm arm is inside
%an obstacle. 
    cost = [];
    % [p_closest, face] = closestPoints(arm, world, angles(:,i));
    % normals = world.normals(face,:);
    c=sum((p_closest'-p_center'+normals*.025) .* normals,2);
    c = max(c,0);
    cost = [cost; c];
end
