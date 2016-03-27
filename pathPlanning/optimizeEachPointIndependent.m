function optimizedTrajectory = optimizeEachPointIndependent(snake, world, ...
                                                 trajectory, display)
%Does a simple optimization of each point along a trajectory
    spring = 10000;
    optimizedTrajectory = zeros(size(trajectory));

    for i=1:1:size(trajectory,1)
        disp(['Optimizing config ', num2str(i)]);
        [angles,resnorm,residual,exitflag,output]  = ...
            optimizeAngles(trajectory(i,:)', snake, world, spring, ...
                           display);
        optimizedTrajectory(i,:) = angles';
    end
end



function [x,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, spring, display)
    
    function stop = plotOptim(x, varargin)
        snake.plotTorques(x, world, spring)
        stop = false;
    end
    
    maxIter = 20;
    if(display)
        options = optimoptions('lsqnonlin','maxIter', maxIter,'PlotFcn', @plotOptim);
    else
        options = optimoptions('lsqnonlin','maxIter', maxIter,'display','none');
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



