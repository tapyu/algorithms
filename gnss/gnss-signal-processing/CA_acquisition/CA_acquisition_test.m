function ACQ_DATA=CA_acquisition_test(t,signal,fs,f_seq,num_periods)



%FFT acquisitiof
doppler_bin_vec=-5e3:100:5e3;

for PRN=1:32
    
    %generate reference signal
    reference=reference_signal(PRN,0,f_seq,fs,num_periods);
    

for index_doppler_bin=1:length(doppler_bin_vec)
    
    doppler_bin_signal=exp(1i*2*pi*doppler_bin_vec(index_doppler_bin).*t);
    COST(index_doppler_bin,:)=abs(ifft(conj(fft(signal)).*fft(doppler_bin_signal.*reference))).^2;
    
    ACQ_DATA(PRN).cost_function=COST;
end;

end;