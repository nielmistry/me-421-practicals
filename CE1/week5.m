

n = 10; 
Ts = 0.25;  
p = ceil(2000 / (2^n - 1)); 
uinit = ones(1, n);  
u = prbs(n, p,uinit);

N = length(u); 
simin.time = (0:Ts:(N-1)*Ts)';  
simin.signals.values = u;
simin.signals.dimensions = 1;
set_param('model', 'StopTime', num2str((N-1)*Ts));
result = sim("model.slx");
y = result.simout.data;  

% Parameters
segment_length = 2^n - 1;
num_periods = floor(N / segment_length);
fs = 1/Ts;

% Preallocate
U_avg_fft = zeros(segment_length, 1);
Y_avg_fft = zeros(segment_length, 1);

% Average FFT over periods
for k = 1:num_periods
    idx = (1:segment_length) + (k-1)*segment_length;
    u_seg = u(idx);
    y_seg = y(idx);

    U_fft = fft(u_seg);
    Y_fft = fft(y_seg);

    U_avg_fft = U_avg_fft + U_fft;
    Y_avg_fft = Y_avg_fft + Y_fft;
end

U_avg_fft = U_avg_fft / num_periods;
Y_avg_fft = Y_avg_fft / num_periods;


H_est = Y_avg_fft ./ U_avg_fft;


freq = (0:floor(segment_length/2)-1)' * (fs / segment_length);


H_frd = frd(H_est(1:floor(segment_length/2)), freq);


figure;
bode(H_frd); hold on;
bode(G_z);  
legend('Estimated Model', 'True Model');
title('Frequency Response Estimation Using PRBS');
grid on;
