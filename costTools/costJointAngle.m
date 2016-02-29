function fun = costJointAngle(kin)
    function cost = costFunction(angles)
        cost = sumsqr(angles);
    end
    fun = @costFunction;
end
