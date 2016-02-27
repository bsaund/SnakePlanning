function plotHebiLiveTest
close all
g = HebiLookup.newConnectedGroupFromName('Spare','SA002');

kin = HebiKinematics();
% for i=1:g.getNumModules
for i=1:16
    kin.addBody('FieldableElbowJoint');
end


while(true)
    plotHebi(kin, g.getNextFeedback.position(1:16))
    drawnow
end

end