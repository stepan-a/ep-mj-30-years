set(groot,'defaultAxesTickLabelInterpreter','latex');

maxorder = 50;

%
% Three quadrature nodes
%

p = transpose(1:maxorder);
H = 200;
m = 3;
n = 1;

s = NaN(maxorder,1);
N = NaN(maxorder,1);

for i=1:maxorder
    [s(i), N(i)] = sparsity(m, p(i), H, n);
end

figure(1)

tiledlayout(2,2)

nexttile
plot(p(1:10),s(1:10),'+-b','linewidth',2)
ylabel('\% of \textrm{nnz}','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile
plot(p,log10(N),'+-b','linewidth',2)
ylabel('$\log_{10} \#(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile([1,2])
plot(p,log10(s.*N/100),'+-b','linewidth',2)
ylabel('$\log_{10} \mathrm{nnz}(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

matlab2tikz('../../tex/plots/sparse-stacked-jacobian-3-nodes.tikz')

%
% Five quadrature nodes
%

p = transpose(1:maxorder);
H = 200;
m = 5;
n = 1;

s = NaN(maxorder,1);
N = NaN(maxorder,1);

for i=1:maxorder
    [s(i), N(i)] = sparsity(m, p(i), H, n);
end

figure(2)

tiledlayout(2,2)

nexttile
plot(p(1:10),s(1:10),'+-b','linewidth',2)
ylabel('\% of \textrm{nnz}','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile
plot(p,log10(N),'+-b','linewidth',2)
ylabel('$\log_{10} \#(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile([1,2])
plot(p,log10(s.*N/100),'+-b','linewidth',2)
ylabel('$\log_{10} \mathrm{nnz}(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

matlab2tikz('../../tex/plots/sparse-stacked-jacobian-5-nodes.tikz')

%
% Seven quadrature nodes
%

p = transpose(1:maxorder);
H = 200;
m = 7;
n = 1;

s = NaN(maxorder,1);
N = NaN(maxorder,1);

for i=1:maxorder
    [s(i), N(i)] = sparsity(m, p(i), H, n);
end

figure(3)

tiledlayout(2,2)

nexttile
plot(p(1:10),s(1:10),'+-b','linewidth',2)
ylabel('\% of \textrm{nnz}','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile
plot(p,log10(N),'+-b','linewidth',2)
ylabel('$\log_{10} \#(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile([1,2])
plot(p,log10(s.*N/100),'+-b','linewidth',2)
ylabel('$\log_{10} \mathrm{nnz}(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

matlab2tikz('../../tex/plots/sparse-stacked-jacobian-7-nodes.tikz')

%
% Eleven quadrature nodes
%

p = transpose(1:maxorder);
H = 200;
m = 11;
n = 1;

s = NaN(maxorder,1);
N = NaN(maxorder,1);

for i=1:maxorder
    [s(i), N(i)] = sparsity(m, p(i), H, n);
end

figure(4)

tiledlayout(2,2)

nexttile
plot(p(1:10),s(1:10),'+-b','linewidth',2)
ylabel('\% of \textrm{nnz}','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile
plot(p,log10(N),'+-b','linewidth',2)
ylabel('$\log_{10} \#(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

nexttile([1,2])
plot(p,log10(s.*N/100),'+-b','linewidth',2)
ylabel('$\log_{10} \mathrm{nnz}(J)$','Interpreter','latex')
xlabel('SEP order','Interpreter','latex')
axis tight
box on

matlab2tikz('../../tex/plots/sparse-stacked-jacobian-11-nodes.tikz')
