function code2 = sample_3(n,fs,offset,svnum);
% code - gold code
% n - number of samples
% fs - sample frequency in Hz;
% offset - delay time in second must be less than 1/fs can not shift left
% svnum - satellite number; 
gold_rate = 1.023e6; %gold code clock rate in Hz.
ts=1/fs;
tc=1/gold_rate;
cmd1 = codegen(svnum); % generate C/A code
code in=cmd1;
% ******* sampling *******
b = [1:n];
c = ceil((ts*b+offset)/tc);
code = code a(c);
% ******* adjusting first data point *******
if offset>=0;
code2=[code(1) code(1:n-1)];
else
code2=[code(n) code(1:n-1)];
end