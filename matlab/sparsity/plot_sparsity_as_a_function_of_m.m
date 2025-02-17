set(groot,'defaultAxesTickLabelInterpreter','latex');

maxnodesnumber = 111;

%
% SEP(2)
%

p = 2;
H = 200;
m = 3:2:51;
n = 1;

s = NaN(length(m),1);
N = NaN(length(m),1);

for i=1:length(m)
    [s(i), N(i)] = sparsity(m(i), p, H, n);
end

figure(1)

tiledlayout(2,2)

nexttile
plot(m(1:21),s(1:21),'+-b','linewidth',2)
ylabel('\% of \textrm{nnz}','Interpreter','latex')
xlabel('Number of nodes','Interpreter','latex')
axis tight
box on

nexttile
plot(m,log10(N),'+-b','linewidth',2)
ylabel('$\log_{10} \#(J)$','Interpreter','latex')
xlabel('Number of nodes','Interpreter','latex')
axis tight
box on

nexttile([1,2])
plot(m,log10(s.*N/100),'+-b','linewidth',2)
ylabel('$\log_{10} \mathrm{nnz}(J)$','Interpreter','latex')
xlabel('Number of nodes','Interpreter','latex')
axis tight
box on

matlab2tikz('../../tex/plots/sparse-stacked-jacobian-sep-2.tikz')

%
% SEP(2)
%

p = 10;
H = 200;
m = 3:2:51;
n = 1;

s = NaN(length(m),1);
N = NaN(length(m),1);

for i=1:length(m)
    [s(i), N(i)] = sparsity(m(i), p, H, n);
end

figure(2)

tiledlayout(2,2)

nexttile
plot(m(1:21),s(1:21),'+-b','linewidth',2)
ylabel('\% of \textrm{nnz}','Interpreter','latex')
xlabel('Number of nodes','Interpreter','latex')
axis tight
box on

nexttile
plot(m,log10(N),'+-b','linewidth',2)
ylabel('$\log_{10} \#(J)$','Interpreter','latex')
xlabel('Number of nodes','Interpreter','latex')
axis tight
box on

nexttile([1,2])
plot(m,log10(s.*N/100),'+-b','linewidth',2)
ylabel('$\log_{10} \mathrm{nnz}(J)$','Interpreter','latex')
xlabel('Number of nodes','Interpreter','latex')
axis tight
box on

matlab2tikz('../../tex/plots/sparse-stacked-jacobian-sep-10.tikz')
