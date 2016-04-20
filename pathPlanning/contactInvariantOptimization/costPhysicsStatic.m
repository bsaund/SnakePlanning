function cost = costPhysicsStatic(snake, world, angles, c)
    [J, B, tau, W, R, A, b] = getPhysicsParams(snake, world, angles, c);
    [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
    v = J'*f + B*u - tau;
    cost = v;
end


