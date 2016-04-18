close all
angles = 1:7;
c = [1, 2.5];
state = [repelem(angles, 10), repelem(c,10)];

worldName = '../../worlds/block.stl';
world = loadWorld(worldName);
traj = CioTrajectory('numJoints', 10, 'numTimeSteps', 7,...
    'numContacts', 2, 'world', world);

[a, c] = traj.separateState(state)