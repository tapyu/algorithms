clear; clc; 

%% O objetivo do exemplo eh mostrar a propriedade de diagonalizacao
%% da matriz de covariancia dos dados. Em outras palavras, verificar
%% se a matriz de covariancia dos dados transformados Z eh diagonal
%% e se as variancias sao iguais aos autovalores da matriz de covariancia
%% Cx (dados originais).

%% Autor: Guilherme Barreto
%% Data: 17/03/2021 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gera dados gaussianos com atributos nao-correlacionados  %%
%% a partir de dados com atributos descorrelacionados       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m1=5;  % Media teorica do atributo 1
sig1 = 1; % Desvio-padrao teorico do atributo 1

m2=-5; % Media teorica do atributo 2
sig2 = 2; % Desvio-padrao teorico do atributo 2
 
m3=0; % Media teorica do atributo 3
sig3 = 3; % Desvio-padrao teorico do atributo 3

N = 50000;   % Quantidade de observacoes geradas de cada atributo
X1=normrnd(m1,sig1,1,N);
X2=normrnd(m2,sig1,1,N);
X3=normrnd(m3,sig1,1,N);

Xu=[X1; X2; X3];  % Agrupa dados dos atributos em uma unica matriz

% Matriz desejada para os dados
Cd=[1 0.8 -0.9;0.8 4 0.6;-0.9 0.6 9];

R=chol(Cd);  % Decomposicao de Cholesky da matriz Cd

Xc=R'*Xu;  % Gera dados com atributos correlacionados com a matriz COV desejada

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Aplicacao de PCA aos dados correlacionados gerados no  %%
%% procedimento anterior.                                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cx = cov(Xc');  % Estima a matriz de covariancia dos dados simulados
%[V L]=eig(Cx); L=diag(L);
%[L I]=sort(L,'descend'); V=V(:,I);

[V L] = pcacov(Cx);  % Calcula autovalores e autovetores da matriz Cx

Q = V';  % Monta matriz de transformacao
Z = Q*Xc;  % Gera dados via PCA (descorrelaciona matriz dos dados)

Xr = Q'*Z;  % Conjunto de dados original recuperado a partir de Z

erro = norm(Xc-Xr,'fro');  % Norma de Frobenius para calcular o erro.

% Conferencia das propriedades dos dados gerados
Cz = cov(Z');



