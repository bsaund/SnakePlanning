function [x, contacts] = followPolicy(start, contacts)
    close all
    world = loadWorld('worlds/flat.stl');
    % world = loadWorld('worlds/block.stl');
    showWorld(world);
    % stp = SpringTorquePolicy(world);
    stp = SpecifiedContactsPolicy(world);
    % stp.setGoal([0,.2,.35]');
    % stp.setGoal([0,.3,.1]');
    % stp.setGoal([.4,.1,.025]');
    stp.setGoalAngles([1.5 1.5 0 0 0, 0 0 0 0 0, 0])
    
    stp.sphereModel.plot(start);
    x = start;
    
    c = [];
    % profile on
    for i=1:1000
        c = [c, stp.cost(x, contacts)];
        [u, contacts, progress] = stp.getAction(x, contacts);
        x = x + u;
        x = bound(x, -1.57, 1.57);
        % stp.sphereModel.plot(x);
        if(stp.reachedGoal(x))
            disp('Goal Reached')
            break
        end
        if(~progress)
            break
        end
    end
    contacts
    % profile viewer
    stp.sphereModel.plot(x);
    fk = stp.sphereModel.getKin.getFK('EndEffector', x);
    fk = fk(1:3,4)
    figure()
    plot(c)
end

function var = bound(var, minval, maxval)
    one = ones(size(var));
    var = min(maxval.*one, max(minval.*one, var));
end
