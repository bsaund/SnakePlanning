function M = massMatrix(kin, angles)
%Calculates the mass matrix of a hebi kinematics chain
%This is an implementation of the mathematics foun in
%Robotic Manipulation, {Murray, Li, Sastry}
%p. 168
    
    
    n = length(angles);
    
    J_b = getBodyJacobians(kin, angles);
    masses = kin.getBodyMasses();
    M = zeros(n);

    z = zeros(3);
    
    for i=1:n
        M_temp = [eye(3) * masses(i), z; z, z];
        M = M + J_b(:,:,i)' * M_temp * J_b(:,:,i);
    end
    
end
