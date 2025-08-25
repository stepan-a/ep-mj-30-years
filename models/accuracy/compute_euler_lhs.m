function ts = compute_euler_lhs(filename)

% Return a dseries object with all the endogenous variables and the LHS of the Euler equation.
%
% INPUTS
% - filename    [char]     1×n array, name of the mat file where a dseries containing the simulations for the endogenous variables are saved.
%
% OUTPUTS
% - ts          [dseries]  updated dseries object with the left hand side of the Euler equation.

    ts = dseries(filename);

    calibration;

    ts.LHS = (ts.Consumption^theta*(1-ts.Labour)^(1-theta))^(1-tau)/ts.Consumption - ts.LagrangeMultiplier;

end
