



data = load('storedData');
data = data.data;

real_data = struct();

fn = fieldnames(data);
fn = {'trial_4_CIO'};

for field_num=1:numel(fn)
    trial_name = fn{field_num};
    disp(['============TRIAL ', trial_name, '============='])
    
    sim = getfield(data, fn{field_num});
    traj = sim.trajectory;
    runTrajectoryOnSnake;
    
    real_trial_name = [fn{field_num}, '_real'];
    trial.goal = sim.goal;
    trial.torques = tq;
    real_data = setfield(real_data, real_trial_name, trial);
end 

save('storedRealData', 'real_data')