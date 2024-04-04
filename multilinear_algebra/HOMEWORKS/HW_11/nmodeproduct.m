function Y = nmodeproduct(X,U,n)
if iscell(U)
    Y = nmodeproduct1_by_1(X, U{1}, 1);
    for i = 2:numel(U)
        Y = nmodeproduct1_by_1(Y, U{i}, n(i));
    end
else
    Y = nmodeproduct1_by_1(X,U,n);
end
end

function Y = nmodeproduct1_by_1(X,U,n)
Xshiftted = shiftdim(X,n-1);
dimvecY = size(Xshiftted);
dimvecY(1) = size(U,1);
Y = U*Xshiftted(:,:);
Y = reshape(Y,dimvecY);
Y = shiftdim(Y,length(dimvecY)-n+1);
end