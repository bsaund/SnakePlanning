close all
angles = 1:7;
c = [1, 2.5];
state = [repelem(angles, 10), repelem(c,10)];

worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
world = loadWorld(worldName);

traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 1,...
    'numContacts', 1, 'world', world);

[angles, c, ee] = traj.optimizePoint(...
    'EndEffectorGoal', [.1, -.4, .2]', ...
    'display', 'raw',...
    'initialAngles', [0 0 0 0 0 0 0 0 0 0]')

optAngles = optimizeSinglePoint(traj.arm, world, angles, ...
                                false);
traj.arm.plotTorques(optAngles, world, 10000)
    
% traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 7,...
%     'numContacts', 2, 'world', world);

% [a, c] = traj.separateState(state)
