function y = outprod(u, varargin)
    my_ndims = @(x)(isvector(x) + ~isvector(x) * ndims(x));
    y = u;
    for k = 1:numel(varargin)
        v = varargin{k};
        v_t = permute(v, circshift(1:(my_ndims(y) + my_ndims(v)),[0, my_ndims(y)]));
        y = bsxfun(@times, y, v_t);
    end
end