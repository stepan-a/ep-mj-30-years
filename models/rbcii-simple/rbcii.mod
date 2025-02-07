var Capital, Output, Consumption, Investment, Efficiency, efficiency, LagrangeMultiplier;

varexo EfficiencyInnovation;

parameters beta, tau, alpha, delta, rho, effstar, sigma;

beta    =  0.960;
tau     =  2.000;
alpha   =  0.330;
delta   =  0.100;
rho     =  0.900;
effstar =  1.000;
sigma   =  0.013;

model(use_dll);

  // Eq. 1
  efficiency = rho*efficiency(-1)+sigma*EfficiencyInnovation;

  // Eq. 2
  Efficiency = effstar*exp(efficiency);

  // Eq. 3 (Production function)
  Output = Efficiency*Capital(-1)^alpha;

  // Eq. 4 (Transition equation)
  Capital = Investment + (1-delta)*Capital(-1);

  // Eq. 5 (Euler equation)
  Consumption^(-tau) - LagrangeMultiplier = beta*Consumption(1)^(-tau)*(alpha*Output(1)/Capital+1-delta)-beta*LagrangeMultiplier(1)*(1-delta);

  // Eq. 6
  Investment = Output-Consumption;
  
  // Eq. 8 (Lagrange multiplier associated to the constraint Investment> .975*steady_state(Investment))
  LagrangeMultiplier = 0 ⟂ Investment>0.344455694422751 ;

end;

shocks;
var EfficiencyInnovation = 1;
end;

steady_state_model;
  efficiency = 0;
  Efficiency = effstar;
  Capital = (alpha*effstar/(delta+1/beta-1))^(1/(1-alpha));
  Output = effstar*Capital^alpha;
  Consumption = Output-delta*Capital;
  Investment = Output-Consumption;
  ExpectedTerm = Consumption^(-tau);
  LagrangeMultiplier = 0;
end;

steady;


verbatim;

  options_.console_mode = false;
  options_.ep.stack_solve_algo = 7;
  options_.ep.solve_algo = 11;
  options_.ep.stochastic.algo = 1;
  options_.ep.IntegrationAlgorithm = 'Tensor-Gaussian-Quadrature';
  options_.ep.stochastic.quadrature.nodes = 3;

  options_.ep.stochastic.order = 0;
  ts0 = extended_path(oo_.steady_state, 100, [], options_, M_, oo_);

  maxorder=10;
  ts = cell(maxorder, 1);
  ts_ = cell(maxorder, 1);

  for order=1:maxorder
    options_.ep.stochastic.order = order;
    options_.ep.stochastic.hybrid_order = 0;
    ds = extended_path(oo_.steady_state, 100, [], options_, M_, oo_);
    ts{order} = ds;
    options_.ep.stochastic.hybrid_order = 2;
    ds = extended_path(oo_.steady_state, 100, [], options_, M_, oo_);
    ts_{order} = ds; 
  end

  plot(ts0.Investment.data,'-k', 'linewidth', 2)

  hold on
  
  for order=1:maxorder
    fh = plot(ts{order}.Investment.data, '-');
    fh.Color = (1-order/maxorder)*[0,0,0] + (order/maxorder)*[1 0 0];
    gh = plot(ts_{order}.Investment.data, '--');
    gh.Color = (1-order/maxorder)*[0,0,0] + (order/maxorder)*[1 0 0];
  end

  hold off
  axis tight
  box on

  print -depsc2 rbcii-simple.eps

  matlab2tikz('rbcii-simple.tikz');

  saveas(gcf,'rbcii-simple.fig');
  
end;
