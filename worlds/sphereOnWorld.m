function sphereOnWorld()
    close all;
    worldName = 'flat.stl';
    showWorld(worldName);
    S = stlread(worldName);
    p_test = [.5; 0; 1];
    hold on;
    
    % scatter3(p_test(1), p_test(2), p_test(3));
    h = showSphere(p_test, .1);
    p_closest = Contact.closestPointOnWorld(p_test, S);
    scatter3(p_closest(1), p_closest(2), p_closest(3), 'r.');
    
    input('next sphere','s');
    delete(h);
    h = showSphere(p_test + 1, .2);
    
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
