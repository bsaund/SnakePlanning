function cost = costPhysics(arm, world, angles, con)
%Returns the cost for the applied torque not matching the torque needed
    cost = [];
    n = size(angles,2);
    
    dt = .1;
    
    kin = arm.getKin();
    
    for i=2:n
        theta = angles(:,i);
        [J, B, W, R, A, b] = getPhysicsParams(arm, world, theta, ...
                                                   con(:,i-1));
        
        tau = kin.getGravCompTorques(theta, [0 0 1])';
        
        if (i > 1) && (i < n)
            v = (angles(:,i+1) - angles(:,i-1))/(2*dt);
            a = (angles(:,i+1) - 2*theta + angles(:,i-1))/(dt^2);
            
            tau = tau + kin.getDynamicCompTorques(theta, theta,...
                                                          v, a)';
        elseif (i==n)
            v = (angles(:,i) - angles(:,i-1))/(dt);
            a = (angles(:,i) - 2*theta + angles(:,i-1))/(dt^2);
            
            tau = tau + kin.getDynamicCompTorques(theta, theta,...
                                                          v, a)';
        end
        
        [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
        torqueErr = J'*f + B*u - tau;
        cost = [cost; torqueErr];
    end
end




