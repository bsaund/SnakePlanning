function jointTypes = getSimpleRobot()
    % jointTypes(1) = {{'X5-4'}};
    % jointTypes(2) = {{'GenericLink',...
    %                   'com',[.01,.01,.01]','out',...
    %                   ((rotx(pi/2)+ [zeros(4,3),[0 -.04 .055 0]'])*rotz(pi)),...
    %                   'mass',.1}};
    % jointTypes(3) = {{'X5-9'}};
    jointTypes(1) = {{'FieldableElbowJoint'}};
    jointTypes(2) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
    jointTypes(3) = {{'FieldableElbowJoint'}};
    jointTypes(4) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};    
    jointTypes(5) = {{'FieldableElbowJoint'}};
    jointTypes(6) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
    jointTypes(7) = {{'FieldableElbowJoint'}};


end
