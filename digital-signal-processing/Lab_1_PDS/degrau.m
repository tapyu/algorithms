%% c-
function [ x, n ] = degrau( intMin, desloc, intMax )
    
    if(intMin > desloc || intMax < desloc)
        msgbox('Limites inválidos', 'Error','error');
    else
        x = zeros(1, (intMax-intMin+1));
        for i= desloc:intMax
            x(i-intMin+1) = 1;
        end
        n = intMin:1:intMax;
    end
end