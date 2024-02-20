function [tenS, varout, multilinear_ranks] = thosvd(tenX, varargin)
% varargin is the n-rank used given by the user. If no n-rank is given,
% then thosdv compute the rank of the n-mode folding of tenX and use it as
% the n-rank
N = ndims(tenX);
varout = cell(1,N);
tenS = tenX;
if isempty(varargin) % no n-rank is given
    multilinear_ranks = zeros([1, N]);
else
    multilinear_ranks = varargin{1};
end

for n=1:N
    unfolded_X = nmodeunfold(tenX, n); % n-mode unfolding
    if isempty(varargin)
        multilinear_ranks(n) = rank(unfolded_X);
    end
    [U, ~, ~] = svd(unfolded_X);
    U_n = U(:, 1:multilinear_ranks(n)); % truncated
    varout{n} = U_n;
    tenS = nmodeproduct(tenS, U_n.', n);
end
end