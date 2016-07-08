function c = staticCostFunction(state, debug)
    if(nargin < 2)
        debug = false;
    end

    [angles, con] = this.separateState(state);
    fk = this.arm.getKin.getFK('EndEffector', angles);

    pointErr = fk(1:3, 4) - goal_xyz;

    cPh = costPhysicsStatic(this.arm, this.world, angles, con);
    % cPh = costPhysics(this.arm, this.world, angles, c);
    cCI = 100*costContactViolation(this.arm, this.world, ...
                                   angles, con);
    cTask = 100*pointErr;
    cObstacle = 1000*costObjectViolation(this.arm, this.world, angles);
    c = [cPh; cCI; cTask; cObstacle;];

    if(debug)
        cPh = reshape(cPh, this.numJoints, this.numTimeSteps)
        cCI = reshape(cCI, this.numTimeSteps*3, this.numJoints)'
        cTask
        cObstacle = reshape(cObstacle, this.numJoints, this.numTimeSteps)
    end

    % c = [cPh; cCI; cTask];
end
