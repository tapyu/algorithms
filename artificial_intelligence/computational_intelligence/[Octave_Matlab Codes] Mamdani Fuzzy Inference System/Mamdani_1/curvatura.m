function mi=curvatura(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística RAIO_DE_CURVATURA.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de CURVATURAS PEQUENAS
if x<=10,
   mi(1)=1;
elseif x>10 & x<50,
   mi(1)=-(1/40)*(x-50);
else
   mi(1)=0;
end

% Conjunto de CURVATURAS MEDIAS
if x<=10,
   mi(2)=0;
elseif x>10 & x<=40,
   mi(2)=(1/30)*(x-10);
elseif x>40 & x<70,
   mi(2)=-(1/30)*(x-70);
else
   mi(2)=0;
end

% Conjunto de CURVATURAS ALTAS
if x>=70,
   mi(3)=1;
elseif x>=40 & x<=70,
   mi(3)=(1/30)*(x-40);
else
   mi(3)=0;
end