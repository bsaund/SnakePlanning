close all


% worldName = '../../worlds/bumpy.stl';
% worldName = '../../worlds/block.stl';
% worldName = '../../worlds/flat.stl';
% worldName = '../../worlds/ledge.stl';
% worldName = '../../../worlds/Simplified_wing_section.stl';
% worldName = '../../../worlds/front_wing_section_trimmed.stl';
worldName = '../../../worlds/wing_with_floor.stl';
world = loadWorld(worldName);
showWorld(world);


jointTypes = getFodbotJointTypes();


fr=[1, 0, 0,  0;
    0, 1, 0, 0;
    0, 0, 1,  0;
    0, 0, 0,  1;];
fr = fr*rotz(0)

arm = SpherePlotter('JointTypes', jointTypes);
realisticArm = HebiPlotter('JointTypes', jointTypes, ...
                           'figureHandle', gcf(),...
                           'lighting', 'on');
arm.setWorld(world)
arm.setBaseFrame(fr);
realisticArm.setBaseFrame(fr);

traj = MultiSegmentTrajectory('arm', arm, 'numTimeSteps', 5,...
                         'numContacts', 5, 'world', world);



% initial_angles = [0.0388; -1.2968; -0.8412 ; 0.9183 ; 1.37; ...
%                  0.5174;
%                  0.2922; -0.0099 ; 0.3029; -1.1143 ; 0.7576];

hc_path = load('hardcoded_path_wing')

                
initial_angles = hc_path.path(1,:)';
traj.setStartConfig(initial_angles);
traj.trajOptimizer.arm.plot(initial_angles);



% traj.addSegment([0; -.50; .3], 2);
traj.optimizeSegment(hc_path.path');

save('lastTrajectory', 'traj', 'realisticArm', 'world',...
     'jointTypes');

% save('BoeingPartProgress','angles','traj1','traj2','traj3', 'traj4')
% traj.showTrajectory(10)
arm.clearPlot();
finalTrajectory = interpolateTrajectory(traj.trajectory, 10);
loopTrajectory(@realisticArm.plot, finalTrajectory);
