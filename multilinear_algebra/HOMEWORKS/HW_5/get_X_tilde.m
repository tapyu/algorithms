function X_tilde = get_X_tilde(X,mn)
% X is m*p-by-n*q matrix
% m is the number of blocks in the lines
% n is the number of blocks in the columns

m = mn(1);
n = mn(2);
[mp, nq] = size(X);
p = mp/m;
q = nq/n;


X_tilde = zeros(p*q, m*n);
column_index = 1;
for j = 0:n-1
    for i = 0:m-1
        block = X(1+i*p:(i+1)*p, 1+j*q:(j+1)*q);
        X_tilde(:, column_index) = reshape(block, [], 1);
        column_index = column_index + 1;
    end
end
end

