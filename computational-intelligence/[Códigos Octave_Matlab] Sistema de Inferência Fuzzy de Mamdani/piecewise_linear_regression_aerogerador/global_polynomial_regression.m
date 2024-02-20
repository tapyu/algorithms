% Implementacao de regressao polinomial (modelo global) 
% Ou seja, um único polinomio de ordem k
%
% Autor: Guilherme de Alencar Barreto
% Data: 06/05/2016

clear; clc; close all

load aerogerador.dat % carrega arquivo de dados

x=aerogerador(:,1); % medidas de velocidades
y=aerogerador(:,2); % medidas de potencia

figure; plot(x,y,'bo'); hold on; grid; % diagrama de dispersao
xlabel('Velocidade do vento [m/s]'); 
ylabel('Potencia gerada [kWatts]');

k=4; % ordem inicial do polinomio
B=polyfit(x,y,k); % Estimacao do vetor de parametros

ypred=polyval(B,x); % Predicao da saida para dados observados

erro=y-ypred; % Calcula erros
SEQ=sum(erro.^2); % Calcula a soma dos erros quadraticos
ymed=mean(y); % Calcula potencia media
Syy=sum((y-ymed).^2); % Soma dos erros para modelo baseado na media
R2=1 - SEQ/Syy,  % Valor da figura de merito R2

xx=min(x):0.1:max(x); xx=xx'; % Define faixa de valores para velocidade
ypred2=polyval(B,xx); % predicao da saida correspondente

hold on; 
plot(xx,ypred2,'r-'); % Sobrepoe curva de regressao aos dados
hold off; 