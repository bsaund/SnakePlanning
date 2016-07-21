classdef Tree < handle
    properties
        points
        parents
        cost
    end
    
    
    methods
        function add(this, pointValue, parentIndex)
            this.points = [this.points; pointValue];
            this.parents = [this.parents; parentIndex];
        end
        
        function append(this, pointValue)
        %Adds new node to tree with the parent being the last added node
            this.add(pointValue, length(this.parents));
        end
    end
end
