function followLineExperimental()
%Plots a chain of hebi modules following a 
% line trajectory
%This copy of the function is meant for experimentation
    close all
    kin = HebiKinematics();
    range = 1:8;
    for i=range
        kin.addBody('FieldableElbowJoint');
    end

    
    p_0 = [.1, .1, .3];
    p_1 = [-.1, .1, .3];
    p_2 = [-.1, .2, .2];
    p_3 = [.1, .2, .2];
    
    
    figure();
    hold on;
    angles = kin.getIK('xyz', p_0);
    
    n = 40;
    trajectory = [lineTrajectory(p_0, p_1, n);
                  lineTrajectory(p_1, p_2, n);
                  lineTrajectory(p_2, p_3, n);
                  lineTrajectory(p_3, p_0, n);];
                  

    view_start = [150, 35];
    view_end = [150, 35];
    
    
    n = size(trajectory,1);
    
    
    % F(n) = struct('cdata', [], 'colormap', []);
    plotHebi(kin, angles, 'low_res');
    view(view_start);
    for i=1:n
        p_goal = trajectory(i,:);
        % angles = kin.getIK('xyz', p_goal, 'InitialPositions', ...
        %                           angles);
        % function fun =costFunction(kin, xyz)
        %     cart = costCartesianError(kin, xyz);
        %     fun = @(angles) cart(angles);
        % end

        angles = minimizeCost(kin, angles, @costExperimental, p_goal', ...
                              angles);
        plotHebi(kin, angles, 'low_res');
        % plotHebi(kin, angles);
        % view(view_start + (view_end - view_start)*i/n);
        % F(i) = getframe(gcf);
        fk = kin.getFK('EndEffector', angles);
        scatter3(fk(1,4), fk(2,4), fk(3,4), 'k');
        scatter3(p_goal(1), p_goal(2), p_goal(3), 'g');
    end
    % fig = figure()
    % input('Enter to play movie\n');
    % movie(fig, F, 5)
    % input('NextCommand\n');
    % movie2avi(F, 'prettyRendering.avi')
end


function trajectory = lineTrajectory(p_start, p_end, num_points)

    trajectory = zeros(num_points,3);
    for i=1:num_points
        trajectory(i,:) = p_start + (p_end-p_start)*i/num_points;
    end
end
        