function optimizedTrajectory = optimizeEachPointToNeighbors(snake, world, ...
                                                 trajectory, display)
%Does a simple optimization of each point along a trajectory
    spring = 10000;
    optimizedTrajectory = trajectory;

    for iter = 1:4
        for i=2:1:(size(trajectory,1)-1)
            disp(['Optimizing config ', num2str(i)]);
            [angles,resnorm,residual,exitflag,output]  = ...
                optimizeAngles(trajectory(i-1,:)', ...
                               trajectory(i+1,:)', ...
                               snake, world, spring, ...
                               display);
            optimizedTrajectory(i,:) = angles';
        end
        trajectory = optimizedTrajectory;
    end
end



function [x,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(prev_angles, next_angles, ...
                       snake, world, spring, display)
    
    function stop = plotOptim(x, varargin)
        snake.plotTorques(x, world, spring)
        stop = false;
    end
    
    maxIter = 3;
    if(display)
        options = optimoptions('lsqnonlin','maxIter', maxIter,'PlotFcn', @plotOptim);
    else
        options = optimoptions('lsqnonlin','maxIter', maxIter,'display','none');
    end
    
    initial_angles = (prev_angles + next_angles)/2;
    
    func = getCostFunction(prev_angles, next_angles, snake, world, spring);
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

function func = getCostFunction(prev_angles, next_angles, snake, world, spring)
    function c = cost(angles)
        tau = snake.getTorques(angles, world, spring);
        prevErr = prev_angles-angles;
        nextErr = next_angles-angles;
        c = [tau; prevErr; nextErr];
        
        % angleErr = (prev_angles + next_angles)/2 - angles;
        % c = [tau; angleErr];
    end
    func = @cost;
end



