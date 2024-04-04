function C = contrac_prod(G_set, contrac_set)

if numel(G_set) > 2
    G_aux = contrac_prod(G_set(2:end), contrac_set(2:end));
    C = contrac_prod({G_set{1}, G_aux}, contrac_set(1));
else
    [A, B] = deal(G_set{1}, G_set{2});
    [set_A, set_B] = deal(contrac_set{1}(:,1), contrac_set{1}(:,2));
    
    dim_C_posA = setdiff(1:ndims(A), set_A);
    dim_C_posB = setdiff(1:ndims(B), set_B);
    C = zeros([size(A, dim_C_posA), size(B, dim_C_posB)]);
    
    all_index_C = cellfun(@(x)1:x, num2cell(size(C)), 'UniformOutput', false);
    all_index_C = cartprod(all_index_C{:});
    all_index_C = mat2cell(all_index_C, ones(1,size(all_index_C,1)), size(all_index_C,2));
    
    for index_C=all_index_C.'
        index_A = index_C{1}(1:ndims(A)-numel(set_A));
        index_B = index_C{1}(ndims(A)-numel(set_A)+1:end);
        index_A = num2cell(index_A);
        index_B = num2cell(index_B);
        index_C = num2cell(index_C{1});
        for i=numel(set_A)
            conc1 = index_A(1:set_A(i)-1);
            conc2 = index_A(set_A(i):end);
            index_A = [conc1(:)', {':'}, conc2(:)'];
            conc1 = index_B(1:set_B(i)-1);
            conc2 = index_B(set_B(i):end);
            index_B = [conc1(:)', {':'}, conc2(:)'];
        end
        C(index_C{:}) = sum(reshape(A(index_A{:}), [], 1).*reshape(B(index_B{:}), [], 1));
    end
end

end