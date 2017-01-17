clear all
close all
% [obs, worldMin, worldMax, start, goal] = narrowCorridorWorld();
[obs, worldMin, worldMax, start, goal] = simpleLocalMin();
stepSize = .01;
maxSteps = 50;
extend = getBasicExtendFunc(stepSize, maxSteps);
sample = getBasicSamplingFunc(20, worldMin, worldMax);
core = getBasicRrtCore(extend, sample);


plotWorld(obs, worldMin, worldMax, start, goal);
rng(0) %Seed random number generator
% profile on
tree = core(start, goal, obs, 0);
% profile viewer

plotTree(tree)
drawnow
% return


policy = PotentialFieldPolicy();
policy.setObstacles(obs);

extend = getPolicyExtendFunc(stepSize, maxSteps);

policyCore = getPolicyRrtCore(extend, sample);

% profile on 
plotWorld(obs, worldMin, worldMax, start, goal)
rng(0) %Seed random number generator
plotTree(policyCore(start, goal, policy, 0))

% profile viewer