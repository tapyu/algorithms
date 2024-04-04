function [tenlambda, all_A_normalized, all_nse, n_iter]= als(tenX, R)
max_iter = 1e3;
all_nse = zeros(1,max_iter);
N = ndims(tenX);
delta_min = 1e-6;
%% instantiating all_A
try
    % all n-mode unfolding of tenX
    all_unfoldX = cellfun(@nmodeunfold,{tenX,tenX,tenX},num2cell(1:N), 'UniformOutput', false);
    % all left singular vectors for each n-mode unfolding
    [all_U, ~, ~] = cellfun(@svd, all_unfoldX, 'UniformOutput', false);
    % instantiating all_A with the R leading vectors of all_U
    all_A_current = cellfun(@(x)x(:,1:R), all_U, 'UniformOutput', false);
catch ME % it was not possible to instantiate the A(n)'s as the R leading left vector of [tenX]_(n), use random matrices instead.
    if strcmp(ME.identifier,'MATLAB:badsubscript')
        all_A_current = cellfun(@randn, cellfun(@(x,y)[x,y], num2cell(size(tenX)), num2cell(R*ones(1,R)), 'UniformOutput', false), 'UniformOutput', false);
    end
end

%% computing current nmse
all_A_but_1_flipped = flip(all_A_current(setdiff(1:N,1)));
tenX_mode1_hat = all_A_current{1}*kr(all_A_but_1_flipped{:}).';
nse_current = norm(nmodeunfold(tenX,1)-tenX_mode1_hat)/norm(nmodeunfold(tenX,1));

%% the ALS
for n_iter=1:max_iter
    all_A_new = all_A_current;
    for n=1:N
        % A(1), A(2), ..., A(n-1), A(n+1), ..., A(N)
        all_A_but_n = all_A_new(setdiff(1:N,n));
        % V <-  A(1)^TA(1) ⊙ A(2)^TA(2) ⊙ ... A(n-1)^TA(n-1) ⊙ A(n+1)^TA(n+1) ⊙ ... ⊙ A(N)^TA(N)
        V = cellfun(@(x)x.'*x, all_A_but_n, 'UniformOutput', false);
        V = times(V{:});
        % A_hat(n) <- X_mode_n*(A(N) ⊙ A(N-1) ⊙ ... A(n+1) ⊙ A(n-1) ⊙ ... ⊙ A(1))*V^†
        flipped_all_A_but_n = flip(all_A_but_n);
        all_A_new{n} = all_unfoldX{n}*kr(flipped_all_A_but_n{:})/V;
    end

    %% computinng the new nse
    all_A_but_1_flipped = flip(all_A_new(setdiff(1:N,1)));
    tenX_mode1_hat = all_A_new{1}*kr(all_A_but_1_flipped{:}).';
    nse_new= norm(nmodeunfold(tenX,1)-tenX_mode1_hat)/norm(nmodeunfold(tenX,1));

    %% assessing the new result
    all_nse(n_iter) = nse_current;
    if nse_new < nse_current % it had improvement error_new<error_current, save the new ones as the current solution
        nse_current = nse_new;
        all_A_current = all_A_new;
        if all_nse(n_iter)-nse_new < delta_min % the improvement has reached its benchmark, break the loop
            break
        end
    else % the iteration stopped giving any improvement, break the loop
        break
    end
end
%% max iteration has reached or the loop has broken, computing lambda by normalizing all_A
all_nse = all_nse(1:n_iter); % truncating the all_nse to its useful part
all_A_normalized = cellfun(@normc, all_A_current, 'UniformOutput', false);
% bear in mind that <ar(1)○ar(2)○...○ar(N), ar(1)○ar(2)○...○ar(N)> = <ar(1)○ar(1)><ar(2)○ar(2)>...<ar(2)○ar(2)>
lambda_diag = cellfun(@(x,y)x(1,:)./y(1,:), all_A_current, all_A_normalized, 'UniformOutput', false);
lambda_diag = prod(cat(1, lambda_diag{:}),1); % the main diagonal of the tensor lambda
% vectorization of tenlambda
lambda_vec = zeros(R^N,1);
lambda_vec(1:R^2+R+1:R^N) = lambda_diag; % fill the main diagonal of tenlambda
% tenlambda
tenlambda = reshape(lambda_vec, R*ones(1,N));
end