function cost = costContactViolation(pCenter, pClosest, armRadius, con)
%Cost of claiming to be in contact when in reality not in contact

% 
    cost = [];
    %For each time step sum the cost
    for i = 1:size(con,2)
        
        cs = repelem(con(:,i), 3).^(.5);

        
        %Subtract the joint radius to get the distance from the
        %point on the world to the edge of the sphere, not the
        %center of the sphere
        for joint=1:size(pCenter,2)
            p_tmp = pCenter(:,joint);
            p_cl_tmp = pClosest(:,joint);
            v = p_tmp - p_cl_tmp;
            v = v/(v'*v)^.5;
            pClosest(:,joint) = p_cl_tmp + v*(armRadius);
        end
        p_diff = pCenter - pClosest;
        p_diff = reshape(p_diff, numel(p_diff), 1);
        cost = [cost; cs .* p_diff];
    end
end
