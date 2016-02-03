%Homogeneous transform matrix for a rotation about y
function m = roty(theta)
    m = [cos(theta),  0, sin(theta), 0;
         0,           1, 0,          0;
         -sin(theta), 0, cos(theta), 0;
         0,           0, 0,          1];
end
