function [tenS, all_U, multilinear_ranks] = thosvd(tenX)
    sizeX = size(tenX);
    tenS = tenX;
    multilinear_ranks = zeros([1, length(sizeX)]);
    for n=1:length(sizeX)
        unfolded_X = nmodeunfold(tenX, n); % n-mode unfolding
        multilinear_ranks(n) = rank(unfolded_X);
        [U, ~, ~] = svd(unfolded_X);
        U_n = U(:, 1:multilinear_ranks(n)); % truncated
        all_U{n} = U_n;
        tenS = nmodeproduct(tenS, U_n.', n);
    end
end