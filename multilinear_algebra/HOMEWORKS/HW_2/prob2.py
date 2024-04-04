# %%
from cProfile import label
from numpy import zeros, matmul, transpose as trans, multiply as hadamard
from numpy.random import rand
import timeit
from scipy.linalg import khatri_rao, pinv

A = rand(2,4) + 1j * rand(2,4)

n_set = range(0,9,2)
delta_time = zeros(len(n_set))

start = timeit.default_timer()
for n in n_set:
    X = khatri_rao(A,A)
    for _ in range(n):
        X = khatri_rao(X,A)
    stop = timeit.default_timer()
    delta_time[list(n_set).index(n)] = stop - start
# %%
import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot()

ax.semilogy(n_set,delta_time, label='$\overset{N}{\diamond}_{n=1} A_{(n)}$')
ax.set_title(f'Runtime simulation')
ax.set_xlabel("$N$")
ax.set_ylabel("time(sec)")
# # Major ticks every 10^, minor ticks every 5
major_ticks = np.array(range(1,7))*1e-4
# minor_ticks = np.arange(0, 101, 5)

# ax.set_xticks(major_ticks)
# ax.set_xticks(minor_ticks, minor=True)
ax.set_yticks(major_ticks)
# ax.set_yticks(minor_ticks, minor=True)
ax.grid(axis='both', alpha=0.5)

lines = ax.get_lines()
lines[0].set_linestyle('dashed')
lines[0].set_color('black')
lines[0].set_marker('*')

ax.legend()
# fig.savefig(f'./latex/figs/pro2.eps', format='eps')