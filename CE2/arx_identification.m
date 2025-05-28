%%
close all 
clear

mkdir("plots/")

load("data/data_stable.mat")
Ts = 0.01;
t = (0:Ts:(size(y) - 1)*(Ts))';
tt = timetable(u, y, 'SampleRate', 1/Ts);

%% ARX Implementation
%<lst_arx_impl>
N = size(y, 1);
n = 2;
m = 2;
assert(m == n, "Assuming m == n here")
inf_matrix = zeros(2*m, 2*m);
multiplicand = zeros(2*m, 1);
for k=m + 1:N
    y_vec = flip(y(k - m:k - 1));
    u_vec = flip(u(k - m:k - 1));
    
    sigma = [-y_vec; u_vec];
    inf_matrix = inf_matrix + sigma*sigma';   
    multiplicand = multiplicand + sigma * y(k);
end

Theta_hat = inf_matrix\multiplicand
%</lst_arx_impl>

%% Prediction 

y_hat = zeros(N, 1); 
for k=m + 1:N
    y_hat(k) = -Theta_hat(1)*y(k - 1) - Theta_hat(2)*y(k - m) + Theta_hat(3)*u(k - 1) + Theta_hat(4)*u(k - 2);  
end

err = (y_hat - y);
f1 = figure(1); clf;
set(gcf, 'Position', [100 100 800 400]);     % wider figure

% ---- Top: true vs. predicted ----
ax1 = subplot(2,1,1);
plot(t, y,     'LineWidth',1.5, 'Color',[0 0.4470 0.7410], 'DisplayName','True');
hold on
plot(t, y_hat, '--', 'LineWidth',1.5, 'Color',[0.8500 0.3250 0.0980], 'DisplayName','Predicted');
grid on
ylabel('y')
title('ARX: True vs. Predicted')
legend('Location','best','FontSize',9)
set(ax1, 'FontSize',11)

% ---- Bottom: error trace ----
ax2 = subplot(2,1,2);
plot(t, err, 'LineWidth',1.2, 'Color',[0.4660 0.6740 0.1880]);
grid on
xlabel('Time (s)')
ylabel('Error')
title('Prediction Error: y_{hat} - y')
set(ax2, 'FontSize',11)

% link x-axes so you can zoom/pan together
linkaxes([ax1 ax2], 'x');
saveas(f1, "plots/arx_y_ypred.png")

J = sum(err.^2);
disp("J = " + J);

%% Identified System
numerator = [0, Theta_hat(m + 1), Theta_hat(m + 2)];
denominator = [1, Theta_hat(1), Theta_hat(2)];

G = tf(numerator, denominator, Ts)
y_pred = lsim(G, u, t)

err = (y_pred - y);
f2 = figure(2);
clf

set(gcf, 'Position', [100 100 800 400]);     % wider figure

% ---- Top: true vs. predicted ----
ax1 = subplot(2,1,1);
plot(t, y,     'LineWidth',1.5, 'Color',[0 0.4470 0.7410], 'DisplayName','True');
hold on
plot(t, y_pred, '--', 'LineWidth',1.5, 'Color',[0.8500 0.3250 0.0980], 'DisplayName','Predicted');
grid on
ylabel('y')
title('ARX: True vs. Predicted')
legend('Location','best','FontSize',9)
set(ax1, 'FontSize',11)

% ---- Bottom: error trace ----
ax2 = subplot(2,1,2);
plot(t, err, 'LineWidth',1.2, 'Color',[0.4660 0.6740 0.1880]);
grid on
xlabel('Time (s)')
ylabel('Error')
title('Prediction Error: y_{hat} - y')
set(ax2, 'FontSize',11)

saveas(f2, "arx_y_ym.png")
