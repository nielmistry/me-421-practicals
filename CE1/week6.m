close all
clear all

Ts = 0.4;          
N = 2000;          
stop_time = (N-1) * Ts; 

u = sign(randn(N, 1))*0.7; % binary random signal. maximum energy
y = get_system_response(u, Ts).Data;

[f, G] = spectral_analysis(u, y, Ts, "none", 1);
H = frd(G, f); 

[f, G_hann] = spectral_analysis(u, y, Ts, "hann", 1);
H_hann = frd(G_hann, f); 

[f_avg, G_avg_hann] = spectral_analysis(u, y, Ts, "hann", 10);
H_avg_hann = frd(G_avg_hann, f_avg);

[f, G_hamming] = spectral_analysis(u, y, Ts, "hamming", 1);
H_hamming = frd(G_hamming, f); 

[f_avg, G_avg_hamming] = spectral_analysis(u, y, Ts, "hamming", 10);
H_avg_hamming = frd(G_avg_hamming, f_avg);



%% Plots
sys_true = tf([1.2], [1, 2, 1.35, 1.2]);
sys_true = c2d(sys_true, Ts);

f = figure(1);
bode(H, 'r.', {0, 4});
hold on
bode(sys_true, {0, 4})
legend(["Identified", "Real"])
grid on;
title('No Window, No Averaging');

f2 = figure(2);
bode(H_hann, 'r.', {0, 4});
hold on
bode(sys_true, {0, 4})
legend(["Identified", "Real"])
grid on;
title('Hann Window, No Averaging');

f3 = figure(3);
bode(H_avg_hann, 'r.', {0, 4});
hold on
bode(sys_true, {0, 4})
legend(["Identified", "Real"])
grid on;
title('Hann Window, 10 Fold Averaging');


f2 = figure(4);
bode(H_hamming, 'r.', {0, 4});
hold on
bode(sys_true, {0, 4})
legend(["Identified", "Real"])
grid on;
title('Hamming Window, No Averaging');

f3 = figure(5);
bode(H_avg_hamming, 'r.', {0, 4});
hold on
bode(sys_true, {0, 4})
legend(["Identified", "Real"])
grid on;
title('Hamming Window, 10 Fold Averaging');
