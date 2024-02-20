%% f-2
function [ y, ny ] = inverso( x, nx )
    ny = nx;
    limMax = nx(end) - nx(1) + 1;
    y = zeros(1, length(ny));
    for i = 1:limMax
            y(i) = -x(i);
    end
end

