function showFollowingPolicy(start)
    close all
    world = loadWorld('worlds/flat.stl');
    showWorld(world);
    stp = SpringTorquePolicy(world);
    stp.sphereModel.plot(start);
    x = start;
    for i=1:30
        x = x + stp.getPolicy(x);
        stp.sphereModel.plot(x);
    end
end
