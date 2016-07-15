function showFollowingPolicy(start, contacts)
    close all
    world = loadWorld('worlds/flat.stl');
    % world = loadWorld('worlds/block.stl');
    showWorld(world);
    % stp = SpringTorquePolicy(world);
    stp = SpecifiedContactsPolicy(world);
    stp.setGoal([0,.3,.1]');
    stp.sphereModel.plot(start);
    x = start;
    
    c = [];
    % profile on
    for i=1:1000
        c = [c, stp.cost(x, contacts)];
        [u, contacts, progress] = stp.getPolicy(x, contacts);
        x = x + u;
        stp.sphereModel.plot(x);
        if(stp.reachedGoal(x))
            break
        end
        if(~progress)
            break
        end
    end
    % profile viewer
    fk = stp.sphereModel.getKin.getFK('EndEffector', x);
    fk = fk(1:3,4)
    figure()
    plot(c)
end
