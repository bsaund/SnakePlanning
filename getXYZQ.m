%Returns the [x y z q0 q1 q2 q3] from a homogeneous transform
function q = getXYZQ(m)
    q = [getPoint(m), tform2quat(m)];
end
