function fac=myfac3(y,TAU)
% Implementation of the FCAC (backward formula)
%
% Author: Guilherme A. Barreto
% Date: november 3rd, 2021

N=length(y);

for tau=0:TAU,
     soma=0;
     for t=tau+1:N,
       aux=y(t)*y(t-tau);
       soma=soma+aux;
     end
     fac(tau+1)=soma/(N-tau);
end

fac=fac/var(y);


