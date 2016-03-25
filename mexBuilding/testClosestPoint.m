function testClosestPoint()
    world = stlread('block.stl');
    p = [0;0;0];
    closestPointOnWorld(p, world);
%     closestPointOnWorld(p, 1);
end