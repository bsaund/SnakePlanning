function p = closestPointOnWorldOneFaceAtATime(p_test, world)
    f = world.faces;
    v = world.vertices;
    numFaces = size(f,1);

    
    d = inf;

    for i=1:numFaces
        p_temp = Contact.closestPoint(p_test, ...
                                      v(f(i,1),:)',...
                                      v(f(i,2),:)',...
                                      v(f(i,3),:)');
        d_temp = sumsqr(p_test-p_temp);
        patch('Faces', f(i,:), 'Vertices', v, ...
              'EdgeColor', [1,0,0],...
              'FaceColor', [.9, .9, .9]);
        scatter3(p_temp(1), p_temp(2), p_temp(3),'r.');
        input('Next Face?', 's');
        if (d_temp < d)
            d = d_temp;
            p = p_temp;
        end
    end
                                      
end
