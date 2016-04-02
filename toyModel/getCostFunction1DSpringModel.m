function costFun = getCostFunction1DSpringModel(snake, world, spring, ...
                                                       theta);
    goalX = .1;
    
    function cost = costFunction()
        angles = [theta; 0];
        fk = snake.getKin().getFK('EndEffector', angles);
        pointErr = fk(1,4) - goalX;
        torques = snake.getTorques(angles, world, spring);
        
        
        cTask = .5*pointErr;
        cost = [torques(1); cTask];
    end
    
    costFun=@costFunction;
end
