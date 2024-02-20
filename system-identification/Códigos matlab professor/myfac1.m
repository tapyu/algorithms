function fac=myfac1(y,TAU)
% Implementation of the FAC (forward formula)
%
% Author: Guilherme A. Barreto
% Date: november 3rd, 2021

N=length(y);
fac = zeros(1,TAU);

for tau=0:TAU
     soma=0;
     for t=1:N-tau
       aux=y(t)*y(t+tau);
       soma=soma+aux;
     end
     fac(tau+1)=soma;%/(N-tau);
end


