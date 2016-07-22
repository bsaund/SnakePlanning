function extend = getSnakePolicyExtendFunc(maxSteps)
        
    function pointAdded = extendHelper(tree, startInd, policy, ...
                                       numSteps)
        originalTree = tree.points;
        
        x = originalTree(startInd, :);
        
        parentInd = startInd;

        iter = 0;
        
        % prevCost = policy.cost(x);
        % x = x + policy.getPolicy(x)*stepSize;
        % newCost = policy.cost(x);
        
        % makingProgress = newCost < prevCost && ...
        %     ~policy.obs.collides(x);
        
        % EProgress = (prevCost - newCost)*.2; %minimium expected progress
        [u, progress] = policy.getPolicy(x);
        x = x+u;
        while( progress && ...
               ~policy.reachedGoal(x) && ...
               nearestPoint(originalTree, x) == startInd && ...
               iter < numSteps)
            iter = iter + 1;
            if(mod(iter, 10) == 0)
                tree.add(x, parentInd);
                parentInd = length(tree.parents);

            end
            if(mod(iter,30) == 0)
                policy.sphereModel.plot(policy.separateState(x));
            end

            
            % prevCost = newCost;
            [u, progress] = policy.getPolicy(x);
            x = x+u;
            
            
            
            % if( sqrt(sumsqr(x - goal)) < .7)
            %     makingProgress
            %     nearestPoint(originalTree, x) == startInd
            %     disp('close');
                
            % end

        end
        
        if(policy.reachedGoal(x))
            tree.add(x, parentInd);
        end
        
        if(nearestPoint(originalTree, x) ~= startInd)
            disp('entered explored region')
        end
        if(~progress)
            disp('Stopped making progress')
        end
        % pause(1)
       
        
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
        n = length(firstGoal);
        % startInd = nearestPoint(tree.points(:,1:n), firstGoal);
        startInd = nearestPoint(tree.points, [firstGoal, zeros(1,11)]);
        policy.setGoalAngles(firstGoal);
        if(~extendHelper(tree, startInd, ...
                         policy, maxSteps))
            return;
        end
        policy.setGoal(finalGoal);
        extendHelper(tree, size(tree.points,1), ...
                     policy, inf);
    end
    
    extend = @policyExtend;
end
