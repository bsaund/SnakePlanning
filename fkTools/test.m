theta1 = sym('theta1');
theta2 = sym('theta2');
theta3 = sym('theta3');
theta4 = sym('theta4');
l0 = sym('l0')
l1 = sym('l1');
l2 = sym('l2');

g0 = [eye(3), [0; l1+l2; l0]; 0 0 0 1]
t1 = twistMatrix([0;0;0;0;0;1], theta1)
t2 = twistMatrix([l1;0;0;0;0;1], theta2)
t3 = twistMatrix([l1+l2;0;0;0;0;1], theta3)

t1*t2*t3*g0