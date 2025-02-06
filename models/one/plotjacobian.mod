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


options_.ep.periods = 10;
options_.ep.stack_solve_algo = 0;


ts0 = extended_path(oo_.steady_state, 1, 0, options_, M_, oo_);

load('Jacobian-0')
figure(1)

spy(A,'sb',15)
xticks([1:10])
xticklabels({'y_t','y_{t+1}','y_{t+2}','y_{t+3}','y_{t+4}','y_{t+5}','y_{t+6}','y_{t+7}','y_{t+8}','y_{t+9}'})
yticks([1:10])
yticklabels({'t','t+1','t+2','t+3','t+4','t+5','t+6','t+7','t+8','t+9'})
xlabel('')
box on
grid on
print -depsc2 jacobian-0.eps
matlab2tikz('jacobian-0.tikz')


options_.ep.stochastic.algo = 0;
options_.ep.stochastic.quadrature.nodes=3;

options_.ep.stochastic.order = 1;
ts1 = extended_path(oo_.steady_state, 1, 0, options_, M_, oo_);
system('mv Jacobian.mat Jacobian-1.mat');

load('Jacobian-1')
figure(2)
spy(A(1:12,1:12),'sb',15)
xlim([0 13])
xticks([1:13])
xticklabels({'y_t','y_{1,t+1}','y_{2,t+1}','y_{3,t+3}','y_{1,t+2}','y_{2,t+2}','y_{3,t+2}','y_{1,t+3}','y_{2,t+3}','y_{3,t+3}','y_{1,t+4}','y_{2,t+4}','y_{3,t+4}'})
ylim([0 13])
yticks([1:13])
yticklabels({'t','1,t+1','2,t+1','3,t+1','1,t+2','2,t+2','3,t+2','1,t+3','2,t+3','3,t+3','1,t+4','2,t+4','3,t+4'})
hold off
xlabel('')
box on
grid on
print -depsc2 jacobian-1.eps
matlab2tikz('jacobian-1.tikz')

options_.ep.stochastic.order = 2;
ts2 = extended_path(oo_.steady_state, 1, 0, options_, M_, oo_);
system('mv Jacobian.mat Jacobian-2.mat');

load('Jacobian-2')
figure(3)
spy(A(1:22,1:22),'sb',15)
xlim([0 23])
xticks([1:22])
xticklabels({'y_t','y_{1,t+1}','y_{2,t+1}','y_{3,t+1}','y_{1,1,t+2}','y_{1,2,t+2}','y_{1,3,t+2}','y_{2,1,t+2}','y_{2,2,t+2}','y_{2,3,t+2}','y_{3,1,t+2}','y_{3,2,t+2}','y_{3,3,t+2}','y_{1,1,t+3}','y_{1,2,t+3}','y_{1,3,t+3}','y_{2,1,t+3}','y_{2,2,t+3}','y_{2,3,t+3}','y_{3,1,t+3}','y_{3,2,t+3}','y_{3,3,t+3}'})
ylim([0 23])
yticks([1:22])
yticklabels({'t','1,t+1','2,t+1','3,t+1','1,1,t+2','1,2,t+2','1,3,t+2','2,1,t+2','2,2,t+2','2,3,t+2','3,1,t+2','3,2,t+2','3,3,t+2','1,1,t+3','1,2,t+3','1,3,t+3','2,1,t+3','2,2,t+3','2,3,t+3','3,1,t+3','3,2,t+3','3,3,t+3'})
hold off
xlabel('')
grid on
box on
print -depsc2 jacobian-2.eps
matlab2tikz('jacobian-2.tikz')
