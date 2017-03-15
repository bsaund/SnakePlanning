function [x, contacts] = showFollowingPolicy(start, contacts)
    close all
    world = loadWorld('worlds/flat.stl');
    % world = loadWorld('worlds/block.stl');
    showWorld(world);
    % stp = SpringTorquePolicy(world);
    stp = SpecifiedContactsPolicy(world);
    stp.setGoal([-.3,0,.15]');
    % stp.setGoal([0,.3,.1]');
    % stp.setGoal([.4,.1,.025]');
    % stp.setGoalAngles([1.5 1.5 0 0 .4, 0 0 0 0 0, 0])
    % stp.setGoalAngles(rand(size(start))*3 - 1.5);
    
    stp.sphereModel.plot(start);
    x = stp.combineState(start, contacts);
    
    c = [];
    % profile on
    for i=1:1000
        c = [c, stp.cost(x)];
        [u, progress] = stp.getAction(x);
        x = x + u;
        % x = bound(x, -1.57, 1.57);
        angles = stp.separateState(x);
        stp.sphereModel.plot(angles);
        if(stp.reachedGoal(x))
            disp('Goal Reached')
            break
        end
        if(~progress)
            break
        end
    end
    [angles, contacts] = stp.separateState(x)
    % profile viewer
    stp.sphereModel.plot(angles);
    fk = stp.sphereModel.getKin.getFK('EndEffector', angles);
    fk = fk(1:3,4)
    figure()
    plot(c)
end

