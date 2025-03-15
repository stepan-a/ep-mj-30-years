function Y = stochastic_perfect_foresight_model_irf(initialconditions, horizon, exogenousvariables, options_, M_, oo_)

% INPUTS
%  o initialconditions      [double]    m*1 array, where m is the number of endogenous variables in the model.
%  o samplesize             [integer]   scalar, size of the sample to be simulated.
%  o exogenousvariables     [double]    T*n array, values for the structural innovations.
%  o options_               [struct]    options_
%  o M_                     [struct]    Dynare's model structure
%  o oo_                    [struct]    Dynare's results structure
%
% OUTPUTS
%  o ts                     [dseries]   m*samplesize array, the simulations.
%  o results                [struct]    results structure
%
% ALGORITHM
%
% SPECIAL REQUIREMENTS

% Copyright © 2025 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <https://www.gnu.org/licenses/>.

[initialconditions, innovations, pfm, options_, oo_] = ...
    extended_path_initialization(initialconditions, horizon, exogenousvariables, options_, M_, oo_);

[shocks, spfm_exo_simul, innovations, oo_] = extended_path_shocks(innovations, exogenousvariables, horizon, M_, options_, oo_);

% Initialize the matrix for the paths of the endogenous variables.
endogenous_variables_paths = NaN(M_.endo_nbr, horizon+1);
endogenous_variables_paths(:,1) = initialconditions;

%options_.ep.stochastic.algo = 1;

spfm_exo_simul(2,:) = shocks(1,:);

[~, info_convergence, ~, y, pfm, options_] = extended_path_core(innovations.positive_var_indx, ...
                                                                spfm_exo_simul, ...
                                                                endogenous_variables_paths(:,1), ...
                                                                pfm, ...
                                                                M_, ...
                                                                options_, ...
                                                                oo_, ...
                                                                [], ...
                                                                []);
if ~info_convergence
    error('The stochastic perfect foresight solver did not converge!')
end

order = options_.ep.stochastic.order;

Y = zeros(pfm.ny, horizon+1);
Y(:,1) = initialconditions;

ny = pfm.ny;

vid = 1:ny;

if options_.ep.stochastic.algo==1

    j = 0;
    S = 1;

    Y(:,2) = y(j+vid);

    for period=2:horizon
        j = j + S*ny;
        Y(:,period+1) = y(j+vid);
        if period<=order+1
            S = S+(pfm.nnodes-1);
        end
    end

else
    
    k = 1;
    j = 0;
    S = 1;
    for period=2:horizon
        j = j + S*ny;
        Y(:,period+1) = y(j+vid);
        if period<=order+1
            S = pfm.nnodes^k - 1;
            k = k+1;
        end
    end

end
