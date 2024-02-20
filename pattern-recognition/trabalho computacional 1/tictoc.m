table = readtable('data.csv');
X = table2array(table(:,1:end-1));
tic
cov(X);
elapsed_time = toc;

save('tictoc.mat', 'elapsed_time');