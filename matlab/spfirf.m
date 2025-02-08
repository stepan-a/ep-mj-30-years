function spfirf(tt, ts, id)

T = 40;

figure(id)
tiledlayout(3,2)

nexttile
plot(pdss(tt.Output.data(1:T)), '-b','linewidth', 2)
hold on
plot(pdss(ts.Output.data(1:T)), '--r','linewidth', 1.5);
title('Output')
hold off
axis tight
box on

nexttile
plot(pdss(tt.Consumption.data(1:T)), '-b','linewidth', 2)
hold on
plot(pdss(ts.Consumption.data(1:T)), '--r','linewidth', 1.5);
title('Consumption')
hold off
axis tight
box on

nexttile
plot(pdss(tt.Labour.data(1:T)), '-b','linewidth', 2)
hold on
plot(pdss(ts.Labour.data(1:T)), '--r','linewidth', 1.5);
title('Labour')
hold off
axis tight
box on

nexttile
plot(pdss(tt.Capital.data(1:T)), '-b','linewidth', 2)
hold on
plot(pdss(ts.Capital.data(1:T)), '--r','linewidth', 1.5);
title('Capital')
hold off
axis tight
box on

nexttile([1 2])
plot(pdss(tt.Investment.data(1:T)), '-b','linewidth', 2)
hold on
plot(pdss(ts.Investment.data(1:T)), '--r','linewidth', 1.5);
title('Investment')
hold off
axis tight
box on
