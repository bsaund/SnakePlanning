function plotHebiLiveTest
%Plots the Snake in real time
    close all
    g = HebiLookup.newConnectedGroupFromName('Spare','SA002');

%     range=1:g.getNumModules;
    range=12:16;

    plt = HebiPlotter(length(range));

    while(true)
        angles = g.getNextFeedback.position(range);
        plt.plot(angles);
    end

end
