% Main script to compute and plot the autocorrelation of PRBS

% Step 1: Generate a PRBS signal
n = 7;      % Length of the shift register (e.g., 7 bits)
p = 5;      % Number of periods for the PRBS signal
uinit = ones(1, n);  % Initial state of the shift register (e.g., all ones)

% Generate the PRBS signal
u = prbs(n, p, uinit);

% Step 2: Compute the autocorrelation using the intcor function
% Since it's autocorrelation, we set u and y to be the same signal
[R, h] = intcor(u, u);  % Compute autocorrelation

% Step 3: Plot the autocorrelation
figure;
stem(h, R, 'filled');
xlabel('Lag (h)');
ylabel('Autocorrelation R_{uu}(h)');
title('Autocorrelation of PRBS Signal');
grid on;
