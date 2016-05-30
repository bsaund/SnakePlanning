function holdPosition(g, goal, baseFrame, duration, varargin)
    
    p = inputParser();
    p.addParameter('numControllableModules', 6);
    p.addParameter('display', 'off');
    p.addParameter('holdingAngles', []);
    
    p.parse(varargin{:});
    re = p.Results;
    
    c = re.numControllableModules;
    


    n = g.getNumModules;
    kin = kinMaker('numJoints', n);
    firstKin = kinMaker('numJoints', n-c);
    lastKin = kinMaker('numJoints', c);
    
    startInd = 1:n-c;
    endInd = n-c+1:n;


    firstKin.setBaseFrame(baseFrame);
    kin.setBaseFrame(baseFrame);


    fbk = g.getNextFeedback;
    
    if(isempty(re.holdingAngles))
        initialPos = fbk.position;
        initialPos(:) = nan;
    else
        initialPos = re.holdingAngles
    end

    lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                        fbk.position(startInd)));

    % lastKin.getFK('EndEffector', fbk.position(n-c+1:n)) - goal;
    
    

    cmd = CommandStruct();
    cmd.velocity = nan * zeros(1,n);
    cmd.position = nan * zeros(1,n);
    cmd.position(endInd) = fbk.position(endInd);
    



    tic

    while toc < duration
        
        fbk = g.getNextFeedback(fbk);
        if(isempty(fbk))
            disp('Feedback Missed')
            continue
        end
        

        
        lastKin.setBaseFrame(firstKin.getFK('EndEffector', ...
                                            fbk.position(1:n-c)));
        
        % cmd.position(endInd) = ...
        %     lastKin.getIK('xyz', goal(1:3,4), 'so3', goal(1:3,1:3), ...
        %                          'InitialPositions', fbk.position(endInd));
        cmd.position(startInd) = initialPos(startInd);
        cmd.position(endInd) = ...
            lastKin.getIK('xyz', goal(1:3,4), 'axis', goal(1:3,1:3)*[0;0;1], ...
                                 'InitialPositions', fbk.position(endInd));
        
        cmd.torque = kin.getGravCompTorques(fbk.position, [0 0 1]);
        
        % goal;

        % fk - goal;
        
        % dTheta = cmd.position(endInd) - fbk.position(endInd)
        
        if(strcmpi(re.display, 'on'))
            fk = lastKin.getFK('EndEffector',fbk.position(endInd));
            positionErr = fk(1:3,4) - goal(1:3,4)
        end

        g.set(cmd);
        pause(0.01);
    end
    

end