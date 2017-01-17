function f = contactForce(p_test, world, radius, spring)
%CONTACTFORCE returns the force vector from a sphere at p_test
%interacting with the closest triangle in the world mesh
    stl.faces = world.faces;
    stl.vertices = world.vertices;

    [p_closest, face_closest] = closestPointOnWorld_mex(p_test, stl);
    v = p_test - p_closest;

    if(world.normals(face_closest,:) * v < 0)
        v = -v;
    end
    d = norm(v);
    f = spring*v*max(radius - d,0)/d;
end
