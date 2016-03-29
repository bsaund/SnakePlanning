function showWorldNormals(world)
    v = world.vertices;
    for i=1:size(world.faces,1)
        face = world.faces(i,:);
        p1 = v(face(1), :);
        p2 = v(face(2), :);
        p3 = v(face(3), :);
        pAvg = mean([p1; p2; p3]);
        scatter3(pAvg(1), pAvg(2), pAvg(3));
    end
end
