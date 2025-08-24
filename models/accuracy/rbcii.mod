@#ifndef SIMULATION
@#define SIMULATION = true
@#endif

@#ifndef SEP_ORDER
@#define SEP_ORDER = 0
@#endif

@#ifndef SEP_PERIODS
@#define SEP_PERIODS = 200
@#endif

@#ifndef SEP_HYBRID_ORDER
@#define SEP_HYBRID_ORDER = 0
@#endif

@#ifndef SEP_QUADRATURE_NODES
@#define SEP_QUADRATURE_NODES = 3
@#endif

@#ifndef SEP_ALGORITHM
@#define SEP_ALGORITHM = 1
@#endif

@#ifndef NUMBER_OF_PERIODS
@#define NUMBER_OF_PERIODS = 10000
@#endif

@#ifndef SIGMA_VALUE
@#define SIGMA_VALUE = 0.100
@#endif

var Capital, Output, Labour, Consumption, Efficiency, efficiency, Investment, LagrangeMultiplier, ExpectedTerm;

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
sigma   =  @{SIGMA_VALUE} ;

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
  var epsilon = 1;
end;

@#if SIMULATION

@#ifndef OUTPUT_FILE
@#error "Missing file name for saving the simulations."
@#endif

options_.ep.stochastic.IntegrationAlgorithm = 'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = @{SEP_QUADRATURE_NODES};

options_.ep.stack_solve_algo = 7;
options_.ep.solve_algo = 11; // Use PATH nonlinear mixed complementarity problem solver (must be installed by the user, see https://pages.cs.wisc.edu/~ferris/path.html),
                             // an alternative is solve_algo=10 (lmmcp) but the algorithm is slower and fails much more often.

options_.ep.stochastic.algo = @{SEP_ALGORITHM};

options_.ep.periods = @{SEP_PERIODS};

options_.ep.stochastic.order = @{SEP_ORDER};

options_.ep.stochastic.hybrid_order = @{SEP_HYBRID_ORDER};

if options_.ep.stochastic.hybrid_order>2
stoch_simul(order=4,irf=0,periods=10,noprint);
end


set_dynare_seed(0);
ts = extended_path(oo_.steady_state, @{NUMBER_OF_PERIODS}, [], options_, M_, oo_);

ts.save('@{OUTPUT_FILE}');

@#endif
