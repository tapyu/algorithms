% Test corr
clear;
PRN=7;
f_seq=1.023e6;
fs=4e6;
num_periods=1;

delays=[-3:0.01:3].*1/f_seq;

for m=1:length(delays)

x1=reference_signal(PRN,delays(m),f_seq,fs,num_periods);
x2=reference_signal(PRN,0,f_seq,fs,num_periods);


a(m)=x1*x2';

end;

figure;grid on;
plot(delays*1.023e6,a);