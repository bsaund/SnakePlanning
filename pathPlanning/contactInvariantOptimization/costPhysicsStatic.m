function cost = costPhysics(snake, world, state)
    [J, B, tau, W, R, A, b] = getPhysicsParams(snake, world, state);
    [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
    v = J'*f + B*u - tau;
    cost = v;
end


