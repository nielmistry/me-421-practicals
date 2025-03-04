function [R, h] = intcor(u, y)
% [R, h] = intcor(u, y)
% u: input signal u (vector)
% y: input signal y (vector)
% R: cross-correlation (or autocorrelation if u = y)
% h: lag values corresponding to the cross-correlation

% Length of the input signals
M = length(u);

% Preallocate correlation array
R = zeros(1, M);

% Compute the autocorrelation or cross-correlation
for lag = 0:M-1
    % For each lag h, calculate the sum of the product of u and y
    % considering the periodic nature of the signals
    R(lag + 1) = sum(u .* circshift(y, lag));  % Circular shift to handle periodicity
end

% Create the lag vector (h)
h = 0:M-1;

% Normalize the correlation (optional, for unit correlation)
R = R / M;  % Normalize by M for proper scaling
end
