% Gera sinal AR(2) e estima parametros via Yule-wlaker e OLS.
% Autor: Guilherme Barreto
% Data; 23/12/2021

clear; clc; close all;

s2=0.15;  % variancia do ruido
dp=sqrt(s2);   % Desvio-padrao do ruido
a=[0.3 0.6];  %coeficientes do processo AR(2): a1=0.3; a2=0.6
N=10000;
p=2;   % Ordem do modelo AR(p)  
TAUmax=50;  % Maximo lag da FAC

##x=dp*randn(p,1);  % valor inicial
##for n=p+1:2*N,
##  x(n) = a1*x(n-1) + a2*x(n-2) + a3*x(n-3) + dp*randn;
##end
##x=x(N+1:end);  % descarta metade inicial (warm-up) para evitar influencia da condicao inicial

x=filter(1,[1 -[a]],dp*randn(1,N)); % AR usando a funcao FILTER do Octave/Matlab

fcac=myfac3(x,TAUmax);  % estimativas da FCAC

ahat1=aryule(x,p)    % Usa funcao do pacote SIGNAL octave

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Minha rotina para implementacao do metodo de Yule-Walker  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z=fcac(1:p+1);   % vetor com os p+1 primeiro valores da FCAC: r(0),...,r(p)
% rotina para montar a matriz de correlacao R e o vetor r
r=z(2:end)'; % vetor com os p ultimos valores de z: r(1),...,r(p)
R=toeplitz(z(1:p));  % Monta matriz R a partir do comando toeplitz
ahat2=R\r    % Estimacao de parametros via Yule-Walker

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Minha rotina para implementacao do metodo OLS       %%%
%%%% Limitada ao modelo AR(2), mas pode ser generalizada %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=x(:);  % transposicao do sinal para vetor-coluna
vp=x(p+1:end);  % Monta vetor "v"

X=[];
for l=1:p,
  X=[X x(p-l+1:end-l)];   % Monta colunas da matriz X
end

ahat2=(X'*X)\(X'*vp)    % Estimacao de parametros via OLS
ahat2b=inv(X'*X)*X'*vp
ahat2c=pinv(X)*vp

vpred=X*ahat2;  % vetor de predicoes (usando estimativa via OLS)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Etapa de validacao do modelo  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
residuos=vp-vpred;  % Calcula os residuos

fac3=myfac3(residuos,TAUmax);  % calcula FAC dos residuos

figure; histfit(residuos,40);
xlabel('residuos'); title('Histograma dos residuos: AR(2)');
set(gca, "fontsize", 14)

print -deps -color 'hist-residuos-AR2.eps'

figure; stem(fac3,'k-','linewidth',2);
xlabel('lag'); title('FAC dos residuos: AR(2)');
set(gca, "fontsize", 14)

print -deps -color 'FAC-residuos-AR2.eps'