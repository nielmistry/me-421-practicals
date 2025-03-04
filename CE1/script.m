Ts = 0.25;
stop_time = 50;

simin = struct();
simin.time = (0:Ts:50)';
simin.signals.values = 0.7*(simin.time == 1);

result = sim("model.slx");

plot(result.simout)
