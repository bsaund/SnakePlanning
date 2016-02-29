function fun = costExperimental(kin, xyz, prev_angles)
    function cost = costFunction(angles)
        c1 = costCartesianError(kin, xyz);
        c2 = costJointAngle(kin);
        c3 = sumsqr(angles-prev_angles);
        cost = c1(angles) + .001*c2(angles) + 0.01 *c3;
    end
    fun = @costFunction;
end
