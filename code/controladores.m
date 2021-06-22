%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTORES: Javier Lopez Iniesta Diaz del Campo & Fernando Garcia Gutierrez
% FECHA: 23 de Mayo de 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Diferencias entre los diferentes controladores, desde el punto de vista
% de de señales de referencia monomicas y el comportamiento de regimen transitorio

%% Valor constantes
close all
clear
warning("off")
clc
s = tf("s");
K = 2652.28;
p = 64.986;
G = K/(s*(s + p));

%% Controlador Proporcional (P)
close all
Kp = [5 10 20];
Kplength = length(Kp);

for i = 1:Kplength
    Gc = Kp(i);
    H{i} = feedback(G*Gc,1);
    He{i} = 1 - H{i};
    valores{i} = strcat("$$K_{p}=", num2str(Kp(i)), "$$");
end 

ejes = [0 0.2 0 1.8 0 0.2 -0.8 1; % Escalon
        0 0.1 0 0.1 0 0.25 -0.001 0.01; % Rampa
        0 0.08 0 0.0064 0 5 0 0.05]; % Parabola

parametro = "-";    
controlador = " Controlador P";
texto = "";
analisis(H, He, controlador, valores, ejes, parametro, texto);

%% Controlador Proporcional Derivativo (PD)
close all
Kp = 10;
tau_d = [0.001 0.01 0.05];
tau_dlength = length(tau_d);

for i = 1:tau_dlength
%     Gc = Kp*(1+tau_d(i)*s);
%     H{i} = feedback(G*Gc,1);
    num = [Kp*K*tau_d(i) Kp*K];
    den = [1 (p+Kp*K*tau_d(i)) Kp*K];
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_{d}=", num2str(tau_d(i)), "$$");
end 

ejes = [0 0.1 0 1.5 -0.005 0.1 -0.5 1; % Escalon
        0 0.04 0 0.04 -0.01 0.2 0 0.0065; % Rampa
        0 0.05 0 0.002 0 0.4 0 0.002]; % Parabola
    
parametro = "-";
texto = " (K_p = 10)";
controlador = " Controlador PD";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Proporcional-Derivativo (P-D)
close all
Kp = 10;
tau_d = [0.001 0.01 0.05];
tau_dlength = length(tau_d);

for i = 1:tau_dlength
    num = [Kp*K];
    den = [1 (p+Kp*K*tau_d(i)) Kp*K];
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_{d}=", num2str(tau_d(i)), "$$");
end 

ejes = [0 0.2 0 1.5 -0.001 0.2 -0.42 1.1; % Escalon
        0 0.2 0 0.2 0 0.2 0 0.1; % Rampa
        0 0.05 0 0.002 0 0.1 0 0.004]; % Parabola
    
parametro = "-";
texto = " (K_p = 10)";
controlador = " Controlador P-D";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Proporcional Integral (PI)
close all
Kp = 10;
tau_i= [0.1 0.5 5];
tau_ilength = length(tau_i);

for i = 1:tau_ilength
    Gc = Kp*(1+(1/(tau_i(i)*s)));
    H{i} = feedback(G*Gc,1);
%     num = [Kp*K*tau_d1 Kp*K ((Kp*K)/tau_i)];
%     den = [1 (p+(Kp*K*(tau_d1+tau_d2(i)))) Kp*K ((Kp*K)/tau_i)];
%     H{i} = tf(num,den);    
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_{I}=", num2str(tau_i(i)), "$$");
end 

ejes = [0 0.15 0 1.7 0 0.15 -0.7 1.1; % Escalon
        0 0.1 0 0.1 0 15 0 0.008; % Rampa
        0 0.01 0 0.00002 0 0.02 0 0.0002]; % Parabola
    
parametro = "-";
texto = " (K_p = 10)";
controlador = " Controlador PI";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Proporcional Integral Derivativo (PID) (variando tau_d)
close all
Kp = 10;
tau_i = 0.1;
tau_d= [0.01 0.02 0.05];
tau_dlength = length(tau_d);

for i = 1:tau_dlength
%     Gc = Kp*(1+ (tau_d(i)*s) + (1/(tau_i*s)));
%     H{i} = feedback(G*Gc,1);

    num = [Kp*K*tau_d(i) Kp*K ((Kp*K)/tau_i)];
    den = [1 (p+Kp*K*tau_d(i)) Kp*K ((Kp*K)/tau_i)];    
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_D=", num2str(tau_d(i)), "$$");
end 

ejes = [0 0.06 0 1.2 0 0.06 -0.2 1.1; % Escalon
        0 0.03 0 0.03 -0.1 1 -0.0005 0.0035; % Rampa
        0 0.008 0 0.00002 0 1.5 0 0.0006]; % Parabola
   
parametro = "tau_d";
texto = " (K_p = 10; \tau_I = 0,1)";
controlador = " Controlador PID";
analisis(H, He, controlador, valores, ejes, parametro, texto);  

%% %% Controlador Proporcional Integral Derivativo (PID) (variando tau_i)
close all
clear tau_i
clear tau_d
Kp = 10;
tau_i= [0.1 0.5 5];
tau_d = 0.02;
tau_ilength = length(tau_i);

for i = 1:tau_ilength
%     Gc = Kp*(1+ (tau_d(i)*s) + (1/(tau_i*s)));
%     H{i} = feedback(G*Gc,1);
    num = [Kp*K*tau_d Kp*K ((Kp*K)/tau_i(i))];
    den = [1 (p+Kp*K*tau_d) Kp*K ((Kp*K)/tau_i(i))];    
    H{i} = tf(num,den);    
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_{I}=", num2str(tau_i(i)), "$$");
end 

ejes = [0 0.015 0 1.2 0 0.015 -0.1 1.1; % Escalon
        0 0.02 0 0.02 -1 10 -0.0005 0.003; % Rampa
        0 0.008 0 0.00002 0 15 0 0.025]; % Parabola
  
parametro = "tau_i";
texto = " (K_p = 10, \tau_D = 0,02)";
controlador = " Controlador PID";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Proporcional Integral-Derivativo (PI-D) (tau_d)
close all
Kp = 10;
tau_i = 0.1;
tau_d = [0.01 0.02 0.05];
tau_dlength = length(tau_d);

for i = 1:tau_dlength
    num = [Kp*K ((Kp*K)/tau_i)];
    den = [1 (p+Kp*K*tau_d(i)) Kp*K ((Kp*K)/tau_i)];
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_{D}=", num2str(tau_d(i)), "$$");
end 

ejes = [0 0.5 0 1.4 0 0.5 -0.3 1.1; % Escalon
        0 0.3 0 0.3 0 0.6 -0.01 0.05; % Rampa
        0 0.35 0 0.1 0 0.4 0 0.015]; % Parabola

parametro = "tau_d";
texto = " (K_p = 10; \tau_I = 0,1)";
controlador = " Controlador PI-D";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Proporcional Integral-Derivativo (PI-D) (tau_i)
close all
Kp = 10;
tau_i= [0.1 0.5 5];
tau_d = 0.02;
tau_ilength = length(tau_i);

for i = 1:tau_ilength
    num = [Kp*K ((Kp*K)/tau_i(i))];
    den = [1 (p+Kp*K*tau_d) Kp*K ((Kp*K)/tau_i(i))];
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    valores{i} = strcat("$$\tau_{I}=", num2str(tau_i(i)), "$$");
end 

ejes = [0 0.6 0.6 1.2 -0.02 0.6 -0.2 1.1; % Escalon
        0 0.2 0 0.2 -1 15 -0.002 0.03; % Rampa
        0 0.4 0 0.14 0 20 0 0.3]; % Parabola 

parametro = "tau_i";
texto = " (K_p = 10, \tau_D = 0,02)";
controlador = " Controlador PI-D";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Proporcional Integral Derivativo-Derivativo (PID-D)
close all
Kp = 10;
tau_i = 0.8;
tau_d1 = 0.01;
tau_d2 = [0.01 0.05 (-p/(K*Kp))];
tau_dlength = length(tau_d2);

for i = 1:tau_dlength
    num = [Kp*K*tau_d1 Kp*K ((Kp*K)/tau_i)];
    den = [1 (p+(Kp*K*(tau_d1+tau_d2(i)))) Kp*K ((Kp*K)/tau_i)];
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    if (i==3) 
       valores{i} = strcat("$$\tau_{D2}=-\frac{p}{K \cdot K_p}$$"); 
    else
       valores{i} = strcat("$$\tau_{D2}=", num2str(tau_d2(i)), "$$");
    end
end 

ejes = [0 0.2 0 1.4 0 0.2 -0.4 1.2; % Escalon
        0 0.5 0 0.5 0 3 -0.005 0.05; % Rampa
        0 0.2 0 0.03 0 3 0 0.1]; % Parabola
    
parametro = "-";
texto = " (K_p = 10; \tau_I = 0,8; \tau_{D1} = 0,01)";
controlador = " Controlador PID-D";
analisis(H, He, controlador, valores, ejes, parametro, texto); 

%% Controlador Derivativo|Proporcional Integral Derivativo (D|PID)
close all
Kp = 10;
tau_i = 0.8;
tau_d1 = 0.01;
tau_d2 = [0.01 0.05 (p/(K*Kp))];
tau_dlength = length(tau_d2);

for i = 1:tau_dlength
    num = [(Kp*K*(tau_d1+tau_d2(i))) Kp*K ((Kp*K)/tau_i)];
    den = [1 (p+(Kp*K*tau_d1)) Kp*K ((Kp*K)/tau_i)];
    H{i} = tf(num,den);
    He{i} = 1 - H{i};
    if (i==3) 
       valores{i} = strcat("$$\tau_{D2}=\frac{p}{K \cdot K_p}$$"); 
    else
       valores{i} = strcat("$$\tau_{D2}=", num2str(tau_d2(i)), "$$");
    end
end 

ejes = [0 0.081 0 4 0 0.081 -3 1; % Escalon
        0 0.5 0 0.5 0 3 -0.05 0.01; % Rampa
        0 0.2 0 0.03 0 4 -0.1 0.05]; % Parabola
    
parametro = "-";
texto = " (K_p = 10; \tau_I = 0,8; \tau_{D1} = 0,01)";
controlador = " Controlador D|PID";
analisis(H, He, controlador, valores, ejes, parametro, texto); 