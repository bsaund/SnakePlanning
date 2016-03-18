function f = snakeContactForces(points, world, radius, spring)
%SNAKECONTACTFORCES returns a vector of the contact forces on the snake
    f = zeros(size(points));
    for i=1:size(points,2)
        f(:,i) = Contact.contactForce(points(:,i), world, radius, spring);
    end
end
