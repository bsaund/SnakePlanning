function core = getPolicyRrtCore(policyExtend, sample, goalReached)
    function tree = policyCore(start, goal, policy, debug)
        if(nargin < 3)
            debug = false;
        end
        
        if(debug >= 1)
            numExtends = 0;
            modVal = 1;
        end
        
        tree = Tree();
        tree.points = start;
        tree.parents = 0;
        i = 0;
        
        while(~goalReached(tree.points(end,:)));
            x_rand = sample(i, goal)
            policyExtend(tree, x_rand, goal, policy);
            i = i+1;

            if(debug >= 1)
                numExtends = numExtends+1;
            end
            
            if(debug >= 2)
                lastPlotted = length(tree.parents);
                if(mod(numExtends,modVal)==0)
                    disp(sprintf('Num Extend Attempts: %d', ...
                                 numExtends));
                    modVal = modVal*10;
                end
            end
        end

        if(debug >= 1)
            disp('Goal Reached');
            disp(sprintf('Extended %d times', numExtends));
            disp(sprintf('Tree size: %d', size(tree.points,1)));
            drawnow
        end
    end
    core = @policyCore;
end
