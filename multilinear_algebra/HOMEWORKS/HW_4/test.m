load kronf_matrix.mat X A B

[m, n] = size(A);
[p, q] = size(B);
X_tilde = zeros(p*q, m*n);
X_tilde_column = 1;
for j = 0:n-1
    for i = 0:m-1
        block = X(1+i*p:(i+1)*p, 1+j*q:(j+1)*q);
        X_tilde(:, X_tilde_column) = reshape(block, [], 1);
        X_tilde_column = X_tilde_column + 1;
    end
end