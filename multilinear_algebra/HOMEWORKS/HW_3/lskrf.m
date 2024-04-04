function [A,B] = lskrf(X, i, j)
% X is i*j x r
% A is i x r
% B is j x r


[~, r] = size(X); % r = 2 (A,B, and X columns)
A = zeros(i,r);
B = zeros(j,r);

for index=1:r
    xp = X(:,index); % select the column
    Xp = reshape(xp,[j,i]); % unvectorizing
    [Up,Sp,Vp] = svd(Xp);
    u1 = Up(:,1);
    v1 = Vp(:,1);
    s1 = Sp(1,1);
    
    A(:,index) = sqrt(s1)*conj(v1);
    B(:,index) = sqrt(s1)*u1;
end

end