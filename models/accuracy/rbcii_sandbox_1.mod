var Capital, Output, Labour, Consumption, Efficiency, efficiency, Investment, LagrangeMultiplier, ExpectedTerm;

varexo epsilon;

parameters beta, theta, tau, alpha, psi, delta, Effstar, rho, sigma;

@#include "calibration.m"

sigma   =  .100 ;

model(use_dll);

  // Logged TFP
  efficiency = rho*efficiency(-1) + sigma*epsilon;

  // TFP
  Efficiency = Effstar*exp(efficiency);

  // Production
  Output = Efficiency*(alpha*Capital(-1)^psi+(1-alpha)*Labour^psi)^(1/psi);

  // Capital law of motion
  Capital = Output-Consumption + (1-delta)*Capital(-1);

  // Consumption/Leisure arbitrage
  (1-theta)/theta*Consumption/(1-Labour) - (1-alpha)*(Output/Labour)^(1-psi);

  // Euler equation
  (Consumption^theta*(1-Labour)^(1-theta))^(1-tau)/Consumption - LagrangeMultiplier =  ExpectedTerm(1);

  // Investment
  Investment = Output - Consumption;

  // Lagrange multiplier associated to the positivity constraint on investment
  LagrangeMultiplier = 0 ⟂ Investment > 0;

  // Aux. variable for the expected term
  ExpectedTerm = beta*((Consumption^theta*(1-Labour)^(1-theta))^(1-tau)/Consumption*(alpha*(Output/Capital(-1))^(1-psi)+1-delta) + LagrangeMultiplier*(1-delta));

end;


steady_state_model;

  efficiency = 0;
  Efficiency = Effstar;

  Output_per_unit_of_Capital = ((1/beta-1+delta)/alpha)^(1/(1-psi));
  Consumption_per_unit_of_Capital = Output_per_unit_of_Capital-delta;
  Labour_per_unit_of_Capital = (((Output_per_unit_of_Capital/Efficiency)^psi-alpha)/(1-alpha))^(1/psi);
  Output_per_unit_of_Labour = Output_per_unit_of_Capital/Labour_per_unit_of_Capital;
  Consumption_per_unit_of_Labour = Consumption_per_unit_of_Capital/Labour_per_unit_of_Capital;

  Labour = 1/(1+Consumption_per_unit_of_Labour/((1-alpha)*theta/(1-theta)*Output_per_unit_of_Labour^(1-psi)));

  Consumption = Consumption_per_unit_of_Labour*Labour;

  Capital = Labour/Labour_per_unit_of_Capital;

  Output = Output_per_unit_of_Capital*Capital;

  Investment = Output - Consumption;

  LagrangeMultiplier = 0;

  ExpectedTerm = beta*(Consumption^theta*(1-Labour)^(1-theta))^(1-tau)/Consumption*(alpha*(Output/Capital)^(1-psi)+1-delta);
  
end;

steady;

shocks;
  var epsilon;
  periods 1;
  values -.3;
end;

perfect_foresight_setup(periods=100);
perfect_foresight_solver(stack_solve_algo=7, solve_algo=11);

ts = copy(Simulated_time_series);

ts.LHS = (ts.Consumption^theta*(1-ts.Labour)^(1-theta))^(1-tau)/ts.Consumption - ts.LagrangeMultiplier;

e = max(abs(ts.LHS.data(2:end-1)-ts.ExpectedTerm.data(3:end)));

if max(abs(ts.LHS.data(2:end-1)-ts.ExpectedTerm.data(3:end)))>1e-6
    error('Euler equation residuals are to large (%f)!', e)
end

!rm rbcii_sandbox_1.log
!rm -rf rbcii_sandbox_1 +rbcii_sandbox_1
!rm *.tmp
