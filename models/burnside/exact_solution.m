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

    skipline()
    dprintf('deterministic stead state: %.9f', sum(beta.^i.*exp(theta*xbar*i)))
    dprintf('stochastic steady state:   %.9f', sum(beta.^i.*exp(a)))
    dprintf('unconditional expectation: %.9f', sum(beta.^i.*exp(a).*exp(.5*b.^2*sigma2/(1-rho^2))))
    skipline()
