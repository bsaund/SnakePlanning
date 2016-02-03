function angles = IK_Testing()
    global kin;
    hebi_load();

% target = [0,0,0,1,0,0,0];
    target = trans(.3,.2,.1);
    target = getXYZQ(target);
    
    n = 10;
    link_length(1:n) = 1;
    min_angles(1:n) = -pi/2;
    max_angles(1:n) = pi/2;
    obstacles = [1,2,3,1];
    
    kin = FieldableKinematics;

    for i = 1:n
        kin.addModule('ElbowJoint');
    end


    angles = IK( target, link_length', min_angles', max_angles', obstacles, @HebiFK);

end





% %Calculates the rotation quaternion from the homogeneous matrix
% function q = tform2quat(m)
%     m = m(1:3,1:3);
    
%     copysign = @(x,y) sign(y) * abs(x);
    
%     t = trace(m);
%     r = sqrt(1+t);
%     w = 0.5*r;
    
%     x = copysign(0.5*sqrt(1+m(1,1)-m(2,2)-m(3,3)), m(3,2)-m(2,3));
%     y = copysign(0.5*sqrt(1-m(1,1)+m(2,2)-m(3,3)), m(1,3)-m(3,1));
%     z = copysign(0.5*sqrt(1-m(1,1)-m(2,2)+m(3,3)), m(2,1)-m(1,2));
%     q = [w, x, y, z];
% end
