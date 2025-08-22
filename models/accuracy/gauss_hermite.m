function [x, w] = gauss_hermite(n)

% Return n-points Gauss-Hermite quadrature nodes (x) and weights (w) such that:
%
%      ∫_{-∞}^{∞} f(x) e^{-x^2} dx ≈ sum_{i=1}^n w(i) * f(x(i)).
%
% The approximation is exact for polynomials up to degree 2n-1. If Z ~ N(0,1), an
% approximation of the expectation of f(Z) is given by
%
%      E[f(Z)] = ∫ f(z) φ(z) dz ≈ (1/sqrt(pi)) * sum_{i=1}^n w(i) * f(x(i)*sqrt(2))
%
% where φ is the standard normal pdf. If Z ~ N(0,σ²), an approximation of the
% expectation of f(Z) is given by
%
%      E[f(Z)] = ∫ f(z) ψ(z) dz ≈ (1/sqrt(pi)) * sum_{i=1}^n w(i) * f(x(i)*σ*sqrt(2))
%
% where ψ is the normal pdf with variance σ².
%
% ALGORITHM: Golub–Welsch (symmetric tridiagonal Jacobi matrix).

    if ~(isnumeric(n) && isscalar(n) && isint(n))
        error('Input argument must be a scalar integer (the approximation order).')
    end

    % Build the symetric tridiagonal Jacobi matrix
    k  = (1:n-1).';
    b  = sqrt(k/2);
    J = diag(b,1) + diag(b,-1);

    % Eigen-decomposition: nodes are eigenvalues, weights from first row of V
    [V, D] = eig(J);
    x  = diag(D);
    [x, idx] = sort(x);
    V  = V(:, idx);
    w  = sqrt(pi) * (V(1,:).^2).';

end
