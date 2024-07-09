function RULE_OUT=regras(mi1,mi2,mi_out,y)
% Exemplo simples de base de regras nebulosas
%
% ENTRADA
%     mi1: graus de pertinencia da variavel x1 (velocidade, Km/h)
%     mi2: graus de pertinencia da variavel x2 (raio de curvatura, m)
%     mi_out: funcoes de pertinencia da variavel de saida y (forca no pedal de freio, N)
%
% SAIDA
%
%    RULE_OUT: Conjuntos fuzzy de saida modificados para todas as regras    
%
% Autor: Guilherme A. Barreto
% Data: 03/10/2009


%% REGRA 1 %%%%
%
% SE (VELOCIDADE = ALTA) E (CURVATURA = PEQUENA) , 
% ENTAO (FORCA_PEDAL_FREIO = ALTA)
%

m1=min(mi1(3),mi2(1));
mi_out_R1=min(m1,mi_out(:,3));

figure;
plot(y,mi_out_R1); hold on; plot(y,m1*ones(length(y)),'k.');
xlabel('Forca no pedal de freio');
title('Conjunto Fuzzy de Saida - REGRA 1');
axis([0 10 0 1.2]); hold off


%% REGRA 2 %%%%
%
% SE (VELOCIDADE = ALTA) E (CURVATURA = ALTA) , 
% ENTAO (FORCA_PEDAL_FREIO = BAIXA)
%

m2=min(mi1(3),mi2(3));
mi_out_R2=min(m2,mi_out(:,1));

figure;
plot(y,mi_out_R2); hold on; plot(y,m2*ones(length(y)),'k.');
xlabel('Forca no pedal de freio');
title('Conjunto Fuzzy de Saida - REGRA 2');
axis([0 10 0 1.2]); hold off

RULE_OUT=[mi_out_R1'; mi_out_R2'];

