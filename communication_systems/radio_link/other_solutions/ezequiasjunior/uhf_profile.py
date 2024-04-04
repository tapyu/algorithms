#!/usr/bin/env python3
#%%
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd

#%%
df = pd.read_csv('tabela_radio.csv')
x = np.array(df['x(km)'])
y = np.array(df['h(m)'])

#
k = 4/3
f = 5 #GHz
htx = 30
hrx = 30
#

hmax = max(y)
hmin = 450#min(y)
print('h max, h min: ', hmax, hmin)
dist = x[-1] - x[0] #[km]
print('dist: ',dist)
R = k * 6371 #[km]

# dh 10% h max
dh = 50#int(0.1*hmax)
print('espaço entre curvas: ',dh)
# número de arcos
m = 1 + (hmax - hmin)/dh
print('m: ', np.ceil(m))
# incremento das curvas:
dy = dh*np.arange(m) + hmin
print('Alturas das curvas: ',dy)

yaux = (-x**2 + x*dist)/(2*R*1e-3)
curvas = np.zeros((dy.size, x.size))

for i in range(dy.size): 
    curvas[i, :] = np.round(yaux) + dy[i] 

print(curvas.shape)

# alturas corrigidas [km]: 
Y = np.round(yaux) + y
print(Y.shape)

# linha de visada e fresnel:
Lv = htx + Y[0] + x*(Y[-1] + hrx - Y[0] - htx)/dist
# Lv1 =htx + y[0] + x*(y[-1] + hrx - y[0] - htx)/dist
print(Lv.shape)

fr1 = 17.3*np.sqrt(x*(dist - x)/(f*dist))

fa = Lv + fr1
fb = Lv - fr1

# f1 = Lv1 + fr1
# f2 = Lv1 - fr1

#%%
with plt.style.context('fast', True):
    for i in range(dy.size):
        mpl.rcParams['lines.linewidth'] = 0.75
        plt.plot(x, curvas[i, :], 'xkcd:grey')
    plt.grid(axis='x')
    plt.xticks(np.arange(0, x[-1], 5))
    plt.plot(x, Y)
    plt.plot(x, Lv, 'k--')
    plt.plot(x, fa, 'g-.')
    plt.plot(x, fb, 'g-.')
# n corrigido:
    # plt.plot(x, f1, 'm-.')
    # plt.plot(x, f2, 'm-.')
    # plt.plot(x, Lv1, 'r--')
    # plt.plot(x,y)
    plt.savefig('perfil-test')

#%%
# estranhamente n bateu com a tabela
print(Y)
#%%
print(curvas[0]) # bateu com a tabela

#%%
Lv

#%%
