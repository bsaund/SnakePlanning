


extraAngles = interpolateTrajectory(traj.trajectory, 60);

extraAnglesRev = fliplr(extraAngles);


% g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA017');

gTemp = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA013');
fam = gTemp.getInfo.family;
name = gTemp.getInfo.name;
snakeIndex = strcmp(fam, 'SEA-Snake');
snakeIndex(1) = 0; %Ignore first module, it is trapped by clamp
g = HebiLookup.newGroupFromNames(fam(snakeIndex), name(snakeIndex));
n = g.getNumModules;
cmd=CommandStruct();


screwdriver = HebiLookup.newGroupFromFamily('Wheel')
cmdScrew = CommandStruct();

pause(10)



% kin = traj.trajOptimizer.arm.kin;
kin = HebiKinematics()
kin.setBaseFrame(traj.trajOptimizer.arm.frame)
for i=1:size(extraAngles,1)
    kin.addBody(traj.trajOptimizer.arm.jointTypes{i}{1});
end
g.set('gains', curGains)


for(i=1:size(extraAngles,2))
%     tic
    fbk = g.getNextFeedback();
    while(isempty(fbk))
        g.getNextFeedback();
        pause(0.1)
        disp('No Feedback!')
    end
    
    cmd.position = [extraAngles(:,i)]';
    cmd.torque = [kin.getGravCompTorques(fbk.position, [0 ...
        0 1])];
    g.set(cmd)
    pause(.02)
%     toc
end

%%Set to high gains
% tempGains = g.getGains
% for i=2:g.getNumModules
%     tempGains.positionIClamp(i) = 1;
%     tempGains.positionKi(i) = .01;
% end
% g.set('gains', tempGains);
% 
% tic
% while toc < 15
%     cmd.torque(end) = -.3;
%     g.set(cmd);
%     pause(.02);
% end
    
% 


%% SCREW-------------------------
initialGains = g.getGains();

gains = g.getGains;
c = 6;
endInd = n-c+1:n;

gains.controlStrategy(endInd) = 3;
gains.positionKp(endInd) = 3;
gains.positionKi(endInd) = .004;
gains.positionIClamp(endInd) = 1.5;
g.set('gains', gains);
    
holdPosition(g, hold, traj.trajOptimizer.arm.frame, 10, ...
    'display', 'on',...
    'holdingAngles', extraAngles(:,end))

% goal = kin.getFK('EndEffector', fbk.position);
m = eye(4);
m(3,4) = .00025;



cmdScrew.torque = -.2;

for i=[0:100, 100:-1:0]
    holdPosition(g, hold * m^i, traj.trajOptimizer.arm.frame, 0.05, ...
        'numControllableModules', 6,...
        'display', 'on',...
        'holdingAngles', extraAngles(:,end))
    screwdriver.set(cmdScrew);
end


g.set('gains', initialGains);


%% Return--------------------------
g.set('gains', curGains);

for(i=1:size(extraAnglesRev,2))
%     tic
    fbk = g.getNextFeedback();
    while(isempty(fbk))
        g.getNextFeedback();
        pause(0.1)
        disp('No Feedback!')
    end
    
    cmd.position = [extraAnglesRev(:,i)]';
    cmd.torque = [kin.getGravCompTorques(fbk.position, [0 ...
                        0 1])];
    g.set(cmd)
    pause(.02)
%     toc
end


disp('DONE')

for(t=0:100)
    cmd.position = [extraAnglesRev(:,end)]';
    g.set(cmd)
    pause(.1)
end