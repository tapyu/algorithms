function out = khatri_rao_prod(a,b)
    out = recursive_kron(a,b,1);
end

function out = recursive_kron(a,b, column)
if column < size(a,2)
    out = cat(2, kron(a(:,column), b(:,column)), recursive_kron(a, b, column+1));
else
    out = kron(a(:,column), b(:,column));
end
end