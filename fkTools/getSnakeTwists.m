function [t, g0] = getSnakeTwists(num_links)
%Get the twists and g0 for a chain of 
% Hebi Snake modules
    t = [];
    link_dist = 0.0639;
    p_i = [0;0;0.0366];
    w_i = [0;1;0];
    R = rotz(-num_links*pi/2);
    g0 = [R(1:3, 1:3), [0;0;num_links * link_dist]; [0,0,0,1]];
    xi = @(w, p) [-cross(w,p); w];    
    for i=1:num_links
        t = [t, xi(w_i, p_i)];
        p_i = p_i + [0;0;link_dist];
        w_i = [w_i(2); -w_i(1); 0];
    end
end

%Homogeneous transform matrix for a rotation about z
function m = rotz(theta)
    m = [cos(theta), -sin(theta), 0, 0;
         sin(theta),  cos(theta), 0, 0;
         0,          0,           1, 0;
         0,          0,           0, 1];
end
