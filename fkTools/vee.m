function xi = vee(m)
    if(size(m,1) == 3)
        xi = vee3(m);
        return
    elseif(size(m,1) == 4)
        xi = [m(1:3,4); vee3(m(1:3,1:3))];
        return
    end
    error('Unable to compute vee for this length matrix')
    
end

function v = vee3(m)
    v(1,1) = m(3,2);
    v(2,1) = m(1,3);
    v(3,1) = m(2,1);
end
    