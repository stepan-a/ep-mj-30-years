function v = variance_of_logged_risk_premium(rho)
    global M_
    v = M_.Sigma_e(2,2)/(1-rho^2);