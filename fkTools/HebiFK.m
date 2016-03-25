function [q, points] = HebiFK(l, angles)
    global kin;
    fr = kin.getFrames(angles, 'Output');
    points = [];
    for i = 1:size(fr,3)
        points = [points; getPoint(fr(:,:,i))];
    end
    q = getXYZQ(fr(:,:,end));
end
