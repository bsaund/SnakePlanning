close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
worldName = '../../worlds/higherLedge.stl';
world = loadWorld(worldName);

numJoints = 17;

traj = MultiSegmentTrajectory('numJoints', numJoints, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);
fr=[1, 0, 0,  0;
    0, 0, -1, 0;
    0, 1, 0,  0.05;
    0, 0, 0,  1;];
traj.setBaseFrame(fr);

traj.setStartConfig(zeros(numJoints,1));
traj.addSegment([-.2; -.1; .2], 4);
traj.addSegment([-.2;.1;.4],4);
traj.addSegment([-.2;.35;.4],4);



save('lastTrajectory', 'traj');
traj.showTrajectory(10)
