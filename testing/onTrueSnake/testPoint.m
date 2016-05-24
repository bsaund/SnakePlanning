
extraAngles = interpolateTrajectory(traj.trajectory(:,1:end-1), 60);

extraAnglesRev = fliplr(extraAngles);


g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA017');
cmd=CommandStruct();
pause(5)



% kin = traj.trajOptimizer.arm.kin;
kin = HebiKinematics()
kin.setBaseFrame(traj.trajOptimizer.arm.frame)
for i=1:size(extraAngles,1)
    kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
end

tempGains = g.getGains
for i=2:18
    tempGains.positionKi(i) = .01;
    tempGains.positionIClamp(i) = 1;
    tempGains.positionKp(i) = 10;
end
g.set('gains', tempGains);

while true
    fbk = g.getNextFeedback();
    while(isempty(fbk))
        g.getNextFeedback();
        pause(0.1)
        disp('No Feedback!')
    end
    
    cmd.position = [0; extraAngles(:,end); 0]';
    cmd.torque = [0, kin.getGravCompTorques(fbk.position(2:end-1), [0 ...
                        0 1]), 0];
                    
    g.set(cmd)
    pause(.02)
end