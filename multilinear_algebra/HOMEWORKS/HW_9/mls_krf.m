function[all_A] = mls_krf(X, all_I_n)
R = size(X, 2);
N = length(all_I_n);
all_A = cell(1,N);
for n=1:N
    all_A{n} = zeros(all_I_n(n), R); % A^(n) is a I_nxR matrix
end
for r=1:R
    x_r = X(:,r);
    ten_X_r = reshape(x_r, flip(all_I_n));
    [tenS_r, all_U_r, ~] = thosvd(ten_X_r);
    for n=1:N
        all_A{n}(:,r) = nthroot(tenS_r(1), N) * all_U_r{N-n+1}(:,1);
    end
end
end