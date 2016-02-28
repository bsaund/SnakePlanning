function Problem3()

    
    xs = 0.1:0.1:0.7;
    % Part 1
    WAM_Jacobian(xs)
   %  0.7200    0.1344    0.4396    0.7708   -0.3219    1.8178   -1.1043
   % -0.6100   -1.3393   -0.6245   -1.7636   -0.8168   -1.5531   -1.4406
   %       0    0.6555    0.1349    0.5781    0.4599    0.2569    0.9476
   %       0   -0.9950   -0.0198   -0.9216   -0.1692   -0.6414   -0.5622
   %       0   -0.0998    0.1977   -0.3836    0.5334   -0.6981    0.7100
   %  1.0000         0    0.9801    0.0587    0.8288    0.3183    0.4242

    % Part 2
    gs = WAM_on_table_FK(0.1:0.1:0.7);
    xd = [ 0.46320; 1.16402; 2.22058; -0.29301; 0.41901; 0.84979; ...
           0.12817];
    gd = poseQuat2tform(xd);

    [tw, th] = twistVelocity(gs, gd)
% tw =

%    -0.0036
%     1.4250
%    -0.6853
%     0.4290
%    -0.3960
%    -0.8119


% th =

%     0.3945


    % Part 3
    runPseudoInverse()

    % Part 4
    runDampedLeastSquares()

end


function runPseudoInverse()
    xs = 0.1:0.1:0.7;
    xd1 = [ 0.46320; 1.16402; 2.22058; -0.29301; 0.41901; 0.84979; ...
       0.12817];
    xd2 = [0.49796; 0.98500; 2.34041; -0.11698; 0.07755; 0.82524; 0.54706];

    pseudoInverseIterative(xs, xd1);
    % 0.1524
    % 0.2015
    % 0.2003
    % 0.5000
    % 0.3092
    % 0.3938
    % 0.5420
    
    pseudoInverseIterative(xs, xd2);
    
   %  0.2416
   %  0.2113
   %  0.5798
   %  0.2262
   % -0.0003
   % -0.1461
   % -0.4260

end

function runDampedLeastSquares()
    xs = 0.1:0.1:0.7;
    xd1 = [ 0.46320; 1.16402; 2.22058; -0.29301; 0.41901; 0.84979; ...
       0.12817];
    xd2 = [0.49796; 0.98500; 2.34041; -0.11698; 0.07755; 0.82524; 0.54706];

    dampedLeastSquares(xs, xd1)
    
    dampedLeastSquares(xs, xd2)

end

function FK = WAM_on_table_FK(j)
    FK = tableTransform() * WAM_FK(j);
end

% Forward Kinematics for WAM
function g = WAM_FK(j)
    [t, g0] = WAM_Twists();
    g = eye(4);
    for i =1:size(t,2)
        g = g*twistMatrix(t(:,i), j(i));
    end
    g = g * g0;
    % FK = g(1:3,4)';
end

function m = tableTransform()
    m =  trans(0.75, 0.5, 1) * rotz(pi/2);
end

function [t, g0] = WAM_Twists()
    t = zeros(6,7);
    P0 =[0.220; .280/2; .346];
    P4 = P0 + [0.045; 0; 0.550];
    P5 = P4 + [-0.045; 0; .300];
    PE = P5 + [0;0;.06 + .12];
    w1 = [0;0;1];
    w2 = [0;1;0];
    w3 = [0;0;1];
    w4 = [0;1;0];
    w5 = [0;0;1];
    w6 = [0;1;0];
    w7 = [0;0;1];
    xi = @(w, p) [-cross(w,p); w];
    t(:,1) = xi(w1, P0);
    t(:,2) = xi(w2, P0);
    t(:,3) = xi(w3, P0);
    t(:,4) = xi(w4, P4);
    t(:,5) = xi(w5, P5);
    t(:,6) = xi(w6, P5);
    t(:,7) = xi(w7, P5);
    g0 = [eye(3), PE; 0 0 0 1];
end

%Homogeneous transform matrix for a rotation about z
function m = rotz(theta)
    m = [cos(theta), -sin(theta), 0, 0;
         sin(theta),  cos(theta), 0, 0;
         0,          0,           1, 0;
         0,          0,           0, 1];
end

%Homogeneous transform matrix for a translation
function t = trans(x,y,z)
    t = eye(4);
    t(1:3,4) = [x;y;z];
end

%Returns the point from a homogeneous transformation matrix
function p = getPoint(m)
    p = [m(1:3,4)', tform2quat(m)];
end


%Returns the spacial jacobian in world coordinates
function J= WAM_Jacobian(joints)
%Compute Jacobian in robot frame first
    t = WAM_Twists();
    J = [];
    action = eye(4);
    for i = 1:size(t,2)
        if(i>1)
            action = action * twistMatrix(t(:,i-1), joints(i-1));
        end
        J = [J, Adjoint(action) *  t(:,i)];
    end
    
    %Convert Robot frame jacobian to workspace jacobian
    J = Adjoint(tableTransform) * J;

end

function [tw, th] = twistVelocity(gs, gd)
    [tw, th] = matrix2twist(gd*inv(gs));
end

function m = poseQuat2tform(XYZQ)
    R = quat2tform(XYZQ(4:7));
    m = [R, XYZQ(1:3); 0,0,0,1];
end

function xs = pseudoInverseIterative(init, goal)
    xs = init';
    % getPoint(WAM_on_table_FK(init))
    % goal
    points = [];
    for i=1:100
        J = WAM_Jacobian(xs);
        Jinv = J'*inv(J*J');
        [tw, th] = twistVelocity(WAM_on_table_FK(xs), ...
                                 poseQuat2tform(goal));
        % points = [points, xs]
        xs = xs + Jinv*tw*th*.2;

        % getPoint(WAM_on_table_FK(xs))
        % pause(.3)
    end
    % goal - getPoint(WAM_on_table_FK(xs))'
end

function xs = dampedLeastSquares(init, goal)
    xs = init';
    lambda = .1;
    points = [];
    for i=1:100
        J = WAM_Jacobian(xs);
        [tw, th] = twistVelocity(WAM_on_table_FK(xs), poseQuat2tform(goal));
        e = tw*th*.2;
        points = [points, xs]
        xs = xs + J'* inv(J*J' + lambda^2*eye(6)) *e;
    end
end
        