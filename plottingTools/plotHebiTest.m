function plotHebiTest()

    kin = HebiKinematics();
    num_links = 4;
    num_samples = 200;
    angles = [];
    for i=1:num_links
        kin.addBody('FieldableElbowJoint');
        angles = [angles, linspace(-pi/2, pi/2, num_samples)'];
    end
    
    for i=1:num_samples
        tic
%         plotHebi(kin, angles(i, :), 'low_res');
        plotHebi(kin, angles(i, :)); 
        drawnow();
        toc
    end
    

end
