function gray = get_gray_codes(N)
% Input: N -> Number of bits
% Output: gray -> sequence of bits [N x 2^N] in Gray code
original = zeros(N, 2^N);
for i = 1:length(original)
    aux = dec2bin(i-1, N);
    aux = double(aux) - 48;
    original(:,i) = flip(aux);
end
gray = gray_codes(original);
end

function gray = gray_codes(numbers)
N = size(numbers,1);
if N > 1
    reduced= gray_codes(numbers(1:end-1,1:end/2));
    flipped = reduced(:,end:-1:1);
    gray = [ [reduced; zeros(1, size(reduced ,2))] [flipped; ones(1, size(flipped ,2))] ];
else
    gray = [0, 1];
end
end