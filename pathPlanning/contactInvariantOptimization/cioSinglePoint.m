function optimizedAngles = cioSinglePoint(snake, world, ...
                                                   initial_angles, display)
%Contact Invariant Optimization for a single point

    [angles,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles', snake, world, ...
                       display);
    optimizedAngles = angles';

end



function [x,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, display)
    c = 0*initial_angles
    initial_state = [initial_angles; c];
    
    function stop = plotOptim(x, varargin)
        snake.plotTorques(x, world, spring)
        stop = false;
    end
    
    maxIter = 10000;
    if(display)
        options = optimoptions('lsqnonlin','maxIter', maxIter, ...
                               'maxFunEvals', maxIter,'PlotFcn', @plotOptim);
    else
        options = optimoptions('lsqnonlin','maxIter', maxIter,'display','none');
    end
    
    func = getCostFunction(initial_state, snake, world);
    [lb, ub] = getBounds(initial_angles, c);
    [x,resnorm,residual,exitflag,output]  =... 
        lsqnonlin(func, initial_state, lb, ub, options);
    % angles = zeros(1);
end


function [lb, ub] = getBounds(angles, c)
    lb = [ones(size(angles))*-pi/2;
          zeros(size(c));];
    ub = [ones(size(angles))*pi/2;
          ones(size(c))*100];
    % dist = .2;
    % lb = max([angles-dist, lb]')';
    % ub = min([angles+dist, ub]')';
    
end

function func = getCostFunction(initial_state, snake, world);
    % fk_init = snake.getKin().getFK('EndEffector',initial_angles);
    % ee_init = fk_init(1:3, 4);
    function c = cost(state)
        % tau = snake.getTorques(angles, world, spring);
        % angleErr = initial_angles-angles;
        % fk = snake.getKin().getFK('EndEffector', angles);
        % pointErr = fk(1:3, 4) - ee_init;
        % c = [tau; angleErr; 1000*pointErr];
        c = costPhysics(snake, state)
    end
    func = @cost;
end



