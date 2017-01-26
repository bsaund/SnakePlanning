


close all
g = HebiLookup.newGroupFromNames('*', ...
               {'X-00036', 'X-00031',...
                'SA062', 'SA061', 'SA060', 'SA066', 'SA064', ...
                'SA065', 'SA069', 'SA067', 'SA068'});
cmd=CommandStruct();

extraAngles = interpolateTrajectory(traj.trajectory, 20);
% kin = traj.trajOptimizer.arm.kin;
% kin = HebiKinematics()
% kin.setBaseFrame(traj.trajOptimizer.arm.frame)
% for i=1:size(extraAngles,1)
%     kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
% end
kin = traj.trajOptimizer.arm.kin;
fig = showWorld(world);
arm = HebiPlotter('jointTypes', jointTypes, 'figureHandle', fig);
arm.setBaseFrame(realisticArm.baseFrame);

for(i=1:size(extraAngles,2))
    tic
    fbk = g.getNextFeedback();
    cmd.position = [extraAngles(:,i)]';
    cmd.torque = [kin.getGravCompTorques(fbk.position, ...
                                         [0 0 1])];
    if(mod(i,10) == 0)
        arm.plot(extraAngles(:,i));
    end
    g.set(cmd)
    pause(.05)
    toc
end

disp('DONE')

for(t=0:1000)
    cmd.position = [extraAngles(:,end)]';
    g.set(cmd)
    pause(.05)
end