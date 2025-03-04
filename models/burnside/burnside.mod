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
disp(mean(100*(y_perturbation_1-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_1-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (order 1 perturbation)')
disp(mean(y_perturbation_1-transpose(ytrue)));
disp(mean(abs((y_perturbation_1-transpose(ytrue)))));
disp(min(abs((y_perturbation_1-transpose(ytrue)))));
disp(max(abs((y_perturbation_1-transpose(ytrue)))));

disp('Order 2 perturbation mean and standard deviation')
disp(mean(y_perturbation_2(101:end)))
disp(sqrt(var(y_perturbation_2(101:end))))

disp('Order 2 (with pruning) perturbation mean and standard deviation')
disp(mean(y_perturbation_2_pruning(101:end)))
disp(sqrt(var(y_perturbation_2_pruning(101:end))))

disp('Accuracy error (order 2 perturbation) % deviation')
disp(mean(100*(y_perturbation_2-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_2-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (order 2 perturbation)')
disp(mean(y_perturbation_2-transpose(ytrue)));
disp(mean(abs((y_perturbation_2-transpose(ytrue)))));
disp(min(abs((y_perturbation_2-transpose(ytrue)))));
disp(max(abs((y_perturbation_2-transpose(ytrue)))));

disp('Order 3 perturbation mean and standard deviation')
disp(mean(y_perturbation_3(101:end)))
disp(sqrt(var(y_perturbation_3(101:end))))

disp('Order 3 (with pruning) perturbation mean and standard deviation')
disp(mean(y_perturbation_3_pruning(101:end)))
disp(sqrt(var(y_perturbation_3_pruning(101:end))))

disp('Accuracy error (order 3 perturbation) % deviation')
disp(mean(100*(y_perturbation_3-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_3-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (order 3 perturbation)')
disp(mean(y_perturbation_3-transpose(ytrue)));
disp(mean(abs((y_perturbation_3-transpose(ytrue)))));
disp(min(abs((y_perturbation_3-transpose(ytrue)))));
disp(max(abs((y_perturbation_3-transpose(ytrue)))));

disp('Order 4 perturbation mean and standard deviation')
disp(mean(y_perturbation_4(101:end)))
disp(sqrt(var(y_perturbation_4(101:end))))

disp('Order 4 (with pruning) perturbation mean and standard deviation')
disp(mean(y_perturbation_4_pruning(101:end)))
disp(sqrt(var(y_perturbation_4_pruning(101:end))))

disp('Accuracy error (order 4 perturbation) % deviation')
disp(mean(100*(y_perturbation_4-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((y_perturbation_4-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((y_perturbation_4-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((y_perturbation_4-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (order 4 perturbation)')
disp(mean(y_perturbation_4-transpose(ytrue)));
disp(mean(abs((y_perturbation_4-transpose(ytrue)))));
disp(min(abs((y_perturbation_4-transpose(ytrue)))));
disp(max(abs((y_perturbation_4-transpose(ytrue)))));




options_.ep.stochastic.algo=1;




set_dynare_seed(seed);
options_.ep.stochastic.order = 0;
ts0 = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Extended path mean and standard deviation')
disp(mean(ts0.data(101:end,1)))
disp(sqrt(var(ts0.data(101:end,1))))

disp('Accuracy error (extended path) % deviation')
disp(mean(100*(ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts0.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (extended path)')
disp(mean(ts0.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts0.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts0.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts0.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
ts2 = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Stochastic extended (order=2, sparse tree) path mean and standard deviation')
disp(mean(ts2.data(101:end,1)))
disp(sqrt(var(ts2.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=2, sparse tree) % deviation')
disp(mean(100*(ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts2.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=2, sparse tree)')
disp(mean(ts2.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts2.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts2.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts2.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.algo=0; // Full tree of future innovations
ts2__ = extended_path([], 8001, e_1, options_, M_, oo_);
options_.ep.stochastic.algo=1;

disp('Stochastic extended (order=2, full tree) path mean and standard deviation')
disp(mean(ts2__.data(101:end,1)))
disp(sqrt(var(ts2__.data(101:end,1))))

disp('Accuracy error (stochastic extended path, full tree, order=2) % deviation')
disp(mean(100*(ts2__.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts2__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts2__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts2__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, full tree, order=2)')
disp(mean(ts2__.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts2__.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts2__.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts2__.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts2h = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Stochastic extended (order=2,hybrid, sparse tree) path mean and standard deviation')
disp(mean(ts2h.data(101:end,1)))
disp(sqrt(var(ts2h.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=2, hybrid, sparse tree) % deviation')
disp(mean(100*(ts2h.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts2h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts2h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts2h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=2, hybrid, sparse tree)')
disp(mean(ts2h.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts2h.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts2h.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts2h.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 2;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
options_.ep.stochastic.algo = 0;
ts2h__ = extended_path([], 8001, e_1, options_, M_, oo_);
options_.ep.stochastic.algo = 1;

disp('Stochastic extended (order=2,hybrid, full tree) path mean and standard deviation')
disp(mean(ts2h__.data(101:end,1)))
disp(sqrt(var(ts2h__.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=2, hybrid, full tree) % deviation')
disp(mean(100*(ts2h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts2h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts2h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts2h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=2, hybrid, full tree)')
disp(mean(ts2h__.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts2h__.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts2h__.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts2h__.data(2:end,1)-transpose(ytrue)))));



set_dynare_seed(seed);
options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 0;
ts5 = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Stochastic extended (order=5, sparse tree) path mean and standard deviation')
disp(mean(ts5.data(101:end,1)))
disp(sqrt(var(ts5.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=5, sparse tree) % deviation')
disp(mean(100*(ts5.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts5.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts5.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts5.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=5, sparse tree)')
disp(mean(ts5.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts5.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts5.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts5.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts5h = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Stochastic extended (order=5,hybrid, sparse tree) path mean and standard deviation')
disp(mean(ts5h.data(101:end,1)))
disp(sqrt(var(ts5h.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=5, hybrid, sparse tree) % deviation')
disp(mean(100*(ts5h.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts5h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts5h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts5h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=5, hybrid, sparse tree)')
disp(mean(ts5h.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts5h.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts5h.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts5h.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.algo=0;
ts5__ = extended_path([], 8001, e_1, options_, M_, oo_);
options_.ep.stochastic.algo=1;

disp('Stochastic extended (order=5, full tree) path mean and standard deviation')
disp(mean(ts5__.data(101:end,1)))
disp(sqrt(var(ts5__.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=5, full tree) % deviation')
disp(mean(100*(ts5__.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts5__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts5__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts5__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=5, full tree)')
disp(mean(ts5__.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts5__.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts5__.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts5__.data(2:end,1)-transpose(ytrue)))));




set_dynare_seed(seed);
options_.ep.stochastic.order = 5;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_ordre=2;
options_.ep.stochastic.algo=0;
ts5h__ = extended_path([], 8001, e_1, options_, M_, oo_);
options_.ep.stochastic.algo=1;

disp('Stochastic extended (order=5, hybrid, full tree) path mean and standard deviation')
disp(mean(ts5h__.data(101:end,1)))
disp(sqrt(var(ts5h__.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=5, hybrid, full tree) % deviation')
disp(mean(100*(ts5h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts5h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts5h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts5h__.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=5, hybrid, full tree)')
disp(mean(ts5h__.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts5h__.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts5h__.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts5h__.data(2:end,1)-transpose(ytrue)))));



set_dynare_seed(seed);
options_.ep.stochastic.order = 10;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 0;
ts10 = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Stochastic extended (order=10, sparse tree) path mean and standard deviation')
disp(mean(ts10.data(101:end,1)))
disp(sqrt(var(ts10.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=10, sparse tree) % deviation')
disp(mean(100*(ts10.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts10.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts10.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts10.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=10, sparse tree)')
disp(mean(ts10.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts10.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts10.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts10.data(2:end,1)-transpose(ytrue)))));



set_dynare_seed(seed);
options_.ep.stochastic.order = 10;
options_.ep.stochastic.IntegrationAlgorithm='Tensor-Gaussian-Quadrature';//'Unscented'; //'Tensor-Gaussian-Quadrature';
options_.ep.stochastic.quadrature.nodes = 3;
options_.ep.stochastic.hybrid_order = 2;
ts10h = extended_path([], 8001, e_1, options_, M_, oo_);

disp('Stochastic extended (order=10,hybrid, sparse tree) path mean and standard deviation')
disp(mean(ts10h.data(101:end,1)))
disp(sqrt(var(ts10h.data(101:end,1))))

disp('Accuracy error (stochastic extended path, order=10, hybrid, sparse tree) % deviation')
disp(mean(100*(ts10h.data(2:end,1)-transpose(ytrue))./transpose(ytrue)));
disp(mean(100*abs((ts10h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(min(100*abs((ts10h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));
disp(max(100*abs((ts10h.data(2:end,1)-transpose(ytrue))./transpose(ytrue))));

disp('Accuracy error (stochastic extended path, order=10, hybrid, sparse tree)')
disp(mean(ts10h.data(2:end,1)-transpose(ytrue)));
disp(mean(abs((ts10h.data(2:end,1)-transpose(ytrue)))));
disp(min(abs((ts10h.data(2:end,1)-transpose(ytrue)))));
disp(max(abs((ts10h.data(2:end,1)-transpose(ytrue)))));
