function world = loadWorld(worldName)
    world = stlread(worldName);
    v = world.vertices;
    %Add normal vectors
    for i=1:size(world.faces,1)
        face = world.faces(i,:);
        p1 = v(face(1), :);
        p2 = v(face(2), :);
        p3 = v(face(3), :);
        pAvg = mean([p1; p2; p3]);
        v1 = p3-p1;
        v2 = p2-p1;
        normal = cross(v2,v1);
        normal = normal/norm(normal);
        normals(i,:) = normal;
        
        tangent1 = v2/norm(v2);
        tangents1(i,:) = tangent1;
        tangents2(i,:) = cross(normal, tangent1);
    end
    world.normals = normals;
    world.tangents_1 = tangents1;
    world.tangents_2 = tangents2;
    
    
end
