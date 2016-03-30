function cost = costContactInvariance(snake, world, state)
    [angles, c] = fullStateToVars(state);
    cs = repelem(c, 3).^(.5);
    p = snake.getPoints(angles);
    p_closest = closestPoints(snake, world, angles);
    for i=1:size(p,2)
        p_tmp = p(:,i);
        p_cl_tmp = p_closest(:,i);
        v = p_tmp - p_cl_tmp;
        v = v/(v'*v)^.5;
        p_closest(:,i) = p_cl_tmp + v*(snake.radius);
    end
    p_diff = p - p_closest;
    p_diff = reshape(p_diff, numel(p_diff), 1);
    cost = cs.*p_diff;
end
