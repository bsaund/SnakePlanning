%Returns the point from a homogeneous transformation matrix
function p = getPoint(m)
    p = m(1:3,4)';
end
