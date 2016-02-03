%Forward Kinematics of the snake
function [q, points] = FK(link_lengths, angles)

    TR = eye(4);
    points = getPoint(TR);
    for i = 1:size(link_lengths,1)
        TR = TR * linkFK(link_lengths(i), angles(i));
        points = [points; getPoint(TR)];
    end
    q = getXYZQ(TR);
end


%Forward kinematics for a single link of the snake
function m = linkFK(link_length, angle)
    m = trans(link_length,0,0) * rotz(angle) * rotx(pi/2);
end

