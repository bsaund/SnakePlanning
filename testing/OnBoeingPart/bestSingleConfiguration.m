function optimTraj = bestSingleConfiguration()
    close all
    num_links = 10;
    spring = 10000;
    
    worldName = '../../worlds/Simplified_wing_section.stl';
    world = loadWorld(worldName);
    showWorld(world);

    snake = SpherePlotter();
    plt = HebiPlotter('lighting', 'off');
    kin = snake.getKin();
    angles = zeros(1,num_links);
    snake.getPoints(angles);
        
    num_points = 30;
%     traj = lineTrajectory([.5, 0, .025], [0,-.4, .2], num_points);
    traj = lineTrajectory([.3, .0, .3], [0,-.4, .2], num_points);
%     traj = lineTrajectory([0, -.30, .2], [0,-.4, .2], num_points);
%     traj = lineTrajectory([0, .01, .2], [0,-.4, .2], num_points);
%     traj = lineTrajectory([0, .3, .35], [0,-.4, .2], num_points);
    angle_traj = zeros(num_points, num_links);

%     profile on
    view([-161, 50])
    drawnow
    for i = 1:size(traj,1)
        angles = kin.getIK('xyz', traj(i,:), ...
                                  'InitialPositions', angles);
        angle_traj(i,:) = angles;
    end
    % angle_traj(1,:) = optimizeSinglePoint(snake, world, angle_traj(1,:), ...
    %                                       false);
    % angle_traj(end,:) = optimizeSinglePoint(snake, world, angle_traj(end,:), ...
    %                                       true);
    starting_angles = angle_traj(1,:)'
    
    [optimizedAngles, contacts]  = cioSinglePoint([0; .4; .2],...
        snake, world, angle_traj(1,:)', true)
%     for i=1:10
%     disp('OPTIMIZING ANOTHER TIME')
%     [optimizedAngles, contacts]  = cioSinglePoint(traj(i,:)',...
%         snake, world, optimizedAngles, true)
%     end

%     profile viewer
    
    
    fk = snake.getKin().getFK('EndEffector', optimizedAngles);
    final_position = fk(1:3, 4)
    

    % snake.plotTorques(angle_traj(end,:), world, spring);
    % plotTrajectory(snake, world, spring, angle_traj);

    % optimTraj = optimizeEachPointToNeighbors(snake, world, angle_traj, false);
    
    % % plotTrajectory(snake, world, spring, optimTraj);
    % loopTrajectory(snake, world, spring, optimTraj);
    
    

end
