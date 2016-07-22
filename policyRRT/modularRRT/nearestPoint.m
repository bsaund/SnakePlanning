function pIndex = nearestPoint(list, p)
%Linear search (inefficient) for finding the nearest point in a
%list
    if(isempty(list))
        pIndex = 0;
        return;
    end
    dist = pdist2(list, p);
    [~, pIndex] = min(dist);
end
