data = load('storedData');
data = data.data;

real_data = struct();

fn = fieldnames(data);
% fn = {'trial_4_CIO'};

for field_num=1:numel(fn)
    trial_name = fn{field_num};
    disp(['============TRIAL ', trial_name, '============='])
    
    trial = getfield(data, fn{field_num});
    tq = trial.torques;
    max_tq = max(abs(tq(:)));
    avg_tq = mean(abs(tq(:)));
    % disp([num2str(max_tq), ' (', num2str(avg_tq) ')'])
    fprintf('%4.2f (%4.2f)\n', max_tq, avg_tq);
end 

data = load('storedRealData');
data = data.real_data;

real_data = struct();

fn = fieldnames(data);
% fn = {'trial_4_CIO'};

for field_num=1:numel(fn)
    trial_name = fn{field_num};
    disp(['============TRIAL ', trial_name, '============='])
    
    trial = getfield(data, fn{field_num});
    tq = trial.torques;
    max_tq = max(abs(tq(:)));
    avg_tq = mean(abs(tq(:)));
    % disp([num2str(max_tq), ' (', num2str(avg_tq) ')'])
    fprintf('%4.2f (%4.2f)\n', max_tq, avg_tq);
end 

