% Implementacao de um sistema de inferencia fuzzy Mandani
% ENTRADAS: x (velocidade do vento, m/s)
% SAIDA:  y (potencia gerada, kWatts)
%
% Autor: Guilherme A. Barreto 
% Data:  09/09/2020

clear; clc; close all;

% Read the dataset
data=load('aerogerador.dat');

x=data(:,1); % wind data
y=data(:,2); % power data

[x I]=sort(x); y=y(I);   % Ordena as medidas (x, y)

Nmf=5; % Number of membership functions

% Initial values of the parameters of the membership functions
centers=[4 6.5 9.19 11.5 14]; % Nmf=5
powerw= [20 134 270 480 508]; % Nmf = 5
 


figure; plot(x,y,'b.'); grid; hold on
title('CURVA DE POTENCIA - AEROGERADOR');

plot(centers,powerw,'ro','markersize',10,'linewidth',3)
h = legend({"data samples","pontos de suporte"},"location", "east"); 
set(h, "fontsize", 12); set(gca, "fontsize", 14);

spread=1.35*ones(1,Nmf); % Same spread for all Gaussian membership functions

% Plota funcoes de pertinencia
xx=0.8*min(x):0.1:1.20*max(x); 
for j=1:length(xx),
    for i=1:Nmf,
       mi(i,j) = exp(-(xx(j)-centers(i))^2/(2*spread(i)^2));  % ativacao da i-esima regra
    end
end

K=200;

plot(xx,K*mi(1,:),'r-','linewidth',5);
plot(xx,K*mi(2,:),'g-','linewidth',5); 
plot(xx,K*mi(3,:),'b-','linewidth',5); 
plot(xx,K*mi(4,:),'k-','linewidth',5); 
plot(xx,K*mi(5,:),'m-','linewidth',5); 

h = legend({"data samples","pontos de suporte","muito baixa","baixa","media","alta","muito alta"},"location", "northwest");      

clear mi
for j=1:length(xx),
    for i=1:Nmf,
       regra=i;
       mi(i) = exp(-(xx(j)-centers(i))^2/(2*spread(i)^2));  % ativacao da i-esima regra
       %pause(3)
       ypred(i) = powerw(i);  % Saida predita pela i-esima regra
    end
    
    yhat(j) = sum(mi.*ypred)/sum(mi);  % saida predita final (media ponderada)
end

%%%%%%%%%%%%
% PLOT ESTIMATED POWER CURVE
%%%%%%%%%%%%
plot(xx, yhat, 'k-', 'linewidth', 4);
xlabel('Wind speed [m/s]')
ylabel('Power output [KWatts]')
hold off


%%%%%%%%%%%%
% Compute the R2 performance index
%%%%%%%%%%%%

clear mi
Pmedia=mean(y);
for j=1:length(x),
    for i=1:Nmf,
       regra=i;
       mi(i) = exp(-(x(j)-centers(i))^2/(2*spread(i)^2));  % ativacao da i-esima regra
       %pause(3)
       ypred(i) = powerw(i);  % Saida predita pela i-esima regra
    end
    
    yhat(j) = sum(mi.*ypred)/sum(mi);  % saida predita final (media ponderada)
    erronum(j) = y(j)-yhat(j);  % erro de predicao do modelo Mamdani
    erroden(j) = y(j)-Pmedia;  % erro do modelo Naive (predicao pela media)
end


NUM=sum(erronum.^2);  % Numerador
DEN=sum(erroden.^2); % Denominador

R2 = 1 - NUM/DEN,  % Indice R2 

