function holdPosition(g, goal, baseFrame, duration, varargin)
    
    p = inputParser();
    p.addParameter('numControllableModules', 6);
    
    p.parse(varargin{:});
    re = p.Results;
    
    c = re.numControllableModules;
    


    n = g.getNumModules;
    kin = kinMaker('numJoints', n);
    firstKin = kinMaker('numJoints', n-c);
    lastKin = kinMaker('numJoints', c);


    firstKin.setBaseFrame(baseFrame);
    kin.setBaseFrame(baseFrame);


    fbk = g.getNextFeedback;

    lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                        fbk.position(1:n-c)));

    % lastKin.getFK('EndEffector', fbk.position(n-5:n)) - goal;

    cmd = CommandStruct();
    cmd.velocity = nan * zeros(1,n);
    cmd.position = nan * zeros(1,n);
    cmd.position(n-c+1:n) = fbk.position(n-c+1:n);


    tic

    while toc < duration
        
        fbk = g.getNextFeedback(fbk);
        if(isempty(fbk))
            disp('Feedback Missed')
            continue
        end
        
        endInd = n-c+1:n;
        
        lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                            fbk.position(1:n-c)));
        
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