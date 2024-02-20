function Y = nmodeproduct(X,U,n)
Xshiftted = shiftdim(X,n-1);
dimvecY = size(Xshiftted);
dimvecY(1) = size(U,1);
Y = U*Xshiftted(:,:);
Y = reshape(Y,dimvecY);
Y = shiftdim(Y,length(dimvecY)-n+1);
end