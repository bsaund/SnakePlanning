function m = twistMatrix(twist, theta)

v = twist(1:3);
w = twist(4:6);

w_hat = hat(twist(4:6));

R = eye(3) + w_hat * sin(theta) + w_hat * w_hat * (1-cos(theta));

m = [R, (eye(3) - R)*cross(w,v) + w*w'*v*theta];
m = [m; 0 0 0 1];

end