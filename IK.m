function [angles] = IK( target, link_lengths, min_angles, max_angles, ...
                         obstacles, fk_func)
%% Function that uses optimization to do inverse kinematics for a snake robot

%%Outputs 
% [r, p, y] = roll, pitch, yaw vectors of the N joint angles
%            (N link coordinate frames)
%%Inputs:
% target: [x, y, z, q0, q1, q2, q3]' position and orientation of the end
%    effector
% link_length : Nx1 vectors of the lengths of the links
% min_xxx, max_xxx are the vectors of the 
%    limits on the roll, pitch, yaw of each link.
% limits for a joint could be something like [-pi, pi]
% obstacles: A Mx4 matrix where each row is [ x y z radius ] of a sphere
%    obstacle. M obstacles.

% Your code goes here.
    
    n = size(link_lengths,1);
    figure()
    hold on;
    % plotSnake(link_lengths, [0 1 0], [0 1 1], [0 0 1]);
    
    function c = cost(angles)
        [q_ee, points] = fk_func(link_lengths, angles);
                            
        angle_err = quatdiff(target(4:end), q_ee(4:end));
        % angle_err = 0;
        dist_err = sumsqr(target(1:3) - q_ee(1:3));
        c = 0*angle_err + dist_err;
    end
    
    x0 = zeros(n,1);
    
    size(x0)
    size(min_angles)
    size(max_angles)
    
    x_best = fmincon(@cost, x0, [],[],[],[], min_angles, max_angles)
    % cost([0 0 0, 0 0 0, 0 0 0])
    final_cost = cost(x_best)
    [ee, points] = fk_func(link_lengths, x_best);
    ee
    plotSnake(link_lengths, x_best, fk_func);
    angles = x_best;
end



%Plots the snake as a series of lines
function plotSnake(link_lengths, angles, fk_func)
    [~, points] = fk_func(link_lengths, angles);
    plot3Vec(points);
    scatter3(points(:,1), points(:,2), points(:,3));
end

function h = plot3Vec(v)
    h = plot3(v(:,1), v(:,2), v(:,3));
    axis equal
end




%Bounds input between max and min
function bounded = bound(input, max_val, min_val)
    bounded = max(min(input, max_val), min_val)
end

%Calculates the angular difference between two quaternions
function theta = quatdiff(q1, q2)
    qdiff = quatmultiply(q1, quatconj(q2));
    theta = 2 * acos(qdiff(1));
end

function q = quatconj(q)
    q = [q(1), -1 * q(2:end)];
end

function q = quatmultiply(q1, q2)
    q = zeros(1,4);
    s1 = q1(1);
    v1 = q1(2:4);
    s2 = q2(1);
    v2 = q2(2:4);
    
    q(1) = s1*s2 - dot(v1, v2);
    q(2:4) = s1*v2 + s2*v1 + cross(v1,v2);
end


% %Calculates the rotation quaternion from the homogeneous matrix
% function q = tform2quat(m)
%     m = m(1:3,1:3);
    
%     copysign = @(x,y) sign(y) * abs(x);
    
%     t = trace(m);
%     r = sqrt(1+t);
%     w = 0.5*r;
    
%     x = copysign(0.5*sqrt(1+m(1,1)-m(2,2)-m(3,3)), m(3,2)-m(2,3));
%     y = copysign(0.5*sqrt(1-m(1,1)+m(2,2)-m(3,3)), m(1,3)-m(3,1));
%     z = copysign(0.5*sqrt(1-m(1,1)-m(2,2)+m(3,3)), m(2,1)-m(1,2));
%     q = [w, x, y, z];
% end



