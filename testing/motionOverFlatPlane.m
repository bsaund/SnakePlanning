function optimTraj = motionOverFlatPlane()
    close all
    num_links = 10;
    spring = 10000;
    
    worldName = '../worlds/block.stl';
    world = stlread(worldName);
    showWorld(world);
    snake = SpherePlotter();
    plt = HebiPlotter('lighting', 'off');
    kin = snake.getKin();
    angles = zeros(1,num_links);
    snake.getPoints(angles);
        
    num_points = 30;
    traj = lineTrajectory([.5, 0, 0.05], [0,-.5, 0.05], num_points);
    % traj = lineTrajectory([.5, 0, 0], [0,-.4, .2], num_points);
    angle_traj = zeros(num_points, num_links);


    for i = 1:size(traj,1)
        angles = kin.getIK('xyz', traj(i,:), ...
                                  'InitialPositions', angles);
        angle_traj(i,:) = angles;
    end
    angle_traj(1,:) = optimizeSinglePoint(snake, world, angle_traj(1,:), ...
                                          false);
    angle_traj(end,:) = optimizeSinglePoint(snake, world, angle_traj(end,:), ...
                                          false);
    
    
    
    plotTrajectory(snake, world, spring, angle_traj);

    optimTraj = optimizeEachPointToNeighbors(snake, world, angle_traj, false);
    
    % plotTrajectory(snake, world, spring, optimTraj);
    loopTrajectory(snake, world, spring, optimTraj);
    
    

end
