function showFollowingPolicy(start)
    close all
    % world = loadWorld('worlds/flat.stl');
    world = loadWorld('worlds/block.stl');
    showWorld(world);
    stp = SpringTorquePolicy(world);
    stp.setGoal([0,.3,.3]');
    stp.sphereModel.plot(start);
    x = start;
    
    c = [];
    for i=1:100
        c = [c, stp.cost(x)];
        x = x + stp.getPolicy(x);
        stp.sphereModel.plot(x);
    end
    figure()
    plot(c)
end
