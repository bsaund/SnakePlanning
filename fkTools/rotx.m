%Homogeneous transform matrix for a rotation about x
function m = rotx(theta)
    m = [1, 0,          0,          0;
         0, cos(theta), -sin(theta),0;
         0, sin(theta), cos(theta), 0;
         0, 0,          0,          1];
end