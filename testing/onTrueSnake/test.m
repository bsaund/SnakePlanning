close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
worldName = '../../worlds/ledge.stl';
world = loadWorld(worldName);

numJoints = 17;

if true
    %% Optimize Single Point
    traj = CioTrajectory('numJoints', numJoints, 'numTimeSteps', 1,...
                         'numContacts', 1, 'world', world);
    fr=[1, 0, 0,  0;
        0, 0, -1, 0;
        0, 1, 0,  0.05;
        0, 0, 0,  1;];
    traj.arm.setBaseFrame(fr);


    goal = [.1, .2, .5]';

    initial_angles = zeros(numJoints,1);
    initial_angles(2) = -pi/2;

    [angles, c, ee] = traj.optimizePoint(...
        'EndEffectorGoal', goal, ...
        'display', 'raw',...
        'initialAngles', initial_angles)

end

if true
    %% Optiize Trajectory
    numTimeSteps = 5;
    traj = CioTrajectory('numJoints', numJoints, 'numTimeSteps', numTimeSteps,...
                         'numContacts', 6, 'world', world);
    traj.arm.setBaseFrame(fr);

    

    initial_angles = zeros(numJoints,1)

    goal_angles = angles;
    
    seedAngles = interpolateTrajectory([initial_angles, goal_angles], numTimeSteps-1);
    seedAngles = reshape(seedAngles, numJoints*numTimeSteps, 1);
    
    
    [angles, c] = traj.optimizeTrajectory(...
        'EndEffectorGoal', goal, ...
        'display', 'progress',...
        'initialAngles', initial_angles,...
        'seedAngles', seedAngles,...
        'maxIter', 10)
    
    angles = interpolateTrajectory(angles, 10);
    
    save('lastTrajectory', 'traj', 'angles', 'world');
    
    loopTrajectory(traj.arm, world, 10000, angles)

end