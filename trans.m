%Homogeneous transform matrix for a translation
function t = trans(x,y,z)
    t = eye(4);
    t(1:3,4) = [x;y;z];
end
