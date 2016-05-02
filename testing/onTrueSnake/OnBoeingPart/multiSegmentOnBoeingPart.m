close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
worldName = '../../../worlds/front_wing_section_trimmed.stl';

world = loadWorld(worldName);

numJoints = 17;

traj = MultiSegmentTrajectory('numJoints', numJoints, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);

rotx = [1  0 0 0;
        0 0 -1 0;
        0  1 0 0;
        0  0 0 1];
fr=[0, 0, -1,  0;
    0, 1, 0, 0;
    1, 0, 0,  0;
    0, 0, 0,  1;];
traj.setBaseFrame(rotx*fr);


goal=[-.2,-.2,.2]';


load('BoeingPartProgress');

p2 = -pi/4;
initialAngles = [0; p2; p2; -p2;
                 -p2; p2; p2/2; p2;
                 0; -p2;  p2; p2;
                 p2; -p2; 0; 0;
                 0];



% initialAngles = [-1.3708, 0.0000, 1.2379, -0.0000, -1.1218,...
%                  0.0358, 0.6213, 0.0000, 1.4136, -1.3635, ...
%                  -1.4533, -0.4433, 0.3162, -0.7830, 1.0322,...
%                  1.5600, -0.9317]';

% initialAngles = angles
% traj.trajOptimizer.arm.plot(initialAngles)

% return

[angles, c, ee] = traj.pointOptimizer.optimizePoint(...
    'EndEffectorGoal', goal, ...
    'display', 'raw',...
    'initialAngles', initialAngles)




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


return

traj.addSegment([-.2; -.45; .2], 4);
traj.addSegment([-.2; -.45; .5], 4);
traj.addSegment([-.1; -.45; .5], 1);
traj.addSegment([0; -.45; .5], 1);
traj.addSegment([.1; -.45; .5], 1);
traj.addSegment([.2; -.45; .5], 1);
traj.addSegment([.2; -.45; .2], 4);
traj.addSegment([.2; .45; .2], 4);
traj.addSegment([.2; .45; .3], 4);
traj.addSegment([-.2; .45; .3], 4);
traj.addSegment([-.2; .45; .2], 4);
traj.addSegment([-.2; 0; .2], 4);

save('lastTrajectory', 'traj');

% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
traj.showTrajectory(10)
