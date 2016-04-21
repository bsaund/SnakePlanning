function cost = costPhysics(arm, world, angles, con)
%Returns the cost for the applied torque not matching the torque needed
    cost = [];
    n = size(angles,2);
    
    kin = arm.getKin();
    
    for i=1:n
        theta = angles(:,i);
        [J, B, W, R, A, b] = getPhysicsParams(arm, world, theta, ...
                                                   con(:,i));
        
        tau = kin.getGravCompTorques(angles(:,i), [0 0 -1])';
        
        if (i > 1) && (i < n)
            v = (angles(:,i+1) - angles(:,i-1))/2;
            
            % tau = tau + kin.getDynamicsCompTorques()
        end
        
        [f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);
        
        torqueErr = J'*f + B*u - tau;
        cost = [cost; torqueErr];
    end
end




