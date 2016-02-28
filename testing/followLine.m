function followLine()
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
    
    trajectory = [lineTrajectory(p_0, p_1, 100);
                  lineTrajectory(p_1, p_2, 100);
                  lineTrajectory(p_2, p_3, 100);
                  lineTrajectory(p_3, p_0, 100);];
                  
                  
    
    for i=1:size(trajectory,1)
        p_goal = trajectory(i,:);
        angles = kin.getIK('xyz', p_goal, 'InitialPositions', ...
                                  angles);
        plotHebi(kin, angles, 'low_res');
        fk = kin.getFK('EndEffector', angles);
        scatter3(fk(1,4), fk(2,4), fk(3,4), 'k');
    end
end


function trajectory = lineTrajectory(p_start, p_end, num_points)

    trajectory = zeros(num_points,3);
    for i=1:num_points
        trajectory(i,:) = p_start + (p_end-p_start)*i/num_points;
    end
end
        