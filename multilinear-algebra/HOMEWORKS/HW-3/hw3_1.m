load krf_matrix.mat X A B

m = 5; % A lines
n = 4; % B lines

[~, p] = size(X); % p = 2 (A,B, and X columns)
A_hat = zeros(m,p);
B_hat = zeros(n,p);

for index=1:p
    xp = X(:,index); % select the column
    Xp = reshape(xp,[n,m]); % unvectorizing
    [Up,Sp,VpH] = svd(Xp);
    u1 = Up(:,1);
    v1 = VpH(1,:)';
    s1 = Sp(1,1);
    
    A_hat(:,index) = sqrt(s1)*v1;
    B_hat(:,index) = sqrt(s1)*u1;
end

X_hat = kr(A_hat, B_hat);

[U_hat,S_hat,V_hat] = svd(X_hat);
[U,S,V] = svd(X);

nmse = norm(X_hat - X,'fro')/norm(X,'fro');