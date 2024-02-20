% Gera sinal AR(1) e estima a FAC.

clear; clc; close all;

dp=0.1;   % Desvio-padrao do ruido
a1=0.85;  % coeficiente 
N=5000;

%x(1)=dp*randn;  % valor inicial
%for n=2:2*N,
%  x(n) = a1*x(n-1) + dp*randn;
%end
%x=x(N+1:end);  % descarta metade inicial (warm-up) para evitar influencia da condicao inicial

x=filter(1,[1 -a1],dp*randn(1,N)); % AR usando a funcao FILTER do Octave/Matlab

TAUmax=50;

tic; fac1=myfac1(x,TAUmax); t1=toc;
tic; fac2=myfac2(x,TAUmax); t2=toc;
tic; fac3=myfac3(x,TAUmax); t3=toc;
tic; fac4=myfac4(x,TAUmax); t4=toc;
tic; fac5=xcorr(x,[],TAUmax,'unbiased'); t5=toc;

figure; stem(fac1)
figure; stem(fac2)
figure; stem(fac3)
figure; stem(fac5);

[fac1(:) fac2(:) fac4(:) fac5(end-TAUmax:end)']

[t1 t2 t4 t5]