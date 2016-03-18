function closestPointTest()
    p_test = [0;0;0];
    p1 = [1;-1;0];
    p2 = [1;1;-1];
    p3 = [1;1;1];
    

    val = Contact.closestPoint(p_test, p1, p2, p3);

    expected = [1;0;0];
    
    checkEquality(expected, val);
    
    n = 1000;
    t_direct = 0;
    t_optim = 0;
    disp('Running Tests...')
    for i=1:n

        p_test = rand(3,1);
        p1 = rand(3,1);
        p2 = rand(3,1);
        p3 = rand(3,1);
        
        tic
        optimizer_val = Contact.closestPointOptimizer(p_test, p1, ...
                                                      p2, p3);
        t_optim = t_optim + toc;
        tic
        direct_val = Contact.closestPoint(p_test, p1, p2, p3);
        t_direct = t_direct + toc;
        checkEquality(optimizer_val, direct_val);
    end
    
    t_direct = t_direct /n
    t_optim = t_optim /n
    
    disp('Tests Passed')
end

function checkEquality(expected, actual)
    d = 1000000;
    if(~isequal(round(d*expected), round(d*actual)))
        error(['Expected ' num2str(expected') ', got ' ...
               num2str(actual')])
    end
end
