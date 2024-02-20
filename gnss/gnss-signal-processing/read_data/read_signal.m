%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Signal read
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

fs=4e6;
T_d=1e-3;
fileName='D:\MATLAB\EET-65\Lab_1_2\data\signal_source_L1_E1_4_ITA_2.dat';


num_samples_block=fs*T_d;

index_hold=0;
for index_sample_in=8e5:num_samples_block:1e6;
[data_out, index_sample_out] = read_gr_complex_binary (fileName, index_sample_in, num_samples_block);

if isnan(index_sample_out); 
    break;
end;

res=500;
figure(1);
[PSD,f]=pwelch(data_out,res,[],[],fs,'twosided');
plot(f-fs/2,10*log10(fftshift(PSD)),'LineWidth',1.5); grid on; 
if index_hold==0
    hold on;
    index_hold=1;
end;


end;