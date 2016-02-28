function g = FK(twists, g0, angles)
%Returns the homogenous matrix of the forward kinematics
% given twists, g0, and angles
    g = eye(4);
    for i=1:size(twists,2)
        g = g*twistMatrix(twists(:,i), angles(i));
    end
    g = g * g0;
end
