%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST acquisition and tracking
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%D:\MATLAB\GNSS_receivers\GMB_2022
addpath('.\generate_reference'); 
addpath('.\read_data');
addpath('.\CA_acquisition');

clear all; close all;

PlotFlag = 'All';
PlotFlag ='Basic';

%parameters
fs=4e6;
T_d=1e-3;
f_seq=1.023e6;
Ts=1/fs;
Tc=1/f_seq;
f_c=1575.42e6;
num_periods=1;
Delta=0.5*Tc;
K=3000;
N=num_periods*fs*T_d;
N_acq=fs*T_d;
index_sample_in=60*N;



%signal file paramters
fileName='.\data\signal_source_L1E1_GNSSR_3.dat';

delay=[];
phase=[];
doppler=[];
phase_doppler=[];
error_signal_delay=[];
error_signal_phase=[];
error_signal_doppler=[];
corr_early=[];
corr_late=[];
corr_prompt=[];
I=[];
Q=[];


for k=1:K
    
    %read signal
    [x, index_sample_out,end_file] = read_gr_complex_binary(fileName, index_sample_in, N);
    
    if end_file==1
        break;
    end;
    disp(index_sample_in);
    
    index_sample_in=index_sample_out;
    
    %time
    %t=((k-1)*N)*Ts:Ts:((k-1)*N+N-1)*Ts;
    t=0:Ts:(N-1)*Ts;
    if k<=1
     
        
        %acquisition
        if exist('ACQ_DATA_L1E1_GNSSR_3.mat')~=2;
            
            [ACQ_DATA,doppler_bin_vec,threshold,sats_found]=ca_acquisition(t(1:N_acq),x(1:N_acq),fs,f_seq,1);
            
            save ACQ_DATA_L1E1_GNSSR_3.mat ACQ_DATA doppler_bin_vec threshold sats_found;
            
        else
            
            load ACQ_DATA_L1E1_GNSSR_3.mat;
            
        end;
        disp(sats_found);
        %delay and Doppler acquisition
        for m=1:length(sats_found)
            delay=[delay ACQ_DATA(sats_found(m)).max_index(2)*Ts];
            phase=[phase 0];
            doppler=[doppler doppler_bin_vec(ACQ_DATA(sats_found(m)).max_index(1))];
            phase_doppler=[phase_doppler 0];
            error_signal_delay=[error_signal_delay 0];
            error_signal_phase=[error_signal_phase 0];
            error_signal_doppler=[error_signal_doppler 0];
            corr_early=[corr_early 0];
            corr_late=[corr_late 0];
            corr_prompt=[corr_prompt 0];
            Q=[Q 0];
            I=[I 0];
 
        end;
        
    else
        
        %DLL, PLL, FLL
        
        for m=1:length(sats_found)
            
    
    
            %doppler
            x_d_H=conj(conj(x).*exp(1i*(phase_doppler(k-1,m)+2*pi*doppler(k-1,m).*t)))';
            
            %correlators
            delay_early=delay(k-1,m)+Delta;
            delay_late=delay(k-1,m)-Delta;
            delay_prompt=delay(k-1,m);
%             
%                 delays=delay(k-1,m)+([-2:0.01:2].*1/f_seq);
%             
%             
%                 for n=1:length(delays)
%             
%                     x_r=reference_signal(sats_found(m),delays(n),f_seq,fs,num_periods)';
%             
%                     ACF(k-1,m,n)=conj(x_d_H)'*x_r;
%             
%             
%                 end;
            
            ref_early=reference_signal(sats_found(m),delay_early,f_seq,fs,num_periods)';
            ref_late=reference_signal(sats_found(m),delay_late,f_seq,fs,num_periods)';
            ref_prompt=reference_signal(sats_found(m),delay_prompt,f_seq,fs,num_periods)';
            
            corr_early(k-1,m)=(conj(x_d_H)'*ref_early)/N;
            corr_late(k-1,m)=(conj(x_d_H)'*ref_late)/N;
            corr_prompt(k-1,m)=(conj(x_d_H)'*ref_prompt)/N;
            
            
            %DLL
               
            error_signal_delay(k-1,m)=abs(corr_early(k-1,m))^2-abs(corr_late(k-1,m))^2;
            
%             if(0) % test corr values
%                 figure(1)
%                 dt = Tc/50;
%                 tau = delay_prompt - Tc:dt: delay_prompt + Tc;
%                 for idx =1:length(tau)
%                     ref_prompt_test              =   reference_signal(sats_found(m),tau(idx),f_seq,fs,num_periods)';
%                     R(idx)                  =    (conj(x_d_H)'*ref_prompt_test)/N;
%                 end
%                 plot(tau/Tc,abs(R).^2,'linewidth',2); grid on; hold on;
%                 stem(delay_prompt/Tc,abs(corr_prompt(k-1,m).^2) ,'filled','linestyle','none','color','black')
%                 stem(delay_early/Tc,abs(corr_early(k-1,m)).^2 ,'filled','linestyle','none','color','green')
%                 stem(delay_late/Tc,abs(corr_late(k-1,m)).^2,'filled','linestyle','none','color','green')
%                 title(['Discr Value = ', num2str(abs(corr_early(k-1,m))^2-abs(corr_late(k-1,m))^2) ])
%             end
%             if(0) % plot waveform
%                  figure(5)
%                  plot(real(x_d_H) , 'linewidth',2  ); hold on;
%                  plot(ref_prompt, 'linewidth',2  ); 
%             end
            
            %
            %first order DLL
            K_tau=Tc/(2*abs(corr_prompt(k-1,m))^2);
            K_tau_1=0.03;
            a_tau_0=K_tau_1;
            B_tau_1=K_tau_1/(2*(2-K_tau_1))/T_d;
            delay(k,m)=delay(k-1,m)+K_tau*a_tau_0*error_signal_delay(k-1,m);
                
            
            %PLL
            Q(k-1,m)=imag(corr_prompt(k-1,m)*exp(1i*phase(k-1,m)));
            I(k-1,m)=real(corr_prompt(k-1,m)*exp(1i*phase(k-1,m)));
           
            %Q(k-1,m)=imag(corr_prompt(k-1,m));
            %I(k-1,m)=real(corr_prompt(k-1,m));
            
            error_signal_phase(k-1,m)=-atan(Q(k-1,m)/I(k-1,m));
            
            
            %second order PLL
            if k<3
                phase(k,m)=phase(k-1,m)+0.5*error_signal_phase(k-1,m);
                
                
            else
                %B_phi=200 Hz, supercritically damped response, no
                %computation delay (book Betz)
                K_phi_1=0.438;
                K_phi_2=0.00626;
                K_phi=1;
                a_phi_0=K_phi_1+K_phi_2;
                a_phi_1=K_phi_2;
                B_phi_2=((2*K_phi_1^2+2*K_phi_2+K_phi_1*K_phi_2)/(2*K_phi_1*(4-2*K_phi_1-K_phi_2)))/T_d;
                phase(k,m)=2*phase(k-1,m)-phase(k-2,m)+a_phi_0*K_phi*error_signal_phase(k-1,m)+K_phi*(a_phi_1-a_phi_0)*error_signal_phase(k-2,m);
                
            end;
            
            
            
            
            if k<4
                doppler(k,m)=doppler(k-1,m);
                error_signal_doppler(k-1,m)=0;
                
                
            else
                %FLL
                phase_1=-atan(imag(corr_prompt(k-1,m))/real(corr_prompt(k-1,m)));
                phase_2=-atan(imag(corr_prompt(k-2,m))/real(corr_prompt(k-2,m)));
                
                
                %disc_nu=phase_1-phase_2;
                                 
                %disc_nu=-atan(((imag(corr_prompt(k-1,m))*real(corr_prompt(k-2,m)))- (imag(corr_prompt(k-2,m))*real(corr_prompt(k-1,m))))/((real(corr_prompt(k-1,m))*real(corr_prompt(k-2,m)))+(imag(corr_prompt(k-1,m))*imag(corr_prompt(k-2,m)))));
                              
                disc_nu=-atan2((imag(corr_prompt(k-1,m))*real(corr_prompt(k-2,m)))- (imag(corr_prompt(k-2,m))*real(corr_prompt(k-1,m))),(real(corr_prompt(k-1,m))*real(corr_prompt(k-2,m)))+(imag(corr_prompt(k-1,m))*imag(corr_prompt(k-2,m))));
                
                error_signal_doppler(k-1,m)=disc_nu/(2*pi*num_periods*T_d);
                
                             
                %first order FLL
%                 K_nu=1;
%                 K_nu_1=0.03;
%                 a_nu_0=K_nu_1;
%                 B_nu=K_nu_1/(2*(2-K_nu_1))/T_d;
%                 doppler(k,m)=doppler(k-1,m)+K_nu*a_nu_0*error_signal_doppler(k-1,m);
                
                
                
                %second order FLL
                %B_nu=1 Hz, standard underdamped response modified, no computation delay
%                 K_nu_1=0.003193;
%                 K_nu_2=2.553e-6;
%                 K_nu=1;
%                 a_nu_0=K_nu_1+K_nu_2;
%                 a_nu_1=K_nu_2;
%                 B_nu=((2*K_nu_1^2+2*K_nu_2+K_nu_1*K_nu_2)/(2*K_nu_1*(4-2*K_nu_1-K_nu_2)))/T_d;
%                 doppler(k,m)=2*doppler(k-1,m)-doppler(k-2,m)+a_nu_0*K_nu*error_signal_doppler(k-1,m)+K_nu*(a_nu_1-a_nu_0)*error_signal_doppler(k-2,m);
%                 
                %third order FLL
                 %B_nu=1 Hz, supercritically damped response, no computation delay
                 K_nu_1=0.002903;
                 K_nu_2=2.812e-6;
                 K_nu_3=9.084e-10;
                 K_nu=1; %tuning
                 a_nu_0=(K_nu_1+K_nu_2+K_nu_3);
                 a_nu_1=(K_nu_2+2*K_nu_3);
                 a_nu_2= K_nu_3;
                 doppler(k,m)=3*doppler(k-1,m)-3*doppler(k-2,m)+doppler(k-3,m)+a_nu_0*K_nu*error_signal_doppler(k-1,m)+K_nu*(a_nu_1-2*a_nu_0)*error_signal_doppler(k-2,m)+K_nu*(a_nu_0-a_nu_1)*error_signal_doppler(k-3,m);
%             

                
            end;
            
            
            phase_doppler(k,m)=phase_doppler(k-1,m)+2*pi*doppler(k,m)*T_d;
            
            
        end;
        
        
        
    end;
    
end;


%Plot
%tracking error_signal
figure('Name','Delay error','NumberTitle','off');
plot(error_signal_delay); grid on;

figure('Name','Delay','NumberTitle','off');
plot(delay); grid on;

figure('Name','Phase error','NumberTitle','off');
plot(error_signal_phase);grid on;

figure('Name','Carrier Phase','NumberTitle','off');
plot(phase);grid on;

figure('Name','Doppler error','NumberTitle','off');
plot(error_signal_doppler);grid on;

figure('Name','Doppler shift','NumberTitle','off');
plot(doppler);grid on;

figure('Name','In-Phase','NumberTitle','off');
plot(I);grid on;

figure('Name','Quadrature','NumberTitle','off');
plot(Q);grid on;





