function [J, B, W, R, A, b] = ...
    getPhysicsParams(arm, world, angles, c)
    %See Mordatch Contact Invariant Optimization paper for details


    % J_tmp = arm.getKin().getJacobian('CoM', angles);
    J_tmp = arm.getJacobian(angles);
    n= size(J_tmp,3);
    D = size(angles,1);
    J = zeros(3*n, D);
    for i=1:n
        ind = (1:3) + 3*(i-1);
        J(ind, :) = J_tmp(1:3,:,i);
    end

    
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
    p = arm.getPoints(angles);
    [~, face] = arm.cpCalc.getClosestPointsFast(p);
    % face;
    % A = zeros(1,4*n);
    % b = zeros(4*n,1);
    for i=1:n
        row = (1:1) + 1*(i-1);
        col = (1:3) + 3*(i-1);
        t1 = world.tangents_1(face(i), :);
        t2 = world.tangents_2(face(i), :);
        % A(row, col) = [t1;
        %                -t1;
        %                t2;
        %                -t2;
        %              world.normals(face(i),:)];
        % A(row, col) = [0,0,0;];
        A(row, col) = [-world.normals(face(i),:)];

        % b(row,1) = [1;1;1;1;0];
        b(row,1) = 0;
        normals(col,1) = world.normals(face(i),:)';
    end
    
    % normals;


    % A = 0;
    % b = 0;

end
