# %% [markdown]
#   # TIP8311 - Reconhecimento de Padrões - 1o. Trabalho Computacional – 06/12/2021
# 
#   - Programa de Pós-Graduação em Engenharia de Teleinformática (PGPETI)
#   - Universidade Federal do Ceará (UFC), Centro de Tecnologia, Campus do Pici
#   - Responsável: Prof. Guilherme de Alencar Barreto
#   - Aluno: Rubem Vasconcelos Pacelli; matrícula: 519024
# 
# 
#   ---
#   **A brief comment about the data**: This dataset consists of a collection of 16 high-frequency antennas with a total transmitted power on the order of 6.4 kilowatts. Received signals were processed using an autocorrelation function whose arguments are the time of a pulse and the pulse number.  There were 17 pulse numbers for the Goose Bay system.  Instances in this database are described by two attributes per pulse number, corresponding to the complex values returned by the function resulting from the complex electromagnetic signal.
# 
#   **Key features**:
#   - Number of Attributes: 34
#   - Number of Instances: 351
#   - The 35th attribute is either "good" or "bad" according to the definition summarized above.
# 
#   ---
#   ### Question 1
# 
#   - Estimar a matriz de covariância GLOBAL (i.e. sem considerar os rótulos das classes) para o referido conjunto de dados usando o método descrito na `Eq. (100)`, usando as `Eqs. (101), (102) e (104)` para estimar a matriz de correlação.
#   - Comparar com o resultado produzido pelo comando COV nativo do Octave/Matlab ou de outra linguagem de programação de sua preferência.
# 
#   #### Solution
# 
#   Downloading the file

# %%
from urllib.request import urlretrieve
import pandas as pd
import numpy as np
from numpy.linalg import norm, matrix_rank
import os.path
import matlab.engine
from scipy.io import loadmat
import time
import matplotlib.pyplot as plt

data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data"

if not os.path.isfile("data.csv"):
    urlretrieve(data_url, "data.csv")


# %% [markdown]
#   The downloaded file is a `.csv` files with the following values (the last column is the "good" and "bad" classifier):

# %%
df = pd.read_csv (r'./data.csv')
df.head()


# %% [markdown]
#   Estimating the covariance matrix using the `Eq.(100)`.
# 
#   The covariance matrix of a vector of random variables, $\mathbf{x} \in \mathbb{R}^p$, is defined as the second-order central moments of its components, that is
# 
#   $\mathbf{C}_i = \begin{bmatrix}
#   E[(x_1 - m_1)^2]  & E[(x_1 - m_1)(x_2 - m_2)] & \cdots & E[(x_1 - m_1)(x_p - m_p)] \\
#   E[(x_2 - m_2)(x_1 - m_1)] & E[(x_2 - m_2)^2]  & \cdots & E[(x_2 - m_2)(x_p - m_p)] \\
#   \cdot    & \cdot    & \ddots & \vdots \\
#   E[(x_p - m_p)(x_1 - m_1)] & E[(x_p - m_p)(x_2 - m_2)] & \cdots & E[(x_p - m_p)^2]
#   \end{bmatrix},$
# 
#   where $x_k$ is the $k$-th element of the vector $\mathbf{x}$, $E[x_k]\triangleq m_k$ denotes the expected value of the random variable $x_k$, and $i\in \left\{1, 2, \cdots, C\right\}$ is the $i$-th class in which the covariance matrix is estimated.
# 
#   Note that the main diagonal of $\mathbf{C}_i$ is the variance of $x_k$, hereafter denoted as $\sigma_k^2$. The elements outside of the main diagonal are the covariance, which can be written as
#   $$E[(x_k - m_k)(x_l - m_l)] \triangleq \sigma_{kl} = \sigma_{k}\sigma_{l}\rho_{kl}$$
# 
#   where the last equation come from the correlation coefficient ($\rho_{kl}$) definition.
# 
#   Hence, the covariance matrix can be rewritten as
# 
#   $\mathbf{C}_i = \begin{bmatrix}
#   \sigma_1^2  & \sigma_{1}\sigma_{2}\rho_{12} & \cdots & \sigma_{1}\sigma_{p}\rho_{1p} \\
#   \sigma_{2}\sigma_{1}\rho_{21} & \sigma_2^2  & \cdots & \sigma_{2}\sigma_{p}\rho_{2p} \\
#   \cdot    & \cdot    & \ddots & \vdots \\
#   \sigma_{p}\sigma_{1}\rho_{p1} & \sigma_{p}\sigma_{2}\rho_{p2} & \cdots & \sigma_p^2
#   \end{bmatrix},$
# 
#   Using the matrix notation, $\mathbf{C}_i$ can be written as
#   \begin{align}
#   \mathbf{C}_i & = E\left[(\mathbf{x} - \mathbf{m})(\mathbf{x} - \mathbf{m})^\mathsf{T}\right] \\
#   & = E\left[\mathbf{x}\mathbf{x}^\mathsf{T} - \mathbf{x}\mathbf{m}^\mathsf{T} - \mathbf{m}\mathbf{x}^\mathsf{T} + \mathbf{m}\mathbf{m}^\mathsf{T}\right] \\
#   & = E\left[\mathbf{x}\mathbf{x}^\mathsf{T}\right] - E\left[\mathbf{x}\right]\mathbf{m}^\mathsf{T} - \mathbf{m} E\left[\mathbf{x}\right]^\mathsf{T} + \mathbf{m}\mathbf{m}^\mathsf{T} \\
#   & = \mathbf{R}_\mathbf{x} - \mathbf{m}\mathbf{m}^\mathsf{T},
#   \end{align}
# 
#   where $\mathbf{R}_\mathbf{x}$ and $\mathbf{m}$ are the correlation matrix and the mean vector of $\mathbf{x}$, respectively.
# 
#   Using a set of $N$ realizations, $\left\{\mathbf{x}(1), \mathbf{x}(2), \cdots, \mathbf{x}(N)\right\}$, the estimator of $\mathbf{R}_\mathbf{x}$ can be calculated as
#   \begin{align}
#   \mathbf{\hat{R}}_\mathbf{x} = \frac{1}{N} \sum_{n=1}^N \mathbf{x}(n)\mathbf{x}^\mathsf{T}(n)
#   \end{align}

# %%
X = df.iloc[:,:-1].to_numpy() # matrix of all realizations of the vector x (discart the last column)
N = X.shape[1] # number of realizations
def eq101(X):
    R_hat101 = 0
    N = X.shape[1] # number of realizations

    for n in range(N):
        R_hat101 = R_hat101 + np.outer(X[:,n],X[:,n])
    return R_hat101/N


# %% [markdown]
#   The estimation of the autocorrelation matrix can be computed faster using a matrix notation of all realization of the vector $\mathbf{x}$:
# 
#   \begin{align}
#   \mathbf{X} = \left\{\mathbf{x}(1)\mid \mathbf{x}(2)\mid \cdots\mid \mathbf{x}(N) \right\}
#   \end{align}
#   The estimation of the correlation matrix is simply given by
#   \begin{align}
#   \mathbf{\hat{R}}_\mathbf{x} = \frac{1}{N}\mathbf{X}\mathbf{X}^\mathsf{T}
#   \end{align}

# %%
def eq102(X):
    N = X.shape[1] # number of realizations
    return np.matmul(X, X.transpose())/N


# %% [markdown]
#   Instead of using a batch approach to compute the correlation matrix, it is possible to make it recursively. For the $n$-th realization of the vector $\mathbf{x}$, the matrix $\mathbf{\hat{R}}_\mathbf{x}(n)$ is updated to:
#   \begin{align}
#   \mathbf{\hat{R}}_\mathbf{x}(n) = \left(\frac{n-1}{n}\right)\mathbf{\hat{R}}_\mathbf{x}(n-1) + \frac{1}{n}\mathbf{x}(n)\mathbf{x}^\mathsf{T}(n)
#   \end{align}
#   where $\mathbf{\hat{R}}_\mathbf{x}(1) \triangleq \mathbf{I}_N$.

# %%
def eq104(X):
    R_hat104 = np.identity(X.shape[0])
    for n in range(N): # go from 0 up to N-1
        R_hat104 = R_hat104*n/(n+1) + np.outer(X[:,n], X[:,n])/(n+1)
    return R_hat104


# %% [markdown]
#   The estimation of the mean vector is given by
#   $$\mathbf{\hat{m}} = \frac{1}{N} \sum_{n=1}^{N} \mathbf{x}(n)$$

# %%
m_hat = np.sum(X,1)/N


# %% [markdown]
#   For each of the correlation matrices estimated in this exercise, we compute a covariance matrix using the following formula
#   $$\mathbf{\hat{C}}_\mathbf{x} = \mathbf{\hat{R}}_\mathbf{x} - \mathbf{\hat{m}}\mathbf{\hat{m}}^\mathsf{T}$$

# %%
C_hat101 = eq101(X) - np.outer(m_hat,m_hat) # Eq.(101)
C_hat102 = eq102(X) - np.outer(m_hat,m_hat) # Eq.(102)
C_hat104 = eq104(X) - np.outer(m_hat,m_hat) # Eq.(104)


# %% [markdown]
#   ### Performance comparasions
#   The following code compares these covariance matrices computed in `Python` with the built-in covariance estimation from `Matlab` (using the `cov` command). The performance is assessed in terms of the difference between the estimated matrix in `Python` and the output matrix from the built-in command in `Matlab`. Then, it is computed the Frobenius norm of each error matrix

# %%
X_matlab = matlab.double(X.tolist())

eng = matlab.engine.start_matlab()
C_matlab = np.array(eng.cov(eng.ctranspose(X_matlab),1)) # the command cov(X',1) from matlab
eng.exit()


# %%
E101 = C_hat101 - C_matlab # Eq.(101)
E102 = C_hat102 - C_matlab # Eq.(102)
E104 = C_hat104 - C_matlab # Eq.(104)

# Frobenius norm
list(map(norm, (E101, E102, E104)))



# %% [markdown]
# 
#  ---
#  ### Question 2
#  Comparar os métodos implementados no Item 1 com o comando COV nativo do Octave/Matlab ou de outra linguagem de programação que melhor lhe convier em termos de tempo de processamento. No Matlab/Octave usar os comandos tic/toc.
# 
# 
#  It is used built-in commands from `Matlab` and `Python` as benchmark performance. To enhance the reliability of the actual performance reached in Matlab, it was used a `.m` file in the own Matlab IDE. Then, the result of the elapsed time was imported to the Python code to make comparisons.

# %%
# calling the tictoc.m script from Python increases the time computation, run the script from Matlab IDE instead
# if not os.path.isfile('tictoc.mat'):
#     eng = matlab.engine.start_matlab()
#     eng.tictoc(nargout=0)
#     eng.quit()

# time elapse - matlab built-in command
time_matlab = loadmat('tictoc.mat')

# time elapse - python built-in command
start = time.perf_counter()
np.cov(X)
end = time.perf_counter()
time_python = end - start

# time elapse - Eq.(101)
start = time.perf_counter()
eq101(X)
end = time.perf_counter()
time_eq101 = end - start

# time elapse - Eq.(102)
start = time.perf_counter()
eq102(X)
end = time.perf_counter()
time_eq102 = end - start

# time elapse - Eq.(104)
start = time.perf_counter()
eq104(X)
end = time.perf_counter()
time_eq104 = end - start

fig = plt.figure()
ax = fig.add_axes([0,0,1,1])

ax.bar(["Matlab\nbuilt-in\ncommand", "Python\nbuilt-in\ncommand", "Eq.(101)", "Eq. (102)", "Eq. (104)"], [time_matlab['elapsed_time'], time_python, time_eq101, time_eq102, time_eq104])


# %% [markdown]
#  #### Conclusions
# 
#  - `Matlab` and `Python` built-in commands have a very similar performance with regard to time consumption.
#  - Eq.(102) (computation with matrix notation) outperforms the other approaches
#  - Eq.(104) had the worst performance. However, this method allows computing the covariance matrix in an online fashion.
# 
#  ---
#  ### Question 3
#  -  Escolher um dos métodos implementados no Item 1 e estimar as matrizes de covariância de cada classe
# 

# %%
Xb = df.loc[df.iloc[:,-1] == 'b'].iloc[:,:-1].to_numpy()
Xg = df.loc[df.iloc[:,-1] == 'g'].iloc[:,:-1].to_numpy()

C_hatb = np.cov(Xb)
C_hatg = np.cov(Xg)


# %% [markdown]
#  ### Question 4
#  - Avaliar a invertibilidade da matriz de covariância global e das de cada classe (matrizes de covariância locais) através do seu posto e do seu número de condicionamento.
#  - A que conclusões você pode chegar quanto a este quesito de invertibilidade das matrizes locais em relação à matriz de covariância global?

# %%
r = matrix_rank(C_hat102)
rb = matrix_rank(C_hatb)
rg = matrix_rank(C_hatg)

r, rb, rg


# %% [markdown]
#   - It is possible to notice that $r = rank(\mathbf{C})=rank(\mathbf{X})$, for both global and local set.
#   - All covariances matrices are rank-deficient, since $r \leq m$, where $m$ is the dimension of the covariance matrix. For rank-deficient and square matrices, it is not possible to invert it as there is a linear dependency on the columns vectors. Such dependency decreases the dimensionality of the column space. That is, if $\mathbf{C}\mathbf{x} = \mathbf{b}$, where $\mathbf{C}\in \mathbb{R}^{m\times m}$ is a rank-deficient matrix, the column space, which is defined by $C(\mathbf{C}) = \left\{\mathbf{b}\in \mathbb{R}^m \mid \mathbf{C}\mathbf{x} = \mathbf{b}, \forall \mathbf{x}\in \mathbb{R}^m\right\}$, does no cover all $\mathbb{R}^m$. Therefore, once applied the linear transformation, $\mathbf{C}$, on the input vector, $\mathbf{x}$, is not possible to retrieve it from $\mathbf{b}$.


