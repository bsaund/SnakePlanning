function p = closestPointOnWorld(p_test, world)
%CLOSESTPOINTONWORLD finds the closest point to p_test that lies on
%the mesh 'world'. world should be a struct of faces and vertices,
%the same struct you might pass to matlab's 'patch'
    f = world.faces;
    v = world.vertices;
    numFaces = size(f,1);

    
    d = inf;

    for i=1:numFaces
        p_temp = Contact.closestPoint_mex(p_test, ...
                                      v(f(i,1),:)',...
                                      v(f(i,2),:)',...
                                      v(f(i,3),:)');
        d_temp = (p_test-p_temp)'*(p_test - p_temp);
%         d_temp = 1;
        if (d_temp < d)
            d = d_temp;
            p = p_temp;
        end
    end
                                      
end