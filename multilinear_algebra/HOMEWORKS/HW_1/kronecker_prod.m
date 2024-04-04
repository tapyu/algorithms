function out = kronecker_prod(a,b)
% out = zeros(size(a,1)*size(b,1), size(a,2)*size(b,2));

lines1 = recursive_columns(a, 1, 1, b);
lines2 = recursive_columns(a, 2, 1, b);
out = recursive_lines(lines1, 2, lines2, a, b);
end

function out = recursive_lines(lines1, line, lines2, a, b)
if line+1 > size(a,1)
    out = cat(1, lines1, lines2);
else
    new_lines = recursive_columns(a,line+1,1,b);
    out = cat(1, lines1, recursive_lines(lines2, line+1, new_lines, a, b));
end
end

function out = recursive_columns(a, line, column, b)
if column+2 > size(b,2)
        out = cat(2, a(line,column)*b, a(line,column+1)*b);
else
    out = cat(2, a(line,column)*b, recursive_columns(a, line, column+1, b));
end
end