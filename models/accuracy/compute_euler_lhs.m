function ts = compute_euler_lhs(filename)

% Return a dseries object with all the endogenous variables and the LHS of the Euler equation.

    ts = dseries(filename);

    calibration;

    ts.LHS = (ts.Consumption^theta*(1-ts.Labour)^(1-theta))^(1-tau)/ts.Consumption - ts.LagrangeMultiplier;

end
