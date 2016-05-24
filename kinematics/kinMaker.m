function kin = kinMaker(varargin)
    p = inputParser();
    p.addParameter('armType', 'snake');
    p.addParameter('numJoints', 0);
    p.addParameter('baseFrame', eye(4));
    
    p.parse(varargin{:});
    
    re = p.Results;
    if(strcmpi(re.armType, 'snake'))
        kin = snakeKinematics(re.numJoints);
    else 
        kin = [];
        return;
    end
    
    kin.setBaseFrame(re.baseFrame);
    
end

function kin = snakeKinematics(numLinks)
    kin = HebiKinematics();
    for i=1:numLinks
        kin.addBody('FieldableElbowJoint');
    end
end


