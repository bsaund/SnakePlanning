function [J, B, tau, W, R, A, b] = getPhysicsParams(snake, world, ...
                                                           state)
    %See Mordatch Contact Invariant Optimization paper for details
    [angles, c] = fullStateToVars(state);
    J_tmp = snake.getKin().getJacobian('CoM', angles);
    n= size(J_tmp,3);
    J = zeros(3*n,n);
    for i=1:n
        ind = (1:3) + 3*(i-1);
        J(ind, :) = J_tmp(1:3,:,i);
    end

    
    tau = snake.getKin().getGravCompTorques(angles, [0 0 -1])';
    
    c_j = repelem(c, 3);
    
    %Regularization matrix for the forces based on the contact
    %auxillary variables
    k0 = 1e-2;
    k1 = 1e-3;
    W = diag(k0./(c_j.^2 + k1));
    
    %Mapping from input u to joint torques
    B = eye(size(angles,1));
    
    %Regularization matrix for joint torques
    R = eye(size(angles,1));
    
    %Matrices defining the friction cone
    [~, face] = closestPoints(snake, world, angles);
    face;
    A = zeros(4*n);
    b = zeros(4*n,1);
    for i=1:n
        ind = (1:3) + 3*(i-1);
        A(ind, ind) = [0,0,0;
                     0,0,0;
                     world.normals(face(i),:)];
        % b(ind,1) = [0;0;0];
    end

    % A = 0;
    % b = 0;

end
