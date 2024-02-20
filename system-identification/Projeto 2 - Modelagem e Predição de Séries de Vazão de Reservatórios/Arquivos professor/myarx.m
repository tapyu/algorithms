%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Exemplo de estimacao de parametros de  %%%%
%%% um modelo ARX(2,1) usando o método OLS %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

sig2=0.01;  % variancia do ruido branco
N=2000;   % num. de observacoes das series {u(k),y(k)}, k=1, ..., N
TAUmax=20;  % Max. lag para FAC
n=2; m=1; % Ordens da regressao de entrada e saida


%%%%%% Geracao das series de entrada (u) e de saida (y)
u=sign(randn(2*N,1));  % SINAL DE ENTRADA (onda quadrada aleatoria)
u=(u+1)/2;
y=zeros(1,n);
for k=n+1:2*N,
    y(k) = 0.43*y(k-1)-0.67*y(k-2) + 1.98*u(k-1) + sqrt(sig2)*randn;
end

u=u(N+1:end);
y=y(N+1:end);

% figure; plot(u,'linewidth',2);
% figure; plot(y,'linewidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ETAPA DE ESTIMACAO %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

n=2; m=1;  % Ordens supostas para fins de estimacao

p=[]; X=[];
N=length(y);
for k=max(n,m)+1:N,
    p=[p; y(k)];
    X=[X; y(k-1) y(k-2) u(k-1)]; % ARX(2,1)
    %X=[X; y(k-1) u(k-1) u(k-2)]; % ARX(1,2)
    %X=[X; y(k-1) y(k-2) y(k-3) u(k-1) u(k-2)]; % ARX(3,2)
end

B=inv(X'*X)*X'*p;
B1=pinv(X)*p;
B2=X\p;

OLS=[B B1 B2]

% Predicao (saida vetorial ou todos de uma vez)
yhat=X*B1;  % Predicao da variavel de saida (com dados de estimacao)
residuos=p-yhat;

% Analise dos residuos
fcac=myfac3(residuos,TAUmax);  % estimativas da FCAC
limconf=(2/sqrt(N))*ones(1,TAUmax);
figure; stem(fcac,'linewidth',2); hold on;
plot(limconf,'r-','linewidth',2,-limconf,'r-','linewidth',2); hold off
figure; histfit(residuos,20);

% Forma Alternativa: (saida escalar ou predicao um-a-um)
for k=1:N-n,
    yhat2(k)=X(k,:)*B1;
    resd(k)=p(k)-yhat2(k);
end

%% Estimacao via algoritmo LMS
w=zeros(n+m,1);
lr=0.1;   % Passo de aprendizagem
Nr=10;  % Numero de repeticoes (opcional)
%for i=1:Nr,
for k=max(n,m)+1:N,
    %x=[y(k-1); y(k-2); y(k-3); u(k-1); u(k-2)];
    x=[y(k-1); y(k-2); u(k-1)];
    yhat3=w'*x;
    erro=y(k)-yhat3;
    
    w=w+lr*erro*x;
    %w=w+lr*erro*x/(x'*x);   % LMS normalizado
end
%end
param=[0.43; -0.67; 1.98]
w