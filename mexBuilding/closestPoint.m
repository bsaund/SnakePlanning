function p_plane = closestPoint(p_test, p1, p2, p3)
%CLOSESTPOINT returns the closest points to p_test on the triangle
%defined by p1, p2, and p3. All points are column vectors.
%This uses the algorithm from:
%http://www.geometrictools.com/Documentation/DistancePoint3Triangle3.pdf

    B = p1;
    E0 = p2-p1;
    E1 = p3-p1;
    P = p_test;
    D = B-P;
%     a = dot(E0,E0);
%     b = dot(E0,E1);
%     c = dot(E1,E1);
%     d = dot(E0,D);
%     e = dot(E1,D);
    a = E0'*E0;
    b = E0'*E1;
    c = E1'*E1;
    d = E0'*D;
    e = E1'*D;
%     f = dot(D,D);
    
    det = a*c-b*b;
    s = b*e-c*d;
    t = b*d-a*e;
  
 
    
    
    if(s+t < det)
        if (s<0)
            if(t<0)
                % region = 4
                if (d<0)
                    s = bound(-d/a, 0, 1);
                    t = 0;
                else
                    s = 0;
                    t = bound(-e/c, 0, 1);
                end
                
            else
                % region = 3
                s = 0;
                t = bound(-e/c, 0, 1);
            end
        elseif (t<0)
            % region = 5
            s = bound(-d/a, 0, 1);
            t = 0;
        else
            % region = 0
            invDet = 1/det;
            s = s*invDet;
            t = t*invDet;
        end
    else
        if (s<0)
            % region = 2
            tmp0 = b+d;
            tmp1 = c+e;
            if (tmp1 > tmp0)
                numer = tmp1-tmp0;
                denom = a-2*b+c;
                s = bound(numer/denom, 0, 1);
                t = 1-s;
            else
                s=0;
                t = bound(-e/c, 0, 1);
            end

        elseif (t<0)
            
            % region = 6
            
            tmp0 = b+e;
            tmp1 = a+d;
            if (tmp1 > tmp0)
                numer = tmp1-tmp0;
                denom = a-2*b+c;
                t = bound(numer/denom, 0, 1);
                s = 1-t;
            else
                t=0;
                s = bound(-d/a, 0, 1);
            end

        else 
            % region = 1
            numer = c+e-b-d;
            denom = a-2*b+c;
            s = bound(numer/denom, 0, 1);
            t = 1-s;
        end
    end
       
    p_plane = B+E0*s + E1*t;
end

function b = bound(x, minval, maxval)
    b = min(max(x,minval), maxval);
end
