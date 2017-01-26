close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
% worldName = '../../../worlds/front_wing_section_trimmed.stl';
worldName = '../../../worlds/table.stl';

world = loadWorld(worldName);
showWorld(world);

% numJoints = 17;
% jointTypes = cell(1,numJoints);

jointTypes(1) = {{'X5-4'}};
jointTypes(2) = {{'GenericLink',...
                'com',[.01,.01,.01]','out',...
                ((rotx(pi/2)+ [zeros(4,3),[0 -.04 .055 0]'])*rotz(pi)),...
                'mass',.1}};
jointTypes(3) = {{'X5-9'}};
jointTypes(4) = {{'FieldableElbowJoint'}};
jointTypes(5) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
jointTypes(6) = {{'FieldableElbowJoint'}};
jointTypes(7) = {{'FieldableElbowJoint'}};
jointTypes(8) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
jointTypes(9) = {{'FieldableElbowJoint'}};
jointTypes(10) = {{'FieldableElbowJoint'}};
jointTypes(11) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi}};
jointTypes(12) = {{'FieldableElbowJoint'}};
jointTypes(13) = {{'FieldableElbowJoint'}};
jointTypes(14) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
jointTypes(15) = {{'FieldableElbowJoint'}};
jointTypes(16) = {{'FieldableElbowJoint'}};


% rotx = [1  0 0 0;
%         0 0 -1 0;
%         0  1 0 0;
%         0  0 0 1];
fr=[1, 0, 0,  .3;
    0, 1, 0, 0;
    0, 0, 1,  .3;
    0, 0, 0,  1;];
fr = fr*rotz(-pi/4);

arm = SpherePlotter('JointTypes', jointTypes);
realisticArm = HebiPlotter('JointTypes', jointTypes, ...
                           'figureHandle', gcf(),...
                           'lighting', 'on');
arm.setBaseFrame(fr);
realisticArm.setBaseFrame(fr);

traj = MultiSegmentTrajectory('arm', arm, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);



goal=[-.2,-.2,.2]';


% load('BoeingPartProgress');


% initialAngles = [0; p2; p2; -p2;
%                  -p2; p2; p2/2; p2;
%                  0; -p2;  p2; p2;
%                  p2; -p2; 0; 0;
%                  ];
initialAngles = zeros(11,1);
initialAngles(1) = pi/4;
initialAngles(4) = -pi/4;
initialAngles(7) = 0;

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




% traj.addSegment([.4; -.5; .5], 3);
traj.addSegment([.3; 0; .5], 4);
traj.addSegment([-.3; 0; .5], 2);
% traj.addSegment([-.3; -.5; .5], 2);
traj.addSegment([-.3; 0; .9], 5);
% traj.addSegment([-.5; -.1; .9], 1);
% traj.addSegment([-.1; -.1; .9], 10);
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

save('lastTrajectory', 'traj', 'realisticArm', 'world',...
     'jointTypes');

% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
% traj.showTrajectory(10)
arm.clearPlot();
finalTrajectory = interpolateTrajectory(traj.trajectory, 10);
loopTrajectory(@realisticArm.plot, finalTrajectory);
