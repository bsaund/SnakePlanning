close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
worldName = '../../../worlds/front_wing_section_trimmed.stl';

world = loadWorld(worldName);

numJoints = 15;

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


% goal=[-.2,-.2,.2]';


% load('BoeingPartProgress');

% p2 = -pi/4;
% initialAngles = [0; p2; p2; -p2;
%                  -p2; p2; p2/2; p2;
%                  0; -p2;  p2; p2;
%                  p2; -p2; 0; 0;
%                  0];
             
initialAngles = [   -0.1473
   -1.4647
   -1.5000
    1.0537
    0.2720
   -0.8723
    0.0013
    0.9000
    0.0732
   -0.8633
   -0.1357
    0.8564
   -0.0613
   -0.5787
    0.1091];



% initialAngles = [-1.3708, 0.0000, 1.2379, -0.0000, -1.1218,...
%                  0.0358, 0.6213, 0.0000, 1.4136, -1.3635, ...
%                  -1.4533, -0.4433, 0.3162, -0.7830, 1.0322,...
%                  1.5600, -0.9317]';

% initialAngles = angles
% traj.trajOptimizer.arm.plot(initialAngles)

% return

% [angles, c, ee] = traj.pointOptimizer.optimizePoint(...
%     'EndEffectorGoal', goal, ...
%     'display', 'raw',...
%     'initialAngles', initialAngles)




% p2 = -pi/2;
% initialAngles = [p2; 0; -p2; 0;
%                  p2; 0; 0; 0;
%                  p2; p2;  -p2; 0;
%                  0; 0; 0; 0;
%                  0];
traj.setStartConfig(initialAngles);
traj.trajOptimizer.arm.plot(initialAngles);
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




% traj.addSegment([-.1; .2; .15], 4);
traj.addSegment([.1; .5; .2], 4);


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
