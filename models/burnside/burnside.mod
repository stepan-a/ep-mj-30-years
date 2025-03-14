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
stoch_simul(order=1,irf=0,periods=8001);
y_perturbation_1 = transpose(oo_.endo_simul(1,:));
x_perturbation_1 = transpose(oo_.endo_simul(2,:));
e_1 = oo_.exo_simul;

set_dynare_seed(seed);
stoch_simul(order=2,irf=0,periods=8001);
y_perturbation_2 = transpose(oo_.endo_simul(1,:));
x_perturbation_2 = transpose(oo_.endo_simul(2,:));
e_2 = oo_.exo_simul;

set_dynare_seed(seed);
stoch_simul(order=2,pruning,irf=0,periods=8001);
y_perturbation_2_pruning = transpose(oo_.endo_simul(1,:));
x_perturbation_2_pruning = transpose(oo_.endo_simul(2,:));
e_2_ = oo_.exo_simul;

set_dynare_seed(seed);
stoch_simul(order=3,irf=0,periods=8001);
y_perturbation_3 = transpose(oo_.endo_simul(1,:));
x_perturbation_3 = transpose(oo_.endo_simul(2,:));
e_3 = oo_.exo_simul;

set_dynare_seed(seed);
stoch_simul(order=3,pruning,irf=0,periods=8001);
y_perturbation_3_pruning = transpose(oo_.endo_simul(1,:));
x_perturbation_3_pruning = transpose(oo_.endo_simul(2,:));
e_3_ = oo_.exo_simul;

set_dynare_seed(seed);
stoch_simul(order=4,irf=0,periods=8001);
y_perturbation_4 = transpose(oo_.endo_simul(1,:));
x_perturbation_4 = transpose(oo_.endo_simul(2,:));
e_4 = oo_.exo_simul;

set_dynare_seed(seed);
stoch_simul(order=4,pruning,irf=0,periods=8001);
y_perturbation_4_pruning = transpose(oo_.endo_simul(1,:));
x_perturbation_4_pruning = transpose(oo_.endo_simul(2,:));
e_4_ = oo_.exo_simul;


options_.simul.maxit = 100;

set_dynare_seed(seed);
ytrue=exact_solution(M_,oo_, 800);

disp('True mean and standard deviation')
disp(mean(ytrue(101:end)))
disp(sqrt(var(ytrue(101:end))))

disp('Order 1 perturbation mean and standard deviation')
disp(mean(y_perturbation_1(101:end)))
disp(sqrt(var(y_perturbation_1(101:end))))

disp('Accuracy error (order 1 perturbation) % deviation')
disp(mean(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));

disp('Order 2 perturbation mean and standard deviation')
disp(mean(y_perturbation_2(101:end)))
disp(sqrt(var(y_perturbation_2(101:end))))

disp('Accuracy error (order 2 perturbation) % deviation')
disp(mean(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));

disp('Order 3 perturbation mean and standard deviation')
disp(mean(y_perturbation_3(101:end)))
disp(sqrt(var(y_perturbation_3(101:end))))

disp('Accuracy error (order 3 perturbation) % deviation')
disp(mean(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));

disp('Order 4 perturbation mean and standard deviation')
disp(mean(y_perturbation_4(101:end)))
disp(sqrt(var(y_perturbation_4(101:end))))

disp('Accuracy error (order 4 perturbation) % deviation')
disp(mean(100*abs((y_perturbation_4-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_4-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_4-transpose(ytrue))./transpose(ytrue))));

T = 5001;

options_.ep.stochastic.algo=1; // Default is to use a sparse tree


options_.ep.stochastic.order = 0;
ts0 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts0, ytrue);


options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
ts2 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2, ytrue, 2, false, true, false)


options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.algo=0; // Full tree of future innovations
ts2__ = extended_path([], T, e_1, options_, M_, oo_);
options_.ep.stochastic.algo=1;
burndisp(ts2__, ytrue, 2, false, false, true)


options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts2h = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts2h, ytrue, 2, true, true, false)


options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
options_.ep.stochastic.algo = 0;
ts2h__ = extended_path([], T, e_1, options_, M_, oo_);
options_.ep.stochastic.algo = 1;
burndisp(ts2h__, ytrue, 2, true, false, true)


options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 0;
ts5 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts5, ytrue, 5, false, true, false)


options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.algo=0; // Full tree of future innovations
options_.ep.stochastic.hybrid_order = 0;
ts5__ = extended_path([], T, e_1, options_, M_, oo_);
options_.ep.stochastic.algo=1;
burndisp(ts5__, ytrue, 5, false, false, true)


options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts5h = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts5h, ytrue, 5, true, true, false)


options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
options_.ep.stochastic.algo = 0;
ts5h__ = extended_path([], T, e_1, options_, M_, oo_);
options_.ep.stochastic.algo = 1;
burndisp(ts5h__, ytrue, 5, true, false, true)


options_.ep.stochastic.order = 10;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 0;
ts10 = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts10, ytrue, 10, false, true, false)


options_.ep.stochastic.order = 10;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts10h = extended_path([], T, e_1, options_, M_, oo_);
burndisp(ts10h, ytrue, 10, true, true, false)
