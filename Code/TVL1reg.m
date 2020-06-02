function tv = TVL1reg(M, lambda)

% Calculate the total variation regularisation factor for the RL algorithm 
% using the L1 norm over the divergence of the array M 
% as described in Dey et al. Microsc. Res. Tech. 69, 260-266 (2006).
%
% Inputs:
%   M: 2D array
%   lambda: TV regularisation coefficient
%
%   All inputs are required.
%
% Output:
%   tv: total variation regularisation factor
%
% By Raphael Turcotte (2020)
% University of Oxford
% raphael.turcotte@pharm.ox.ac.uk / rturcotte861@gmail.com


% Evaluate the gradient
[gx,gy] = gradient(M);

% Normalise the gradient
[ngx, ngy] = normalise(gx, gy);

% Evaluate the divergence
[ggx,~] = gradient(ngx);
[~,ggy] = gradient(ngy);

% Calculate the total variation factor
tv = calculateTV(lambda, ggx, ggy);

end

function tv = calculateTV(lambda, ggx, ggy)

% Calculate the total variation factor

tv = 1 ./ (1-(ggx+ggy).*lambda);

end

function [ngx, ngy] = normalise(gx, gy)

% Calculate the normalised gradients

% Define variable to avoid division by zero
emin = 1e-6;

% space allocation
ngx = gx;
ngy = gy;

norm = sqrt(gx .* gx + gy .* gy);
ngx(norm < emin) = emin;
ngy(norm < emin) = emin;
ngx(norm >= emin) = gx(norm >= emin) ./ norm(norm >= emin);
ngy(norm >= emin) = gy(norm >= emin) ./ norm(norm >= emin);

end