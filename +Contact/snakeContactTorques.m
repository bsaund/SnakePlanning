function tau =  snakeContactTorques(p, world, r, spring, J1)
    f = Contact.snakeContactForces(p, world, r, spring);
    
    n=size(f,2);
    J = zeros(n*6, n);
    wrench = zeros(6*n,1);
    
    for i=1:n
        ind = (1:6) + 6*(i-1);
        wrench(ind) = [f(1:3, i);0;0;0];
        J(ind, :) = J1(:,:,i);
    end
    
    tau = J'*wrench;
        
        
    
end
