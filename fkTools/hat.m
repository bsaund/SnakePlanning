function m = hat(v)
    if(length(v)==3)
        m=hat3(v);
        return;
    elseif(length(v)==6)
        m0 = hat3(v(4:6));
        m = [m0, v(1:3); 0,0,0,0];
        return;
    end
    
    error('Unable to compute hat for this length')
end

function m = hat3(v)
    m = [0, -v(3), v(2);
     v(3), 0, -v(1);
     -v(2), v(1), 0;];
end