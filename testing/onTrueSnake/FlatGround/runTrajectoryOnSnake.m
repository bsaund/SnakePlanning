


close all
g = HebiLookup.newGroupFromNames('*', ...
               {'X-00036', 'X-00031',...
                'SA062', 'SA061', 'SA060', 'SA066', 'SA064', ...
                'SA065', 'SA069', 'SA067', 'SA068'});
cmd=CommandStruct();

extraAngles = interpolateTrajectory(traj.trajectory, 20);
extraTq = interpolateTrajectory(-traj.torques, 20);
% kin = traj.trajOptimizer.arm.kin;
% kin = HebiKinematics()
% kin.setBaseFrame(traj.trajOptimizer.arm.frame)
% for i=1:size(extraAngles,1)
%     kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
% end
% kin = traj.trajOptimizer.arm.kin;
fig = showWorld(world);
arm = HebiPlotter('jointTypes', jointTypes, 'figureHandle', fig);
arm.setBaseFrame(realisticArm.baseFrame);
kin = arm.kin;


for(i=1:30)
    fbk = g.getNextFeedback();
    cmd.position = [extraAngles(:,1)]';
    cmd.torque = [kin.getGravCompTorques(fbk.position, ...
                                         [0 0 1])];
    g.set(cmd)
    pause(0.1)
end


tq = [];

for(i=1:size(extraAngles,2))
    tic
    fbk = g.getNextFeedback();
    cmd.position = [extraAngles(:,i)]';
    % cmd.torque = [kin.getGravCompTorques(fbk.position, ...
    %                                      [0 0 1])];
    cmd.torque = [extraTq(:,i)]';
    if(mod(i,10) == 0)
        arm.plot(extraAngles(:,i));
    end
    g.set(cmd)
    pause(.05)
    if(mod(i,10)==0)
        joint_torque = fbk.torque;
        tq = [tq; fbk.torque];
    end
    % toc;
end

disp('DONE')

for(t=0:10)
    cmd.position = [extraAngles(:,end)]';
    g.set(cmd)
    pause(.05)
end