function [A,B] = lskf(X,mn)
% X is m*p-by-n*q matrix
% A is a m-by-n matrix
% B is a p-by-q matrix

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

[U,S,V] = svd(X_tilde);

u1 = U(:,1);
v1 = V(:,1);
sigma1 = S(1,1);

vecA = sqrt(sigma1) * v1;
vecB = sqrt(sigma1) * u1;

A = reshape(vecA, [m, n]);
B = reshape(vecB, [p, q]);

end