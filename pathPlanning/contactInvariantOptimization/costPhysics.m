function cost = costPhysics(arm, world, angles, c)
%Returns the cost for the applied torque not matching the torque needed
    cost = 0;
    
    for i=1:size(angles,2)
        [J, B, W, R, A, b] = getPhysicsParams(arm, world, angles(:,i), ...
                                                   c(:,i));
        
        tau = arm.getKin().getGravCompTorques(angles(:,i), [0 0 -1])';
        
        [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
        v = J'*f + B*u - tau;
        cost = cost + v;
    end
end




