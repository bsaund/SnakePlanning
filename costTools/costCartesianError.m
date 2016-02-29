function fun = costCartesianError(kin, xyz)
    function cost = costFunction(angles)
        fk = kin.getFK('EndEffector', angles);
        cost = sumsqr(xyz-fk(1:3,4));
    end
    fun = @costFunction;
end
