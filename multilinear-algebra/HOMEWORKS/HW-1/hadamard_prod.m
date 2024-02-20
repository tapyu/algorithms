function out = hadamard_prod(a,b)
out = zeros(size(a));
for i = 1:length(a)
    for j = 1:length(b)
        out(i,j) = a(i,j)*b(i,j);
    end
end
end