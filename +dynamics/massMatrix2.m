function M = massMatrix2(kin, angles)
%Calculate the mass matrix of a hebi kinematics chain
%Only tested on "Fieldable Kinematics" "snake" joints
%This is an implementation of the mathematics found in
%Robotic Manipulation, {Murray, Li, Sastry}
%p. 176, Dynamics of Open Chain Manipulators
    
%This computes the same value as the similar function "massMatrix",
%but does the computation in a different way
    
    n = length(angles);
    z = zeros(3);
    
    [t, g0] = getSnakeTwists(n);
    
    masses = kin.getBodyMasses();
    M = zeros(n);  %Final mass matrix
    
    %M_link is M' in the textbook
    M_link = zeros(6,6,n); 


    
    %Compute adjoint inv from base to link i;
    Ad_inv_s_l = zeros(6,6,n);
    fk_0 = kin.getFK('CoM', zeros(size(angles)));
    for i=1:n
        Ad_inv_s_l(:,:,i) = Adjoint(inv(fk_0(:,:,i)));
    end
    
    %Compute M' from the text, the Inertia matrix of each link as seen
    %from the base frame
    for i=1:n
        M_temp = [eye(3) * masses(i), z; z, z];
        M_link(:,:,i) = Ad_inv_s_l(:,:,i)' * M_temp * Ad_inv_s_l(:,:,i);
    end
    
    %Compute each element of M using M'
    for i=1:n
        for j=1:n
            for l=max(i,j):n
                A_li = AdjointSpecific(t, angles, l,i);
                A_lj = AdjointSpecific(t, angles, l,j);
                M(i,j) = M(i,j) + t(:,i)' * A_li' * M_link(:,:,l) * ...
                         A_lj * t(:,j);
            end
        end
    end
    
    
end
