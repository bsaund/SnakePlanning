function plotHebiLiveTest
close all
g = HebiLookup.newConnectedGroupFromName('Spare','SA002');

kin = HebiKinematics();
% for i=1:g.getNumModules
for i=1:8
    kin.addBody('FieldableElbowJoint');
end


while(true)
    % t0 = tic
    plotHebi(kin, g.getNextFeedback.position(1:8))

    
end

end