var Capital, Output, Labour, Consumption, Efficiency, efficiency, Investment;

varexo epsilon;

parameters beta, theta, tau, alpha, psi, delta, rho, Effstar, sigma;

beta    =  0.990 ;
theta   =  0.357 ;
tau     =  2.000 ;
alpha   =  0.450 ;
psi     = -0.200 ;
delta   =  0.010 ;
Effstar =  1.000 ;
rho     =  0.800 ;
sigma   =  0.100 ;


model(use_dll);

  // TFP
  efficiency = rho*efficiency(-1) + sigma*epsilon;
  Efficiency = Effstar*exp(efficiency);//-.5*sigma*sigma/(1-rho*rho));

  // Production
  Output = Efficiency*(alpha*(Capital(-1)^psi)+(1-alpha)*(Labour^psi))^(1/psi);

  // Capital law of motion
  Capital = Investment + (1-delta)*Capital(-1);

  // Consumption/Leisure arbitrage
  ((1-theta)/theta)*(Consumption/(1-Labour)) - (1-alpha)*(Output/Labour)^(1-psi);

  // Euler equation
  (((Consumption^theta)*((1-Labour)^(1-theta)))^(1-tau))/Consumption = beta*((((Consumption(1)^theta)*((1-Labour(1))^(1-theta)))^(1-tau))/Consumption(1))*(alpha*((Output(1)/Capital)^(1-psi))+1-delta);

  // Investment
  Investment = Output-Consumption;

end;

shocks;
var epsilon = 1;
end;

steady_state_model;

  efficiency = 0;
  Efficiency = Effstar;

  // Compute steady state ratios.
  Output_per_unit_of_Capital=((1/beta-1+delta)/alpha)^(1/(1-psi));
  Consumption_per_unit_of_Capital=Output_per_unit_of_Capital-delta;
  Labour_per_unit_of_Capital=(((Output_per_unit_of_Capital/Efficiency)^psi-alpha)/(1-alpha))^(1/psi);
  Output_per_unit_of_Labour=Output_per_unit_of_Capital/Labour_per_unit_of_Capital;
  Consumption_per_unit_of_Labour=Consumption_per_unit_of_Capital/Labour_per_unit_of_Capital;
  //ShareOfCapital=alpha/(alpha+(1-alpha)*Labour_per_unit_of_Capital^psi);

  Labour=1/(1+Consumption_per_unit_of_Labour/((1-alpha)*theta/(1-theta)*Output_per_unit_of_Labour^(1-psi)));

  Consumption = Consumption_per_unit_of_Labour*Labour;

  Capital = Labour/Labour_per_unit_of_Capital;

  Output = Output_per_unit_of_Capital*Capital;

  Investment = Output-Consumption;

end;

steady;

options_.ep.stochastic.IntegrationAlgorithm = 'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;

options_.ep.stack_solve_algo = 7;
options_.ep.solve_algo = 0; // fsolve
options_.ep.stochastic.algo = 1;

maxorder=10;

figure(1)
hold on

verbatim;
  for order=0:maxorder
    set_dynare_seed(0);
    options_.ep.stochastic.order = order;
    ts = extended_path(oo_.steady_state, 100, [], options_, M_, oo_);
    fh = plot(ts.Investment.data);
    fh.Color = (1-order/maxorder)*[0,0,0] + (order/maxorder)*[1 0 0];
  end
end;

% Plot steady state
plot([1 nobs(ts)], oo_.steady_state(strcmp('Investment',M_.endo_names))*[1 1], '--b', 'linewidth', 2)

hold off
ylabel('Investment')
axis tight
box on

print -depsc2 rbc.eps

matlab2tikz( 'rbc.tikz' );
