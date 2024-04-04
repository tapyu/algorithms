

function signal=reference_signal(PRN,offset,f_seq,fs,num_periods)

seq=cacode(PRN);

seq=repmat(seq,1,num_periods);

signal=sample_2(seq,offset,f_seq,fs);

%%plot signal check
% res=2000;
% 
% figure(1);
% [PSD,f]=pwelch(signal,res,[],[],fs,'twosided');
% plot(f-fs/2,10*log10(fftshift(PSD)),'LineWidth',1.5); grid on; 
% 
% figure(2);
% plot(1/length(signal).*xcorr(signal));
% 
% 
% S=fftshift(fft(signal));
% f=fs/2*linspace(-1,1,length(S));
% cal=trapz(f,abs(S).^2);
% % sqrt(cal)
% S=1/sqrt(cal).*S;
% figure(3)
% plot(f,10*log(S.*conj(S)));
% 
% d=-20/f_seq:0.1/f_seq:20/f_seq;
% 
% for corr_index=1:length(d)
%     
% R(corr_index)=trapz(f,(S.*conj(S)).*exp(1i*2*pi*f*d(corr_index)));    
%     
% end;
% 
% figure(4);
% plot(d*f_seq,real(R));