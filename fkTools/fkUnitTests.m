function fkUnitTests
%Tests various fk functions to ensure they are computing correct values
    kin = HebiKinematics();
    n=1;
    for i=1:n
        kin.addBody('FieldableElbowJoint');
    end
    
    angles = pi*(rand(n,1) - .5);
    
    assertEqual(snakeFK(angles), kin.getFK('EndEffector', angles), ...
                'snakeFK and HebiKinematics give different results')
    

    angles = zeros(n, 1);
    [J_sp, J_b, J_geo] = snakeEEJacobian(angles);
    J_sp
    J_b
    J_geo
    kin.getJacobian('EndEffector', angles)
    
    assertEqual(J_geo, kin.getJacobian('EndEffector', angles), ...
                'snakeEEJacobian and HebiKinematics disagree');
end

function assertEqual(m1, m2, message)
    if(~approxEqual(m1, m2))
        error(message);
    end
end

function e = approxEqual(m1, m2)
    e = ~any(any(abs(m1-m2) > 0.00001));
end