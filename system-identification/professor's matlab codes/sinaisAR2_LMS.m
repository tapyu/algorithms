% Gera sinal AR(2) e estima parametros via LMS.
% Autor: Guilherme Barreto
% Data; 23/12/2021

clear; clc; close all;

s2=0.1;  % variancia do ruido
dp=sqrt(s2);   % Desvio-padrao do ruido
a=[0.3 0.6];  %coeficientes do processo AR(2): a1=0.3; a2=0.6
N=10000;
p=2;   % Ordem do modelo AR(p)  
TAUmax=50;  % Maximo lag da FAC

x=dp*randn(p,1);  % valor inicial
for n=p+1:2*N,
  %x(n) = a1*x(n-1) + a2*x(n-2) + a3*x(n-3) + dp*randn;
  x(n) = a(1)*x(n-1) + a(2)*x(n-2) + dp*randn;
end
x=x(N+1:end);  % descarta metade inicial (warm-up) para evitar influencia da condicao inicial

%x=filter(1,[1 -[a]],dp*randn(1,N)); % AR usando a funcao FILTER do Octave/Matlab


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Minha rotina para implementacao do metodo LMS       %%%
%%%% Limitada ao modelo AR(p), mas pode ser generalizada %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=x(:);  % transposicao do sinal para vetor-coluna
lr=0.01;  % passo de aprendizagem
ahat=zeros(p,1);  % valores iniciais parametros
grad_ant=zeros(size(ahat));

for n=p+1:N,
  
  xin=flipud(x(n-p:n-1));   % Monta o vetor de regressao no instante n
                    % xin = [x(n-1) x(n-2) ... x(n-p)]
                    
  %xout=x(n); % Saida observada no instante n
  %xpred=ahat'*xin; % predicao da saida usando os coeficientes atuais
  
  erro = x(n) - ahat'*xin;   % erro de predicao
  
  %ahat = ahat + lr*erro*xin;  % LMS convencional
  %alf=0.001; ahat = ahat + lr*erro*xin/(alf+xin'*xin); % LMS normalizado
  %gama=0.1; ahat = (1-gama)*ahat + lr*erro*xin;   % Leaky LMS
  
  % Median LMS (m=2) 
  grad_atual=erro*xin;
  ahat = ahat + lr*median([grad_atual grad_ant],2);
  grad_ant=grad_atual;
end

%% Calcula predicoes e residuos com dados de estimacao
for n=p+1:N,
  
  xin=flipud(x(n-p:n-1));   % Monta o vetor de regressao no instante n
                    % xin = [x(n-1) x(n-2) ... x(n-p)]

  xpred(n)=ahat'*xin; % predicao da saida usando os coeficientes atuais
  
  residuos(n) = x(n) - xpred(n);   % erro de predicao
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Etapa de validacao do modelo  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fac3=myfac3(residuos,TAUmax);  % calcula FAC dos residuos

figure; histfit(residuos,40);
xlabel('residuos'); title('Histograma dos residuos: AR(2)');
set(gca, "fontsize", 14)

print -deps -color 'hist-residuos-AR2.eps'

figure; stem(fac3,'k-','linewidth',2);
xlabel('lag'); title('FAC dos residuos: AR(2)');
set(gca, "fontsize", 14)

print -deps -color 'FAC-residuos-AR2.eps'