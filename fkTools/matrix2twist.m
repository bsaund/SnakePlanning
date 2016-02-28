function [t, theta] = matrix2twist(m)

    R = m(1:3, 1:3);
    p = m(1:3, 4);
    
    theta = acos((trace(R) - 1)/2);
    
    w = [R(3,2) - R(2,3);
         R(1,3) - R(3,1);
         R(2,1) - R(1,2);] / (2 * sin(theta));
    
    w = w/norm(w);

    
    A = (eye(3) - R)*hat(w) + w*w'*theta;
    v = inv(A) * p;
    
    t = [v;w];

end
