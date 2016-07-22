clear all
close all
% [obs, worldMin, worldMax, start, goal] = narrowCorridorWorld();
% [obs, worldMin, worldMax, start, goal] = simpleLocalMin();
numLinks = 11;
minConfig = -1.57*ones(1,numLinks);
maxConfig = 1.57*ones(1,numLinks);
start = [[1.57, zeros(1,10)], [zeros(1,6) ones(1,5)]];
% goal = [0,.2,.30]';
goal = [-.4,-.05,.25]';

world = loadWorld('worlds/flat.stl');
showWorld(world);
scatter3(goal(1), goal(2), goal(3));
policy = SpecifiedContactsPolicy(world);
policy.sphereModel.plot(policy.separateState(start));
% stepSize = .01;
maxSteps = 61;
extend = getSnakePolicyExtendFunc(maxSteps);
sample = getSnakeSampling(20, minConfig, maxConfig);
goalReached = @policy.reachedGoal;
core = getPolicyRrtCore(extend, sample, goalReached);


% plotWorld(obs, worldMin, worldMax, start, goal);
rng(0) %Seed random number generator
% profile on

tree = core(start, goal, policy, 2);

path = [policy.separateState(tree.points(end,:))];
parent = tree.parents(end);

while(parent >1)
    path = [policy.separateState(tree.points(parent,:)); path];
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