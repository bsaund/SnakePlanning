function f = contactForce(p_test, world, radius, spring)
%CONTACTFORCE returns the force vector from a sphere at p_test
%interacting with the closest triangle in the world mesh
    p_closest = closestPointOnWorld_mex(p_test, world);
    v = p_test - p_closest;
    d = norm(v);
    f = spring*v*max(radius - d,0)/d;
end
