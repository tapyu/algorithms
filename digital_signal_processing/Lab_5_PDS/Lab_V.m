%% audios

% Em C:\Users\rubem\Google Drive\Disciplinas\Processamento Digital de Sinais\Laboratório\Lab_5_PDS

semInt = audioread('aleluia.wav');
fvtool(semInt);

comInt = audioread('aleluia_int.wav');
fvtool(comInt);


%% filtro notch
FInt = 4e3;
wInt = .4882813*pi;

N = 5000;

n1 = [1 -exp(1i*wInt)];
n2 = [1 -exp(-1i*wInt)];

num = conv(n1,n2);

[h, w] = freqz(num, 1, N);

plot(w/pi,20*log10(abs(h)))
ax = gca;
ax.YLim = [-100 20];
ax.XTick = 0:.5:2;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')

%% Audio correto

audiocorrigido = filter(num, 1, comInt);
fvtool(audiocorrigido);