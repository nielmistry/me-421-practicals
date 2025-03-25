close all
clear all

Ts = 0.25;
stop_time = 50;
rnd_var = 0.01;
mkdir("plots/")


in_sig = prbs(8, 2)*0.7;
fig = figure();
simin = struct();
simin.time = 0:Ts:Ts*(length(in_sig) - 1);
simin.signals.values = in_sig;

plot(simin.time, simin.signals.values)

result = sim("model.slx");

y = result.simout;

[R, h] = intcor(in_sig, y);

figure
stem(h, R);

[r, lags] = xcorr(in_sig, y.Data); 
figure
stem(lags, r);