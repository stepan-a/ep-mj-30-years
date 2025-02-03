addpath ..
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

options_.simul.maxit = 100;

set_dynare_seed(seed);
ytrue=exact_solution(M_,oo_, 800);

options_.ep.stochastic.algo=1;

set_dynare_seed(seed);
options_.ep.stochastic.order = 0;
ts0 = extended_path([], 8001, e_1, options_, M_, oo_);

set_dynare_seed(seed);
options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
ts2 = extended_path([], 8001, e_1, options_, M_, oo_);

set_dynare_seed(seed);
options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts2_ = extended_path([], 8001, e_1, options_, M_, oo_);

set_dynare_seed(seed);
options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts5_ = extended_path([], 8001, e_1, options_, M_, oo_);

set_dynare_seed(seed);
options_.ep.stochastic.order = 10;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts10_ = extended_path([], 8001, e_1, options_, M_, oo_);

disp('True mean and standard deviation')
disp(mean(ytrue(101:end)))
disp(sqrt(var(ytrue(101:end))))

disp('Order 1 perturbation mean and standard deviation')
disp(mean(y_perturbation_1(101:end)))
disp(sqrt(var(y_perturbation_1(101:end))))

disp('Order 2 perturbation mean and standard deviation')
disp(mean(y_perturbation_2(101:end)))
disp(sqrt(var(y_perturbation_2(101:end))))

disp('Order 2 (with pruning) perturbation mean and standard deviation')
disp(mean(y_perturbation_2_pruning(101:end)))
disp(sqrt(var(y_perturbation_2_pruning(101:end))))

disp('Order 3 perturbation mean and standard deviation')
disp(mean(y_perturbation_3(101:end)))
disp(sqrt(var(y_perturbation_3(101:end))))

disp('Order 3 (with pruning) perturbation mean and standard deviation')
disp(mean(y_perturbation_3_pruning(101:end)))
disp(sqrt(var(y_perturbation_3_pruning(101:end))))

disp('Extended path mean and standard deviation')
disp(mean(ts0.data(101:end,1)))
disp(sqrt(var(ts0.data(101:end,1))))

disp('Stochastic extended (order=2) path mean and standard deviation')
disp(mean(ts2.data(101:end,1)))
disp(sqrt(var(ts2.data(101:end,1))))

disp('Stochastic extended (order=2,hybrid) path mean and standard deviation')
disp(mean(ts2_.data(101:end,1)))
disp(sqrt(var(ts2_.data(101:end,1))))

disp('Stochastic extended (order=5,hybrid) path mean and standard deviation')
disp(mean(ts5_.data(101:end,1)))
disp(sqrt(var(ts5_.data(101:end,1))))

disp('Stochastic extended (order=2,hybrid) path mean and standard deviation')
disp(mean(ts10_.data(101:end,1)))
disp(sqrt(var(ts10_.data(101:end,1))))

disp('Accuracy error (order 1 perturbation) % deviation')
disp(mean(100*(y_perturbation_1-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (order 2 perturbation) % deviation')
disp(mean(100*(y_perturbation_2-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (order 3 perturbation) % deviation')
disp(mean(100*(y_perturbation_3-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (extended path) % deviation')
disp(mean(100*(ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=2) % deviation')
disp(mean(100*(ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=2, hybrid) % deviation')
disp(mean(100*(ts2_.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts2_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts2_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts2_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=5, hybrid) % deviation')
disp(mean(100*(ts5_.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts5_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts5_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts5_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=10, hybrid) % deviation')
disp(mean(100*(ts10_.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts10_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts10_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts10_.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));


disp('Accuracy error (order 1 perturbation)')
disp(mean(y_perturbation_1-transpose(ytrue)));
disp(mean(abs((y_perturbation_1-transpose(ytrue)))));
disp(min(abs((y_perturbation_1-transpose(ytrue)))));
disp(max(abs((y_perturbation_1-transpose(ytrue)))));

disp('Accuracy error (order 2 perturbation)')
disp(mean(y_perturbation_2-transpose(ytrue)));
disp(mean(abs((y_perturbation_2-transpose(ytrue)))));
disp(min(abs((y_perturbation_2-transpose(ytrue)))));
disp(max(abs((y_perturbation_2-transpose(ytrue)))));

disp('Accuracy error (order 3 perturbation)')
disp(mean(y_perturbation_3-transpose(ytrue)));
disp(mean(abs((y_perturbation_3-transpose(ytrue)))));
disp(min(abs((y_perturbation_3-transpose(ytrue)))));
disp(max(abs((y_perturbation_3-transpose(ytrue)))));

disp('Accuracy error (extended path)')
disp(mean(ts0.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts0.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts0.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts0.data(2:end,1)-transpose(ytrue)))));

disp('Accuracy error (stochastic extended path, order=2)')
disp(mean(ts2.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts2.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts2.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts2.data(2:end,1)-transpose(ytrue)))));

disp('Accuracy error (stochastic extended path, order=2, hybrid)')
disp(mean(ts2_.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts2_.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts2_.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts2_.data(2:end,1)-transpose(ytrue)))));

disp('Accuracy error (stochastic extended path, order=5, hybrid)')
disp(mean(ts5_.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts5_.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts5_.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts5_.data(2:end,1)-transpose(ytrue)))));

disp('Accuracy error (stochastic extended path, order=10, hybrid)')
disp(mean(ts10_.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts10_.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts10_.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts10_.data(2:end,1)-transpose(ytrue)))));
