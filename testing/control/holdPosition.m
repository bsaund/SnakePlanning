

g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA013');
n = g.getNumModules;
kin = kinMaker('numJoints', n);
firstKin = kinMaker('numJoints', n-6);
lastKin = kinMaker('numJoints', 6);


baseFrame = [0  0 1 0;
             0 -1 0 0;
             1  0 0 0;
             0 0 0 1;];
firstKin.setBaseFrame(baseFrame);
kin.setBaseFrame(baseFrame);


fbk = g.getNextFeedback;
goal = kin.getFK('EndEffector', fbk.position);
cmd = CommandStruct();
cmd.velocity = nan * zeros(1,n);
cmd.position = nan * zeros(1,n);
cmd.position(n-5:n) = fbk.position(n-5:n);

gains = g.getGains;
gains.controlStrategy(:) = 3;
gains.positionKp(:) = 5;

g.set('gains', gains);




while true
    
    fbk = g.getNextFeedback(fbk);
    
    lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                        fbk.position(1:n-6)));
    
    cmd.position(n-5:end) = ...
        lastKin.getIK('xyz', goal(1:3,4), 'so3', goal(1:3,1:3), ...
                             'InitialPositions', fbk.position(n-5: ...
                                                      end));
    
    cmd.torque = kin.getGravCompTorques(fbk.position, [0 0 1]);
    
    goal;
    fk = lastKin.getFK('EndEffector',fbk.position(n-5:end));
    goal - fk
    

    % kin.getFK('EndEffector', fbk.position)
    % J = kin.getJacobian('EndEffector', fbk.position);
    % fk = kin.getFK('EndEffector', fbk.position);
    % err = fk(1:3,4) - goal(1:3, 4);
    
    % Jmoveable = J(1:3,end-5:end);
    % pJmoveable = Jmoveable'*inv(Jmoveable*Jmoveable');
    % dTheta = pJmoveable * err /100;
    
    % for i=1:6
    %     % cmd.velocity(n-6+i) = 0;
    %     cmd.position(n-6+i) = cmd.position(n-6+i) - dTheta(i);
    %     % cmd.velocity(n-6+i) = dTheta(i)
    % end
    % cmd.position
    g.set(cmd);
    pause(0.01);
end