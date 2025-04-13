close all
clear all

Ts = 0.25;
mkdir("plots/")

%% Unit Step Response

fig = figure();
t = (0:Ts:50)';
u = 0.7*(t > 1);

result = get_system_response(u, Ts);

plot(result)
title("Step Response")
ylabel("Value")
saveas(fig, "plots/ce1_step.png")


%% Impulse Response
fig = figure();
u = 0.7*(t == t(2));
result = get_system_response(u, Ts);
plot(result)

title("Impulse Response")
ylabel("Value")

saveas(fig, "plots/ce1_impulse.png")


%% Autocorrelation Function 

prbs_64 = prbs(3, 2, ones(1, 3));
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


result = get_system_response(u, Ts);
Y = result.Data;
Y = Y(2:end);


% Assume length is < 30s (how can we do better?) 
K = floor(30/Ts); 
U_K = U(:, 1:K);
Theta_K = pinv(U_K)*Y; % TODO BROKEN
    
lambda = 0.5;
Theta_regularization = (U'*U + lambda*eye(size(U))) \ (U'*Y);

sys = tf([1.2], [1, 2, 1.35, 1.2]);
sys_dt = c2d(sys, Ts, 'zoh');
sys_impulse = impulse(sys, t)*Ts;

figure
stem(t(1:length(Theta_K)), Theta_K, 'filled');
hold on
stem(t(1:length(Theta_regularization)), Theta_regularization, 'filled');
stem(t, sys_impulse, 'filled');

legend(["pinv", "regularized", "system"])