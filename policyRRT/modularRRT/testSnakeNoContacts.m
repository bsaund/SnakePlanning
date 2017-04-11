clear all
close all
% [obs, worldMin, worldMax, start, goal] = narrowCorridorWorld();
% [obs, worldMin, worldMax, start, goal] = simpleLocalMin();
numLinks = 11;
numContacts = 16;
minConfig = -1.57*ones(1,numLinks);
maxConfig = 1.57*ones(1,numLinks);
start = [1,.15,1,-1,0,0,-1,0,-1,0,0];
% goal = [0,.2,.30]';
% goal = [.1,.2,.3]';
% goal = [-.3,-.6,.1]';
goal = [0, -.5, .4]';

world = loadWorld('worlds/wing_with_floor.stl');
% world = loadWorld('worlds/flat.stl');
% world = loadWorld('worlds/block.stl');
showWorld(world);
scatter3(goal(1), goal(2), goal(3));

policy = NoContactsPolicy(world, getFodbotJointTypes());
policy.sphereModel.plot(start);
% stepSize = .01;
maxSteps = 61;
extend = getSnakePolicyExtendFunc(maxSteps);
% sample = getSnakeSampling(20, minConfig, maxConfig);
sample = getSnakeSampling(minConfig, maxConfig);
goalReached = @policy.reachedGoal;
core = getPolicyRrtCore(extend, sample, goalReached);


% plotWorld(obs, worldMin, worldMax, start, goal);
rng(0) %Seed random number generator
profile on


tree = core(start, goal, policy, 2);
profile viewer


end_angles = tree.points(end,:);
path = [end_angles];


parent = tree.parents(end);

while(parent >1)
    angles = tree.points(parent,:);
    path = [angles; path];
    parent = tree.parents(parent);
end

while(true)
    for i=1:size(path,1)
        policy.sphereModel.plot(path(i,:));
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