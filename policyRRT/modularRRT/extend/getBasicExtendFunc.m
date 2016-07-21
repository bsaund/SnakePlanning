function extend = getBasicExtendFunc(stepSize, maxSteps)
    function basicExtend(tree, goal, obstacles)
        startInd = nearestPoint(tree.points, goal);
        start = tree.points(startInd, :);
        dist = sqrt(sumsqr(start-goal));
        dir = (goal-start)/dist;
        iter = 0;
        iterations = 1:min(maxSteps, dist/stepSize);
        for i = iterations;
            newPoint = start + dir*i*stepSize;
            if(obstacles.collides(newPoint))
                return
            end
            if(i==1)
                tree.add(newPoint, startInd);
            else
                tree.append(newPoint);
            end
        end
    end
    extend = @basicExtend;
end
