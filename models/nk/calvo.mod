@#ifndef WITH_MEAN_PRESERVING_SPREAD_CORRECTION
  @#define WITH_MEAN_PRESERVING_SPREAD_CORRECTION = false
@#endif

@#ifdef WITH_TAYLOR_RULE
  @#ifdef WITH_RAMSEY_POLICY
    @#if WITH_TAYLOR_RULE && WITH_RAMSEY_POLICY
      @#error "WITH_TAYLOR_RULE and WITH_RAMSEY_POLICY must have different boolean values"
    @#endif
  @#endif
@#endif

@#ifndef WITH_TAYLOR_RULE
  @#ifndef WITH_RAMSEY_POLICY
    @#define WITH_TAYLOR_RULE = true
    @#define WITH_RAMSEY_POLICY = false
  @#else
    @#if WITH_RAMSEY_POLICY
      @#define WITH_TAYLOR_RULE = false
    @#endif
@#endif
@#else
  @#if WITH_TAYLOR_RULE
    @#ifndef WITH_RAMSEY_POLICY
      @#define WITH_RAMSEY_POLICY = false
    @#endif
  @#endif
@#endif

@#ifndef WITH_ZLB
  @#define WITH_ZLB = false
@#endif


var Efficiency RiskPremium a b 
    Dist Theta 
    Consumption Lambda RealWage Inflation NominalInterestRate Output RelativePrice Hours 
    Z1 Z2 Z3 
    Exp1 Exp2 Exp3 Exp4 ;

varexo ea eb ;

parameters SIGMAC XIH ETA BETA NU PSI EPSILON RHOA RHOB GAMMAPI PHI ;

parameters sa sb; // Size of the structural innovations

// CALIBRATION:
SIGMAC = 1.5;
ETA = 2;
BETA = 0.997;
NU = 0.75;
PSI = -.1;
EPSILON = 6;
PHI = EPSILON*(1+PSI)/(EPSILON*(1+PSI)-1);
RHOA = .98;
RHOB = .2;
GAMMAPI = 1.2;
XIH = 0; // This parameter will be updated in the steady state file.

sa = sqrt(.00002);
sb = sqrt(.00001);

/*
** Update the value of the Calvo probability if PSI is not equal to -.1.
*/

slope = 0.075074404761905; // from (EPSILON-1)/(EPSILON*(1-PSI)-1)*(1-NU)*(1-BETA*NU)/NU; with NU=.75 and PSI=-.1 (formula is obtained by linearizing the Phillips curve).
gamma = slope*(EPSILON*(1-PSI)-1)/(EPSILON-1);
discr = ((1+gamma+BETA)/BETA)^2-4/BETA;
NU    = .5*((1+gamma+BETA)/BETA-sqrt(discr));


model;

  @#if WITH_MEAN_PRESERVING_SPREAD_CORRECTION
  [dynamic, type = 'Definition of the exogenous state variables'] Efficiency - STEADY_STATE(Efficiency)*exp(a-.5*sa*sa/(1-RHOA*RHOA));
  [static, type = 'Definition of the exogenous state variables'] Efficiency - exp(a);
  @#else
    [type = 'Definition of the exogenous state variables']
    Efficiency - STEADY_STATE(Efficiency)*exp(a);
  @#endif

  @#if WITH_MEAN_PRESERVING_SPREAD_CORRECTION
    [dynamic, type = 'Definition of the exogenous state variables'] RiskPremium - STEADY_STATE(RiskPremium)*exp(b-.5*sb*sb/(1-RHOB*RHOB));
    [static, type = 'Definition of the exogenous state variables'] RiskPremium - exp(b);
  @#else
    [type = 'Definition of the exogenous state variables']
    RiskPremium - STEADY_STATE(RiskPremium)*exp(b);
  @#endif

  [type = 'Definition of the exogenous state variables']
  a - RHOA*a(-1) - sa*ea ;

  [type = 'Definition of the exogenous state variables']
  b - RHOB*b(-1) - sb*eb ;

  [type = 'Definition of the non predetermined variables']
  Lambda - 1*Consumption^(-SIGMAC);

  [type = 'Definition of the non predetermined variables']
  Hours^ETA*XIH + Lambda*RealWage;

  [type = 'Euler equations']
  BETA*RiskPremium*Exp1(+1) - Lambda/NominalInterestRate;

  [type = 'Euler equations']
  Z1 - Output*RealWage/Efficiency*Theta^(-PHI) - BETA*NU*Exp2(+1)/Lambda;

  [type = 'Euler equations']
  Z2 - Output*Theta^(-PHI) - BETA*NU*Exp3(+1)/Lambda;

  [type = 'Euler equations']
  Z3 - Output - BETA*NU*Exp4(+1)/Lambda;

  [type = 'Definition of the non predetermined variables']
  Z2/((1+PSI)*(1-PHI))*RelativePrice^(PHI/(1-PHI))+Z3*PSI/(1+PSI)+Z1*PHI/((1+PSI)*(PHI-1))*RelativePrice^(PHI/(1-PHI)-1);      

  [type = 'Definition of the endogenous state variables']
  NU*Theta(-1)*(STEADY_STATE(Inflation)/Inflation)^(1/(1-PHI))+(1-NU)*RelativePrice^(1/(1-PHI)) - Theta;

  [type = 'Definition of the non predetermined variables']
  Theta^(1-PHI)-PSI-1 + PSI*RelativePrice*(1-NU) + STEADY_STATE(Inflation)/Inflation*NU*(1+PSI-Theta(-1)^(1-PHI));

  [type = 'Definition of the non predetermined variables']
  (Output*(PSI + Dist/Theta^PHI))/(PSI + 1) - Efficiency*Hours;

  [type = 'Definition of the non predetermined variables']
  Consumption - Output;

  @#if WITH_TAYLOR_RULE
    [type = 'Taylor']
    @#if WITH_ZLB
      NominalInterestRate-max(1.0,STEADY_STATE(NominalInterestRate)*(Inflation/STEADY_STATE(Inflation))^GAMMAPI);
    @#else
      NominalInterestRate-STEADY_STATE(NominalInterestRate)*(Inflation/STEADY_STATE(Inflation))^GAMMAPI;
    @#endif
  @#endif

  [type = 'Definition of the endogenous state variables']
  (Dist(-1)*NU)/(STEADY_STATE(Inflation)/Inflation)^(PHI/(PHI - 1)) - (NU - 1)/RelativePrice^(PHI/(PHI - 1)) - Dist;

  [type = 'Definition of the auxiliary forward variables']
  Exp1 - Lambda/Inflation;

  [type = 'Definition of the auxiliary forward variables']
  Exp2 - (Lambda*Z1)/(STEADY_STATE(Inflation)/Inflation)^(PHI/(PHI - 1));

  [type = 'Definition of the auxiliary forward variables']
  Exp3 - (Lambda*Z2)/(STEADY_STATE(Inflation)/Inflation)^(1/(PHI - 1));

  [type = 'Definition of the auxiliary forward variables']
  Exp4 - (STEADY_STATE(Inflation)*Lambda*Z3)/Inflation;

end;

steady_state_model;

  Efficiency = 1;
  RiskPremium = 1;
  Inflation = 1+.5330/100; //(1.02)^(1/4);
  Hours = 0.33333;

  Theta = 1;
  Dist = 1;
  RelativePrice = 1;
  NominalInterestRate = Inflation/BETA;
  RealWage = (Efficiency*(EPSILON - 1))/EPSILON;
  XIH = -RealWage/(Hours^ETA*(Efficiency*Hours)^SIGMAC);
  Output = Efficiency*Hours;
  Consumption = Output;
  Lambda = 1/Consumption^SIGMAC;
  Z1 = -(Output*RealWage)/(Efficiency*(BETA*NU - 1));
  Z2 = -Output/(BETA*NU - 1);
  Z3 = -Output/(BETA*NU - 1);
  Exp1 = Lambda/Inflation;
  Exp2 = -(Lambda*Output*RealWage)/(Efficiency*(BETA*NU - 1));
  Exp3 = -(Lambda*Output)/(BETA*NU - 1);
  Exp4 = -(Lambda*Output)/(BETA*NU - 1);

  a = 0;
  b = 0;

end;

@#if WITH_RAMSEY_POLICY
  planner_objective Consumption^(1-SIGMAC)/(1-SIGMAC) - XIH*Hours^(1+ETA)/(1+ETA) ;
  ramsey_model(planner_discount=BETA, instruments=(NominalInterestRate));
  @#if WITH_ZLB
    ramsey_constraints;
      NominalInterestRate > 1;
    end;
  @#endif
@#endif



/*
** To reproduce the variances of output growth inflation and interest rate we need V(ea) = 0.00002 and V(eb) = 0.00001
** if we consider a first order approximation of the model.
**
** The non linear simulation (with EP approach) almost equal variance for these variables.
**/
shocks;
  var ea = 1; //.0002; // .00002;  
  var eb = 1; // .0001; // .00001;
end;

steady;


options_.ep.stochastic.IntegrationAlgorithm = 'Tensor-Gaussian-Quadrature';
% options_.ep.stochastic.IntegrationAlgorithm = 'Unscented';
options_.ep.stochastic.quadrature.nodes = 3;

options_.ep.stack_solve_algo = 7;
options_.ep.solve_algo = 10; // Use PATH nonlinear mixed complementarity problem solver (must be installed by the user, see https://pages.cs.wisc.edu/~ferris/path.html),
                             // an alternative is solve_algo=10 (lmmcp) but the algorithm is slower and fails much more often.
options_.ep.stochastic.algo = 1;

//set_dynare_seed(0);%'default')
options_.ep.stochastic.order = 1;
ts0 = extended_path(oo_.steady_state, 200, [], options_, M_, oo_);

%set_dynare_seed(0);%'default')
%options_.ep.stochastic.order = 1;
%ts1 = extended_path(oo_.steady_state, 100, [], options_, M_, oo_);
