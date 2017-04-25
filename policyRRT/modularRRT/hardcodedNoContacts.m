clear all
close all
% [obs, worldMin, worldMax, start, goal] = narrowCorridorWorld();
% [obs, worldMin, worldMax, start, goal] = simpleLocalMin();
numLinks = 11;
numContacts = 16;
minConfig = -1.57*ones(1,numLinks);
maxConfig = 1.57*ones(1,numLinks);
start = [1,.15,1,1,0,0,-1,1,0,0,0];
% goal = [0,.2,.30]';
% goal = [.1,.2,.3]';
% goal = [-.3,-.6,.1]';
goal = [0, -.5, .4]';

world = loadWorld('worlds/wing_with_floor.stl');
% world = loadWorld('worlds/flat.stl');
% world = loadWorld('worlds/block.stl');
showWorld(world);
% scatter3(goal(1), goal(2), goal(3));

policy = NoContactsPolicy(world, getFodbotJointTypes());
policy.sphereModel.radius=0.07;
policy.sphereModel.plot(start);
% stepSize = .01;
maxSteps = 61;

% plotWorld(obs, worldMin, worldMax, start, goal);
rng(0) %Seed random number generator




goals = [[-.5, -.1, .1];
         [-.4, -.2, .1];
         [-.3, -.3, .1];
         [-.2, -.4, .1];
         [-.1, -.5, .1];
         [0, -.5, .1];
         [0, -.5, .2];
         [0, -.5, .3];
         [0, -.5, .4];
         [-0.1, -.5, .5];
         [-0.2, -.6, .4];
         [-0.2, -.7, .4];
         [-0.2, -.8, .4];
         [-0.2, -.9, .4];
        ]';
% goals = [[.1, -.9, .1];
%          [0, -.7, .1];
%          [0, -.6, .1];
%          [0, -.5, .1];
%          [0, -.5, .2];
%          [0, -.5, .3];
%          [0, -.5, .4];
%          [0, -.5, .55];
%          [0, -.5, .7];         
%          [0, -.6, .5];
%          [0, -.7, .5];
%          [0, -.8, .5];
%          [0, -.9, .5];
%         ]';
% goals = [[0.2, -1, .1];
%          [-0, -.9, .1];
%          [-.2, -.8, .1];
%          [-.4, -.7, .1];
%          [-.6, -.6, .1];
%          [-.6, -.5, .1];
%          [-.6, -.5, .2];
%          [-.6, -.5, .3];
%          [-.6, -.5, .4];
%          [-.6, -.5, .5];
%          [-.6, -.5, .6];
%          [-.6, -.5, .7];
%          [-.6, -.6, .6];         
%          [-.7, -.7, .5];
%          [-.8, -.8, .5];
%          [-.8, -.9, .4];
%          [-.7, -1.0, .4];
%         ]';

path = start;

delta = 0.3*ones(1,11);

view([0.2,2,2])
for i=1:size(goals,2)
    policy.setGoal(goals(:,i));
    l = path(end,:);
    lb = max(l-delta, 0*l - 1.57);
    ub = min(l+delta, 0*l + 1.57);
    new_ang = fmincon(@policy.cost, l,[],[],[],[],lb, ub);
    policy.cost(new_ang, 1)
    % policy.sphereModel.plot(new_ang);
    policy.plotObCost(new_ang);
    path = [path; new_ang];
end
path

aug_path = interpolateTrajectory(path',5)';

save('hardcoded_path_wing', 'path')

while(true)
    for i=1:size(aug_path,1)
        ang = aug_path(i,:);
        % colors = policy.obstacleCost(ang);
        % policy.sphereModel.plotColored(ang, colors);
        policy.plotObCost(ang);
    end
    pause(1);
end

% profile viewer

% plotTree(tree)
% drawnow
% return


% policy = PotentialFieldPolicy();
% policy.setObstacles(obs);

% extend = getPolicyExtendFunc(stepSize, maxSteps);

% policyCore = getPolicyRrtCore(extend, sample);

% % profile on 
% plotWorld(obs, worldMin, worldMax, start, goal)
% rng(0) %Seed random number generator
% plotTree(policyCore(start, goal, policy, 0))

% profile viewer