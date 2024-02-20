function r = FAC_as_builtin(y,TAU)
c0 = var(y);
r = zeros(1,TAU+1);
N = numel(y);

for tau=0:TAU
    ck = 0;
    for t=1:N-tau
        ck = ck + (y(t)-mean(y)).*(y(t+tau)-mean(y));
    end
    ck = ck/N;
    r(tau+1) = ck/c0;
end
end