function y=sample(seq,F_seq,Fs)

%y=sample(seq,F_seq,Fs)			
%
%           Sampled ideal signal generator.
%
%               Inputs:
%               -------
%                   - seq: Original PRN sequence (NRZ modulated -1/1)
%		            - F_seq: Chip rate (Chip/s)
%					- Fs: sampling frequency (Hz)
%
%               Output:
%               -------
%                   - y: sampled PRN signal (NRZ modulated).
%
%
%    

Nseq=length(seq);

Nppc=Fs/F_seq;	% number of samples per chip

Nsample=round(Nppc*Nseq);

t=(0:Nsample-1)/Fs;

CLK=sin(2*pi*F_seq*t);

y=seq(1)*ones(1,Nsample);

id_seq=1;

for k=2:Nsample
   
   if (CLK(k)>=0)&&(CLK(k-1)<0)
      
      id_seq=id_seq+1;
                 
   end;
   
   y(k)=seq(id_seq);
   
end;



