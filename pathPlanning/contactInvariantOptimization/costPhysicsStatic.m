function cost = costPhysicsStatic(arm, world, angles, c)
    [J, B, W, R, A, b] = getPhysicsParams(arm, world, angles, ...
                                                      c);

    % tic
    tau = arm.getGravTorques(angles);
    % toc
    [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
    v = J'*f + B*u - tau;
    cost = v;
end


