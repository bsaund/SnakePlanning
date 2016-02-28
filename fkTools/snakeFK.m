function g = snakeFK(angles)
%Returns the homogeneous matrix for a chain of
% Hebi modules at specified angles
    [t, g0] = getSnakeTwists(length(angles));
    g = FK(t, g0, angles);
end
