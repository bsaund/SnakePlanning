function cost = costDistErr(angles)

    cost = [];
    n = size(angles,2);
    
    for i=2:n
        cost = [cost; angles(:,i) - angles(:,i-1)];
    end
end