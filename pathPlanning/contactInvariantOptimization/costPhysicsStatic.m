function cost = costPhysicsStatic(arm, world, angles, c)
    [J, B, W, R, A, b] = getPhysicsParams(arm, world, angles, ...
                                                      c);
    tau = arm.getKin().getGravCompTorques(angles, [0 0 -1])';
    [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
    v = J'*f + B*u - tau;
    cost = v;
end


