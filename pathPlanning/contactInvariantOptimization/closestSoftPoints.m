function p_closest = closestSoftPoints(arm, world, angles)
    p = arm.getPoints(angles);
    stl.faces = world.faces;
    stl.vertices = world.vertices;
    for i=1:size(p,2)
        p_tmp = p(:,i);
        % [p_cl_tmp, face] = closestPointOnWorld_mex(p(:,i), stl);
        % [p_cl_tmp, face] = softNearestPointToSphere(p(:,1), world, ...
        %                                             arm.radius, 10000);
        p_cl_tmp = softNearestPointToSphere(p(:,i), world, ...
                                            arm.radius, 10000);
        p_closest(:,i) = p_cl_tmp;

    end

end
