function plotTrajectory(arm, world, spring, trajectory)
    for i = 1:size(trajectory,1)
        arm.plotTorques(trajectory(i,:), world, spring);
    end
end
