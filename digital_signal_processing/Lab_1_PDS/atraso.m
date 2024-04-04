%% f-1
function [ y, ny ] = atraso( x, nx, k )
    if(k > nx(end))
        msgbox('Limites inválidos', 'Error','error');
    else
        ny = nx(1):1:nx(end)+k;
        limMax = nx(end) - nx(1) + 1;
        y = zeros(1, length(ny));
        for i = 1:limMax
                y(i + k) = x(i);
        end
    end
end

