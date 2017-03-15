function extend = getPolicyExtendFunc(stepSize, maxSteps)
        
    function pointAdded = extendHelper(tree, startInd, goal, policy, ...
                                       numSteps)
        policy.setGoal(goal);
        originalTree = tree.points;
        
        x = originalTree(startInd, :);
        
        parentInd = startInd;

        iter = 0;
        
        prevCost = policy.cost(x);
        x = x + policy.getAction(x)*stepSize;
        newCost = policy.cost(x);
        
        makingProgress = newCost < prevCost && ...
            ~policy.obs.collides(x);
        
        EProgress = (prevCost - newCost)*.2; %minimium expected progress
        
        while( makingProgress && ...
               nearestPoint(originalTree, x) == startInd && ...
               iter < numSteps)
            tree.add(x, parentInd);
            parentInd = length(tree.parents);
            
            prevCost = newCost;
            x = x + policy.getAction(x)*stepSize;
            newCost = policy.cost(x);
            makingProgress = newCost < prevCost && ...
                ~policy.obs.collides(x);
            
            iter = iter + 1;
            
            % if( sqrt(sumsqr(x - goal)) < .7)
            %     makingProgress
            %     nearestPoint(originalTree, x) == startInd
            %     disp('close');
                
            % end

        end
        
        % if( sqrt(sumsqr(x - goal)) < .7)
        %     numSteps
        %     makingProgress
        %     prevCost
        %     newCost
        %     nearestPoint(originalTree, x) == startInd
        %     disp('close');
            
        % end

        pointAdded = iter > 0;
    end
    
    function policyExtend(tree, firstGoal, finalGoal, policy)
        startInd = nearestPoint(tree.points, firstGoal);
        if(~extendHelper(tree, startInd, ...
                         firstGoal, policy, maxSteps))
            return;
        end

        extendHelper(tree, length(tree.points), ...
                     finalGoal, policy, inf);
    end
    
    extend = @policyExtend;
end
