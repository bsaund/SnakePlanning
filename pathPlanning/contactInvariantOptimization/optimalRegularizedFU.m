function [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b)
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
    
    
    A = [A, zeros(size(A,1), size(B,1))]; %u doesnt affect friction cone, but terms are still needed
    options = optimoptions('quadprog','Display','none');
    x = quadprog(H, func, A,b,[],[],[],[],[],options);
    
    % x = quadprog(H, func, [],[],[],[],[],[],[],options);
    
    %With no constraints this is faster
    % x = -H\func';



    n =  size(J,1);
    f = x(1:n);
    u = x(n+1:end);
    
    % A(:,1:n)*f
    
    
end

