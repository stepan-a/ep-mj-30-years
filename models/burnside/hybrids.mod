addpath ../../matlab

var y x;

varexo e;

parameters beta theta rho xbar;
xbar = 0.0179;
rho =  -0.139;
theta = -1.5;
beta = 0.95;

model(use_dll);
1 = beta*exp(theta*x(+1))*(1+y(+1))/y;
x = (1-rho)*xbar + rho*x(-1)+e;
end;

shocks;
var e; stderr 0.0348;
end;

initval;
x = xbar;
y = beta*exp(theta*xbar)/(1-beta*exp(theta*xbar));
end;

resid;

steady;

check;

if beta*exp(theta*xbar+.5*theta^2*M_.Sigma_e/(1-rho)^2)>1-eps
   disp('The model doesn''t have a solution!')
   return
end

seed = 31415;

set_dynare_seed(seed);
stoch_simul(order=1,irf=0,periods=5001);
y_perturbation_1 = transpose(oo_.endo_simul(1,:));
x_perturbation_1 = transpose(oo_.endo_simul(2,:));
e_1 = oo_.exo_simul;

set_dynare_seed(seed);
ytrue=exact_solution(M_,oo_, 800);

stoch_simul(order=2,irf=0,periods=5001);
stoch_simul(order=4,irf=0,periods=5001);
//stoch_simul(order=6,irf=0,periods=5001);
//stoch_simul(order=8,irf=0,periods=5001);

T = 5001;

options_.ep.stochastic.algo=1; // Default is to use a sparse tree

options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;

options_.ep.stochastic.hybrid_order = 0;
ts2 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2, ytrue, 2, false, true, false)

options_.ep.stochastic.hybrid_order = 2;
ts2_2 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2_2, ytrue, 2, true, true, false)

options_.ep.stochastic.hybrid_order = 4;
ts2_4 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2_4, ytrue, 2, true, true, false)

/*
options_.ep.stochastic.hybrid_order = 6;
ts2_6 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2_6, ytrue, 2, true, true, false)
*/
/*
options_.ep.stochastic.hybrid_order = 8;
ts2_8 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2_8, ytrue, 2, true, true, false)
*/
