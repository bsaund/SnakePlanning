function trajectory = lineTrajectory(p_start, p_end, num_points)
%Given a start point, end point, and number of points returns a
%vector of linearly spaced vectors (matrix)
%basically matlabs linspace for multiple dimensions
    trajectory = zeros(num_points,size(p_start,1));
    
    for i=1:num_points
        trajectory(i,:) = p_start + (p_end-p_start)*(i-1)/(num_points-1);
    end
end
