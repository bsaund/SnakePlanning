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
    for i=1:100
        c = [c, stp.cost(x, contacts)];
        x = x + stp.getPolicy(x, contacts);
        stp.sphereModel.plot(x);
    end
    figure()
    plot(c)
end
