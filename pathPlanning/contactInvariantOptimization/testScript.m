close all


worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
world = loadWorld(worldName);

if false
    %% Optimize Single Point
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 1,...
                         'numContacts', 1, 'world', world);

    % goal = [.3, 0, .2]';
    goal = [-.4, 0, .2]';
    % goal = [.1, -.4, .2]';
    % initial_angles = [1.5706, 1.2141, -0.0746, -0.0241, -0.0820, ...
    %                   0.1485, 0.9089, -0.6175, -0.4330, -0.2632]';
    % initial_angles = [1.5, -1.5, .5 , .2 , 0,...
    %                   0, 0 , 0 , 0 , 0 ]';
    initial_angles = zeros(10,1);

    [angles, c, ee] = traj.optimizePoint(...
        'EndEffectorGoal', goal, ...
        'display', 'raw',...
        'initialAngles', initial_angles)

    % disp('opt2')
    % [angles, c, ee] = traj.optimizePoint(...
    %     'EndEffectorGoal', goal, ...
    %     'display', 'raw',...
    %     'initialAngles', angles)

    % optAngles = optimizeSinglePoint(traj.arm, world, angles, ...
    %                                 false);
    % traj.arm.plotTorques(optAngles, world, 10000)
    
    % traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 7,...
    %     'numContacts', 2, 'world', world);

    % [a, c] = traj.separateState(state)
end

if true
    %% Optiize Trajectory
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 20,...
                         'numContacts', 6, 'world', world);
    % goal = [.1, -.4, .2]';
    % goal = [.4, -.1, .1]';
    goal = [-.4, 0, .2]';
    
    % initial_angles = [1.5706, 1.2141, -0.0746, -0.0241, -0.0820, ...
    %                   0.1485, 0.9089, -0.6175, -0.4330, -0.2632]';

    initial_angles = [1.3975, -1.0557, -0.2183, -0.4938, 0.1510, ...
                      1.3744, 0.5406, -0.7338, -0.4109, 0.0072]';
    % initial_angles = [1.2619, -0.3965, 0.9298, 0.6572, 0.5007, ...
    %                   0.0345, 1.5574, 0.1510, -0.4365, -1.1502]';
    
    
    % goal_angles = [1.3123, 1.5707, -0.1628, -0.1068, -0.1518,...
    %                -0.0953, 1.1470, -0.2779, -0.0099, -1.4319]';
    % goal_angles = [-0.1605, 1.5703, 1.2461, -0.0853, -0.3379,...
    %                -0.9222, 0.5119, -0.0706, -0.0198, 0.5794]';
    goal_angles = [1.3975, 1.57, -0.2183, -0.4938, 0.1510, ...
                      1.3744, 0.5406, -0.7338, -0.4109, 0.0072]';
    
    seedAngles = interpolateTrajectory([initial_angles, goal_angles], 19);
    seedAngles = reshape(seedAngles, 10*20, 1);
    
    
    [angles, c] = traj.optimizeTrajectory(...
        'EndEffectorGoal', goal, ...
        'display', 'progress',...
        'initialAngles', initial_angles,...
        'seedAngles', seedAngles,...
        'maxIter', 10000)
    
    angles = interpolateTrajectory(angles, 10);
    loopTrajectory(traj.arm, world, 10000, angles)

end