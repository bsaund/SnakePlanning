function plotCostCIO
    close all
    num_links = 2;
    spring = 1000;
    
    % worldName = '../worlds/block.stl';
    worldName = '../worlds/flat_lifted.stl';
    world = loadWorld(worldName);
    showWorld(world);
    snake = SpherePlotter();
    plt = HebiPlotter('lighting', 'off');
    kin = snake.getKin();
    angles = zeros(1,num_links);
    snake.getPoints(angles);
        
    num_points = 100;
    
    angles = zeros(num_points,num_links);
    angles(:,1) = linspace(-pi/2-.5, pi/2+.5, num_points)';
    

    % view([0 10]);
    % camzoom(4);
    % camtarget([0 0 0]);

    % %% MOVIE
    % for i=1:num_points
    %     snake.plotTorques(angles(i,:)', world, spring)
    % end



    %% Surface over c and angles
    figure


    contactVariables = 0:10';
    
    for i=1:num_points
        for c = 1:length(contactVariables)
            % torques(i,:) = snake.getTorques(angles(i,:), world, ...
            %                                              spring);
            fun = getCostFunction1DCio(snake, world, angles(i,1));
            costTemp = fun(contactVariables(c));
            cost(i, c) =costTemp' * costTemp;
            
        end
    end

    surf(angles(:,1), contactVariables, cost');
    
    
    %% Plot over angles using optimized c
    figure
    cost = zeros(num_points,1);
    for i=1:num_points
        c = optimizeCOnly(snake, world, angles(i,1));
        fun = getCostFunction1DCio(snake, world, angles(i,1));
        costTemp = fun(c);
        cost(i, 1) =costTemp' * costTemp;
    end
    
    plot(angles(:,1), cost(:,1))
    

    % end

end
