function J = HebiGetJacobian(l, angles)
    global kin;
    J = kin.getJacobian(angles, 'Output');
    J = J(end-5:end,:);
end
