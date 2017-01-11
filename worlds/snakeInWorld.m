function snakeInWorld()
%A demo of the snake moving through the world
    close all
    worldName = 'block.stl';
    spring = 10000;
    
    showWorld(worldName);
    num_links = 10;
    
    world = stlread(worldName);
    snake = SpherePlotter();
    plt = HebiPlotter('lighting','off');
    angles = zeros(1,num_links);
    snake.getPoints(angles);
    kin = snake.getKin();
    
    num_points = 100;
    traj = lineTrajectory([.5, 0, 0], [0, .3, .253], num_points);
    angle_traj = zeros(num_points, num_links);


    for i = 1:size(traj,1)
        angles = kin.getIK('xyz', traj(i,:), ...
                                  'InitialPositions', angles);
        angle_traj(i,:) = angles;
%         snake.plotTorques(angles, world, spring);
    end
    
    
    
%     profile on

    
%     [angles,resnorm,residual,exitflag,output]  = ...
%           optimizeAngles(angle_traj(1,:)', snake, world, spring);
    for i=1:10:size(traj,1)
        disp(['Optimizing config ', num2str(i)]);
        [angles,resnorm,residual,exitflag,output]  = ...
            optimizeAngles(angle_traj(i,:)', snake, world, spring);
    end
%     snake.plotTorques(angles, world, spring);
%     replayMotion(angle_traj, snake, plt, world, spring);
%     profile viewer
end


function [x,resnorm,residual,exitflag,output]  = ...
            optimizeAngles(initial_angles, snake, world, spring)
    
    function stop = plotOptim(x, varargin)
        snake.plotTorques(x, world, spring)
        stop = false;
    end
    options = optimoptions('lsqnonlin','PlotFcn', @plotOptim);
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
        tau = snake.getSpringTorques(angles, world, spring);
        angleErr = initial_angles-angles;
        c = [tau; angleErr];
    end
    func = @cost;
end

function trajectory = lineTrajectory(p_start, p_end, num_points)

    trajectory = zeros(num_points,3);
    
    for i=1:num_points
        trajectory(i,:) = p_start + (p_end-p_start)*(i-1)/(num_points-1);
    end
end

function replayMotion(angle_traj, snake, plt, world, spring)
%% Repeat trajectory
    useRealistic = true;
    while true
        for i= 1:size(angle_traj, 1)
            if useRealistic
                plt.plot(angle_traj(i,:));
            else
                snake.plotTorques(angle_traj(i,:), world, spring);
            end
        end
        useRealistic = ~useRealistic;
    end

end
