function Z = tenkron(X,Y, varargin)
% tensor Kronecker product
Z = tenkron1_by_1(X,Y);
for i=1:numel(varargin)
    Z = tenkron1_by_1(Z, varargin{i});
end
end

function Z = tenkron1_by_1(X,Y)
sizeZ = size(X).*size(Y);
Z = zeros(sizeZ);
all_index = cellfun(@(x)1:x, num2cell([size(X) size(Y)]), 'UniformOutput', false);
all_index = combvec(all_index{:});
all_index = cellfun(@(x)x.', num2cell(all_index,1), 'UniformOutput', false);

for index=all_index
    iZ = cellfun(@(x)x(ndims(X)+1:end)+size(Y).*(x(1:ndims(X))-1), index, 'UniformOutput', false);
    iZ = num2cell(iZ{1});
    
    i = num2cell(index{1});
    iX = i(1:ndims(X));
    iY = i(ndims(X)+1:end);
    
    Z(iZ{:}) = X(iX{:})*Y(iY{:});
end
end