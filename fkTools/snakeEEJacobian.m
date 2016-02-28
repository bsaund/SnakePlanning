function [J_spatial, J_body, J_geometric] = snakeEEJacobian(angles)
%Returns the end effector spatial, body, and geometric jacobian for a 
% chain of hebi links
    [t, g0] = getSnakeTwists(length(angles));
    J_spatial = manipulatorJacobian(t, angles);
    J_body = inv(Adjoint(snakeFK(angles)))*J_spatial;
    
    fk = snakeFK(angles);
    J_geometric = [fk(1:3, 1:3), zeros(3); zeros(3), fk(1:3, 1:3)]* ...
        J_body;
    

end
