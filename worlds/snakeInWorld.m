function snakeInWorld()
    close all
    worldName = 'block.stl';
    spring = 1000;
    
    showWorld(worldName);
    
    
    world = stlread(worldName);
    snake = SpherePlotter();
    angles = [0;-.5;0;.5;0;0;0;0];
    snake.getPoints(angles);
    

    % [p, r] = snake.getPoints(angles);
    % J = snake.getKin().getJacobian('CoM',angles);
    % % f = Contact.snakeContactForces(p, world, r, 100)
    % tau = Contact.snakeContactTorques(p, world, r, 1000, J)
    
    % snake.getKin().getGravCompTorques(angles, [0,0,-1])
    
    
    
    % [tau, grav] = snake.getTorques(angles, world, r, spring)
    while true
        for a = 0:.01:.8
            angles = [0;-a;0;a;0;0;0;0];
            snake.plotTorques(angles, world, spring);
        end
    end
end
