function angles = minimizeCost(kin, initial_angles, cost_function, varargin)
    fun = cost_function(kin, varargin{:});
    lb = -pi/2 * ones(length(initial_angles), 1);
    ub = -lb;
    
    options = optimoptions('fmincon','Display','none');
    angles = fmincon(fun, initial_angles, [], [], [], [], lb, ub, ...
                     [], options);
end
