


extraAngles = interpolateTrajectory(traj.trajectory, 60);

extraAngles = [fliplr(extraAngles), extraAngles];


g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA017');
cmd=CommandStruct();
pause(10)



% kin = traj.trajOptimizer.arm.kin;
kin = HebiKinematics()
kin.setBaseFrame(traj.trajOptimizer.arm.frame)
for i=1:size(extraAngles,1)
    kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
end


for(i=1:size(extraAngles,2))
%     tic
    fbk = g.getNextFeedback();
    while(isempty(fbk))
        g.getNextFeedback();
        pause(0.1)
        disp('No Feedback!')
    end
    
    cmd.position = [0; extraAngles(:,i)]';
    cmd.torque = [0, kin.getGravCompTorques(fbk.position(2:end), [0 ...
                        0 1])];
    g.set(cmd)
    pause(.02)
%     toc
end

disp('DONE')

for(t=0:100)
    cmd.position = [0; extraAngles(:,end)]';
    g.set(cmd)
    pause(.1)
end