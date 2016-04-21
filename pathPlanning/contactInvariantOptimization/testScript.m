close all


worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
world = loadWorld(worldName);

if true
    %% Optimize Single Point
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 1,...
                         'numContacts', 1, 'world', world);

    goal = [0, .2, .33]';
    % goal = [.1, -.4, .2]';
    % initial_angles = [1.5706, 1.2141, -0.0746, -0.0241, -0.0820, ...
    %                   0.1485, 0.9089, -0.6175, -0.4330, -0.2632]';
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
    %% Optimize Trajectory
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 6,...
                         'numContacts', 6, 'world', world);
    % goal = [.1, -.4, .2]';
    goal = [.4, -.1, .1]';

    
    % initial_angles = [1.5706, 1.2141, -0.0746, -0.0241, -0.0820, ...
    %                   0.1485, 0.9089, -0.6175, -0.4330, -0.2632]';
    initial_angles = [1.2619, -0.3965, 0.9298, 0.6572, 0.5007, ...
                      0.0345, 1.5574, 0.1510, -0.4365, -1.1502]';
    [angles, c] = traj.optimizeTrajectory(...
        'EndEffectorGoal', goal, ...
        'display', 'none',...
        'initialAngles', initial_angles,...
        'maxIter', 10000)
    
    angles = interpolateTrajectory(angles, 10);
    loopTrajectory(traj.arm, world, 10000, angles)

end