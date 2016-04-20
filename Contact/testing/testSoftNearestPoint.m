function testSoftNearestPoint()
    close all
    world = loadWorld('../../worlds/block.stl');
    showWorld(world);
    light('Position',[0,0,10]);
    light('Position',[5,0,10]);
    light('Position',[-5,0,10]);

    stl.faces = world.faces;
    stl.vertices = world.vertices;


    
    sphereCenter = [0;0;.1];
    radius = .03;
    h = patchSphere(sphereCenter, radius);
    hs = scatter3(0,0,0);
    ha = scatter3(0,0,0);
    view(3);
    
    while true
        ui = input('direction: ', 's');
        switch ui
          case 'w'
            val = [0;0;.1];
          case 's'
            val = [0;0;-.1];
          case 'a'
            val = [0;.1;0];
          case 'd'
            val = [0;-.1;0];
          case 'e'
            val = [.1;0;0];
          case 'q'
            val = [-.1;0;0];
        end
        sphereCenter = sphereCenter + .1*val;
        delete(h)
        delete(hs)
        delete(ha)
        h = patchSphere(sphereCenter, radius);

        p_soft = softNearestPointToSphere(sphereCenter, world, radius, ...
                                 1e10);
        p_act = closestPointOnWorld_mex(sphereCenter, stl);
        
        p_soft - p_act
        hs = scatter3(p_soft(1), p_soft(2), p_soft(3), 'b');
        ha = scatter3(p_act(1), p_act(2), p_act(3), 'k');
        dist = sqrt(sumsqr(p_soft - sphereCenter)) - radius
        
    end
end

function h = patchSphere(p0, r)
    h = patch(getSphere(p0, r),...
              'FaceColor', [.5, .5, .5],...
              'EdgeColor', 'none',...
              'FaceLighting', 'gouraud',...
              'AmbientStrength',.1);
end

function cyl = getSphere(p0, r)
    [x,y,z] = sphere;
    cyl = surf2patch(r*x + p0(1), r*y + p0(2), r*z + p0(3));
end

