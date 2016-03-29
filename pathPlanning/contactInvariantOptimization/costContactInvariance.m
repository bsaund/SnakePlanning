function cost = costContactInvariance(snake, world, state)
    [angles, c] = fullStateToVars(state);
    cs = repelem(c, 3).^(.5);
    p = snake.getPoints(angles);
    p_closest = zeros(size(p));
    for i=1:size(p,2)
        p_closest(:,i) = closestPointOnWorld_mex(p(:,i), world);
    end
    p_diff = p - p_closest;
    p_diff = reshape(p_diff, numel(p_diff), 1);
    cost = cs.*p_diff;
end
