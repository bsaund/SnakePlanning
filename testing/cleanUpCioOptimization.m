function optimTraj = cleanUpCioOptimization()
    close all
    num_links = 10;
    spring = 10000;
    
    load reasonableTraj.mat
    load reasonableOptimTraj.mat
    
    worldName = '../worlds/block.stl';
    world = stlread(worldName);
    showWorld(world);
    snake = SpherePlotter();
    plt = HebiPlotter('lighting', 'off');
    kin = snake.getKin();
    angles = zeros(1,num_links);
%     snake.getPoints(angles);
        
    
%     optimTraj = optimizeEachPointToNeighbors(snake, world, angle_traj, false);
%     save('reasonableOptimTraj.mat','optimTraj');
%     plotTrajectory(snake, world, spring, optimTraj);
%     loopTrajectory(snake, world, spring, angle_traj);
    loopTrajectory(snake, world, spring, optimTraj);
    
    

end
