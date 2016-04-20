close all


% worldName = '../../worlds/block.stl';
worldName = '../../worlds/flat.stl';
world = loadWorld(worldName);

if false
    %% Optimize Single Point
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 1,...
                         'numContacts', 1, 'world', world);

    % goal = [0, .4, .3]';
    goal = [.1, -.4, .2]';

    [angles, c, ee] = traj.optimizePoint(...
        'EndEffectorGoal', goal, ...
        'display', 'raw',...
        'initialAngles', [0 0 0 0 0 0 0 0 0 0]')

    % disp('opt2')
    % [angles, c, ee] = traj.optimizePoint(...
    %     'EndEffectorGoal', goal, ...
    %     'display', 'raw',...
    %     'initialAngles', angles)

    optAngles = optimizeSinglePoint(traj.arm, world, angles, ...
                                    false);
    traj.arm.plotTorques(optAngles, world, 10000)
    
    % traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 7,...
    %     'numContacts', 2, 'world', world);

    % [a, c] = traj.separateState(state)
end

if true
    %% Optimize Trajectory
    traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 2,...
                         'numContacts', 1, 'world', world);
    goal = [.1, -.4, .2]';
    
    initial_angles = [1.5706, 1.2141, -0.0746, -0.0241, -0.0820, ...
                      0.1485, 0.9089, -0.6175, -0.4330, -0.2632]';
    [angles, c] = traj.optimizeTrajectory(...
        'EndEffectorGoal', goal, ...
        'display', 'raw',...
        'initialAngles', initial_angles)

end