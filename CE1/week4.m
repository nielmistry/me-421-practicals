close all
clear all

in_sig = prbs(8, 2)*0.7;

Ts = 0.25;

y = get_system_response(in_sig, Ts);

[Ryu_intcor, h] = intcor(y.Data, in_sig);
[Ruu_intcor, h2] = intcor(in_sig, in_sig);

g_intcor = Ryu_intcor/Ruu_intcor(find(h2==0));

figure
plot(h, g_intcor, 'DisplayName', 'intcor');
hold on

%%
[Ryu_xcorr, lags] = xcorr(y.Data, in_sig, 'unbiased'); 
[Ruu_xcorr, lags2] = xcorr(in_sig, in_sig, 'unbiased');

g_xcorr = Ryu_xcorr/Ruu_xcorr(find(lags2==0));
plot(lags, g_xcorr, 'DisplayName', 'xcorr');


G_s = tf([1.2], [1, 2, 1.35, 1.2]);
G_z = c2d(G_s, 0.25, 'zoh');

impulse_true = impulse(G_z, y.Time) * Ts;

plot(impulse_true, 'DisplayName', 'true');

xlim([0, 200])

legend()