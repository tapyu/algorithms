function mi=temperatura(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística TEMPERATURA.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de TEMPERATURAS BAIXAS
if x<=25,
   mi(1)=1;
elseif x>25 & x<50,
   mi(1)=-(1/25)*(x-50);
else
   mi(1)=0;
end

% Conjunto de TEMPERATURAS MEDIAS
if x<=25,
   mi(2)=0;
elseif x>25 & x<=50,
   mi(2)=(1/25)*(x-25);
elseif x>50 & x<75,
   mi(2)=-(1/25)*(x-75);
else
   mi(2)=0;
end

% Conjunto de TEMPERATURAS ALTAS
if x>=75,
   mi(3)=1;
elseif x>=50 & x<=75,
   mi(3)=(1/25)*(x-50);
else
   mi(3)=0;
end