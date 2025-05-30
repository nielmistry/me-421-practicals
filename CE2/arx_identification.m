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
d = 1;
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

Theta_hat = inf_matrix\multiplicand;
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
%<arx_lsim>
G = get_model_from_theta(Theta_hat, Ts, n, d);
y_m = lsim(G, u, t);
%</arx_lsim>

difference = (y_m - y);
f2 = figure(2);
clf

set(gcf, 'Position', [100 100 800 400]);     % wider figure

% ---- Top: true vs. predicted ----
ax1 = subplot(2,1,1);
plot(t, y,     'LineWidth',1.5, 'Color',[0 0.4470 0.7410], 'DisplayName','True');
hold on
plot(t, y_m, '--', 'LineWidth',1.5, 'Color',[0.8500 0.3250 0.0980], 'DisplayName','Predicted');
grid on
ylabel('y_m')
title('ARX: Measured vs. Model')
legend('Location','best','FontSize',9)
set(ax1, 'FontSize',11)

% ---- Bottom: error trace ----
ax2 = subplot(2,1,2);
plot(t, difference, 'LineWidth',1.2, 'Color',[0.4660 0.6740 0.1880]);
grid on
xlabel('Time (s)')
ylabel('Error')
title('Difference: y_{m} - y')
set(ax2, 'FontSize',11)

saveas(f2, "plots/arx_y_ym.png")

%% Instrumental Variables

%<lst_inst_var>
assert(m == n, "Assuming m == n here")
inf_matrix = zeros(2*m, 2*m);
multiplicand = zeros(2*m, 1);
for k=m + 1:N
    y_vec = flip(y_m(k - m:k - 1));
    u_vec = flip(u(k - m:k - 1));
    
    sigma = [-y_vec; u_vec];
    inf_matrix = inf_matrix + sigma*sigma';   
    multiplicand = multiplicand + sigma * y(k);
end

Theta_hat_iv = inf_matrix\multiplicand;

G_iv = get_model_from_theta(Theta_hat_iv, Ts, n, d);
y_iv = lsim(G_iv, u, t);
%</lst_inst_var>

f3 = figure(3);
clf

set(gcf, 'Position', [100 100 800 400]);     % wider figure

% ---- Top: true vs. predicted ----
ax1 = subplot(2,1,1);
plot(t, y_m,     'LineWidth',1.5, 'Color',[0 0.4470 0.7410], 'DisplayName','ARX Model Predicted');
hold on
plot(t, y_iv, '--', 'LineWidth',1.5, 'Color',[0.8500 0.3250 0.0980], 'DisplayName','IV Model Predicted');
grid on
ylabel('y_m')
title('ARX vs. IV')
legend('Location','best','FontSize',9)
set(ax1, 'FontSize',11)

% ---- Bottom: error trace ----
ax2 = subplot(2,1,2);
plot(t, difference, 'LineWidth',1.2, 'Color',[0.4660 0.6740 0.1880]);
grid on
xlabel('Time (s)')
ylabel('Error')
title('Difference: y_{m} - y')
set(ax2, 'FontSize',11)

saveas(f3, "plots/arx_y_yinst.png")
