function optimTraj = bestSingleConfigurationCioObject()
    close all
    
    worldName = '../../worlds/block.stl';
    world = loadWorld(worldName);
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 1,...
                         'numContacts', 1, 'world', world);
        
    optimizedAngles = ...
        traj.optimizePoint('EndEffectorGoal', [0, .3, .35]',...
                           'display', 'raw')


%     optAngles = optimizeSinglePoint(snake, world, optimizedAngles, ...
%         false);
%     snake.plotTorques(optAngles, world, 10000)

    fk = traj.arm.getKin().getFK('EndEffector', optimizedAngles);
    final_position = fk(1:3, 4)
    


    
    

end
