%% Questão 2 - b

M = 200;
n1 = -10;
n2 = 10;
nx = n1:1:n2;

x = (-.9).^nx;

[X, nX] = DTFT(M, x);

figure(1)
stem(nX,abs(X));
title('módulo X');
xlabel('k');
ylabel('módulo X');

figure(2)
stem(nX,angle(X));
title('fase X');
xlabel('k');
ylabel('fase X');

%% Questão 2 - c

M = 100;
n1 = 0;
n2 = 100;
nx = n1:1:n2;

x = cos(pi*nx/2);
y = exp(1i*pi*nx/4).*x;

% x
[X, nX] = DTFT(M, x);

figure(1)
stem(nX,abs(X));
title('módulo X');
xlabel('k');
ylabel('módulo X');

figure(2)
stem(nX,angle(X));
title('fase X');
xlabel('k');
ylabel('fase X');

% y
[Y, nY] = DTFT(M, y);

figure(3)
stem(nY,abs(Y));
title('módulo Y');
xlabel('k');
ylabel('módulo Y');

figure(4)
stem(nY,angle(Y));
title('fase Y');
xlabel('k');
ylabel('fase Y');


%% Questão 2 - d
M = 100;
nH = -M:1:M;

H = (1+ 2*exp(-1i*nH*pi/M) + exp(-1i*2*nH*pi/M)) ./ (1+ .5*exp(-1i*2*nH*pi/M));

figure(5)
stem(nH,abs(H));
title('módulo H');
xlabel('k');
ylabel('módulo H');

figure(6)
stem(nH,angle(H));
title('fase H');
xlabel('k');
ylabel('fase H');
