% Implementacao de regressao linear por partes em intervalos rigidos
% (crisp intervals)
%
% Autor: Guilherme de Alencar Barreto
% Data: 06/05/2016

clear; clc; close all

load aerogerador.dat % carrega arquivo de dados

x=aerogerador(:,1); % medidas de velocidades
y=aerogerador(:,2); % medidas de potencia

figure; plot(x,y,'bo'); grid; % diagrama de dispersao
xlabel('Velocidade do vento [m/s]'); 
ylabel('Potencia gerada [kWatts]');

%% Divisao do universo de discurso em intervalos de larguras iguais
T(1)=0;  % Limite inferior do 1o. intervalo
T(2)=5;   % Limite superior do 1o. intervalo
T(3)=10; % Limite superior do 2o. intervalo
T(4)=15;  % Limite superior do 3o. intervalo

% Separacao dos dados por intervalo de x
for i=1:3,
  I=find(x>=T(i) & x<T(i+1));   % indice dos pares ordenados (xi,yi) contidos no i-esimo intervalo
  %X{i}=[x(I) y(I)]; % Subconjunto dos dados contidos no i-esimo intervalo
  B{i}=polyfit(x(I),y(I),1);  % Coeficientes da reta ajustada ao i-esimo intervalo
end

xx=min(x):0.1:max(x); % Define faixa de valores para velocidade
xx=xx'; 

for n=1:length(xx),
    if xx(n) < T(2),  % testa se entrada cai no 1o. intervalo
        ypred(n)=polyval(B{1},xx(n)); % predicao correspondente
    elseif (xx(n)>=T(2) & xx(n)<T(3)), % testa se entrada cai no 2o. intervalo
        ypred(n)=polyval(B{2},xx(n)); % predicao correspondente
    else  % entrada cai no 3o. intervalo
        ypred(n)=polyval(B{3},xx(n)); % predicao correspondente
    end
        
end

hold on; 
plot(xx,ypred,'r-','linewidth',3); % Sobrepoe curva de regressao aos dados
hold off; 





