classdef ClosestPointCalculator < handle
    
    methods
        function this = ClosestPointCalculator(world)
            this.world = world;
        end
        
        function [pClosest, faceClosest] = ...
                getClosestPointsFast(this, p)
            if( ~isequal(size(p), size(this.prevP)) ||...
                max(max(abs(p-this.prevP))) > 0.01)
                
                [this.prevPClosest, this.prevFClosest] = ...
                    this.getClosestPoints(p);
                this.prevP = p;
            end
            pClosest = this.prevPClosest;
            faceClosest = this.prevFClosest;

        end
        
        function [p_closest, face_closest] = ...
                getClosestPoints(this, p)
            stl.faces = this.world.faces;
            stl.vertices = this.world.vertices;
            for i=1:size(p,2)
                p_tmp = p(:,i);
                [p_cl_tmp, face] = closestPointOnWorld_mex(p(:,i), stl);
                p_closest(:,i) = p_cl_tmp;
                face_closest(i) = face;
            end

        end
    end
    
    properties
        world;
        prevP;
        prevPClosest;
        prevFClosest;
    end
end