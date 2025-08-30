function ts = compute_euler_residuals(filename, n, options_, M_, oo_)

% Return a dseries object with all the endogenous variables and the estimated residuals of the Euler equation.
%
% INPUTS
% - filename    [char]     1×n array, name of the mat file where a dseries containing the simulations for the endogenous variables are saved.
% - n           [integer]  scalar, number of Gauss-Hermite approximate integral nodes.
% - options_    [struct]
% - M_          [struct]
% - oo_         [struct]
%
% OUTPUTS
% - ts          [dseries]  updated dseries object with the estimated residuals of the Euler equation.

    if iseven(n)
        error('Number of nodes, second input argument, must be an odd number.')
        % This ensures that 0 is a node, the stochastic perfect foresight model is first simulated with the central node. The solution serves as an initial guess
        % for all the other simulations (with non zero nodes).
    end

    try
        o = dseries(filename);
    catch
        error('Cannot instantiate a dseries object with %s.', filename)
    end

    % Get model's calibration
    calibration;

    % Set the value of σ consistent with the database
    M_.params(strcmp(M_.param_names, 'sigma')) = str2num(filename(7:9))/1000;

    % Set SEP (stochastic) order
    options_.ep.stochastic.order = str2num(filename(15));

    % Set SEP algorithm (full or sparse tree of possible futures)
    options_.ep.stochastic.algo = str2num(filename(22));

    % Set hybrid SEP order
    options_.ep.stochastic.hybrid_order = str2num(filename(31));

    % Set number of periods in the auxiliary model
    options_.ep.periods = 200;

    % Set SEP approximate integration
    options_.ep.stochastic.IntegrationAlgorithm = 'Tensor-Gaussian-Quadrature';
    options_.ep.stochastic.quadrature.nodes = 3;

    % Set SEP nonlinear solver
    options_.ep.stack_solve_algo = 7;
    options_.ep.solve_algo = 11; % Use PATH nonlinear mixed complementarity problem solver (must be installed by the user, see https://pages.cs.wisc.edu/~ferris/path.html),


    ts = copy(o); % Keep a deep copy of the database.

    T = ts.nobs; % number of periods

    poolobj = parpool('Processes', n-1)


    %
    % Compute Euler equation LHS
    %

    ts = compute_euler_lhs(ts);

    %
    % Set approximation weights and nodes
    %

    [x, w] = gauss_hermite(n);
    x = x*sqrt(2);
    w = w/sqrt(pi);
    % Reorder the nodes (center node comes first, then positive node by increasing order negative nodes by decreasing order)
    tmp = [abs(x), -sign(x), x, w];
    [~, id] = sortrows(tmp, [2,1]);
    x = x(id);
    w = w(id);

    npn = floor(n/2); % Number of positive (negative) nodes.

    T = ts.nobs;

    ts.EulerErrors_c = dseries(NaN);
    ts.EulerErrors_e = dseries(NaN);

    Errors_c = NaN(T,1);
    Errors_e = NaN(T,1);

    skipline();

    hh_fig = waitbar.run(0,'Please wait. Computing Euler errors...');
    set(hh_fig,'Name', 'SEP simulations.' );


    for t=1:T;

        if ~mod(t,10)
            waitbar.run(t/T, hh_fig, 'Please wait. Computing Euler errors...');
        end

        initialconditions = transpose(o.data(t,:));

        [initialconditions, innovations, pfm, options_, oo_] = ...
            extended_path_initialization(initialconditions, 1, [], options_, M_, oo_);

        [shocks, spfm_exo_simul, innovations, oo_] = extended_path_shocks(innovations, [], 1, M_, options_, oo_);

        z = NaN(M_.endo_nbr, n);

        %
        % First simulation on the central node
        %

        spfm_exo_simul(2) = x(1); % should be zero


        [z(:,1), info_convergence, initialguess, y, pfm, options_] = extended_path_core(innovations.positive_var_indx, ...
                                                                                        spfm_exo_simul, ...
                                                                                        initialconditions, ...
                                                                                        pfm, ...
                                                                                        M_, ...
                                                                                        options_, ...
                                                                                        oo_, ...
                                                                                        [], ...
                                                                                        []);

        parfor node=2:2*npn+1
            yy = y;
            xxx = zeros(202,1);
            xxx(2) = x(node);
            [z(:,node), info_convergence, endogenousvariablespaths, yy] = extended_path_core(innovations.positive_var_indx, ...
                                                                                             xxx, ...
                                                                                             initialconditions, ...
                                                                                             pfm, ...
                                                                                             M_, ...
                                                                                             options_, ...
                                                                                             oo_, ...
                                                                                             initialguess, ...
                                                                                             yy);
        end

        % Compute Euler equation error
        Z = z*w;
        E = ts.LHS.data(t)-Z(end);
        Errors_e(t) = E;
        % Express the Euler equation error in terms of consumption (in percentage deviation from the steady state)
        C = ((Z(end)+o.LagrangeMultiplier.data(t))/(1-o.Labour.data(t))^((1-theta)*(1-tau)))^(1/(theta*(1-tau)-1));
        Cstar = oo_.steady_state(strcmp(M_.endo_names,'Consumption'));
        Errors_c(t) = 100*(C-o.Consumption.data(t))/Cstar;


    end

    waitbar.close(hh_fig);

    delete(poolobj);

    ts.fill_('EulerErrors_e', Errors_e);
    ts.fill_('EulerErrors_c', Errors_c);

end
