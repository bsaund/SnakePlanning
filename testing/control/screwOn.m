
gTemp = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA013');
fam = gTemp.getInfo.family;
name = gTemp.getInfo.name;
snakeIndex = strcmp(fam, 'SEA-Snake');
g = HebiLookup.newGroupFromNames(fam(snakeIndex), ...
                                 name(snakeIndex));

screwdriver = HebiLookup.newGroupFromNames('Wheel', 'wheel_01');
screwdriver.setCommandLifetime(1);
screwcmd = CommandStruct

gains = g.getGains;
gains.controlStrategy(:) = 3;
gains.positionKp(:) = 5;
gains.positionKi(:) = .002;
gains.positionIClamp(:) = .5;

g.set('gains', gains);

kin = kinMaker('numJoints', n);
baseFrame = [0  0 1 0;
    0 -1 0 0;
    1  0 0 0;
    0 0 0 1;];

kin.setBaseFrame(baseFrame);
fbk = g.getNextFeedback;


% ang1 =  [0.1169, -0.6022,  0.0530, -1.2990, -0.2891, -1.2139, -0.1735,...
%    -0.5808,  0.5359,  1.0069, -1.1889, -0.4881,  0.7353,  1.5924,...
%    -0.1470, -0.5506];
% goal1 = kin.getFK('EndEffector', ang1);

% ang2 = [0.1174, -0.5883, -0.0054, -1.2999, -0.4112, -1.2331, -0.1765,...
%    -0.5680,  0.5755,  0.9945, -1.1922, -0.5181,  0.8274,  1.5966,...
%    -0.0105, -0.5405];
% goal2 = kin.getFK('EndEffector', ang2);

goal = kin.getFK('EndEffector', fbk.position);
m = eye(4);
m(3,4) = .01;

% while true
%     fk = kin.getFK('EndEffector', g.getNextFeedback.position);
%     err = fk(1:3,4) - goal(1:3,4)
% end


while true
    for i=[0:5, 5:-1:0]
        holdPosition(g, goal * m^i, baseFrame, 1, ...
                     'numControllableModules', 6,...
                     'display', 'on')
        screwcmd.torque = -.5
        % screwdriver.set(screwcmd)
    end
end


