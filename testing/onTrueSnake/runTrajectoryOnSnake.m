

% g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA013');
gTemp = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA013');
fam = gTemp.getInfo.family;
name = gTemp.getInfo.name;
snakeIndex = strcmp(fam, 'SEA-Snake');
snakeIndex(1) = 0; %Ignore first module, it is trapped by clamp
g = HebiLookup.newGroupFromNames(fam(snakeIndex), name(snakeIndex));
cmd=CommandStruct();

extraAngles = interpolateTrajectory(traj.trajectory, 60);
% kin = traj.trajOptimizer.arm.kin;
kin = HebiKinematics()
kin.setBaseFrame(traj.trajOptimizer.arm.frame)
for i=1:size(extraAngles,1)
    kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
end


for(i=1:size(extraAngles,2))
    tic
    fbk = g.getNextFeedback();
    cmd.position = [extraAngles(:,i)]';
    cmd.torque = [kin.getGravCompTorques(fbk.position, [0 ...
                        0 1])];
    g.set(cmd)
    pause(.02)
    toc
end

disp('DONE')

for(t=0:100)
    cmd.position = [extraAngles(:,end)]';
    g.set(cmd)
    pause(.1)
end