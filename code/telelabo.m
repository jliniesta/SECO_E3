%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTORES: Javier Lopez Iniesta Diaz del Campo & Fernando Garcia Gutierrez
% FECHA: 03 de Junio de 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TELELABO: 

%% Valores fijos

close all
clear
warning("off")
clc
syms s t;

reductora = 23; % 23:1
K = 2652.28 / reductora;
p = 64.986;
G = K/(s*(s + p));
v = 0.02; %tolerancia

% Kp=23.146, tau_D1=0.043, tau_D2=-0.024, tau_I=0.088 

% Parametros
tau_I = 0.088;
tau_D1 = 0.043;
tau_D2 = -0.024;
Kp = 23.146;

T = 0.01; % Periodo de muestreo: 10ms

%% PARAMETROS TELELABO

% Lazo directo
Ki = (Kp * T)/(tau_I);
Kd1 = (Kp * tau_D1)/(T);

fprintf('Lazo directo: Kp=%.3f, Ki=%.3f, Kd=%.3f\n',Kp,Ki,Kd1);  

% Lazo paralelo
Kd2 = (Kp * tau_D2)/(T);

fprintf('Lazo paralelo: Kd=%.3f\n',Kd2);  

%% RESPUESTA AL ESCALÓN SIMULADA

% H -> Funcion de transferencia de lazo cerrado del controlador PID-D
num = [Kp*K*tau_D1 Kp*K ((Kp*K)/tau_I)];
den = [1 (p+(Kp*K*(tau_D1+tau_D2))) Kp*K ((Kp*K)/tau_I)];
H = tf(num,den);

% Respuesta al escalon
t = 0:0.005:1; 
ref_simulado = 3.14; % Una vuelta: pi (rad)
y_simulado = step(H,t).*ref_simulado; 
error_simulado = ref_simulado - y_simulado;

[Mp, tp, tr, ts] = parametros(y_simulado,t, ref_simulado, v);
fprintf(' \n')   
fprintf('Caracteristicas del régimen transitorio (simulación):\n');   
fprintf('Mp=%.2f, tp=%.2f s, tr=%.2f s, ts=%.2f s \n',Mp,tp, tr, ts); 

% f0 = figure('Name','Respuesta al escalon simulada','NumberTitle','off');
% sdf(f0);
% style.Width = '26';
% style.Height = '12';
% hgexport(f0,'figures_style',style,'applystyle', true);
% f0 = plot(t,y_simulado, 'LineWidth', 3, 'color', [(207/255) (53/255) (16/255)]);
% f0 = title('$$ \mathbf{Respuesta \; al \; escal\acute{o}n \; simulada} $$','Interpreter','latex','FontSize',16);
% f0 = xlabel('$$ \mathbf{t \; (s)} $$','Interpreter','latex','FontSize',14);
% f0 = ylabel('$$ \mathbf{\theta \; (rad)} $$','Interpreter','latex','FontSize',14);
% ylim([0 4]);
% xlim([0 0.6]);

%% TELELABO: READ FILES

nombre_carpeta='ficheros_telelabo/';
formatSpec = '%f %f';
sizeA = [2 Inf];

nombre_fichero_output = 'escalon-MOTOR3Y';
nombre_ruta = strcat(nombre_carpeta, nombre_fichero_output);
fidLectura = fopen(nombre_ruta,'r');
file_output = fscanf(fidLectura,formatSpec,sizeA)';
fclose(fidLectura);
t_output = file_output(:,1);
output_real = file_output(:,2);

nombre_fichero_error = 'escalon-MOTOR3ERR';
nombre_ruta = strcat(nombre_carpeta, nombre_fichero_error);
fidLectura = fopen(nombre_ruta,'r');
file_error = fscanf(fidLectura,formatSpec,sizeA)';
fclose(fidLectura);
t_error = file_error(:,1);
error_real = file_error(:,2);

nombre_fichero_referencia = 'escalon-MOTOR3REF';
nombre_ruta = strcat(nombre_carpeta, nombre_fichero_referencia);
fidLectura = fopen(nombre_ruta,'r');
file_referencia = fscanf(fidLectura,formatSpec,sizeA)';
fclose(fidLectura);
t_ref = file_referencia(:,1);
ref_real = file_referencia(:,2);

nombre_fichero_control = 'escalon-MOTOR3U';
nombre_ruta = strcat(nombre_carpeta, nombre_fichero_control);
fidLectura = fopen(nombre_ruta,'r');
file_control = fscanf(fidLectura,formatSpec,sizeA)';
fclose(fidLectura);
t_control = file_control(:,1);
control_real = file_control(:,2);

nombre_fichero_controlSat = 'escalon-MOTOR3USAT';
nombre_ruta = strcat(nombre_carpeta, nombre_fichero_controlSat);
fidLectura = fopen(nombre_ruta,'r');
file_controlSat = fscanf(fidLectura,formatSpec,sizeA)';
fclose(fidLectura);
t_controlSat = file_controlSat(:,1);
controlSat_real = file_controlSat(:,2);

%% TELELABO: FIGURES & COMPARATION

carpeta_telelabo = 'figuras/figuras_telelabo/';
mkdir(carpeta_telelabo);

[Mp, tp, tr, ts] = parametros(output_real,t_output, ref_simulado, v);
fprintf(' \n')   
fprintf('Caracteristicas del régimen transitorio (real):\n');   
fprintf('Mp=%.2f, tp=%.2f s, tr=%.2f s, ts=%.2f s \n',Mp,tp, tr, ts);  

% FIG 1 -> y(rad): real vs simulación
f1 = figure('Name','y(rad): real vs simulación','NumberTitle','off');
sdf(f1);
style.Width = '26';
style.Height = '12';
set(gca, 'FontSize', 11.5);
hgexport(f1,'figures_style',style,'applystyle', true);
hold on;
f1 = plot(t_output,output_real, 'LineWidth', 3, 'color', [(207/255) (53/255) (16/255)]);
f1 = plot(t,y_simulado, 'LineWidth', 3, 'color', [(19/255) (147/255) (28/255)]);
f1 = plot(t_ref,ref_real, 'LineWidth', 1, 'color', 'k');
f1 = title('$$ \mathbf{Salida \;\, con \;\, controlador \;\, PID-D \; \; ( real \;\, vs \;\, simulaci\acute{o}n)} $$','Interpreter','latex','FontSize',16);
f1 = xlabel('$$ \mathbf{t \; (s)} $$','Interpreter','latex','FontSize',14);
f1 = ylabel('$$ \mathbf{\theta \; (rad)} $$','Interpreter','latex','FontSize',14);
f1 = legend('$$ Real $$','$$ Simulada $$', '$$ Referencia $$', 'Interpreter','latex', 'Location', 'southeast','FontSize',11);
yticks([0 pi/4 pi/2 pi*(3/4) pi pi*(5/4) pi*(6/4) pi*(7/4) 2*pi])
yticklabels({'0','\pi/4','\pi/2','3\pi/4','\pi','5\pi/4','3\pi/2','7\pi/4','2\pi'})
ylim([0 4]);
xlim([0 0.8]);
hold off;
nombre_figura_f1 = strcat(carpeta_telelabo, '1-output');
saveas(f1,nombre_figura_f1,'epsc');
saveas(f1,nombre_figura_f1,'svg');

% FIG 2 -> y(rad): real vs simulación
f2 = figure('Name','e(rad): real vs simulación','NumberTitle','off');
sdf(f2);
set(gca, 'FontSize', 11.5);
style.Width = '26';
style.Height = '12';
hgexport(f2,'figures_style',style,'applystyle', true);
hold on
f2 = plot(t_error,error_real, 'LineWidth', 3, 'color', [(11/255) (154/255) (233/255)]);
f2 = plot(t,error_simulado, 'LineWidth', 3, 'color', [(233/255) (162/255) (11/255)]);
yline(0, 'LineWidth', 0.8);
f2 = title('$$ \mathbf{Error \;\, con \;\, controlador \;\, PID-D \; \; ( real \;\, vs \;\, simulaci\acute{o}n)} $$','Interpreter','latex','FontSize',16);
f2 = xlabel('$$ \mathbf{t \; (s)} $$','Interpreter','latex','FontSize',14);
f2 = ylabel('$$ \mathbf{e \; (rad)} $$','Interpreter','latex','FontSize',14);
f2 = legend('$$ Real $$','$$ Simulada $$', '$$Error \; te\acute{o}rico $$', 'Interpreter','latex', 'Location', 'east','FontSize',11);
yticks([-pi/2 -pi/4 0 pi/4 pi/2 pi*(3/4) pi pi*(5/4)])
yticklabels({'-\pi/4','-\pi/2','0','\pi/4','\pi/2','3\pi/4','\pi','5\pi/4','3\pi/2','7\pi/4','2\pi'})
ylim([-0.85 3.95]);
xlim([0 0.8]);
hold off
nombre_figura_f2 = strcat(carpeta_telelabo, '2-error');
saveas(f2,nombre_figura_f2,'epsc');
saveas(f2,nombre_figura_f2,'svg');

% FIG 3 -> control & control_saturacion
f3 = figure('Name','Saturación de la señal de control','NumberTitle','off');
sdf(f3);
set(gca, 'FontSize', 11.5);
style.Width = '21';
style.Height = '12';
hgexport(f3,'figures_style',style,'applystyle', true);
hold on;
f3 = plot(t_control,control_real, 'LineWidth', 2.5, 'color', [(11/255) (191/255) (233/255)]);
f3 = plot(t_controlSat,controlSat_real, 'LineWidth', 2.5, 'color', [(233/255) (11/255) (135/255)]);
xlim([0.01 0.7]);
ylim([-5 80]);
hold off
f3 = title('$$ \mathbf{Saturaci\acute{o}n \;\, se\tilde{n}al \;\, de \;\, control} $$','Interpreter','latex','FontSize',16);
f3 = xlabel('$$ \mathbf{t \; (s)} $$','Interpreter','latex','FontSize',14);
f3 = ylabel('$$ \mathbf{(V)} $$','Interpreter','latex','FontSize',14);
f3 = legend('$$ Se\tilde{n}al \; de \; control: \;\, u(V) $$','$$ Se\tilde{n}al \; de \; control \; saturada: \;\, \hat{u}(V)$$', '$$Error \; te\acute{o}rico $$', 'Interpreter','latex', 'Location', 'northeast','FontSize',11);
nombre_figura_f3 = strcat(carpeta_telelabo, '3-control');
% yline(0, 'LineWidth', 0.8);
saveas(f3,nombre_figura_f3,'epsc');
saveas(f3,nombre_figura_f3,'svg');