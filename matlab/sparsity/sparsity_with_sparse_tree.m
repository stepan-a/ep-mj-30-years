function [s, N] = sparsity_with_sparse_tree(m, p, H, n)

    if nargin<4
        n = 1; % Only one endogenous variable
    end

    s = 100*nnz(m, p, H, n)/sJ(m, p, H, n);

    if nargout>1
        N = sJ(m, p, H, n);
    end

end

function N = nnz(m, p, H, n)
% Number of non zero elements assuming that n×n blocks are dense
    N = 3*H-2 + (m-1)*p;
    tmp = 0;
    for i=1:p-1
        tmp = tmp + 3*(H-i-1) +2;
    end
    N = N + (m-1)*tmp;
    N = N*n^2;
end

function N = sJ(m, p, H, n)
% Number of unknowns
    N = H;
    tmp = 0;
    for i=1:p-1
        tmp = tmp + (H-i);
    end
    N = N + (m-1)*tmp;
    N = N*n^2;
    N = N^2;
end
