close all
clear all

in_sig = prbs(8, 2)*0.7;

Ts = 0.25;

y = get_system_response(in_sig, Ts);

[Ryu_intcor, h] = intcor(y.Data, in_sig);
[Ruu_intcor, h2] = intcor(in_sig, in_sig);

g_intcor = Ryu_intcor/Ruu_intcor(find(h2==0));
% g_intcor = g_intcor';



%%
[Ryu_xcorr, lags] = xcorr(y.Data, in_sig, 'unbiased'); 
[Ruu_xcorr, lags2] = xcorr(in_sig, in_sig, 'unbiased');

g_xcorr = Ryu_xcorr/Ruu_xcorr(find(lags2==0));

%%

f = figure();
stairs(h, g_intcor, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410], 'DisplayName', 'intcor');
hold on
stairs(lags, g_xcorr, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980], 'DisplayName', 'xcorr');


G_s = tf([1.2], [1, 2, 1.35, 1.2]);
G_z = c2d(G_s, 0.25, 'zoh');

impulse_true = impulse(G_z, y.Time) * Ts;

plot(impulse_true, 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250], 'DisplayName', 'true');

time_limit = 200;
xlim([0, time_limit])
xlabel("Time (s)");
ylabel("Magnitude")

title("Impulse Response of Various Methods")
legend()
grid("on")

print(f, 'plots/week4.png', '-dpng', '-r600');
%%

intcor_zero = find(h==0);
g_intcor = g_intcor(intcor_zero:intcor_zero + time_limit - 1);

xcorr_zero = find(lags2==0);
g_xcorr = g_xcorr(xcorr_zero:xcorr_zero + time_limit - 1);

impulse_true = impulse_true(1:time_limit);
intcor_err = vecnorm(g_intcor - impulse_true);
xcorr_err = vecnorm(g_xcorr - impulse_true);
