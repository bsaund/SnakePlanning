function holdPosition(g, goal)


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


    lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                        fbk.position(1:n-6)));

    lastKin.getFK('EndEffector', fbk.position(n-5:n)) - goal;

    cmd = CommandStruct();
    cmd.velocity = nan * zeros(1,n);
    cmd.position = nan * zeros(1,n);
    cmd.position(n-5:n) = fbk.position(n-5:n);





    while true
        
        fbk = g.getNextFeedback(fbk);
        if(isempty(fbk))
            disp('Feedback Missed')
            continue
        end
        
        endInd = n-5:n;
        
        lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                            fbk.position(1:n-6)));
        
        % cmd.position(endInd) = ...
        %     lastKin.getIK('xyz', goal(1:3,4), 'so3', goal(1:3,1:3), ...
        %                          'InitialPositions', fbk.position(endInd));
        cmd.position(endInd) = ...
            lastKin.getIK('xyz', goal(1:3,4), 'axis', goal(1:3,1:3)*[0;0;1], ...
                                 'InitialPositions', fbk.position(endInd));
        
        cmd.torque = kin.getGravCompTorques(fbk.position, [0 0 1]);
        
        % goal;
        % fk = lastKin.getFK('EndEffector',fbk.position(endInd));
        % fk - goal;
        
        % dTheta = cmd.position(endInd) - fbk.position(endInd)


        g.set(cmd);
        pause(0.01);
    end
end