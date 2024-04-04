#%%
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqz, lfilter
#%%
f= np.linspace(4.5, 7, 100)*1e9
w = 2*np.pi*f
a, b = 1, 0.7
t = 0.63e-9
f0=5e9
w0 =f0*2*np.pi
H = a-b*np.exp(-1j*(w-w0)*t)
plt.plot(f,20*np.log10(abs(H)))

f0=4.7e9
w0 =f0*2*np.pi
H = a-b*np.exp(-1j*(w-w0)*t)
plt.plot(f,20*np.log10(abs(H)))

f0=4.9e9
w0 =f0*2*np.pi
H = a-b*np.exp(-1j*(w-w0)*t)
plt.plot(f,20*np.log10(abs(H)))

#%%
w = 0
w0 =5.2e9 *2*np.pi
ch = np.array([a, -b*np.exp(-1j*(w-w0)*t)])
# janela ....
x, y = freqz(ch)
plt.plot(x, 20*np.log10(abs(y)))
#%%
time = np.linspace(0, 1e-3, 1000) 
Ts= 1e-3
fc = 2.4
arg = 2*np.pi*fc*time
n = 0
phi = np.pi/4 * (2*n + 1)
s = np.sqrt(2/Ts) * np.exp(1j*(arg + phi))

plt.plot(time, s.real)

#%%

def gerador_simb(n):

    s = np.ones(n, dtype=complex)    
    # fases = np.array([1,3])*np.pi/4
    for i in range(n):
        if np.random.rand() < 0.5:
            s[i] *= complex(-1,0)
        else:
            s[i] *= complex(1,0)
        # s[i] *= np.exp(1j*fases[np.random.randint(2)]) 
    return s
#%%
np.set_printoptions(3)
simb = gerador_simb(2)
print(f'{simb.reshape(2,1)}')

#%%
for val in simb:
    plt.plot(val.real, val.imag,'o')

#%%
y = lfilter(ch, 1, simb)

for val in y:
    plt.plot(val.real, val.imag,'o')

#%%
