function mi=forca_pedal_freio(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística FORCA_NO_PEDAL_DE_FREIO.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de FORCA BAIXA
if x>=0 & x<5,
   mi(1)=-(1/5)*(x-5);
else
   mi(1)=0;
end

% Conjunto de FORCA MEDIA
if x>0 & x<=5,
   mi(2)=(1/5)*x;
elseif x>5 & x<10,
   mi(2)=-(1/5)*(x-10);
else
   mi(2)=0;
end

% Conjunto de FORCA ALTA
if x>=5 & x<=10,
   mi(3)=(1/5)*(x-5);
else
   mi(3)=0;
end