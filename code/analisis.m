function analisis(H, He, controlador, valores, ejes, parametro, texto)

% Analisis de la respuesta y el error para distintas señales de referencia  
% monomicas para distintos controladores

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ENTRADAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H -> funcion de transferencia de lazo cerrado
% H -> funcion de transferencia del error
% controlador -> tipo de controlador (P, P-D, PD, PI, PID, PI-D, PI-D, PID-D o D|PID)
% ejes -> matriz especificando los ejes x e y para la respuesta y error del escalon, rampa y parabola
% parametro -> parametro que se modifica (solo en PID y PI-D)
% texto -> parametros que permanecen fijos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SALIDAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f1 -> figura de la respuesta y error al escalon 
% f2 -> figura de la respuesta y error a la rampa 
% f3 -> figura de la respuesta y error a la parabola 
% f4 -> figura de los errores para distintas señales de referencia monomicas en el controlador

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTORES: Javier Lopez Iniesta Diaz del Campo & Fernando Garcia Gutierrez
% FECHA: 23 de Mayo de 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 0:0.00001:40; 

rampa = t; 
parabola = t.^2; 

Hlength = length(H);

if ((controlador == " Controlador PID") || (controlador == " Controlador PI-D"))
    carpeta_controlador =strcat('figuras/analisis/', strrep(strrep(controlador,'|',']'),' ',''), '/', parametro, '/'); 
else     
    carpeta_controlador =strcat('figuras/analisis/', strrep(strrep(controlador,'|',']'),' ',''), '/'); 
end
mkdir(carpeta_controlador);

%Escalon
figure_escalon = strcat(controlador," - Escalon");
f1 = figure('Name',figure_escalon,'NumberTitle','off');
sdf(f1);
subplot(1,2,1)
for i = 1:Hlength
    hold on
    y = step(H{i},t);
    f1 = plot(t,y, 'LineWidth', 1.5);
end
yline(1, '--', 'color', 'k');
axis(ejes(1,1:4));

% It doesn't work
% f1 = text(15,5,texto,'Interpreter','latex');

xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Respuesta al escalon')
if (controlador == " Controlador D|PID")
    f1 = legend(valores{1}, valores{2}, valores{3}, '$$Escal\acute{o}n \; te\acute{o}rico $$','Interpreter','latex', 'Location', 'northeast');
else
    f1 = legend(valores{1}, valores{2}, valores{3}, '$$Escal\acute{o}n \; te\acute{o}rico $$','Interpreter','latex', 'Location', 'southeast');
end
hold off
subplot(1,2,2)
for i = 1:Hlength
    hold on
    y = step(He{i},t);
    f1 = plot(t,y, 'LineWidth', 1.5);
end
yline(0, 'LineWidth', 0.3);
axis(ejes(1,5:8))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Error al escalon');
if (controlador == " Controlador D|PID")
    f1 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'southeast');
else
    f1 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'northeast');
end
title_escalon = strcat("\bf", controlador, texto);
sgtitle(title_escalon,'FontSize',14);
nombre_figura_f1 = strcat(carpeta_controlador, 'Escalon');
saveas(f1,nombre_figura_f1,'epsc');
saveas(f1,nombre_figura_f1,'svg');

%Rampa
figure_rampa = strcat(controlador," - Rampa");
f2 = figure('Name',figure_rampa,'NumberTitle','off');
sdf(f2);
subplot(1,2,1)
for i = 1:Hlength
    hold on
    y =lsim(H{i},rampa,t);
    f2 = plot(t,y, 'LineWidth', 1.5);
end
axis(ejes(2,1:4))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Respuesta a la rampa')
rampa_teorica = t;
f2=plot(t,rampa_teorica, '--', 'color', 'k');
f2=legend(valores{1}, valores{2}, valores{3}, '$$Rampa \, te\acute{o}rica $$','Interpreter','latex', 'Location', 'northwest');
hold off

subplot(1,2,2)
for i = 1:Hlength
    hold on
    y =lsim(He{i},rampa,t);
    f2 = plot(t,y, 'LineWidth', 1.5);
end
yline(0, 'LineWidth', 0.3);
axis(ejes(2,5:8))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Error a la rampa')
if (controlador == " Controlador D|PID")
    f2 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'southeast');
else
    f2 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'northeast');
end
title_rampa = strcat("\bf", controlador, texto);
sgtitle(title_rampa,'FontSize',14);
nombre_figura_f2 = strcat(carpeta_controlador, 'Rampa');
saveas(f2,nombre_figura_f2,'epsc');
saveas(f2,nombre_figura_f2,'svg');

%Parabola
figure_parabola = strcat(controlador," - Parabola");
f3 = figure('Name',figure_parabola,'NumberTitle','off');
sdf(f3);
subplot(1,2,1)
for i = 1:Hlength
    hold on
    y =lsim(H{i},parabola,t);
    f3 = plot(t,y, 'LineWidth', 1.5);
end
axis(ejes(3,1:4))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Respuesta a la parabola');
parabola_teorica = t.^2;
f3 = plot(t,parabola_teorica, '--', 'color', 'k');
f3 = legend(valores{1}, valores{2}, valores{3}, '$$Par\acute{a}bola \, te\acute{o}rica $$','Interpreter','latex', 'Location', 'northwest');
hold off

subplot(1,2,2)
for i = 1:Hlength
    hold on
    y =lsim(He{i},parabola,t);
    f3 = plot(t,y, 'LineWidth', 1.5);
end
axis(ejes(3,5:8))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Error a la parabola');
f3 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'northwest');
title_parabola = strcat("\bf", controlador, texto);
sgtitle(title_parabola,'FontSize',14);
nombre_figura_f3 = strcat(carpeta_controlador, 'Parabola');
saveas(f3,nombre_figura_f3,'epsc');
saveas(f3,nombre_figura_f3,'svg');

f4 = figure('Name','Errores','NumberTitle','off');
sdf(f4);
style = struct();
style.Width = '22';
style.Height = '14';
hgexport(f4,'figures_style',style,'applystyle', true);
subplot(2,2,1)
for i = 1:Hlength
    hold on
    y = step(He{i},t);
    f4 = plot(t,y, 'LineWidth', 1.5);
end
yline(0, 'LineWidth', 0.3);
axis(ejes(1,5:8))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Escalon');
if (controlador == " Controlador D|PID")
    f4 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'southeast');
else
    f4 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'northeast');
end
subplot(2,2,2)
for i = 1:Hlength
    hold on
    y =lsim(He{i},rampa,t);
    f4 = plot(t,y, 'LineWidth', 1.5);
end
axis(ejes(2,5:8))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Rampa');
if (controlador == " Controlador D|PID")
    f4 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'southeast');
else
    f4 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'northeast');
end
subplot(2,1,2)
for i = 1:Hlength
    hold on
    y =lsim(He{i},parabola,t);
    f4 = plot(t,y, 'LineWidth', 1.5);
end
axis(ejes(3,5:8))
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Parabola');
if (controlador == " Controlador D|PID")
    f4 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'southeast');
else
    f4 = legend(valores{1}, valores{2}, valores{3},'Interpreter','latex', 'Location', 'northeast');
end
titulo_errores = strcat('\bf Errores en el ', controlador, ' para distintas señales de referencia monomicas');
sgtitle(titulo_errores,'FontSize',14);
nombre_figura_f4 = strcat(carpeta_controlador, 'Errores');
saveas(f4,nombre_figura_f4,'epsc');
saveas(f4,nombre_figura_f4,'svg');
end 