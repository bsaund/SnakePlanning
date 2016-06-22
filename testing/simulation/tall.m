close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
% worldName = '../../../worlds/front_wing_section_trimmed.stl';

world = loadWorld(worldName);

numJoints = 40;

traj = MultiSegmentTrajectory('numJoints', numJoints, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);

traj.setBaseFrame(eye(4));


goal=[-.2,-.2,.2]';


% load('BoeingPartProgress');


% initialAngles = [pi/2, zeros(1,16)]';
% initialAngles = [zeros(1,numJoints)]';
initialAngles = [-pi/3, zeros(1,numJoints-1)]';
% initalAngles = traj.pointOptimizer.arm.getKin().getIK('xyz', goal)

% initialAngles = angles
% traj.trajOptimizer.arm.plot(initialAngles)

% return

profile on

[angles, c, ee] = traj.pointOptimizer.optimizePoint(...
    'EndEffectorGoal', goal, ...
    'display', 'none',...
    'InitialAngles', initialAngles)

traj.pointOptimizer.arm.plot(angles);
profile viewer
return


% p2 = -pi/2;
% initialAngles = [p2; 0; -p2; 0;
%                  p2; 0; 0; 0;
%                  p2; p2;  -p2; 0;
%                  0; 0; 0; 0;
%                  0];
traj.setStartConfig(angles);
traj.trajOptimizer.arm.plot(angles);
% traj.addSegment([-.2; -.5; .2], 4);
% traj1 = traj.trajectory
% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
% disp('FINISHED SEGMENT 1')

% traj.addSegment([-.2; -.5; .5],4);
% traj2 = traj.trajectory
% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
% disp('FINISHED SEGMENT 2')

% traj.addSegment([.2; -.5; .2],4);
% traj3 = traj.trajectory
% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
% disp('FINISHED SEGMENT 3')

% traj.addSegment([.2;.5;.2],4);
% traj4 = traj.trajectory
% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
% disp('FINISHED SEGMENT 4')



% profile on
traj.addSegment([-.2; -.45; .2], 4);
% profile viewer
% traj.addSegment([-.2; -.45; .5], 4);
% traj.addSegment([-.1; -.45; .5], 1);
% traj.addSegment([0; -.45; .5], 1);
% traj.addSegment([.1; -.45; .5], 1);
% traj.addSegment([.2; -.45; .5], 1);
% traj.addSegment([.2; -.45; .2], 4);
% traj.addSegment([.2; .45; .2], 4);
% traj.addSegment([.2; .45; .3], 4);
% traj.addSegment([-.2; .45; .3], 4);
% traj.addSegment([-.2; .45; .2], 4);
% traj.addSegment([-.2; 0; .2], 4);

save('lastTrajectory', 'traj');

% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
traj.showTrajectory(10)
