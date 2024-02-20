function [tenS_new, all_U_new, tenX_hat_new, nmse_new, n_iteratons] = hooi(tenX)
% HOSVD
[tenS_cur, all_U_cur] = thosvd(tenX);
% assessing the nmse with HOSVD
tenX_hat_cur = tenS_cur;
for n=1:length(all_U_cur)
    tenX_hat_cur = nmodeproduct(tenX_hat_cur, all_U_cur{n}, n);
end
nmse_cur = 0;
for slice=1:size(tenX,3)
    nmse_cur = nmse_cur + norm(tenX_hat_cur(:,:,slice) - tenX(:,:,slice),"fro")/norm(tenX(:,:,slice),"fro");
end
nmse_cur = nmse_cur/3;
% initializing output
all_U_new = cell(size(all_U_cur));
% initializing loop parameters
vec_index = 1:length(all_U_cur);
n_iteratons = 1;
iter_max = 1e3;
nmse_min = 1e-18;

while n_iteratons<iter_max
    %% computing all_U_new
    for n=1:length(all_U_cur)
        % computing tenY
        tenY_n = tenX;
        for i=vec_index(vec_index~=n)
            tenY_n = nmodeproduct(tenY_n, all_U_cur{i}', i);
        end
        % computing U^(n)
        Y_n = nmodeunfold(tenY_n, n);
        r = rank(Y_n);
        [U, ~, ~] = svd(Y_n);
        all_U_new{n} = U(:, 1:r);
    end
    
    %% assessing the nmse of the new solution
    % computing tenS_new
    tenS_new = tenX;
    for n=1:length(all_U_new)
        tenS_new = nmodeproduct(tenS_new, all_U_new{n}.', n);
    end
    % computing tenX_hat_new
    tenX_hat_new = tenS_new;
    for n=1:length(all_U_new)
        tenX_hat_new = nmodeproduct(tenX_hat_new, all_U_new{n}, n);
    end
    % nmse_new
    nmse_new = 0;
    for slice=1:size(tenX,3)
        nmse_new = nmse_new + norm(tenX_hat_new(:,:,slice) - tenX(:,:,slice),"fro")/norm(tenX(:,:,slice),"fro");
    end
    nmse_new = nmse_new/3;
    
    % comparing the nmse_new to the nmse_cur
    if nmse_new < nmse_min % the the nmse_new reached the nmse_min, stop the iteration
        break
    elseif nmse_new < nmse_cur % the iteration is giving improviment, continue the iteration
        nmse_cur = nmse_new;
        all_U_cur = all_U_new;
    else % the iteration is not giving improviment, keep the cur solution and stop the iteration
        nmse_new = nmse_cur;
        all_U_new = all_U_cur;
        % recompute tenS with the current values intead of the news ones
        tenS_new = tenX;
        for n=1:length(all_U_cur)
            tenS_new = nmodeproduct(tenS_new, all_U_new{n}.', n);
        end
        break
    end
    % increment the iteration number
    n_iteratons = n_iteratons+1;
end

end

function [tenS, varout, multilinear_ranks] = thosvd(tenX)
sizeX = size(tenX);
tenS = tenX;
multilinear_ranks = zeros([1, length(sizeX)]);
for n=1:length(sizeX)
    unfolded_X = nmodeunfold(tenX, n); % n-mode unfolding
    multilinear_ranks(n) = rank(unfolded_X);
    [U, ~, ~] = svd(unfolded_X);
    U_n = U(:, 1:multilinear_ranks(n)); % truncated
    varout{n} = U_n;
    tenS = nmodeproduct(tenS, U_n.', n);
end
end