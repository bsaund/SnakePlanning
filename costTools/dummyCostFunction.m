function fun = dummyCostFunction(kin)
    function cost = costFunction(angles)
        fk = kin.getFK('EndEffector', angles);
        cost = max(abs(angles));
    end
    fun = @costFunction
end
