function [p, all_f] = my_periogram(g,Fs)
% This function immitates the built-in function
% periogram()


N = numel(g);
% Nyquist theorem
W = Fs/2;
all_f = 0:Fs/N:W;

% DFT
G = fft(g);
% two-sided periogram -> see doc guilherme slides
p =  abs(G).^2 / (N*Fs);
% transforming into one-sided
p = p(1:N/2+1);
p(2:end-1) = 2*p(2:end-1);
end