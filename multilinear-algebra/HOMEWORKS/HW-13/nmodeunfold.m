function X_mat = nmodeunfold(X, n)
    dim_orders = 1:ndims(X);
    dim_orders(n) = []; % delete this position
    X_perm = permute(X, [n dim_orders]);
    X_mat = reshape(X_perm, size(X,n), []);
end