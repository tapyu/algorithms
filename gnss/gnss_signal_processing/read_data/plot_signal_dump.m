%read signal dump of GNSS-sdr receiver, gr_complex
clear; 
clc;
num_samples = 60000;
offs=900000;
fileName_1 = 'signal_source_L1_E1_4.dat';
fileName_2 = 'signal_source_L1_E1_4_n.dat';
fileName_3 = 'signal_source_L1_E1_8.dat';
fileName_4 = 'signal_source_L1_E1_8_n.dat';
fileName_5 = 'signal_source_L1_E1_10.dat';
fileName_6 = 'signal_source_L1_E1_10_n.dat';
fileName_7 = 'signal_source_L1_E1_12_5.dat';
fileName_8 = 'signal_source_L1_E1_12_5_n.dat';
fileName_9 = 'signal_source_L1_E1_16.dat';
fileName_10 = 'signal_source_L1_E1_16_n.dat';
fileName_11 = 'signal_source_L1_E1_20.dat';
fileName_12 = 'signal_source_L1_E1_20_n.dat';

[fid, message] = fopen(fileName_1, 'rb');
fseek(fid, offs, 0);

[data_1, count] = fread(fid, [2, num_samples], 'float');
data_1 = data_1(1,:) + data_1(2,:).*1i; %Inphase and Quadrature
fclose('all');


[fid, message] = fopen(fileName_2, 'rb');
fseek(fid, offs, 0);

[data_2, count] = fread(fid, [2, num_samples], 'float');
data_2 = data_2(1,:) + data_2(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_3, 'rb');
fseek(fid, offs, 0);

[data_3, count] = fread(fid, [2, num_samples], 'float');
data_3 = data_3(1,:) + data_3(2,:).*1i; %Inphase and Quadrature

[fid, message] = fopen(fileName_4, 'rb');
fseek(fid, offs, 0);

[data_4, count] = fread(fid, [2, num_samples], 'float');
data_4 = data_4(1,:) + data_4(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_5, 'rb');
fseek(fid, offs, 0);

[data_5, count] = fread(fid, [2, num_samples], 'float');
data_5 = data_5(1,:) + data_5(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_6, 'rb');
fseek(fid, offs, 0);

[data_6, count] = fread(fid, [2, num_samples], 'float');
data_6 = data_6(1,:) + data_6(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_7, 'rb');
fseek(fid, offs, 0);

[data_7, count] = fread(fid, [2, num_samples], 'float');
data_7 = data_7(1,:) + data_7(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_8, 'rb');
fseek(fid, offs, 0);

[data_8, count] = fread(fid, [2, num_samples], 'float');
data_8 = data_8(1,:) + data_8(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_9, 'rb');
fseek(fid, offs, 0);

[data_9, count] = fread(fid, [2, num_samples], 'float');
data_9 = data_9(1,:) + data_9(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_10, 'rb');
fseek(fid, offs, 0);

[data_10, count] = fread(fid, [2, num_samples], 'float');
data_10 = data_10(1,:) + data_10(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_11, 'rb');
fseek(fid, offs, 0);

[data_11, count] = fread(fid, [2, num_samples], 'float');
data_11 = data_11(1,:) + data_11(2,:).*1i; %Inphase and Quadrature
fclose('all');

[fid, message] = fopen(fileName_12, 'rb');
fseek(fid, offs, 0);

[data_12, count] = fread(fid, [2, num_samples], 'float');
data_12 = data_12(1,:) + data_12(2,:).*1i; %Inphase and Quadrature
fclose('all');

res=1000;
figure(1);
Fs_1=4e6;
[PSD_1,f_1]=pwelch(data_1,res,[],[],Fs_1,'twosided');
plot(f_1-Fs_1/2,10*log10(fftshift(PSD_1)),'k','LineWidth',1.5); title PSD; legend 4MHz; grid on; hold on;
[PSD_2,f_2]=pwelch(data_2,res,[],[],Fs_1,'twosided');
plot(f_2-Fs_1/2,10*log10(fftshift(PSD_2)),'r','LineWidth',1.5); title PSD; legend 4MHz N4MHz;

figure(2);
Fs_2=8e6;
[PSD_3,f_3]=pwelch(data_3,res,[],[],Fs_2,'twosided');
plot(f_3-Fs_2/2,10*log10(fftshift(PSD_3)),'b','LineWidth',1.5); title PSD; legend 8MHz;grid on; hold on; 
[PSD_4,f_4]=pwelch(data_4,res,[],[],Fs_2,'twosided');
plot(f_4-Fs_2/2,10*log10(fftshift(PSD_4)),'r','LineWidth',1.5); title PSD; legend 8MHz N8MHz; 

figure(3);
Fs_3=10e6;
[PSD_5,f_5]=pwelch(data_5,res,[],[],Fs_3,'twosided');
plot(f_5-Fs_3/2,10*log10(fftshift(PSD_5)),'b','LineWidth',1.5); title PSD; legend 10MHz;grid on; hold on; 
[PSD_6,f_6]=pwelch(data_6,res,[],[],Fs_3,'twosided');
plot(f_6-Fs_3/2,10*log10(fftshift(PSD_6)),'r','LineWidth',1.5); title PSD; legend 10MHz N10MHz; 


figure(4);
Fs_4=12.5e6;
[PSD_7,f_7]=pwelch(data_7,res,[],[],Fs_4,'twosided');
plot(f_7-Fs_4/2,10*log10(fftshift(PSD_7)),'b','LineWidth',1.5); title PSD; legend 12.5MHz;grid on; hold on; 
[PSD_8,f_8]=pwelch(data_8,res,[],[],Fs_4,'twosided');
plot(f_8-Fs_4/2,10*log10(fftshift(PSD_8)),'r','LineWidth',1.5); title PSD; legend 12.5MHz N12.5MHz;

figure(5);
Fs_5=16e6;
[PSD_9,f_9]=pwelch(data_9,res,[],[],Fs_5,'twosided');
plot(f_9-Fs_5/2,10*log10(fftshift(PSD_9)),'b','LineWidth',1.5); title PSD; legend 16MHz;grid on; hold on; 
[PSD_10,f_10]=pwelch(data_10,res,[],[],Fs_5,'twosided');
plot(f_10-Fs_5/2,10*log10(fftshift(PSD_10)),'r','LineWidth',1.5); title PSD; legend 16MHz N16MHz;

figure(6);
Fs_6=20e6;
[PSD_11,f_11]=pwelch(data_11,res,[],[],Fs_6,'twosided');
plot(f_11-Fs_6/2,10*log10(fftshift(PSD_11)),'b','LineWidth',1.5); title PSD; legend 20MHz;grid on; hold on; 
[PSD_12,f_12]=pwelch(data_12,res,[],[],Fs_6,'twosided');
plot(f_12-Fs_6/2,10*log10(fftshift(PSD_12)),'r','LineWidth',1.5); title PSD; legend 20MHz N20MHz;




