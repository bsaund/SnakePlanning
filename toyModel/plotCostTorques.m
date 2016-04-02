function plotCostTorques()
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
    
    torques = zeros(num_points, num_links);

    view([0 10]);
    camzoom(4);
    camtarget([0 0 0]);

    %% MOVIE
    % for i=1:num_points
    %     snake.plotTorques(angles(i,:)', world, spring)
    % end



    %% PLOT
    figure
    for spring = logspace(4,2.3010,50)

        for i=1:num_points
            % torques(i,:) = snake.getTorques(angles(i,:), world, ...
            %                                              spring);
            fun = getCostFunction1DSpringModel(snake, world, spring, ...
                                                      angles(i,1));
            costTmp = fun();
            cost(i) = costTmp' * costTmp;
        end
        plot(angles(:,1), cost)
        axis([-2 2 0 .05]); 
        text(-.5, .04, ['Spring Constant = ' num2str(round(spring))]);
        drawnow
    end
end
