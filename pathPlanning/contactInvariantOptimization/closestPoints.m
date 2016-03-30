function [p_closest, face_closest] = closestPoints(snake, world, angles)
    p = snake.getPoints(angles);
    stl.faces = world.faces;
    stl.vertices = world.vertices;
    for i=1:size(p,2)
        p_tmp = p(:,i);
        [p_cl_tmp, face] = closestPointOnWorld_mex(p(:,i), stl);
        p_closest(:,i) = p_cl_tmp;
        face_closest(i) = face;
    end

end
