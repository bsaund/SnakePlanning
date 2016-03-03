function plotCylinderLiveTest
%Plots the Snake in real time
    close all
    g = HebiLookup.newConnectedGroupFromName('Spare','SA002');

    range=1:g.getNumModules;
    % range=12:16;

    plt = CylinderPlotter('frame','VC');

    while(true)
        angles = g.getNextFeedback.position(range);
        plt.plot(angles);
        % plt.plot(angles);
        % plt.plot(g.getNextFeedback())
    end

end
