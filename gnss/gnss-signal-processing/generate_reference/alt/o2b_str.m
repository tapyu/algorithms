

oct_str = input('Enter octal number: ', 's');
n = length(oct_str);

bin_str = '';
for o = 1 : n
    bin_str = [bin_str o2b(oct_str(o))];
end

bin_str








