n_set = [2, 4, 8, 16, 32, 64, 128];
time_run_builtin = zeros(1, length(n_set));
time_run_alg = zeros(1, length(n_set));

for n=n_set
    A = random('uniform',0,100,n,n) + 1i*random('uniform',0,100,n,n);
    B = random('uniform',0,100,n,n) + 1i*random('uniform',0,100,n,n); 
    
    tic;
    out = A.*B;
    time_run_builtin(n_set==n) = toc;
end

for n=n_set
    A = random('uniform',0,100,n,n) + 1i*random('uniform',0,100,n,n);
    B = random('uniform',0,100,n,n) + 1i*random('uniform',0,100,n,n); 
    
    tic;
    out = hadamard_prod(A,B);
    time_run_alg(n_set==n) = toc;
end

f = figure();
f.WindowState = 'maximized';
semilogy(n_set, time_run_builtin, 'LineWidth', 4, 'Color', 'black');
hold on
semilogy(n_set, time_run_alg, 'LineWidth', 4, 'Color', 'red');
title('Hadamard Product');
ax = gca();
ax.XLim = [-inf max(n_set)];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.FontName = 'Times New Roman';
ax.TickLabelInterpreter = 'latex';
ax.FontSize = 30;
ax.XLabel.Interpreter = 'latex';
ax.XLabel.String = '$N$';
ax.YLabel.String = 'Runtime';
legend({'$A\odot B$ - Built-in', '$A\odot B$ - Algorithm'}, 'location','northeast','Interpreter','latex');

saveas(f, 'hw1_prob1.jpg', 'jpg');