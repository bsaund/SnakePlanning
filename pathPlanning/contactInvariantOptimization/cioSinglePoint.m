function [optimizedAngles, contacts] = cioSinglePoint(snake, world, ...
                                                   initial_angles, display)
%Contact Invariant Optimization for a single point

    [state,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, ...
                       display);
    [optimizedAngles, contacts] = fullStateToVars(state);

end



function [x,resnorm,residual,exitflag,output]  = ...
        optimizeAngles(initial_angles, snake, world, display)
    c = 0*initial_angles + 1;
    initial_state = [initial_angles; c];
    
    function stop = plotOptim(x, varargin)
        angles = fullStateToVars(x);
        optAngles = optimizeSinglePoint(snake, world, angles, ...
                                        false);
        snake.plotTorques(optAngles, world, 10000)
        % snake.plotTorques(angles, world, 10000)
        
        disp('New CIO position');
        % pause(1);
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
    [initial_angles, ~] = fullStateToVars(initial_state);
    fk_init = snake.getKin().getFK('EndEffector',initial_angles);
    ee_init = fk_init(1:3, 4);
    function c = cost(state)
        % tau = snake.getTorques(angles, world, spring);
        % angleErr = initial_angles-angles;
        [angles, c] = fullStateToVars(state);
        fk = snake.getKin().getFK('EndEffector', angles);
        pointErr = fk(1:3, 4) - ee_init;
        % c = [tau; angleErr; 1000*pointErr];
        cPh = costPhysics(snake, world, state);
        cCI = costContactInvariance(snake, world, state);
        cTask = pointErr;
        c = [cPh; cCI; pointErr];
        
    end
    func = @cost;
end



