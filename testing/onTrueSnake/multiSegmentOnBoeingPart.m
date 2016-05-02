close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
worldName = '../../worlds/Simplified_wing_section.stl';
world = loadWorld(worldName);

numJoints = 17;

traj = MultiSegmentTrajectory('numJoints', numJoints, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);

fr=[1, 0, 0,  0;
    0, 0, -1, 0;
    0, 1, 0,  0.05;
    0, 0, 0,  1;];
traj.setBaseFrame(fr);


goal=[0,.2,.2]';


% p2 = -pi/2 + .2
% initialAngles = [p2; 0; -p2; 0;
%                  p2; 0; 0; 0;
%                  -p2; p2;  p2; 0;
%                  0; 0; 0; 0;
%                  0];

initialAngles = [-1.3708, 0.0000, 1.2379, -0.0000, -1.1218,...
                 0.0358, 0.6213, 0.0000, 1.4136, -1.3635, ...
                 -1.4533, -0.4433, 0.3162, -0.7830, 1.0322,...
                 1.5600, -0.9317]';

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
traj.addSegment([-.2; .5; .2], 4);
traj.addSegment([-.2; .5; .5],4);
traj.addSegment([.2; .25; .5],4);
% % traj.addSegment([-.2;.35;.4],4);



save('lastTrajectory', 'traj');
traj.showTrajectory(10)
