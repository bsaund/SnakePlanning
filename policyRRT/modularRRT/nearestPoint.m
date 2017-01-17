function pIndex = nearestPoint(list, p)
%Linear search (inefficient) for finding the nearest point in a
%list
    if(isempty(list))
        pIndex = 0;
        return;
    end
    % dist = pdist2(list, p);
    % [~, pIndex] = min(dist);
    dist = @(a,b) norm(a-b);
    list;
    p;
    % S = [1:11 .001*ones(1,11)];
    S = [ones(1,11) .001*ones(1,11)];
    [~, pIndex] = pdist2(list, p, 'seuclidean', S, 'Smallest', 1);
end
