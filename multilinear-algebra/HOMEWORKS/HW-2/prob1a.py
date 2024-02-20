# %%
from numpy import zeros, matmul, transpose as trans, multiply as hadamard
from numpy.random import rand
import timeit
from scipy.linalg import khatri_rao, pinv

delta_time_meth1 = zeros((8,2))
delta_time_meth2 = zeros((8,2))
delta_time_meth3 = zeros((8,2))
i_set = [2**power for power in range(1,9)]
r_set = range(2,5,2)

for r in r_set:
    for i in i_set:
        A = rand(i,r) + 1j * rand(i,r)
        B = rand(i,r) + 1j * rand(i,r)
        X = khatri_rao(A,B)
        # method 1
        start = timeit.default_timer()
        pinv(X)
        stop = timeit.default_timer()
        delta_time_meth1[i_set.index(i),list(r_set).index(r)] = stop - start
        # method 2
        start = timeit.default_timer()
        matmul(pinv(matmul(trans(X),X)), trans(X))
        stop = timeit.default_timer()
        delta_time_meth2[i_set.index(i),list(r_set).index(r)] = stop - start
        #method 3
        start = timeit.default_timer()
        A_T_A = matmul(trans(A),A)
        B_T_B = matmul(trans(B),B)
        matmul(pinv(hadamard(A_T_A,B_T_B)), trans(X))
        stop = timeit.default_timer()
        delta_time_meth3[i_set.index(i),list(r_set).index(r)] = stop - start
# %%

import matplotlib.pyplot as plt


for i, R in zip(range(2), range(2,5,2)):
    fig = plt.figure()
    ax = fig.add_subplot()
    
    ax.semilogy(i_set, delta_time_meth1[:,i], label='pinv(X)')
    ax.semilogy(i_set, delta_time_meth2[:,i], label='$[(\mathbf{A}\diamond \mathbf{B})^\mathsf{T}(\mathbf{A}\diamond \mathbf{B})]^{-1}(\mathbf{A}\diamond \mathbf{B})^\mathsf{T}$')
    ax.semilogy(i_set, delta_time_meth3[:,i], label='$[(\mathbf{A}^\mathsf{T}\mathbf{A})\odot(\mathbf{B}^\mathsf{T} \mathbf{B})]^{-1}(\mathbf{A}\diamond \mathbf{B})^\mathsf{T}$')
    ax.set_xlim(i_set[0],i_set[-1])
    ax.set_title(f'Runtime simulation for $R={R}$')
    ax.set_xlabel("$I$")
    ax.set_ylabel("runtime")

    lines = ax.get_lines()
    [line.set_linestyle('dashed') for line in lines]
    [line.set_marker(marker_) for line, marker_ in zip(lines, ('s', 'P', '*'))]
    ax.legend()


    # fig.savefig(f'./latex/figs/pro1_R{R}.eps', format='eps')