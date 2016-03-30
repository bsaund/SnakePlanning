function cost = costPhysics(snake, world, state)
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
    B = eye(size(angles,1));
    
    c_j = repelem(c, 3);
    
    k0 = 1e-2;
    k1 = 1e-3;
    W = diag(k0./(c_j.^2 + k1));
    B = eye(size(angles,1));
    R = eye(size(angles,1));
    
    A = 0;
    b = 0;
    
    [f, u] = inverseDynamics(J, B, tau, W, R, A, b);
        
    v = J'*f + B*u - tau;
    cost = v;
end


function [f, u] = inverseDynamics(J, B, tau, W, R, A, b)
%Finds the force f and control input (torque) u that best fit the
%dynamics with regularization on force W and torque R
%A and b describe the friction pyramid
    
    z = zeros(size(W,1), size(R,2));
    %quadprog: min 1/2 x'Hx + f'x
    % JB = [J', B];
    H = [J;B']*[J', B] + [W, z; z', R];
    func = -1*([J; B']*tau)';
    % H = JB'*JB + [W, z; z', R];
    % func = -1*tau'*JB;
    options = optimoptions('quadprog','Display','none');
    x = quadprog(H, func, [],[],[],[],[],[],[],options);
    
    n=  size(J,1);
    f = x(1:n);
    u = x(n+1:end);
    
    
end