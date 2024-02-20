function mi=velocidade(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de VELOCIDADES BAIXAS
if x<=10,
   mi(1)=1;
elseif x>10 & x<60,
   mi(1)=-(1/50)*(x-60);
else
   mi(1)=0;
end

% Conjunto de VELOCIDADES MEDIAS
if x<=10,
   mi(2)=0;
elseif x>10 & x<=60,
   mi(2)=(1/50)*(x-10);
elseif x>60 & x<110,
   mi(2)=-(1/50)*(x-110);
else
   mi(2)=0;
end

% Conjunto de VELOCIDADES ALTAS
if x>=110,
   mi(3)=1;
elseif x>=50 & x<=110,
   mi(3)=(1/60)*(x-50);
else
   mi(3)=0;
end