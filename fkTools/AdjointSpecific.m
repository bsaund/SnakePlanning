function Ad = AdjointSpecific(twists, angles, i, j)
%Returns the Adjoint for the twists between j and i
%Returns Ad^-1 (twists j+1 through i) if i>j
%Returns I if i=j
%Returns 0 if i<j
    
    if(i==j)
        Ad=eye(6);
        return;
    end
    if(i<j)
        Ad=zeros(6);
        return;
    end
    
    g = eye(4);
    for ind = (j+1):i
        g = g*twistMatrix(twists(:,ind), angles(ind));
    end
    
    Ad = Adjoint(inv(g));
        
    
end
