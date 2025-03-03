Ts = 0.25;
stop_time = 50;
mkdir("plots/")

%% Unit Step Response

fig = figure();
simin = struct();
simin.time = (0:Ts:50)';
simin.signals.values = 0.7*(simin.time > 1);

result = sim("model.slx");

plot(result.simout)
title("Step Response")
ylabel("Value")
saveas(fig, "plots/ce1_step.png")


%% Impulse Response
fig = figure()
simin.signals.values = 0.7*(simin.time == 1);
result = sim("model.slx");
plot(result.simout)

title("Impulse Response")
ylabel("Value")

saveas(fig, "plots/ce1_impulse.png")
