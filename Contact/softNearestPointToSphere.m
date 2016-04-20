function p_nearest = ...
    softNearestPointToSphere(p_sphere_center, world, ...
                                      sphere_radius, ...
                                      smoothness_parameter)
%SOFTNEARESTPOINTTOSPHERE finds the weighted nearest point on a
%mesh to a sphere. This does not return the actual nearest
%point. Instead it returns a weighted average of all the nearest points to
%each face. This provides a smooth function which is better for
%optimization. See Discovery of Complex Behaviors trhough
%Contact-Invariant Optimization by Igor Mordatch for the inspiration.

    f = world.faces;
    v = world.vertices;
    numFaces = size(f,1);
    r_sq = sphere_radius^2;
    
    weight_sum = 0;
    p_nearest = [0;0;0];
    
    for i=1:numFaces;
        p_temp = closestPoint(p_sphere_center, ...
                              v(f(i,1),:)',...
                              v(f(i,2),:)',...
                              v(f(i,3),:)');
        % d_sq_temp = (p_sphere_center-p_temp)'*(p_sphere_center - ...
        %                                        p_temp) - r_sq;
        d_sq_temp = (p_sphere_center-p_temp)'*(p_sphere_center - ...
                                               p_temp);
        
        d1 = d_sq_temp - r_sq;
        d2 = (sqrt(d_sq_temp) - sphere_radius)^2;
        
        
        weight = 1/(.00001 + smoothness_parameter * d2);
        p_nearest = p_nearest + weight*p_temp;
        
        weight_sum = weight_sum + weight;
    end
    
    p_nearest = p_nearest / weight_sum;

end
