function fac=fac_normalizada_backward(y,TAU)
% Implementation of the Normalized ACF(backward formula)
% 
% Author: Guilherme A. Barreto
% Date: november 3rd, 2021

N=length(y);
fac = zeros(TAU+1, 1);

for tau=0:TAU
     soma=0;
     for t=tau+1:N
       aux=y(t)*y(t-tau);
       soma=soma+aux;
     end
     fac(tau+1)=soma/(N-tau);
end
fac=fac/var(y);


