% Implementacao de um sistema de inferencia fuzzy do tipo Mandani-2
% (desfuzifica, depois agrega)
% 
% ENTRADAS: x1 (velocidade, Km/h), x2 (raio de curvatura, m)
% SAIDA:  y (forca no pedal de freio, N)
%
% Autor: Guilherme A. Barreto 
% Data:  25/08/2021

clear; clc; close all;

% Valores medidos de x1 (VEL) e x2 (CURVATURA)
x1=57;
x2=43;

%%%%%%%%%%%%
% ETAPA 1: FUZZIFICACAO
%%%%%%%%%%%%

mi1=velocidade(x1);   % Pertinencias para variavel VELOCIDADE
mi2=curvatura(x2);     % Pertinencias para variavel CURVATURA

% Funcoes de Pertinencia (VARIAVEL DE SAIDA)
y=0:0.1:10;   % Universo de discurso da variavel de saida
mi_out=[];
for i=1:length(y),
	aux=forca_pedal_freio(y(i));
	mi_out=[mi_out; aux];
end

%%%%%%%%%%%%
% ETAPA 2: AVALIACAO DAS REGRAS FUZZY
%%%%%%%%%%%%
[mi yi]=regras2(mi1,mi2,mi_out,y);  % Conjuntos fuzzy de saida de todas as regras

%%%%%%%%%%%%
% ETAPA 3: AGREGA OS VALORES DESFUZZIFICADOS LOCAIS
%%%%%%%%%%%%
Y= sum(mi.*yi)/sum(mi)
