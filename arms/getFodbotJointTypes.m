function jointTypes = getFodbotJointTypes()
    jointTypes(1) = {{'X5-4'}};
    jointTypes(2) = {{'GenericLink',...
                      'com',[.01,.01,.01]','out',...
                      ((rotx(pi/2)+ [zeros(4,3),[0 -.04 .055 0]'])*rotz(pi)),...
                      'mass',.1}};
    jointTypes(3) = {{'X5-9'}};
    jointTypes(4) = {{'FieldableElbowJoint'}};
    jointTypes(5) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
    jointTypes(6) = {{'FieldableElbowJoint'}};
    jointTypes(7) = {{'FieldableElbowJoint'}};
    jointTypes(8) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
    jointTypes(9) = {{'FieldableElbowJoint'}};
    jointTypes(10) = {{'FieldableElbowJoint'}};
    jointTypes(11) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi}};
    jointTypes(12) = {{'FieldableElbowJoint'}};
    jointTypes(13) = {{'FieldableElbowJoint'}};
    jointTypes(14) = {{'FieldableStraightLink', 'ext1', .165, 'twist', pi/2}};
    jointTypes(15) = {{'FieldableElbowJoint'}};
    jointTypes(16) = {{'FieldableElbowJoint'}};

end
