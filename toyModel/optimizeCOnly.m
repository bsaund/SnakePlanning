function c = optimizeCOnly(snake, world, theta)
    display =false;
    % function cost = costFun(c)
    %     state = [theta; 0; 0; c];
    %     cPh = costPhysics(snake, world, state);
    %     cCi = costContactInvariance(snake, world, state);
    %     cost = [cPh; cCi];
    % end
    costFun = getCostFunction1DCio(snake, world, theta);
    
    if(display)
        options = optimoptions('lsqnonlin','maxIter', maxIter, ...
                               'maxFunEvals', maxIter,'OutputFcn', @plotOptim);
    else
        options = optimoptions('lsqnonlin','display','none');
    end

    c = lsqnonlin(costFun, 1, 0, 100, options);
        
end
