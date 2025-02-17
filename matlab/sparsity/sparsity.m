function [s, N] = sparsity(m, p, H, n)

    if nargin<4
        n = 1; % Only one endogenous variable
    end

    % Number of non zero elements assuming that n×n blocks are dense
    nnz = @(m, p, H, n) (1+m+(2+m)*(m^p-m)/(m-1)+3*m^p*(H-p-1)+2*m^p)*n^2;

    % Number of elements in the stacked jacobian
    sJ = @(m, p, H, n) ((m^p-1)/(m-1)+m^p*(H-p))^2*n^2;

    s = 100*nnz(m, p, H, n)/sJ(m, p, H, n);

    if nargout>1
        N = sJ(m, p, H, n);
    end

end
