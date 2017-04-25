close all

worldName = '../../../worlds/flat.stl';
world = loadWorld(worldName);
showWorld(world);
jointTypes = getSimpleRobot();

arm = SpherePlotter('JointTypes', jointTypes);
realisticArm = HebiPlotter('JointTypes', jointTypes, ...
                           'figureHandle', gcf(),...
                           'lighting', 'off');
  
arm.setWorld(world);

traj = MultiSegmentTrajectory('arm', arm, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);

initialAngles = [1;0;0;0];
traj.setStartConfig(initialAngles);
traj.trajOptimizer.arm.plot(initialAngles);
goal = [0.6; 0; .1];
traj.addSegment(goal, 20);



arm.clearPlot();
f = traj.trajOptimizer.getForceTorques(traj.trajectory, traj.contacts);

finalTrajectory = interpolateTrajectory(traj.trajectory, 1);
finalForces = interpolateForces(f, 1);
% loopTrajectory(@realisticArm.plot, finalTrajectory);
loopTrajectoryWithForce(realisticArm, arm, finalTrajectory, finalForces)

