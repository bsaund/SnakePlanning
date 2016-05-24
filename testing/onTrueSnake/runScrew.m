


extraAngles = interpolateTrajectory(traj.trajectory, 60);

extraAnglesRev = fliplr(extraAngles);


g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA017');
cmd=CommandStruct();
pause(10)



% kin = traj.trajOptimizer.arm.kin;
kin = HebiKinematics()
kin.setBaseFrame(traj.trajOptimizer.arm.frame)
for i=1:size(extraAngles,1)
    kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
end
g.set('gains', curGains)


for(i=1:size(extraAngles,2)-1)
%     tic
    fbk = g.getNextFeedback();
    while(isempty(fbk))
        g.getNextFeedback();
        pause(0.1)
        disp('No Feedback!')
    end
    
    cmd.position = [0; extraAngles(:,i); 0]';
    cmd.torque = [0, kin.getGravCompTorques(fbk.position(2:end-1), [0 ...
                        0 1]), 0];
    g.set(cmd)
    pause(.02)
%     toc
end

%%Set to high gains
tempGains = g.getGains
for i=2:18
    tempGains.positionIClamp(i) = 1;
    tempGains.positionKi(i) = .01;
end
g.set('gains', tempGains);

tic
while toc < 15
    cmd.torque(end) = -.3;
    g.set(cmd);
    pause(.02);
end
    


g.set('gains', curGains);

for(i=1:size(extraAnglesRev,2))
%     tic
    fbk = g.getNextFeedback();
    while(isempty(fbk))
        g.getNextFeedback();
        pause(0.1)
        disp('No Feedback!')
    end
    
    cmd.position = [0; extraAnglesRev(:,i); 0]';
    cmd.torque = [0, kin.getGravCompTorques(fbk.position(2:end-1), [0 ...
                        0 1]), 0];
    g.set(cmd)
    pause(.02)
%     toc
end


disp('DONE')

for(t=0:100)
    cmd.position = [0; extraAnglesRev(:,end); 0]';
    g.set(cmd)
    pause(.1)
end