function sample = getBasicSamplingFunc(sampleGoalLength, minSample, maxSample)
    function sampledPoint = basicSample(i, goal)
        if(mod(i,sampleGoalLength) == 0)
            sampledPoint = goal;
            return
        end
        sampledPoint = rand(size(minSample)).*(maxSample-minSample) ...
            + minSample;
    end
    sample = @basicSample;
end
