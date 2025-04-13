close all
clear all

u = prbs(10, 2);

Ts = 0.25
stop_time = Ts*(length(u) - 1);
rnd_var = 0.01;
[~, ~, ~] = mkdir("plots/");


simin = struct();
simin.time = 0:Ts:Ts*(length(u) - 1);
simin.signals.values = u;

result = sim("model.slx");

y = result.simout.Data;

period = seqperiod(u);
num_periods = length(u)/period;
ffts_u = zeros(num_periods, period);
ffts_y = zeros(num_periods, period);

for i=0:num_periods - 1
    ffts_u(i + 1, :) = fft(u((i*period + 1):((i + 1) * period)));
    ffts_y(i + 1, :) = fft(y((i*period + 1):((i + 1) * period)));
end

averaged_fft_u = mean(ffts_u, 1);
averaged_fft_y = mean(ffts_y, 1);

N = length(averaged_fft_y);
fs = 1/Ts;
Fvec = 0:fs/N:(N - 1)*fs/N;
Fvec = Fvec * 2 * pi;

sys_identified = frd(averaged_fft_y./averaged_fft_u, Fvec);
sys_true = tf([1.2], [1, 2, 1.35, 1.2]);
sys_true = c2d(sys_true, Ts);


figure
bode(sys_identified);
hold on
bode(sys_true);
