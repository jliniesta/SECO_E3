% 
% JAVIER LOPEZ INIESTA DIAZ DEL CAMPO
% FERNANDO GARCIA GUTIERREZ
% 
% ENTREGABLE 3 SECO
% 
% CALCULO DE LOS DISTINTOS PARAMETROS DEL REGIMEN PERMANENTE Y TRANSITORIO

function [Mp, tp, tr, ts] = parametros(pos,t,ref,v)

    L=length(pos); 
    v = v*ref;
%     ref=3.14;
    
    % Parametros
    Mp=0;
    tr=0;
    tp=0;
    ts=0;
    
    pos_max=0;
    subamortiguado=0;
    primera_vez = 0;
    
    for i=1:L
        
        % Calculo del tiempo de subida, tr
        if ((pos(i)>ref) && (primera_vez == 0))
            tr=t(i);
            primera_vez = 1;
        end
        
        % Calculo de la sobreenlogacion máxima, Mp
        
        sobreenlogacion = abs(pos(i)-ref);
        if ((primera_vez ~= 0) && (sobreenlogacion > Mp))
            Mp=sobreenlogacion;
            subamortiguado = 1;
        end
                
        % Calculo del tiempo de establecimiento, ts
        if ((pos(i)>ref+v)||(pos(i)<ref-v))
            ts=t(i);
        end
        
        % Calculo del tiempo de pico, tp
        if ((pos(i) > pos_max) && (subamortiguado ==1))
            pos_max = pos(i);
            tp=t(i);
        end
        
        % Calculo del tiempo de subida, tr
        if ((pos(i)>ref) && (primera_vez == 0))
            tr=t(i);
            primera_vez = 1;
        end
    end

end