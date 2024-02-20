%% b-
% Plotagem analógica
t = 0:.01:1;
x = sin(2*pi*t) + .5*sin(6*pi*t) + (1/3)*sin(10*pi*t);
plot(t,x);

% Plotagem discreta
Ts = .025; % Tempo de amostragem
t = 0:Ts:1;
x = sin(2*pi*t) + .5*sin(6*pi*t) + (1/3)*sin(10*pi*t);
stem(t, x);

%% d- 1-

n0 = 1;
n2 = 100;
n1 = 0:1:20;

[degrau1 xdegrau1] = degrau(0,0,20);
[degrau2 xdegrau2] = degrau(0,10,20);
parcela2 = 10*exp(-.3*(n1-10)) .* degrau2;
d1 = (degrau1 - degrau2) + parcela2;
stem(n1, d1);


%% d- 2-

n2 = -5:1:5;
d2 = 2.* (delta(-5, -2, 5) - delta(-5, 4, 5));
stem(n2, d2);

%% e-

ne = -10:1:10;
e = exp((-.1+1i*.3).*ne);
stem(ne, abs(e));
stem(ne, angle(e));
stem(ne, real(e));
stem(ne, imag(e));

%% f
nf = -20:1:20;
k=5;
f = exp(.01*nf) .* sin(.1*pi*nf);

[fa, nfa] = atraso(f, nf, k);
[fi, nfi] = inverso(f, nf);

figure(1)
stem(nf, f);
title('sinal original');
figure(2)
stem(nfi, fi);
title('sinal invertido');
figure(3)
stem(nfa, fa);
title('sinal atrasado');


%% g-

ng = -20:1:120;
g = sin(ng*pi/25) .* (degrau(-20, 0, 120) - degrau(-20, 100, 120));
stem(ng, g);








