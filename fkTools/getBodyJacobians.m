function J_b = getBodyJacobians(kin, angles)
%Returns the body jacobians to the center of mass for each link
    n = length(angles);
    
    j_type = 'CoM';
    
    J_geo = kin.getJacobian(j_type, angles);
    fk = kin.getFK(j_type, angles);
    J_b = zeros(6,n,n);
    z = zeros(3);
    
    for i=1:n
        R = fk(1:3, 1:3, i);
        T = [R, z; z, R]';
        J_b(:,:,i) = T*J_geo((1:6) + (6*(i-1)), :);
    end

end
