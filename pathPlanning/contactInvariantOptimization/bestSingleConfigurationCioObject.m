function optimTraj = bestSingleConfigurationCioObject()
    close all
    num_links = 10;
    spring = 10000;
    
    worldName = '../../worlds/block.stl';
    world = loadWorld(worldName);
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 1,...
                         'numContacts', 1, 'world', world);
        
    traj.optimizePoint('EndEffectorGoal', [0, .3, .35]',...
                       'display', 'raw');

    traj = lineTrajectory([0, .3, .35], [0,-.4, .2], num_points);


%     optAngles = optimizeSinglePoint(snake, world, optimizedAngles, ...
%         false);
%     snake.plotTorques(optAngles, world, 10000)

%     fk = snake.getKin().getFK('EndEffector', optimizedAngles);
%     final_position = fk(1:3, 4)
    


    
    

end
