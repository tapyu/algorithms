function Y = nmodeproduct(X,U,n)
if numel(U) > 1
    Y_aux = nmodeproduct(X, U(1:end-1), n(end-1));
    Y = nmodeproduct(Y_aux, U(end), n(end));
else
    Xshiftted = shiftdim(X,n{1}-1);
    dimvecY = size(Xshiftted);
    dimvecY(1) = size(U{1},1);
    Y = U{1}*Xshiftted(:,:);
    Y = reshape(Y,dimvecY);
    Y = shiftdim(Y,length(dimvecY)-n{1}+1);
end
end