function [angles, c] = fullStateToVars(state)
%Recovers the angles and c from the full state
%Assumes that each angle leads to an end effector, and each end
%effector has a contact variable
    n = size(state,1);
    angles = state(1:n/2);
    c = state(n/2+1:n);
end
