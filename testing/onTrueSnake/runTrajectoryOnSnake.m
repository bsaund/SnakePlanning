

g = HebiLookup.newConnectedGroupFromName('SEA-Snake', 'SA017');
cmd=CommandStruct();

extraAngles = interpolateTrajectory(angles, 10);

for(i=1:size(extraAngles,2))
    cmd.position = [0; extraAngles(:,i)]';
    g.set(cmd)
    pause(.02)
end

for(t=0:100)
    cmd.position = [0; extraAngles(:,end)]';
    g.set(cmd)
    pause(.1)
end