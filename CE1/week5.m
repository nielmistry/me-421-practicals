close all
clear all

u = 0.7*prbs(10, 2);

Ts = 0.25;
[~, ~, ~] = mkdir("plots/");

out = get_system_response(u, Ts);
y = out.Data;

period = seqperiod(u);
num_periods = length(u)/period;
ffts_u = zeros(num_periods, period);
ffts_y = zeros(num_periods, period);

for i=0:num_periods - 1
    range = (i*period + 1):((i + 1)*period);
    ffts_u(i + 1, :) = fft(u(range));
    ffts_y(i + 1, :) = fft(y(range));
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

%%
f = figure();
bp = bodeplot(sys_identified, 'r.', {0.01, 4});
hold on
bp2 = bodeplot(sys_true, {0, 4});

legend('Location', 'southoutside')
title("Bode Plot of FRD Model vs. True System")
grid("on")

print(f, 'plots/week5.png', '-dpng', '-r300');