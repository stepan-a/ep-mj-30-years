function v = variance_of_logged_productivity(rho)
    global M_
    v = M_.Sigma_e(1,1)/(1-rho^2);