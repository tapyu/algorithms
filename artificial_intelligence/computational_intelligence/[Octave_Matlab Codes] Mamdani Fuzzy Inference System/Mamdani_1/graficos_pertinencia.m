clear; clc; close all;

x=0:0.1:120;  % Universo de discurso da variavel de interesse

L=length(x); % No. total de medidas da variavel linguistica

M=[];
for i=1:L,
  mi=velocidade(x(i));  % pertinencia aos conjuntos fuzzy (velocidade)
  %mi=curvatura(x(i));  % pertinencia aos conjuntos fuzzy (curvatura)
  %mi=forca_pedal_freio(x(i));  % pertinencia aos conjuntos fuzzy (forca no pedal de freio)
  M=[M; mi];
end

figure; hold on
plot(x,M(:,1),'r-','linewidth',4); % grafico conjunto fuzzy velocidade BAIXA
plot(x,M(:,2),'b-','linewidth',4); % grafico conjunto fuzzy velocidade MEDIA
plot(x,M(:,3),'m-','linewidth',4); % grafico conjunto fuzzy velocidade ALTA
hold off
axis([0 120 0 1.2]);
xlabel('VELOCIDADE');
legend('BAIXA','MEDIA','ALTA');
grid