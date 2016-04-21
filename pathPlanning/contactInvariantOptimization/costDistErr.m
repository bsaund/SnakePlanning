function cost = costDistErr(angles)
%Returns the cost for the applied torque not matching the torque needed
    cost = [];
    n = size(angles,2);
    
    for i=2:n
        cost = [cost; angles(:,i) - angles(:,i-1)];
    end
end