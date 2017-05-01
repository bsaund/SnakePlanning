function interpF = interpolateForces(forces, interpFactor)
    num_contacts = size(forces,2);
    f = reshape(forces, 3*num_contacts, [])
    f = [zeros(3*num_contacts,1), f];
    n = size(f, 2);
    interpF = f(:,1);
    for i=2:n
        prev = f(:,i-1);
        cur = f(:,i);
        for j=1:interpFactor
            newF = prev + (cur-prev)*j/interpFactor;
            interpF = [interpF, newF];
        end
    end
    interpF = reshape(interpF, 3, num_contacts,[]);
end
