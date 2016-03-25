function p_plane = closestPointOptimizer(p_test, p1, p2, p3)
%CLOSESTPOINT returns the closest points to p_test on the triangle
%defined by p1, p2, and p3. All points are column vectors.
    C = [p1, p2, p3];
    d = p_test;
    A = -eye(3);
    b = zeros(3,1);
    lb = zeros(3,1);
    ub = ones(3,1);
    Aeq = ones(1,3);
    beq = [1];
    
    options = optimoptions('lsqlin','Algorithm','active-set', 'display','off');
    % tic
    % x = lsqlin(C,d,[],[],Aeq, beq, lb, ub, [], options);
    x = lsqlin(C,d,A,b,Aeq, beq, [],[], [], options);
    % toc
    p_plane = C*x;
    
end
