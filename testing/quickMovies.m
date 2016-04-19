function quickMovies
global GLOBAL_TRAJ
    close all
    num_links = 10;
    spring = 10000;
    
    load reasonableTraj.mat
    
%     worldName = '../worlds/block.stl';
    worldName = '../worlds/Simplified_wing_section.stl';
    world = stlread(worldName);
    showWorld(world);
    snake = SpherePlotter();
    plt = HebiPlotter('lighting', 'off', 'drawWhen', 'later');
    kin = snake.getKin();
    angles = zeros(1,num_links);
%     snake.getPoints(angles);
        
    
%     optimTraj = optimizeEachPointToNeighbors(snake, world, angle_traj, false);
    axis([-1, 1, -1, 1, -1, 1])
    % plotTrajectory(snake, world, spring, optimTraj);
    loopTrajectory(snake, world, spring, GLOBAL_TRAJ);
    
end