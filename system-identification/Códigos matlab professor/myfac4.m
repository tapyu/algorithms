function fac=myfac4(y,TAU)
% Implementation of the FAC (forward formula)
%
% Author: Guilherme A. Barreto
% Date: november 3rd, 2021

N=length(y);

y=y(:);

for tau=0:TAU,
     fac(tau+1)=y(1:N-tau)'*y(tau+1:N)/(N-tau);
end


