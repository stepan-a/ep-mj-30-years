function y=exact_solution(M,oo,n)
    beta = M.params(1);
    theta = M.params(2);
    rho = M.params(3);
    xbar = M.params(4);
    sigma2 = M.Sigma_e;

    if beta*exp(theta*xbar+.5*theta^2*sigma2/(1-rho)^2)>1-eps
        disp('The model doesn''t have a solution!')
        return
    end

    i = 1:n;
    a = theta*xbar*i+(theta^2*sigma2)/(2*(1-rho)^2)*(i-2*rho*(1-rho.^i)/(1-rho)+rho^2*(1-rho.^(2*i))/(1-rho^2));
    b = theta*rho*(1-rho.^i)/(1-rho);

    x = oo.endo_simul(2,:);
    xhat = x-xbar;

    n2 = size(x,2);

    y = zeros(1,n2);


    for j=1:n2
        y(j) = sum(beta.^i.*exp(a+b*xhat(j)));
    end

    E = sum(beta.^i.*exp(a).*exp(.5*b.^2*sigma2/(1-rho^2)));

    skipline()
    dprintf('deterministic stead state:        %.9f', sum(beta.^i.*exp(theta*xbar*i)))
    dprintf('stochastic steady state:          %.9f', sum(beta.^i.*exp(a)))
    dprintf('unconditional expectation:        %.9f', E)
    skipline()
    disp('Share of accounted for unconditional expectation:')
    skipline()
    E0 = sep_unconditional_expectation(beta, theta, rho, xbar, 0, n, 0);
    dprintf('Gap between SEP(0) and exact solution (for the unconditional expectation, in percentage) %.9f', -100*(E0-E)/E)
    for p=1:300
        Ep = sep_unconditional_expectation(beta, theta, rho, xbar, sigma2, n, p);
        dprintf('Share of the gap closed by SEP(%u) in percentage\t\t %.4f', p, 100-100*(Ep-E)/(E0-E))
    end
    skipline()
end

function E = sep_unconditional_expectation(beta, theta, rho, xbar, sigma2, n, p)

    i = 1:n;
    a = zeros(size(i));
    b = zeros(size(i));

    j=1:p;
    a(j) = theta*xbar*j+(theta^2*sigma2)/(2*(1-rho)^2)*(j-2*rho*(1-rho.^j)/(1-rho)+rho^2*(1-rho.^(2*j))/(1-rho^2));
    b(j) = theta*rho*(1-rho.^j)/(1-rho);

    j=p+1:n;
    a(j) = theta*xbar*j+(theta^2*sigma2)/(2*(1-rho)^2)*(p-2*rho*(rho.^(j-p)-rho.^j)/(1-rho)+rho^2*(rho.^(2*(j-p))-rho.^(2*j))/(1-rho^2));
    b(j) = theta*rho*(1-rho.^j)/(1-rho);

    E = sum(beta.^i.*exp(a).*exp(.5*b.^2*sigma2/(1-rho^2)));
end
