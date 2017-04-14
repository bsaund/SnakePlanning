

trials = cell(2,1);
trials{1}.name = 'trial_1';
trials{1}.goal = [0; 1; .5];
trials{2}.name = 'trial_2';
trials{2}.goal = [0; .5; .5];
trials{3}.name = 'trial_3';
trials{3}.goal = [0; 0; .5];
trials{4}.name = 'trial_4';
trials{4}.goal = [-0.5; 0; .3];

for i=1:numel(trials)
    goal = trials{i}.goal;
    trial_name = [trials{i}.name, '_CIO'];
    % trial_name = [trials{i}.name, '_NoCon'];    
    genTrajectory
end