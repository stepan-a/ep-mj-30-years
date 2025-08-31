ts0_nozlb = dseries('euler-007-sep-0-algo-1-hybrid-0.nozlb.mat');
ts1_nozlb = dseries('euler-007-sep-1-algo-1-hybrid-0.nozlb.mat');
ts2_nozlb = dseries('euler-007-sep-2-algo-1-hybrid-0.nozlb.mat');
ts2_full_nozlb = dseries('euler-007-sep-2-algo-0-hybrid-0.nozlb.mat');

skipline(2)
dprintf('NO-ZLB, Without pertubation based correction')
skipline()
dprintf('average error: %f', mean(log10(abs(ts0_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts1_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_full_nozlb.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('max error: %f', max(log10(abs(ts0_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts1_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_full_nozlb.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('min error: %f', min(log10(abs(ts0_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts1_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_full_nozlb.EulerErrors_c.data(2:end))/100)))

figure(1)
plot(ts0_nozlb.Investment.data(2:end), log10(abs(ts0_nozlb.EulerErrors_c.data(2:end)/100)), '.k')
hold on
plot(ts1_nozlb.Investment.data(2:end), log10(abs(ts1_nozlb.EulerErrors_c.data(2:end)/100)), '.b')
plot(ts2_nozlb.Investment.data(2:end), log10(abs(ts2_nozlb.EulerErrors_c.data(2:end)/100)), '.g')
plot(ts2_full_nozlb.Investment.data(2:end), log10(abs(ts2_full_nozlb.EulerErrors_c.data(2:end)/100)), '.r')
hold off
axis tight
box on

print -depsc2 rbcii_euler_nozlb.eps
!epstopdf rbcii_euler_nozlb.eps
matlab2tikz( 'rbcii_euler_nozlb.tikz' );


ts1_nozlb_hybrid = dseries('euler-007-sep-1-algo-1-hybrid-4.nozlb.mat');
ts2_nozlb_hybrid = dseries('euler-007-sep-2-algo-1-hybrid-4.nozlb.mat');
ts2_full_nozlb_hybrid = dseries('euler-007-sep-2-algo-0-hybrid-4.nozlb.mat');

skipline(2)
dprintf('NO-ZLB, Hybrid(4)')
skipline()
dprintf('average error: %f', mean(log10(abs(ts0_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts1_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_full_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('max error: %f', max(log10(abs(ts0_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts1_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_full_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('min error: %f', min(log10(abs(ts0_nozlb.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts1_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_full_nozlb_hybrid.EulerErrors_c.data(2:end))/100)))

figure(2)
plot(ts0_nozlb.Investment.data(2:end), log10(abs(ts0_nozlb.EulerErrors_c.data(2:end)/100)), '.k')
hold on
plot(ts1_nozlb_hybrid.Investment.data(2:end), log10(abs(ts1_nozlb_hybrid.EulerErrors_c.data(2:end)/100)), '.b')
plot(ts2_nozlb_hybrid.Investment.data(2:end), log10(abs(ts2_nozlb_hybrid.EulerErrors_c.data(2:end)/100)), '.g')
plot(ts2_full_nozlb_hybrid.Investment.data(2:end), log10(abs(ts2_full_nozlb_hybrid.EulerErrors_c.data(2:end)/100)), '.r')
hold off
axis tight
box on

print -depsc2 rbcii_euler_nozlb_hybrid.eps
!epstopdf rbcii_euler_nozlb_hybrid.eps
matlab2tikz( 'rbcii_euler_nozlb_hybrid.tikz' );


ts0 = dseries('euler-007-sep-0-algo-1-hybrid-0.mat');
ts1 = dseries('euler-007-sep-1-algo-1-hybrid-0.mat');
ts2 = dseries('euler-007-sep-2-algo-1-hybrid-0.mat');
ts2_full = dseries('euler-007-sep-2-algo-0-hybrid-0.mat');

skipline(2)
dprintf('ZLB, Without pertubation based correction')
skipline()
dprintf('average error: %f', mean(log10(abs(ts0.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts1.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_full.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('max error: %f', max(log10(abs(ts0.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts1.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_full.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('min error: %f', min(log10(abs(ts0.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts1.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_full.EulerErrors_c.data(2:end))/100)))

figure(3)
plot(ts0.Investment.data(2:end), log10(abs(ts0.EulerErrors_c.data(2:end)/100)), '.k')
hold on
plot(ts1.Investment.data(2:end), log10(abs(ts1.EulerErrors_c.data(2:end)/100)), '.b')
plot(ts2.Investment.data(2:end), log10(abs(ts2.EulerErrors_c.data(2:end)/100)), '.g')
plot(ts2_full.Investment.data(2:end), log10(abs(ts2_full.EulerErrors_c.data(2:end)/100)), '.r')
hold off
axis tight
box on

print -depsc2 rbcii_euler.eps
!epstopdf rbcii_euler.eps
matlab2tikz( 'rbcii_euler.tikz' );


ts1_hybrid = dseries('euler-007-sep-1-algo-1-hybrid-4.mat');
ts2_hybrid = dseries('euler-007-sep-2-algo-1-hybrid-4.mat');
ts2_full_hybrid = dseries('euler-007-sep-2-algo-0-hybrid-4.mat');

skipline(2)
dprintf('ZLB, Without pertubation based correction')
skipline()
dprintf('average error: %f', mean(log10(abs(ts0.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts1_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('average error: %f', mean(log10(abs(ts2_full_hybrid.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('max error: %f', max(log10(abs(ts0.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts1_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('max error: %f', max(log10(abs(ts2_full_hybrid.EulerErrors_c.data(2:end))/100)))
skipline()
dprintf('min error: %f', min(log10(abs(ts0.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts1_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_hybrid.EulerErrors_c.data(2:end))/100)))
dprintf('min error: %f', min(log10(abs(ts2_full_hybrid.EulerErrors_c.data(2:end))/100)))

figure(4)
plot(ts0.Investment.data(2:end), log10(abs(ts0.EulerErrors_c.data(2:end)/100)), '.k')
hold on
plot(ts1_hybrid.Investment.data(2:end), log10(abs(ts1_hybrid.EulerErrors_c.data(2:end)/100)), '.b')
plot(ts2_hybrid.Investment.data(2:end), log10(abs(ts2_hybrid.EulerErrors_c.data(2:end)/100)), '.g')
plot(ts2_full_hybrid.Investment.data(2:end), log10(abs(ts2_full_hybrid.EulerErrors_c.data(2:end)/100)), '.r')
hold off
axis tight
box on

print -depsc2 rbcii_euler_hybrid.eps
!epstopdf rbcii_euler_hybrid.eps
matlab2tikz( 'rbcii_euler_hybrid.tikz' );
