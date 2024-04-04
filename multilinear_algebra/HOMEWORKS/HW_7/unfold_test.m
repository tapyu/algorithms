function [X] = unfold_test( T, i )
dim = size(T);
X = reshape(shiftdim(T,i-1), dim(i), []);
end