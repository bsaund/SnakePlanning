%Homogeneous transform matrix for a rotation about z
function m = rotz(theta)
    m = [cos(theta), -sin(theta), 0, 0;
         sin(theta),  cos(theta), 0, 0;
         0,          0,           1, 0;
         0,          0,           0, 1];
end