from numpy import inner, var, empty

# normalized autocorrelation function
def my_normalized_afc(x, tau=10):
    N = x.size
    r_k = empty(tau+1)
    for k in range(tau+1):
        r_k[k] = inner(x[:N-k], x[k:N])/(x.size - k)
    return r_k/var(x)

# Partial Autocorrelation Function (PACF)
def my_pafc(X, tau):
    r = empty(tau)
    for k in range(tau):
        r[k] = sum(X[-1,:]*X[-1-k,:])/X.shape[1]
    return r