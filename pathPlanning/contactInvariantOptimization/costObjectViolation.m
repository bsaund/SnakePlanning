function c = costObjectViolation(snake, world, state)
%I am adding this as a cost term for when the snake arm is inside
%an obstacle. 
    [angles, c] = fullStateToVars(state);
    p = snake.getPoints(angles);
    [p_closest, face] = closestPoints(snake, world, angles);
    normals = world.normals(face,:);
    c=sum((p_closest'-p'+normals*.025) .* normals,2);
    c = max(c,0);
    % if(sum(c)>0)
    %     costObjViolation = c
    % end
end
