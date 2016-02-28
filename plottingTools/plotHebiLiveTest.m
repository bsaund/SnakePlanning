function plotHebiLiveTest
    close all
    g = HebiLookup.newConnectedGroupFromName('Spare','SA002');

    kin = HebiKinematics();

    range=1:g.getNumModules;
    % range=12:16;
    for i=range
        kin.addBody('FieldableElbowJoint');
    end


    while(true)
        plotHebi(kin, g.getNextFeedback.position(range), true)
    end

end
