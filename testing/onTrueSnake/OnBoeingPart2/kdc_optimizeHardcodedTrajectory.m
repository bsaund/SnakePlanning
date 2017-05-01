close all

tic;
% worldName = '../../../worlds/bumpy.stl';
% worldName = '../../../worlds/block.stl';
% worldName = '../../../worlds/flat.stl';
worldName = '../../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
% worldName = '../../../worlds/front_wing_section_trimmed.stl';
% worldName = '../../../worlds/wing_with_floor.stl';
world = loadWorld(worldName);
showWorldMultiPlots(world);

%%
jointTypes = getFodbotJointTypes();
numbodies = length(jointTypes);
%%

fr=[1, 0, 0,  0;
    0, 1, 0, -0.25;
    0, 0, 1,  0;
    0, 0, 0,  1;];
fr = fr*rotz(0);

arm = SpherePlotter('JointTypes', jointTypes);
realisticArm = HebiPlotter('JointTypes', jointTypes, ...
                           'figureHandle', gcf(),...
                           'lighting', 'on');

arm.setWorld(world)
arm.setBaseFrame(fr);
realisticArm.setBaseFrame(fr);

%%

traj = MultiSegmentTrajectory('arm', arm, 'numTimeSteps', 10,...
                         'numContacts', 5, 'world', world);
goalPosition = [0; 0.5; 0.6];
ikConfig = traj.trajOptimizer.arm.getIK(goalPosition)';
hold on
scatter3(goalPosition(1), goalPosition(2), goalPosition(3),'filled','SizeData', 200);
hold off
% realisticArm.plot(ikConfig);
% initialAngles = [-1.9839, 0.0000, 1.3063, -1.2756, 0.7608, 0.2888,...
% -1.2374, 0.2340, -1.0038, 0.2429, 1.1661]'; % result1
initialAngles = [1.1*pi, 0-pi/2, 1.3063+0.2, -1.2756, 0, 0.2888, -1.2374,...
0.2340, pi/2, 0.2429, 1.1661]'; % result2
% initialAngles = [1.0*pi, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]'; %result3
% initialAngles = [0.5*pi, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]'; %result4
% initialAngles = [0.4*pi, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]'; %result5
% initialAngles = [-0.4*pi, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]'; %result6
% initialAngles = [-0.4*pi, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]'; %result5

realisticArm.plot(initialAngles);

%%
traj.setStartConfig(initialAngles);
% traj.trajOptimizer.arm.plot(initial_angles);
traj.optimizeSingleConfig(initialAngles, goalPosition);
% [pointCioConfig, c, ee] = traj.pointOptimizer.optimizePoint(...
%     'EndEffectorGoal', goalPosition, ...
%     'display', 'raw', 'maxIter', 10000, ...
%     'initialAngles', initialAngles')

% arm.clearPlot();
%%
[J, B, W, R, A, b] = getPhysicsParams(arm, world, traj.trajectory(:,end), traj.contacts(:,end));
tau = arm.getGravTorques(traj.trajectory(:,end));
[f, u] = optimalRegularizedFU(J, B, tau, W, R, A, b);    
f = reshape(f,3,[]);
jointTorques = zeros(1,numbodies);
jointNum = 1;

for i=1:numbodies
    if (length(jointTypes{i}) == 1)
        jointTorques(i) = u(jointNum);
        jointNum = jointNum + 1;
    else
        jointTorques(i) = 0;
    end
        
end
forceMag = sqrt(sum(f.^2,1));

subplot(2,2,4);
xlim([1,numbodies]);

yyaxis right;
plot(1:1:numbodies, forceMag);
ylabel('contact force')

yyaxis left;
bar(1:1:numbodies, jointTorques);
ylabel('joint torques')

% loopTrajectoryWithForce(realisticArm, arm, finalTrajectory, finalForces)