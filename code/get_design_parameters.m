function [Kp,tau_i,tau_d1,tau_d2] = get_design_parameters(p, K, coef_amort, beta, beta2)

    Kp = (p^2*(2*beta+(1/coef_amort^2)))/(beta2^2*K);
    
    tau_d1 = (beta2*(beta+2))/(p*(2*beta+(1/coef_amort^2)));
    
    tau_i = ((beta2*coef_amort^2)*(2*beta+(1/coef_amort^2)))/(beta*p);
    
    tau_d2 = (-p/(K*Kp));
       
end