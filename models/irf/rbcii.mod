var Capital, Output, Labour, Consumption, Efficiency, efficiency, Investment, LagrangeMultiplier;

varexo epsilon;

parameters beta, theta, tau, alpha, psi, delta, Effstar, rho, sigma;

Effstar =  1.000 ;
beta    =  0.990 ;
theta   =  0.357 ;
tau     =  2.000 ;
alpha   =  0.450 ;
psi     = -0.200 ;
delta   =  0.010 ;
rho     =  0.800 ;
effstar =  1.000 ;
sigma   =  0.100 ;

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
  (Consumption^theta*(1-Labour)^(1-theta))^(1-tau)/Consumption - LagrangeMultiplier =  beta*(Consumption(1)^theta*(1-Labour(1))^(1-theta))^(1-tau)/Consumption(1)*(alpha*(Output(1)/Capital)^(1-psi)+1-delta) + LagrangeMultiplier(1)*(1-delta);

  // Investment
  Investment = Output - Consumption;

  // Lagrange multiplier associated to the positivity constraint on investment
  LagrangeMultiplier = 0 ⟂ Investment > 0;

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

end;

steady;


shocks;
  var epsilon = 1;
end;


options_.ep.stochastic.IntegrationAlgorithm = 'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 5;

options_.ep.stack_solve_algo = 7;
options_.ep.solve_algo = 11; // Use PATH nonlinear mixed complementarity problem solver (must be installed by the user, see https://pages.cs.wisc.edu/~ferris/path.html),
                             // an alternative is solve_algo=10 (lmmcp) but the algorithm is slower and fails much more often.
options_.ep.stochastic.algo = 1;

innovations = zeros(80,1);
innovations(1) = -2;

maxorder=5;

tt = extended_path(oo_.steady_state, 80, innovations, options_, M_, oo_);

ds = transpose(oo_.steady_state);

for order=maxorder:-1:0
options_.ep.stochastic.order = order;
switch order
case maxorder
ts = extended_path(transpose(ds(end,:)), 1, innovations(1), options_, M_, oo_);
ds = [ds; ts.data(2,:)];
case 0
ts = extended_path(transpose(ds(end,:)), 80, zeros(80,1), options_, M_, oo_);
ds = [ds; ts.data(2:end,:)];
otherwise
ts = extended_path(transpose(ds(end,:)), 1, 0, options_, M_, oo_);
ds = [ds; ts.data(2,:)];
end
end

ts = dseries(ds, '1Y', M_.endo_names);

spfirf(tt, ts, 1)
