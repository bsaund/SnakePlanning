function J = HebiGetJacobian(kin, angles)
    J = kin.getJacobian(angles, 'Output');
    J = J(end-5:end,:);
end
