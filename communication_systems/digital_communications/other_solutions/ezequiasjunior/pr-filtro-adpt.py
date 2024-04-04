##!/usr/bin/env python3
#%% imports
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
# %matplotlib inline

def bpsk_gen(n):
    """
    Função que retorna um vetor (n, 1) contando a sequência binária 
    x com valores {-1, 1}.
    """
    x = np.ones((n, 1))
    for value in x:
        if np.random.rand() < 0.5:
            value *=-1
    return x

#%% ##########################################################################

# Parâmetros do algorítimo LMS:
M = 21            # Ordem do filtro (taps)
step = 0.001      # Passo de aprendizadem

# Sequência binária:
N = 100     # Tamanho da seqência
xn = bpsk_gen(N)

# Canal:
H = np.array([0.25, 1, -0.25])
# Ruído:
sigma = np.sqrt(0.01)  # Desvio padrão a partir da ver. especificada
noise = np.random.normal(0, sigma, (N, 1))

# Sinal no receptor:
ch_out = signal.lfilter(H, 1, xn) + noise

#%% ##########################################################################

# Visualizando:
with plt.style.context('ggplot', True):
    fig, ax = plt.subplots(2, 1, sharex=True)
    ax[0].stem(xn, linefmt='C1-', markerfmt='C1o')
    ax[0].set_title('Sinal de entrada')
    ax[0].set_ylabel('Amplitude')
    ax[1].set_ylabel('Amplitude')
    ax[1].set_title('Sinal após o Canal')
    ax[1].stem(ch_out, linefmt='C0-', markerfmt='C0o')
    ax[1].set_xlabel('n')
    plt.savefig('test_fig.png')
    plt.show()

print(xn)
print(ch_out)

#%% #########################################################################

# 
L = 0 # tal que L < N
# d = xn[] 
# erro = np.zeros((N, 1))

# LMS:
# Inicializando vetor de pesos e a janela u:
w = np.zeros((M, 1))
u = np.zeros((M, 1))
# mt_W = np.zeros((N, w.size, 1))

for n in range(N):
# e = 1
# n = 0
# while abs(e) > 1e-3:
#     # Vetor u:
#     u = np.insert(u, 0, ch_out[-(n+1)])
#     u = np.delete(u, -1)
#     u = u.reshape(u.size, 1)
#     # Cálculo do erro: sinal desejado - saída do filtro
#     y = w.T @ u
#     e = xn[n - L] - y
#     # Atualiza o vetor de pesos:
#     w += step*u*e
#     #n
#     n += 1
# print('sai:', e, l, 'iter:', n)
# erro[n] = e
# mt_W[n, :] = w
    
    # Vetor u:
    u = np.insert(u, 0, ch_out[-(n+1)])
    u = np.delete(u, -1)
    u = u.reshape(u.size, 1)

    # Cálculo do erro: sinal desejado - saída do filtro
    erro[n] = xn[n - L] - w.T @ u

    # Atualiza o vetor de pesos:
    w += step*u*erro[n]    # Fonte: Haykin - Adptive Filter Theory (cap 5)
    
    mt_W[n, :] = w

#%% #########################################################################