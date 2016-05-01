

g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA017');
cmd=CommandStruct();

extraAngles = interpolateTrajectory(traj.trajectory, 30);
kin = traj.trajOptimizer.arm.kin;

for(i=1:size(extraAngles,2))
    tic
    fbk = g.getNextFeedback();
    cmd.position = [0; extraAngles(:,i)]';
    cmd.torque = [0, kin.getGravCompTorques(fbk.position(2:end), [0 ...
                        0 1])];
    g.set(cmd)
    pause(.02)
    toc
end

for(t=0:100)
    cmd.position = [0; extraAngles(:,end)]';
    g.set(cmd)
    pause(.1)
end