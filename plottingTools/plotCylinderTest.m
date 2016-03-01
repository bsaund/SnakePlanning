function plotCylinderTest
    close all
    % plt = CylinderPlotter();
    plt = HebiPlotter();
    % plt.plot([.4,.1,.1,.1,.1,0,0,.4]);
    
    
    kin = HebiKinematics;
    kin.addBody('FieldableElbowJoint');
    kin.addBody('FieldableElbowJoint');
    kin.addBody('FieldableElbowJoint');
    kin.addBody('FieldableElbowJoint');
    kin.addBody('FieldableElbowJoint');
    kin.addBody('FieldableElbowJoint');
    
    angles = [.1,.2,-.1,-.3,.1,.2];

    fk = kin.getFK('CoM',angles);
    VC = unifiedVC(fk, eye(3))

    plt.setBaseFrame(inv(VC));
    plt.plot(angles);
    
end
