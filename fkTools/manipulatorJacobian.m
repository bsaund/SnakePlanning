function J = manipulatorJacobian(twists, angles)
%Returns the spacial frame jacobian
    action = eye(4);
    J = [];
    for i=1:size(twists,2)
        J = [J, Adjoint(action) * twists(:,i)];
        action = action * twistMatrix(twists(:,i), angles(i));
    end
end
