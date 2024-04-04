% Cálculo da DTFT
%
%
% M = Qntd de pontos da DTFT
% x = Sinal de entrada (domínio do tempo)
% X = Sinal de saída (Domínio da frequência
% nX = Eixo das abcisas do sinal de saída
%
%

function [ X, nX ] = DTFT( M, x)
    X = zeros(1, 2*M+1);
    nX = -M:1:M;
    for k = -M:M
        aux = 0;
        for nx = 1:length(x)
            aux = aux + x(nx)*exp(-1i*pi/M).^(nx*k);
        end
        X(k+M+1) = aux;
    end
end

