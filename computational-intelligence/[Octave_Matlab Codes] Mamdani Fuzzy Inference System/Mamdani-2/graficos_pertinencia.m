clear; clc; close all;

x=0:0.1:90;  % Universo de discurso da variavel de interesse

L=length(x); % No. total de medidas da variavel linguistica

M=[];
for i=1:L,
  %mi=velocidade(x(i));  % pertinencia aos conjuntos fuzzy (velocidade)
  mi=curvatura(x(i));  % pertinencia aos conjuntos fuzzy (curvatura)
  %mi=forca_pedal_freio(x(i));  % pertinencia aos conjuntos fuzzy (forca no pedal de freio)
  M=[M; mi];
end

figure; hold on
plot(x,M(:,1),'r-'); % grafico conjunto fuzzy temperatura BAIXA
plot(x,M(:,2),'b-'); % grafico conjunto fuzzy temperatura MEDIA
plot(x,M(:,3),'m-'); % grafico conjunto fuzzy temperatura ALTA
hold off
axis([0 90 0 1.2]);
xlabel('CURVATURA');
legend('BAIXA','MEDIA','ALTA')