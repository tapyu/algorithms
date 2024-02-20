%% c-
function [ x, n ] = delta( intMin, desloc, intMax )
    
    if(intMin > desloc || intMax < desloc)
        msgbox('Limites inválidos', 'Error','error');
    else
        x = zeros(1, (intMax-intMin+1));
        x(desloc-intMin+1) = 1;
        n = intMin:1:intMax;
    end
end

