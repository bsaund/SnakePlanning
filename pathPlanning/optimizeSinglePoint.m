function optimizedAngles = optimizeSinglePoint(snake, world, ...
                                                   initial_angles, display)
%Does a simple optimization of each point along a trajectory
    spring = 10000;
    
    [angles,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, spring, ...
                       display);
    optimizedAngles = angles;

end



function [x,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, spring, display)
    
    function stop = plotOptim(x, varargin)
        snake.plotTorques(x, world, spring)
        stop = false;
    end
    
    maxIter = 100;
    if(display)
        options = optimoptions('lsqnonlin','maxIter', maxIter, ...
                               'maxFunEvals', maxIter,'PlotFcn', @plotOptim);
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
    dist = .1;
    lb = max([angles-dist, lb]')';
    ub = min([angles+dist, ub]')';
    
end

function func = getCostFunction(initial_angles, snake, world, ...
                                              spring)
    fk_init = snake.getKin().getFK('EndEffector',initial_angles);
    ee_init = fk_init(1:3, 4);
    function c = cost(angles)
        tau = snake.getTorques(angles, world, spring);
        angleErr = initial_angles-angles;
        fk = snake.getKin().getFK('EndEffector', angles);
        pointErr = fk(1:3, 4) - ee_init;
        c = [tau; angleErr; pointErr];
    end
    func = @cost;
end



