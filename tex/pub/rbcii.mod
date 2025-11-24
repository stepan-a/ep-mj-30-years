var Capital, Output, Labour, Consumption, Efficiency, efficiency, Investment, LagrangeMultiplier;

varexo epsilon;

parameters beta, theta, tau, alpha, psi, delta, Effstar, rho, sigma;

@#define ZLB = .85

Effstar =  1.000 ;
beta    =  0.990 ;
theta   =  0.357 ;
tau     =  2.000 ;
alpha   =  0.450 ;
psi     = -0.200 ;
delta   =  0.025 ;
rho     =  0.950 ;
effstar =  1.000 ;

sigma   =  0.007 ;

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
  (Consumption^theta*(1-Labour)^(1-theta))^(1-tau)/Consumption - LagrangeMultiplier =  beta*((Consumption(1)^theta*(1-Labour(1))^(1-theta))^(1-tau)/Consumption(1)*(alpha*(Output(1)/Capital)^(1-psi)+1-delta) + LagrangeMultiplier(1)*(1-delta));

  // Investment
  Investment = Output - Consumption;

  // Lagrange multiplier
  LagrangeMultiplier = 0 ⟂ Investment > @{ZLB}*0.241741953339345;

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
options_.ep.stochastic.quadrature.nodes = 3;

options_.ep.stack_solve_algo = 7;
options_.ep.solve_algo = 11; // Use PATH nonlinear mixed complementarity problem solver (must be installed by the user, see https://pages.cs.wisc.edu/~ferris/path.html),
                             // an alternative is solve_algo=10 (lmmcp) but the algorithm is slower and fails much more often.
options_.ep.stochastic.algo = 1;

set_dynare_seed(0);%'default')
ts0 = extended_path(oo_.steady_state, 400, [], options_, M_, oo_);



%plot(120:400,ts0.Investment.data(120:400))
%hold on
%plot([120 400], oo_.steady_state(strcmp('Investment', M_.endo_names))*[1 1], '--b', 'linewidth', 2)
%plot([120 400], oo_.steady_state(strcmp('Investment', M_.endo_names))*[.85 .85], '--r', 'linewidth', 2)
%hold off





set_dynare_seed(0);%'default')
options_.ep.stochastic.order = 1;
ts1 = extended_path(oo_.steady_state, 400, [], options_, M_, oo_);

set_dynare_seed(0);%'default')
options_.ep.stochastic.order = 2;
ts2 = extended_path(oo_.steady_state, 400, [], options_, M_, oo_);

set_dynare_seed(0);%'default')
options_.ep.stochastic.order = 3;
ts3 = extended_path(oo_.steady_state, 400, [], options_, M_, oo_);

set_dynare_seed(0);%'default')
options_.ep.stochastic.order = 4;
ts4 = extended_path(oo_.steady_state, 400, [], options_, M_, oo_);

set_dynare_seed(0);%'default')
options_.ep.stochastic.order = 5;
ts5 = extended_path(oo_.steady_state, 400, [], options_, M_, oo_);


plot(120:400, ts0.Investment.data(120:400),'-k', 'linewidth', 2)

hold on
plot(120:400, ts1.Investment.data(120:400),'-b')
plot(120:400, ts2.Investment.data(120:400),'-c')
plot(120:400, ts3.Investment.data(120:400),'-m')
plot(120:400, ts4.Investment.data(120:400),'-g')
plot(120:400, ts5.Investment.data(120:400),'-r')
plot([120 400], oo_.steady_state(strcmp('Investment', M_.endo_names))*[1 1], '--b', 'linewidth', 2)
plot([120 400], oo_.steady_state(strcmp('Investment', M_.endo_names))*[.85 .85], '--r', 'linewidth', 2)

% Plot steady state
%plot([1 nobs(ts0)], oo_.steady_state(strcmp('Investment', M_.endo_names))*[1 1], '--b', 'linewidth', 2)

hold off

ylabel('Investment')
legend('order=0', 'order=1', 'order=2','order=3','order=4','order=5')
axis tight
box on

print -depsc2 rbcii.eps
!epstopdf rbcii.eps

matlab2tikz( 'rbcii.tikz' );
