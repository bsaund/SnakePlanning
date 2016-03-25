function optimizedTrajectory = optimizeEachPoint(snake, world, ...
                                                 trajectory, display)
%Does a simple optimization of each point along a trajectory
    sprint = 10000;

    for i=1:10:size(traj,1)
        disp(['Optimizing config ', num2str(i)]);
        [angles,resnorm,residual,exitflag,output]  = ...
            optimizeAngles(angle_traj(i,:)', snake, world, spring);
    end
end



function [x,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, spring, display)
    
    function stop = plotOptim(x, varargin)
        snake.plotTorques(x, world, spring)
        stop = false;
    end
    if(display)
        options = optimoptions('lsqnonlin','PlotFcn', @plotOptim);
    else
        options = optimoptions('lsqnonlin')
    end
    
    func = getCostFunction(initial_angles, snake, world, spring);
    [lb, ub] = getBounds(initial_angles);
    [x,resnorm,residual,exitflag,output]  =... 
        lsqnonlin(func, initial_angles, lb, ub, options);
    % angles = zeros(1);
end


function [lb, ub] = getBounds(angles)
    lb = ones(size(angles))*-pi/2;
    ub = ones(size(angles))*pi/2;
    dist = .2;
    lb = max([angles-dist, lb]')';
    ub = min([angles+dist, ub]')';
    
end

function func = getCostFunction(initial_angles, snake, world, spring)
    function c = cost(angles)
        tau = snake.getTorques(angles, world, spring);
        angleErr = initial_angles-angles;
        c = [tau; angleErr];
    end
    func = @cost;
end



