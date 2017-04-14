close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
worldName = '../../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
% worldName = '../../../worlds/front_wing_section_trimmed.stl';
% worldName = '../../../worlds/wing_with_floor.stl';
world = loadWorld(worldName);
showWorld(world);

% numJoints = 17;
% jointTypes = cell(1,numJoints);

% jointTypes(1) = {{'X5-4'}};
% jointTypes(2) = {{'GenericLink',...
%                 'com',[.01,.01,.01]','out',...
%                 ((rotx(pi/2)+ [zeros(4,3),[0 -.04 .055 0]'])*rotz(pi)),...
%                 'mass',.1}};
% jointTypes(3) = {{'X5-9'}};
% jointTypes(4) = {{'FieldableElbowJoint'}};
% jointTypes(5) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
% jointTypes(6) = {{'FieldableElbowJoint'}};
% jointTypes(7) = {{'FieldableElbowJoint'}};
% jointTypes(8) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
% jointTypes(9) = {{'FieldableElbowJoint'}};
% jointTypes(10) = {{'FieldableElbowJoint'}};
% jointTypes(11) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi}};
% jointTypes(12) = {{'FieldableElbowJoint'}};
% jointTypes(13) = {{'FieldableElbowJoint'}};
% jointTypes(14) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
% jointTypes(15) = {{'FieldableElbowJoint'}};
% jointTypes(16) = {{'FieldableElbowJoint'}};
jointTypes = getFodbotJointTypes();


% rotx = [1  0 0 0;
%         0 0 -1 0;
%         0  1 0 0;
%         0  0 0 1];
fr=[1, 0, 0,  0;
    0, 1, 0, 1;
    0, 0, 1,  0
    0, 0, 0,  1;];
fr = fr*rotz(0);

arm = SpherePlotter('JointTypes', jointTypes);
realisticArm = HebiPlotter('JointTypes', jointTypes, ...
                           'figureHandle', gcf(),...
                           'lighting', 'on');
arm.setBaseFrame(fr);
realisticArm.setBaseFrame(fr);

traj = MultiSegmentTrajectory('arm', arm, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);



% goal=[-.2,-.2,.2]';


% load('BoeingPartProgress');


% initialAngles = [0; p2; p2; -p2;
%                  -p2; p2; p2/2; p2;
%                  0; -p2;  p2; p2;
%                  p2; -p2; 0; 0;
%                  ];
% initialAngles = zeros(11,1);
% initialAngles(1) = pi/4;
% initialAngles(4) = -pi/4;
% initialAngles(7) = 0;


% initialAngles = [0.0388; -1.2968; -0.8412 ; 0.9183 ; 1.37; ...
%                  0.5174;
%                  0.2922; -0.0099 ; 0.3029; -1.1143 ; 0.7576];

initialAngles=[-0.1047;
               -1.3670;
               -0.2637;
               0.3397;
               1.5699;
               0.6885;
               0.3648;
               -1.5469;
               0.2402;
               -1.5708;
               1.5705];

% initialAngles = [-1.3708, 0.0000, 1.2379, -0.0000, -1.1218,...
%                  0.0358, 0.6213, 0.0000, 1.4136, -1.3635, ...
%                  -1.4533, -0.4433, 0.3162, -0.7830, 1.0322,...
%                  1.5600, -0.9317]';

% initialAngles = angles
% traj.trajOptimizer.arm.plot(initialAngles)

% return

% [angles, c, ee] = traj.pointOptimizer.optimizePoint(...
%     'EndEffectorGoal', [.4; .5; 0], ...
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

% trial_name = 'trial_1';
% goal = [0; .5; .5];

% trial_name = 'trial_2';
% goal = [-.5; 0; .5];

% trial_name = 'trial_2';
% goal = [-.5; 0; .5];

% trial_name = 'trial_2';
% goal = [-.5; 0; .5];

% trial_name = 'trial_2';
% goal = [-.5; 0; .5];

% trial_name = [trial_name, '_CIO'];

traj.addSegment(goal, 7);
% traj.addSegment([0; -.80; .5], 2);
% traj.addSegment([0.1; -.90; .5], 2);
% traj.addSegment([-0.1; -.90; .5], 2);
% traj.addSegment([0; -.50; .1], 2);
% traj.addSegment([-.5; -1; .1], 2);
% traj.addSegment([-1; -.5; .1], 2);
% traj.addSegment([-1; -.90; .5], 2);
% traj.addSegment([-1; -.90; .5], 2);
% traj.addSegment([.3; .6; .6], 4);
% traj.addSegment([.1; .1; .6], 3);
% traj.addSegment([.1; .3; .9], 2);
% traj.addSegment([.1; -.1; .6], 3);
% traj.addSegment([.1; .3; .9], 2);
% traj.addSegment([-.3; .3; .85], 3);
% traj.addSegment([-.6; .3; .85], 3);
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


% torques = costPhysics(traj.trajOptimizer.arm, traj.trajOptimizer.world, ...
%             traj.trajectory, traj.contacts(:,2:end));

% torques = reshape(torques, traj.trajOptimizer.numJoints, [])

save('lastTrajectory', 'traj', 'realisticArm', 'world',...
     'jointTypes');


data = load('storedData');
data = data.data;
trial.goal = goal;
trial.torques = traj.torques;
trial.trajectory = traj;
data = setfield(data, trial_name, trial);

save('storedData', 'data')


% traj.showTrajectory(10)
arm.clearPlot();
finalTrajectory = interpolateTrajectory(traj.trajectory, 10);
% loopTrajectory(@realisticArm.plot, finalTrajectory);
