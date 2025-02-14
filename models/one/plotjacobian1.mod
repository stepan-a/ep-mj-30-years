var y;

varexo e;

parameters a;

model;

  y = .1*y(-1) - .5*y(1) + a + e; 
  
end;

a = 1;

steady_state_model;

  y = a/(1-.1+.5);
  
end;

steady;

check;

shocks;
  var e = 1;
end;

close all

options_.ep.periods = 50;
options_.ep.stack_solve_algo = 7;
options_.ep.stack_solve_algo = 0;
options_.ep.stochastic.algo = 1;
options_.ep.stochastic.order = 1;
options_.ep.stochastic.quadrature.nodes=3;

options_.ep.stochastic.order = 2;
ts1 = extended_path(oo_.steady_state, 1, 0, options_, M_, oo_);
system('mv Jacobian.mat Jacobian-2_1.mat');

load('Jacobian-2_1')
figure(1)
spy(A(1:20,1:20),'sb',15)
xlim([0 21])
xticks([1:20])
xticklabels({'y_t','y_{t+1}^1','y_{t+1}^2','y_{t+3}^3','y_{t+2}^{1,1}','y_{t+2}^2','y_{t+2}^3','y_{1,t+2}^{1,2}','y_{t+2}^{1,3}','y_{t+3}^{1,1}','y_{t+3}^2','y_{t+3}^3','y_{t+3}^{1,2}', 'y_{t+3}^{1,3}','y_{t+4}^{1,1}','y_{t+4}^2','y_{t+4}^3','y_{t+4}^{1,2}', 'y_{t+4}^{1,3}', 'y_{t+5}^{1,1}'})
ylim([0 21])
yticks([1:20])
yticklabels({'t','1,t+1','2,t+1','3,t+1','1,1,t+2','2,t+2','3,t+2','1,2,t+2','1,3,t+2','1,1,t+3','2,t+3','3,t+3','1,2,t+3','1,3,t+3','1,1,t+4','2,t+4','3,t+4','1,2,t+4','1,3,t+4','1,1,t+5'})
hold off
xlabel('')
box on
grid on
print -depsc2 jacobian-sparse-tree-2.eps
matlab2tikz('jacobian-sparse-tree-2.tikz')
