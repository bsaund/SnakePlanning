function loopTrajectory(snake, world, spring, angle_traj)
%% Repeat trajectory
    useRealistic = true;
    plt = HebiPlotter('lighting','off');
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
