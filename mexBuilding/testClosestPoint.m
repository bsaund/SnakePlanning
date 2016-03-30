function testClosestPoint()
    world = loadWorld('block.stl');
    stl.faces = world.faces;
    stl.vertices = world.vertices;
    p = [0;0;0];
    closestPointOnWorld(p, stl);
%     closestPointOnWorld(p, 1);
end