function sample = getSnakeContactSampling(minSample, maxSample, numContacts)
    function sampledPoint = basicSample(i, goal)
        % if(mod(i,sampleGoalLength) == 0)
        %     sampledPoint = goal;
        %     return
        % end
        sampledPoint = rand(size(minSample)).*(maxSample-minSample) ...
            + minSample;
        sampledPoint = [sampledPoint, zeros(1, numContacts)];
    end
    sample = @basicSample;
end
