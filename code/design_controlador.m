%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTORES: Javier Lopez Iniesta Diaz del Campo & Fernando Garcia Gutierrez
% FECHA: 26 de Mayo de 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% OBTENCIÓN DE LOS PARAMETROS DE DISEÑO DEL CONTROLADOR PID-D

%% Definicion de variables

close all
clear
warning("off")
clc
syms s t;

% Especificaciones
Mpmax = 0.15; %sobreelongacion maxima
Mpmin = 0.08; %sobreelongacion minima
tsmax = 0.5; %tiempo de establecimiento maximo
v = 0.02; %tolerancia
trmax = 0.3; %tiempo de subida maximo

reductora = 23; % 23:1
K = 2652.28 / reductora;
p = 64.986;

ref = 1; % Escalon unidad

carpeta_design ='figuras/design_parameters/';
mkdir(carpeta_design);

%% Mp en funcion de beta

% coef_amort_min = sqrt((log(Mpmax)/pi)^2/(1 +(log(Mpmax)/pi)^2 ));

beta2 = 1;
beta = 0:0.1:30;
beta_length=length(beta);

coef_amort =[0.5 0.707 0.85 1.01];
coef_amort_length=length(coef_amort);

f1 = figure('Name','Mp en función de beta','NumberTitle','off');
sdf(f1);
set(gca, 'FontSize', 11.5);
style.Width = '24';
style.Height = '12';
hgexport(f1,'figures_style',style,'applystyle', true);
hold on

for i = 1:coef_amort_length 
    
    for j = 1:beta_length 
        
        % Parametros
        wn  = p/(beta2*coef_amort(i));
        Q = ((beta(j))^2)-2*beta(j)+1/((coef_amort(i))^2);
        r1 = (coef_amort(i)*wn*(beta(j)*((1/coef_amort(i) ^2)-4)+(2/coef_amort(i)^2)))/Q;
        r2 = (wn^2*((1/coef_amort(i)^2)-2*beta(j)))/Q;
        r3 = ((beta(j)^3)*coef_amort(i)*wn)/Q;
        
        % H -> Funcion de transferencia de lazo cerrado del controlador PID-D
        numerador1 = [r1 r2];
        denominador1 = [1 2*coef_amort(i)*wn wn^2];
        numerador2 = [r3];
        denominador2 = [1 beta(j)*coef_amort(i)*wn];
        H = tf(numerador1, denominador1) + tf(numerador2, denominador2);
        
        % Respuesta al escalon
        [y,t] = step(H);
        [Mp, tp, tr, ts] = parametros(y,t,ref, v);
        
        % Obtencion de la sobreenlogacion para cada beta
        Mp_vector(j)= Mp;
         
        % Calculo de los valores de beta validos
         if ((Mp > Mpmin ) && (Mp  < Mpmax))
             valid_beta(j) = beta(j);
         end
         
    end
        
    % Se calcula el valor y minimo de beta posible
    valid_beta(valid_beta==0)=[];
    beta_min = valid_beta(1);
    beta_max = valid_beta(end);
    clear valid_beta;
    valores_coef_amort_beta(i,:) = [coef_amort(i), beta_min, beta_max];
    
    f1 = plot(beta,Mp_vector,'LineWidth',2);
    
    valores_coef_amort{i} = strcat("$$\zeta=", num2str(coef_amort(i)), "; \, \beta=(",num2str(valores_coef_amort_beta(i, 2)),"," ,num2str(valores_coef_amort_beta(i, 3)), ")$$");

end

ylim([0 0.4]);
xlim([0 30]);

f1 = yline(Mpmax, '--', 'LineWidth', 1, 'color', [(11/255) (134/255) (0/255)]);
f1 = yline(Mpmin, '--', 'LineWidth', 1, 'color', [(159/255) (29/255) (105/255)]);
f1 = legend(valores_coef_amort{1}, valores_coef_amort{2}, valores_coef_amort{3}, valores_coef_amort{4}, '$$M_{p \, max}$$','$$M_{p \, min}$$','Interpreter','latex', 'Location', 'northeast','FontSize',11);
f1 = title('$$ \mathbf{M_p \; de \; y(t) \; con \; PID-D \; a \; la \; entrada \; escal\acute{o}n \; unidad \; (\beta_2 = 1)} $$','Interpreter','latex','FontSize',16);
f1 = xlabel('$$ \mathbf{\beta} $$','Interpreter','latex','FontSize',14);
f1 = ylabel('$$ \mathbf{M_p} $$','Interpreter','latex','FontSize',14);

nombre_figura_f1 = strcat(carpeta_design, '1-Mp_en_funcion_de_beta');
saveas(f1,nombre_figura_f1,'epsc');
saveas(f1,nombre_figura_f1,'svg');

%% ts en funcion de beta2

beta2 = 0:0.01:45;
beta2_length=length(beta2);

[m, n] = size(valores_coef_amort_beta);
index = 1;

f2 = figure('Name','ts en función de beta2','NumberTitle','off');
sdf(f2);
set(gca, 'FontSize', 11.5);
style.Width = '24';
style.Height = '12';
hgexport(f2,'figures_style',style,'applystyle', true);
hold on

for i = 1:m 
    
    for j = 2:n % Valor minimo y maximo de beta
        
        for k = 1:beta2_length 
            
            % Parametros
            wn  = p/(beta2(k)*valores_coef_amort_beta(i,1));
            Q = ((valores_coef_amort_beta(i,j))^2)-2*valores_coef_amort_beta(i,j)+1/((valores_coef_amort_beta(i,1))^2);
            r1 = (valores_coef_amort_beta(i,1)*wn*(valores_coef_amort_beta(i,j)*((1/valores_coef_amort_beta(i,1)^2)-4)+(2/valores_coef_amort_beta(i,1)^2)))/Q;
            r2 = (wn^2*((1/valores_coef_amort_beta(i,1)^2)-2*valores_coef_amort_beta(i,j)))/Q;
            r3 = ((valores_coef_amort_beta(i,j)^3)*valores_coef_amort_beta(i,1)*wn)/Q;

            % H -> Funcion de transferencia de lazo cerrado del controlador PID-D
            numerador1 = [r1 r2];
            denominador1 = [1 2*valores_coef_amort_beta(i,1)*wn wn^2];
            numerador2 = [r3];
            denominador2 = [1 valores_coef_amort_beta(i,j)*valores_coef_amort_beta(i,1)*wn];
            H = tf(numerador1, denominador1) + tf(numerador2, denominador2);
            
            % Respuesta al escalon
            [y,t] = step(H);
            
            % Obtencion de la tiempo de establecimiento para cada beta2
            [Mp, tp, tr, ts] = parametros(y,t,ref, v);
            ts_vector(k)= ts;

            % Calculo del valor de beta2 maximo
            if (round(ts,3) == tsmax)
                valid_beta2(k) = beta2(k);
            end

        end
   
        % beta2 maximo        
        valid_beta2(valid_beta2==0)=[];
        beta_2_max = valid_beta2(1);

        % Se elige un valor de beta2 que sea menor o igual al beta2 maximo
        if (index == 1)
            beta_2_def = beta_2_max;
        elseif (index ==2)    
            beta_2_def = 21.9;
        elseif (index ==3)    
            beta_2_def = 5;
        elseif (index ==4)    
            beta_2_def = 10;
        elseif (index ==5)    
            beta_2_def = 10;
        elseif (index ==6)    
            beta_2_def = 19.3;
        elseif (index ==7)    
            beta_2_def = 2;
        elseif (index ==8)    
            beta_2_def = beta_2_max;            
        end
        
    clear valid_beta2;
    valores_def(index,:) = [valores_coef_amort_beta(i,1), valores_coef_amort_beta(i,j), beta_2_def];
    
    f2 = plot(beta2,ts_vector,'LineWidth',2);
    val_legend{index} = strcat("$$\zeta=", num2str(valores_def(index,1)), '; \, \beta=', num2str(valores_def(index,2)), "; \, \beta_2=(", num2str(beta_2_max), ")$$");
    index = index +1;   
    end
    
end

ylim([0 1]);
xlim([0 65]);

f2 = yline(tsmax, '--', 'LineWidth', 1.5, 'color', [(9/255) (143/255) (116/255)]);
f2 = legend(val_legend{1}, val_legend{2}, val_legend{3}, val_legend{4},val_legend{5}, val_legend{6}, val_legend{7}, val_legend{8}, '$$t_{s \, max}$$','Interpreter','latex', 'Location', 'northeast','FontSize',11);
f2 = title('$$ \mathbf{t_s \; de \; y(t) \; con \; PID-D \; a \; la \; entrada \; escal\acute{o}n \; unidad} $$','Interpreter','latex','FontSize',16);
f2 = xlabel('$$ \mathbf{\beta_2} $$','Interpreter','latex','FontSize',14);
f2 = ylabel('$$ \mathbf{t_s \; (s)} $$','Interpreter','latex','FontSize',14);

nombre_figura_f2 = strcat(carpeta_design, '2-ts_en_funcion_de_beta2');
saveas(f2,nombre_figura_f2,'epsc');
saveas(f2,nombre_figura_f2,'svg');

%% Respuesta al escalon del sistema realimentado que satisface las especificaciones de diseño

t = 0:0.0001:2; 
fprintf(' \n')   
fprintf('Caracteristicas del régimen transitorio:\n');   

f3 = figure('Name','Respuesta al escalon con los parametros que cumplen las especificaciones','NumberTitle','off');
sdf(f3);
set(gca, 'FontSize', 11.5);
sdf(f3);
style = struct();
style.Width = '26';
style.Height = '12';
hgexport(f3,'figures_style',style,'applystyle', true);
hold all

for i = 1:8
    
    % Parametros
    wn  = p/(valores_def(i,3)*valores_def(i,1));
    Q = ((valores_def(i,2))^2)-2*valores_def(i,2)+1/((valores_def(i,1))^2);
    r1 = (valores_def(i,1)*wn*(valores_def(i,2)*((1/valores_def(i,1)^2)-4)+(2/valores_def(i,1)^2)))/Q;
    r2 = (wn^2*((1/valores_def(i,1)^2)-2*valores_def(i,2)))/Q;
    r3 = ((valores_def(i,2)^3)*valores_def(i,1)*wn)/Q;

    % H -> Funcion de transferencia de lazo cerrado del controlador PID-D
    numerador1 = [r1 r2];
    denominador1 = [1 2*valores_def(i,1)*wn wn^2];
    numerador2 = [r3];
    denominador2 = [1 valores_def(i,2)*valores_def(i,1)*wn];
    H = tf(numerador1, denominador1) + tf(numerador2, denominador2);

    % Respuesta al escalon
    y = step(H, t);
    f3 = plot(t,y, 'LineWidth', 1.5);
    [Mp, tp, tr, ts] = parametros(y,t,ref, v);
    fprintf('Respuesta %d: Mp=%.2f, tp=%.2f s, tr=%.2f s, ts=%.2f s \n',i,Mp,tp, tr, ts)   

    val_legend_2(i,:) = strcat("$$Respuesta \;", num2str(i), ": \zeta=", num2str(valores_def(i,1)), '; \, \beta=', num2str(valores_def(i,2)), "; \, \beta_2=", num2str(valores_def(i,3)), "$$");

end

f3 = legend(val_legend_2{1}, val_legend_2{2}, val_legend_2{3}, val_legend_2{4},val_legend_2{5}, val_legend_2{6}, val_legend_2{7}, val_legend_2{8}, 'Interpreter','latex', 'Location', 'southeast','FontSize',11);

% yline((1+v), '-.', 'LineWidth', .7, 'color', [(195/255) (149/255) (9/255)]);
% yline((1-v), '-.', 'LineWidth', .7, 'color', [(195/255) (149/255) (9/255)]);
% xline(tsmax, '--', 'LineWidth', 1, 'color', [(11/255) (134/255) (0/255)]);
f3 = title('$$ \mathbf{Controlador \; PID-D \; con \; par\acute{a}metros \; que \; cumplen \, las \; especificaciones} $$','Interpreter','latex','FontSize',16);
f3 = xlabel('$$ \mathbf{t (s)} $$','Interpreter','latex','FontSize',14);
f3 = ylabel('$$ \mathbf{y (t)} $$','Interpreter','latex','FontSize',14);

ylim([0 1.4]);
xlim([0 0.8]);

nombre_figura_f3 = strcat(carpeta_design, '3-respuestas_al_escalon');
saveas(f3,nombre_figura_f3,'epsc');
saveas(f3,nombre_figura_f3,'svg');

%% Respuesta al escalon del sistema realimentado con los parametros finales
fprintf(' \n')   
fprintf('Controlador PID-D: \n')   

t = 0:0.0001:2; 

% Respuesta elegida para el telelabo: 3
num_respuesta = input('Introduce el número de la respuesta al escalón que quiere observar (1-8):');

% Obtener parametros de diseño a partir del coef. amort, beta y beta2
[Kp,tau_i,tau_d1,tau_d2] = get_design_parameters(p, K, valores_def(num_respuesta,1), valores_def(num_respuesta,2), valores_def(num_respuesta,3));
fprintf('Parametros de diseño elegidos\n')   
fprintf('Kp=%.3f, tau_D1=%.3f, tau_D2=%.3f, tau_I=%.3f \n',Kp,tau_d1, tau_d2, tau_i)   
fprintf(' \n')   

% H -> Funcion de transferencia de lazo cerrado del controlador PID-D
num = [Kp*K*tau_d1 Kp*K ((Kp*K)/tau_i)];
den = [1 (p+(Kp*K*(tau_d1+tau_d2))) Kp*K ((Kp*K)/tau_i)];
H = tf(num,den);

% Respuesta al escalon
y = step(H, t);

% Características del régimen transitorio
[Mp, tp, tr, ts] = parametros(y,t, ref,v);
fprintf('Caracteristicas del régimen transitorio:\n');   
fprintf('Mp=%.2f, tp=%.2f s, tr=%.2f s, ts=%.2f s \n',Mp,tp, tr, ts);  

f4 = figure('Name','Respuesta al escalon con los parametros finales','NumberTitle','off');
sdf(f4);
style.Width = '26';
style.Height = '12';
hgexport(f4,'figures_style',style,'applystyle', true);
f4 = plot(t,y, 'LineWidth', 3, 'color', [(207/255) (53/255) (16/255)]);
f4 = title('$$ \mathbf{Controlador \; \; PID-D} $$','Interpreter','latex','FontSize',16);
f4 = xlabel('$$ \mathbf{t (s)} $$','Interpreter','latex','FontSize',14);
f4 = ylabel('$$ \mathbf{y (t)} $$','Interpreter','latex','FontSize',14);

ylim([0 1.4]);
xlim([0 0.7]);

% Sobreenlogación máxima
% yline(1+Mpmax, ':', 'LineWidth', 1.5, 'color', [(115/255) (185/255) (211/255)]);
% Sobreenlogación mínima
% yline(1+Mpmin, ':', 'LineWidth', 1.5, 'color', [(115/255) (185/255) (211/255)]);

% Respuesta al escalón unidad
% yline(1, 'LineWidth', .4, 'color', [(182/255) (180/255) (177/255)]);

% Tolerancia
% yline((1+v), '-.', 'LineWidth', .8, 'color', [(188/255) (113/255) (7/255)]);
% yline((1-v), '-.', 'LineWidth', .8, 'color', [(188/255) (113/255) (7/255)]);

% Tiempo de establecimiento máximo
% xline(tsmax, '--', 'LineWidth', 1, 'color', [(11/255) (134/255) (0/255)]);

nombre_figura_f4 = strcat(carpeta_design, '4-respuesta_al_escalon_final');
saveas(f4,nombre_figura_f4,'epsc');
saveas(f4,nombre_figura_f4,'svg');
