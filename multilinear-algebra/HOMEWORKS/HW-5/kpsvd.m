function [all_Uk,all_sigma,all_Vk] = kpsvd(X, mn)
% X is a M*P x N*Q
% mn is a [M, N] vector

M = mn(1);
N = mn(2);
[mp, nq] = size(X);
P = mp/M;
Q = nq/N;

X_tilde = get_X_tilde(X, [M, N]);
[U,S,V] = svd(X_tilde');

all_Uk = zeros(M,N,size(U,2));
all_Vk = zeros(P,Q,size(V,2));
if size(S,2) == 1
    all_sigma = S(1);
else
    all_sigma = diag(S);
end


for i=1:size(U,2)
    all_Uk(:,:,i) = reshape(U(:,i), [M,N]);
end

for i=1:size(V,2)
    all_Vk(:,:,i) = reshape(V(:,i), [P,Q]);
end

end

