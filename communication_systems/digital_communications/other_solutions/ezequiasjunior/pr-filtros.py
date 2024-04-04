#!/usr/bin/env python3
import numpy as np 
import matplotlib.pylab as plt
import scipy.io.wavfile as wf
from scipy import signal
from scipy.fftpack import fft, fftfreq
import IPython.display as ipd
# %matplotlib
plt.style.use('seaborn')

#%%
# Lendo arquivo de audio e armazenando em uma matriz Nx2
rate, wavefile = wf.read('audio-pr-filter.wav')
print(rate, wavefile.shape)
audioL = wavefile[:, 0]
# Construindo vetor de tempo para representação do sinal:
time = np.linspace(0, audioL.size/rate, audioL.size)

#%%
# Reprodução do audio:
print('Audio:')
ipd.Audio(data=audioL, rate=rate)

#%%
# Visualização do sinal
plt.figure('audio')
plt.title('Audio')
plt.ylabel('Amplitude')
plt.xlabel('Tempo [s]')
plt.plot(time, audioL)
plt.show()

#%%
# Visualização do espectro:
# Frequências e fft do sinal de audio:
freq = fftfreq(audioL.size) * rate
Y = 2*np.abs(fft(audioL))/audioL.size
plt.figure('audio fft')
plt.title('Espectro do sinal de audio')
plt.xlabel('Frequência [Hz]')
plt.ylabel('|Y(j_omega)|')
plt.plot(freq, Y, 'C0-')
plt.xlim(0, rate/2)
plt.show()
# Psd do sinal de audio:
f, P_den = signal.welch(audioL, rate, nperseg=1024)
plt.figure()
plt.title('PSD do sinal de audio')
plt.xlabel('Frequência [Hz]')
plt.ylabel('PSD [$V^2$/Hz]')
plt.semilogy(f, P_den, 'C0-')
plt.xlim(0, rate/2)
plt.show()

#%%
# Projeto do filtro FIR:
"""
For the given filter specifications, choose
the filter length M and a window function w(n) for the narrowest main
lobe width and the smallest side lobe attenuation possible.
Fonte: Proakins
"""
def h_d(m, wc):
    """
    Função que retorna a sequência de resposta ao impulso do LPF
    ideal.
    """
    # Sample delay obtido da definição do LPF ideal:
    alpha = 0.5*(m - 1)
    # Vetor de amostras:
    n = np.arange(m)    # 0:1:M-1
    # Resposta ideal:
    return wc*np.sinc(wc*(n - alpha)/np.pi)  
    # sinc(x) = sin(pi x)/ pi x

# Especificações - modelo discreto - LPF:
delta1 = 0.01      # Tolerância banda passante
delta2 = 0.001     # Tolerância banda de atenuação

Rp = -20*np.log10((1 - delta1)/(1 + delta1))   # pass band ripple [dB]
As = -20*np.log10(delta2/(1 + delta1))         # stop band atenuation [dB]

# A partir do valor de As acima é determinada qual janela será utilizada,
# observando o valor de atenuação da faixa de rejeinção mínimo que a janela 
# proporciona. Este valor é tabelado segue tabela 7.1[Proakins - Digital
# Signal Processing Using MATLAB - 3rd ed. Cap 7]

print('Atenuação da faixa de rejeição: {:.2f} dB'.format(As))

# As frequências devem ser normalizadas !
# o máximo valor da banda de rejeição deve ser pi, pois o domínio da
# resposta em frequência do LPF ideal de fase linear é de [-pi; pi]

# Normalização tratando a frequência máxima do sinal (Nyquist: 44100/2 Hz)
# como pi, fazendo a multiplicação cruzada tem-se:
w_p = np.pi * 5e3/(0.5*rate)        # pass band freq [rad/s]
w_s = np.pi * 6.5e3/(0.5*rate)      # stop band freq [rad/s]
# Frequências acima obtidas analisando visualmente o plot da fft do sinal 
# de audio, visando resgatar apenas a parte útil do sinal bem como
# considerando o slope da queda na faixa de transição.

# Faixa de transição:
tr_width = w_s - w_p
# Frequência de corte:
w_c = 0.5*(w_s + w_p)  
print('Freqência de corte: {} Hz'.format(w_c*0.5*rate/np.pi))

# Tamanho da sequência do filtro:
# Cálculo feito a partir da relação da frequência de transição com o tamanho
# da sequência e um parâmetro característico da janela: M*df = c
# De acordo com a tabela 7.1, para janela de hamming: c = 6.6pi
M = int(np.ceil(6.6*np.pi/tr_width) + 1)
print('Tamanho da Janela calculado: {}'.format(M))

# Construindo janela:
def hamming(m):
    n = np.arange(m)
    th = n * 2*np.pi/(m - 1)
    return 0.54 - 0.46*np.cos(th)

#%%
# Visualizando janela:
plt.figure('hamming-window')
plt.stem(hamming(M))
plt.show()

w, hjw = signal.freqz(hamming(M), 1)
plt.figure('hamming-freqr')
plt.plot(w, 20*np.log10(np.abs(hjw)))
plt.show()

#%%
# Definindo e visualizando filtro LP FIR:
h_fir = h_d(M, w_c) * hamming(M)
# h_fir = signal.firwin(M, 5750, fs=rate) # função pronta para comparativo
plt.figure('FIR')
plt.stem(h_fir)
plt.show()

h_firw, h_firjw = signal.freqz(h_fir, 1)
plt.figure('FIR-freqr')
plt.plot(h_firw, 20*np.log10(np.abs(h_firjw)))
plt.show()

#%%
# Filtrando sinal:
audioL_fir = signal.lfilter(b=h_fir, a=1, x=audioL)

print(audioL_fir.size)


#%%
# Frequências e fft: audio 1
freq_fir = fftfreq(audioL_fir.size) * rate
Y_fir = 2*np.abs(fft(audioL_fir))/audioL_fir.size
plt.figure('audio filtrado FIR fft')
plt.title('Espectro do sinal de audio')
plt.xlabel('Frequência [Hz]')
plt.ylabel('|Y(j_omega)|')
plt.plot(freq_fir, Y_fir, 'C0-')
plt.xlim(0, rate/2)
plt.show()

# Psd do sinal de audio filtrado via FIR:
f_fir, P_den_fir = signal.welch(audioL_fir, rate, nperseg=1024)
plt.figure()
plt.title('PSD do sinal de audio filtrado FIR')
plt.xlabel('Frequência [Hz]')
plt.ylabel('PSD [$V^2$/Hz]')
plt.semilogy(f_fir, P_den_fir, 'C0-')
plt.xlim(0, rate/2)
plt.show()

#%%
# bode e phase, rascunho
import control
sys = control.tf(h_fir, [1], 1)
mag, phase, om = control.bode(sys)

#%%
# cascata:
so=signal.tf2sos(h_fir[::-1],1)
h_so=signal.sosfilt(so, audioL)

freq_fir = fftfreq(h_so.size) * rate
Y_fir = 2*np.abs(fft(h_so))/h_so.size
plt.figure('audio filtrado FIR fft')
plt.title('Espectro do sinal de audio')
plt.xlabel('Frequência [Hz]')
plt.ylabel('|Y(j_omega)|')
plt.plot(freq_fir, Y_fir, 'C0-')
plt.xlim(0, rate/2)
plt.show()

h_firw, h_firjw = signal.sosfreqz(so)
plt.figure('FIR-freqr')
plt.plot(h_firw, 20*np.log10(np.abs(h_firjw)))
plt.show()

#%%S
# Projeto do filtro IIR:
# Especificações contínuo:S

