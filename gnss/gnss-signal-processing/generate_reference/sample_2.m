function y=sample_2(seq,offset,F_seq,Fs)


T_seq=length(seq)/F_seq;

N_samples=floor(T_seq*Fs);

seq_2=[seq seq seq seq seq];

if offset < 0
    
    offset_samp=ceil(abs(offset)*Fs);
    
    offset=offset_samp/Fs-abs(offset);
    index_samp=2*N_samples+1-offset_samp:3*N_samples-offset_samp;
    
else
    index_samp=2*N_samples+1:3*N_samples;
       
end

select=ceil((index_samp*1/Fs+offset)*F_seq);

y=seq_2(select);

