% Step 1: Generate random signal (Gaussian, uniform, binary, multi-level)
N = 2000;    % Length of the signal
Ts = 0.25;   % Sampling period
fs = 1/Ts;   % Sampling frequency

% Gaussian random signal
u = randn(1, N);  % Gaussian distributed random signal

% Alternatively, use a uniform signal (or binary, multi-level, etc. as required):
% u = rand(1, N);  % Uniform random signal (values between 0 and 1)

% Step 2: Apply the random signal to the system
simin.time = (0:Ts:(N-1)*Ts)';
simin.signals.values = u(:);  % Ensure column vector
simin.signals.dimensions = 1;

% Simulate the model
set_param('model', 'StopTime', num2str((N-1)*Ts));
result = sim("model.slx");
y = result.simout.data;

% Step 3: Compute frequency response using Spectral Analysis (FFT)
segment_length = N;  % Use the full signal as one segment
window = hamming(segment_length);  % Hamming window (alternatively, use hann)

% Apply the window to both input and output
u_windowed = u .* window';
y_windowed = y .* window';

% FFT of windowed input and output
U_fft = fft(u_windowed);
Y_fft = fft(y_windowed);

% Frequency vector
freq = (0:floor(segment_length/2)-1)' * (fs / segment_length);

% Compute frequency response estimate (H_est = Y_fft / U_fft)
H_est = Y_fft ./ U_fft;

% Step 4: Average over multiple segments (if needed)
% Divide the signal into m groups (optional improvement)
m = 10;  % Number of segments to average over
U_avg_fft = zeros(segment_length, 1);
Y_avg_fft = zeros(segment_length, 1);

for k = 1:m
    idx = (1:segment_length) + (k-1)*segment_length;
    u_seg = u(idx);
    y_seg = y(idx);

    % Apply window
    u_seg_windowed = u_seg .* window';
    y_seg_windowed = y_seg .* window';

    % Compute FFT
    U_fft_seg = fft(u_seg_windowed);
    Y_fft_seg = fft(y_seg_windowed);

    % Accumulate the results
    U_avg_fft = U_avg_fft + U_fft_seg;
    Y_avg_fft = Y_avg_fft + Y_fft_seg;
end

% Average the results
U_avg_fft = U_avg_fft / m;
Y_avg_fft = Y_avg_fft / m;

% Step 5: Plot the Bode diagram
H_avg_est = Y_avg_fft ./ U_avg_fft;  % Frequency response after averaging
H_frd = frd(H_avg_est(1:floor(segment_length/2)), freq);

figure;
bode(H_frd); hold on;
bode(G_z);  % Assuming G_z is the true transfer function
legend('Estimated Model', 'True Model');
title('Frequency Response Estimation Using Random Signal');
grid on;
