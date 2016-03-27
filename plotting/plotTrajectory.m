function plotTrajectory(snake, world, spring, trajectory)
    for i = 1:size(trajectory,1)
        snake.plotTorques(trajectory(i,:), world, spring);
    end

end
