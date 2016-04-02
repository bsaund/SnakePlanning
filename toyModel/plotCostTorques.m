function plotCostTorques()
    close all
    num_links = 2;
    spring = 200;
    
    % worldName = '../worlds/block.stl';
    worldName = '../worlds/flat_lifted.stl';
    world = loadWorld(worldName);
    showWorld(world);
    snake = SpherePlotter();
    plt = HebiPlotter('lighting', 'off');
    kin = snake.getKin();
    angles = zeros(1,num_links);
    snake.getPoints(angles);
        
    num_points = 2000;
    
    angles = zeros(num_points,num_links);
    angles(:,1) = linspace(-pi/2-.5, pi/2+.5, num_points)';
    
    torques = zeros(num_points, num_links);
    
    for i=1:num_points
        torques(i,:) = snake.getTorques(angles(i,:), world, spring);
        snake.plotTorques(angles(i,:)', world, spring)
    end
    
    figure
    plot(angles(:,1), torques(:,1).^2)
    axis([-2 2 0 .1])
 
end
