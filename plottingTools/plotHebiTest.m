function plotHebiTest()

    % kin = HebiKinematics();
    num_links = 10;
    num_samples = 200;
    angles = [];
    plt = HebiPlotter(num_links, 'resolution', 'high');
    for i=1:num_links
        % kin.addBody('FieldableElbowJoint');
        angles = [angles, linspace(-pi/2, pi/2, num_samples)'];
    end
    
    for i=1:num_samples
        % plotHebi(kin, angles(i, :));
        plt.plot(angles(i,:));
        % pause(.1);
        % tic
        % drawnow();
        % toc
    end
    

end
