Ts = 0.1;
stop_time = 50;

simin = struct();
simin.time = (0:Ts:stop_time)';
simin.signals.values = 0.7*(simin.time == 1);

result = sim("model.slx");

plot(result.simout)
figure;
plot(simin.signals.values)