
% Octal to binary conversion
function b = o2b(o)
switch o
    case {'0'}
        b = '000';
    case {'1'}
        b = '001';
    case {'2'}
        b = '010';
    case {'3'}
        b = '011';
    case {'4'}
        b = '100';
    case {'5'}
        b = '101';
    case {'6'}
        b = '110';
    case {'7'}
        b = '111';
end