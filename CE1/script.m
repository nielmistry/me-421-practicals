close all
clear all

Ts = 0.25;
stop_time = 50;
rnd_var = 0.01;
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
fig = figure();
simin.signals.values = 0.7*(simin.time == simin.time(2));
result = sim("model.slx");
plot(result.simout)

title("Impulse Response")
ylabel("Value")

saveas(fig, "plots/ce1_impulse.png")


%% Autocorrelation Function 

prbs_64 = prbs(6, 4);
[R, h] = intcor(prbs_64, prbs_64); 

fig = figure();
stem(h, R);

title("Autocorrelation Function for prbs(6, 4)")
xlabel("h")
ylabel("R_{yy}")


saveas(fig, "plots/autocorrelation.png")


%% Deconvolution 

Ts = 0.4; 
length_of_input = 50; % seconds
N = floor(length_of_input/Ts);
u = rand(N, 1)*1.4 - 0.7; % Across full range of input values

U = toeplitz(u, [u(1) zeros(1, length(u) - 1)]);

t = 0:Ts:(N-1)*Ts;

simin = struct();
simin.time = t;
simin.signals.values = u;

result = sim('model.slx');
Y = result.simout.data;
Y = Y(2:end);


% Assume length is < 30s (how can we do better?) 
K = floor(30/Ts); 
U_K = U(:, 1:K);
Theta_K = pinv(U_K)*Y;
    
lambda = 0.5;
Theta_regularization = inv(U'*U + lambda*eye(size(U)))*U'*Y;

sys = tf([1.2], [1, 2, 1.35, 1.2]);
sys_dt = c2d(sys, Ts, 'zoh');
sys_impulse = impulse(sys, t)*Ts;

figure
plot(Theta_K);
hold on
plot(Theta_regularization);
plot(sys_impulse);