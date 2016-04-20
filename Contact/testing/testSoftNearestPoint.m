function testSoftNearestPoint()
    close all
    world = loadWorld('../../worlds/block.stl');
    showWorld(world);
    light('Position',[0,0,10]);
    light('Position',[5,0,10]);
    light('Position',[-5,0,10]);



    
    sphereCenter = [0;0;.1];
    radius = .03;
    h = patchSphere(sphereCenter, radius);
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
        h = patchSphere(sphereCenter, radius)
        p = softNearestPointToSphere(sphereCenter, world, radius, ...
                                 10000)
        dist = sqrt(sumsqr(p - sphereCenter)) - radius
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

