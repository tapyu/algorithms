% Dados coletados do Simulink
% 0 < SNR < 10 dB

BERx = 0:1:5;


%% BT09 c/ convolução; Fs = 280 MHz, FI = 70 MHz c/ BPL

 Eb_No_QPSK = [ .0857 0.0644 0.0447 0.029 0.018 .0086];

 %% BT09 c/ convolução; Fs = 280 MHz, FI = 70 MHz c/ BPL

%  Eb_No_QPSK_teorico = qfunc(sqrt(BERx)*2);
 
%% Plotagem

% semilogy(BERx, Eb_No_QPSK,'MarkerSize',8,'Marker','*', 'color', 'black');
% hold on
semilogy(BERx,Eb_No_QPSK_teorico,'MarkerSize',8,'Marker','*');
hold on




legend1 = legend('BER medido', ...
    'BER teórico');
set(legend1,  'Location','southwest', 'FontSize',15);
grid on;