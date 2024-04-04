function [ACQ_DATA,doppler_bin_vec,threshold,sats_found]=ca_acquisition(t,signal,fs,f_seq,num_periods)



%FFT acquisition
doppler_bin_vec=-6e3:100:6e3;
threshold=0.34e5;
sats_found=[];

for PRN=1:32
    
    %generate reference signal
    reference=reference_signal(PRN,0,f_seq,fs,num_periods);
    

for index_doppler_bin=1:length(doppler_bin_vec)
    
    doppler_bin_signal=exp(1i*2*pi*doppler_bin_vec(index_doppler_bin).*t);
    COST(index_doppler_bin,:)=abs(ifft(conj(fft(signal)).*fft(doppler_bin_signal.*reference))).^2;
    
    ACQ_DATA(PRN).cost_function=COST;
    
end;

    max_val=max(max(COST));
    
    if max_val>threshold;
        
        [max_index_row,max_index_colum]=find(COST==max_val);
        
        sats_found=[sats_found, PRN];
        
    else
        
        max_index_row=NaN;
        max_index_colum=NaN;
        
    end;
    
    ACQ_DATA(PRN).max_index=[max_index_row, max_index_colum];
    ACQ_DATA(PRN).max_val=max_val;

end;