function bouncingSphere()
    close all;
    worldName = 'block.stl';
    showWorld(worldName);
    S = stlread(worldName);
    
    x = [.5; 0; .85];
    x_dot = [0;0;0];
    dt = .01;
    r = .3;
    spring = 1000;
    m = 1;
    g = [0;0;-9.8];
    axmin = -5;
    axmax = 5;
    
    hold on;
    view(3);
    
    % scatter3(x(1), x(2), x(3));
    h = showSphere(x, .1);
    p_closest = Contact.closestPointOnWorld(x, S);
    scatter3(p_closest(1), p_closest(2), p_closest(3), 'r.');
    
    while true

        [x, x_dot] = dynamics(x, x_dot, dt, r, spring, g, m, S);
        delete(h);
        h = showSphere(x, r);
        
        axis([axmin, axmax, axmin, axmax, axmin, axmax]);
        drawnow();
        % pause(dt)

    end
    
end

function [x, x_dot] = dynamics(x, x_dot, dt, r, spring, g, m, world)
    f = Contact.contactForce(x, world, r, spring)
    % input('Next dt?', 's');
    x_dot = x_dot + g * dt + m * f * dt;
    x = x + x_dot * dt;
    %Damping
    coulomb = .01;
    viscous = .99;
    for i = 1:3
        if(abs(x_dot(i)) < coulomb)
            x_dot(i) = 0;
        else
            x_dot(i) = sign(x_dot(i)) * (abs(x_dot(i)) - coulomb);
        end
    end
    x_dot = x_dot * viscous;
end

function h = showSphere(p0, r)
    x0 = p0(1);
    y0 = p0(2);
    z0 = p0(3);
    [x,y,z] = sphere();
    h = surf(r*x + x0, ...
             r*y + y0, ...
             r*z + z0);
end
