ts1 = dseries('euler-007-sep-1-algo-1-hybrid-4.mat');
ts2 = dseries('euler-007-sep-2-algo-1-hybrid-4.mat');
ts2 = dseries('euler-007-sep-2-algo-1-hybrid-4.mat');
ts5 = dseries('euler-007-sep-5-algo-1-hybrid-4.mat');
ts0 = dseries('euler-007-sep-0-algo-1-hybrid-0.mat');

istar = 0.241741953339345;

epsilon = .02;

T0 = ts0(ts0.Investment<(0.85+epsilon)*0.241741953339345);
T1 = ts1(ts1.Investment<(0.85+epsilon)*0.241741953339345);
T2 = ts2(ts2.Investment<(0.85+epsilon)*0.241741953339345);
T5 = ts5(ts5.Investment<(0.85+epsilon)*0.241741953339345);

[f0,x0] = kde(log10(abs(T0.EulerErrors_c.data/100)));
[f1,x1] = kde(log10(abs(T1.EulerErrors_c.data/100)));
[f2,x2] = kde(log10(abs(T2.EulerErrors_c.data/100)));
[f5,x5] = kde(log10(abs(T5.EulerErrors_c.data/100)));

plot(x0, f0, '-k', 'linewidth', 2);
hold on
plot(x1, f1, '--k', 'linewidth', 2);
plot(x5, f5, '-ok', 'linewidth', 2);
hold off
axis tight
legend('EP', 'SEP(1+)','SEP(5+)', 'Location', 'northwest')

print -depsc2 rbcii_euler_hybrid_conditional_d.eps
!epstopdf rbcii_euler_hybrid_conditional_d.eps

matlab2tikz( 'rbcii_euler_hybrid_conditional_d.tikz');
