function [angleCost] = plotCostTorques()
    close all
    num_links = 2;
    spring = 1000;
    
    % worldName = '../worlds/block.stl';
    % worldName = '../worlds/flat_lifted.stl';
    worldName = '../worlds/flat_demo.stl';
    world = loadWorld(worldName);
    showWorld(world);
    snake = SpherePlotter();
    plt = HebiPlotter('resolution','high');
    kin = snake.getKin();
    angles = zeros(1,num_links);
    snake.getPoints(angles);
        
    num_points = 100;
    
    angles = zeros(num_points,num_links);
    angles(:,1) = linspace(-pi/2-.25, pi/2+.25, num_points)';
    
    torques = zeros(num_points, num_links);

    % figure()
    % showWorld(world)
    % plt.plot(angles(1,:)')
    view([0 10]);
    camzoom(3);
    camtarget([0 0 0]);

    %% MOVIE

    while false
        for i=1:num_points
            snake.plotTorques(angles(i,:)', world, spring, .1)
            % plt.plot(angles(i,:)')
        end
        for i=num_points:-1:1
            snake.plotTorques(angles(i,:)', world, spring, .1)
            % plt.plot(angles(i,:)')
        end
    end




    
    %% Detailed Plot
    figure
    num_points = 1000;
    angles = zeros(num_points,num_links);
    angles(:,1) = linspace(-pi/2-.25, pi/2+.25, num_points)';
    spring = 10000;
    cost = [];
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
    ylabel('Cost');
    xlabel('Joint Angle: \theta');

    
    %% Detailed Movie
    if false
        hold on;
        s = scatter(angles(1,1), cost(1), 'r');
        while true
            for i=1:3:num_points
                s.XData = angles(i,1);
                s.YData = cost(i);
                drawnow
            end
            for i=num_points:-3:1
                s.XData = angles(i,1);
                s.YData = cost(i);
                drawnow
            end

        end
        
        angleCost = [angles(:,1), cost'];
    end

    %% PLOT
    % hold on
    num_points = 100;
    hold on
    angles = zeros(num_points,num_links);
    angles(:,1) = linspace(-pi/2-.25, pi/2+.25, num_points)';
    cost = [];
    h1 = [];
    h2 = [];
    if true
        
        for spring = logspace(4,2.3010,100)

            for i=1:num_points
                % torques(i,:) = snake.getTorques(angles(i,:), world, ...
                %                                              spring);
                fun = getCostFunction1DSpringModel(snake, world, spring, ...
                                                          angles(i,1));
                costTmp = fun();
                cost(i) = costTmp' * costTmp;
            end
            delete(h1)
            delete(h2)
            h1 = plot(angles(:,1), cost, 'm');


            axis([-2 2 0 .05]); 
            h2 = text(-.5, .04, ['Spring Constant = ' ...
                            num2str(round(spring))], 'Color','m');
            title('Cost using spring model\\Cost= (Joint Torque)^2')
            ylabel('Cost');
            xlabel('Joint Angle: \theta');
            drawnow
            % hold off
        end
    end

    
end
