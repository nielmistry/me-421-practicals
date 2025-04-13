Ts = 0.4;
stop_time = 50;
N = stop_time / Ts + 1; 
simin = struct();
simin.time = (0:Ts:stop_time)';  
simin.signals.values = (1.4 * rand(N, 1)) -0.7; 

result = sim("model.slx");
y = result.simout.Data
ly = 20

U = toeplitz(simin.signals.values, [simin.signals.values(1) zeros(1,length(simin.signals.values)-1)]);

U_cur = U(:,1:75)
g = pinv(U_cur)*y;  

lambda = 0.5;  
g_reg = (U' * U + lambda * eye(size(U))) \ (U' * y);


s = tf('s');
G_s = 1.2 / (s^3 + 2*s^2 + 1.35*s + 1.2); 
G_z = c2d(G_s, Ts, 'zoh');

% 
 impulse_true = impulse(G_z, simin.time)*Ts; 
% 
% error_func = @(g) sum((y - U*g).^2);  
% 
% g_mle = fminsearch(error_func, zeros(ly, 1));

% Plot results
% Plot Estimated Impulse Response (No Regularization)
% figure;
% stem(0:size(g)-1, g', 'filled');
% title('Estimated Impulse Response (No Regularization - LS)');
% xlabel('Time Step');
% ylabel('Amplitude');
% grid on;
% 
% % Plot Regularized Impulse Response
% figure;
% stem(0:ly-1, g_reg, 'g', 'filled');
% title('Estimated Impulse Response (Regularized - LS)');
% xlabel('Time Step');
% ylabel('Amplitude');
% grid on;
% 
% % Plot True Impulse Response
% figure;
% stem(0:length(impulse_true)-1, impulse_true, 'r', 'filled');
% title('True Impulse Response');
% xlabel('Time Step');
% ylabel('Amplitude');
% grid on;
% 
% % Plot MLE Impulse Response
% figure;
% stem(0:ly-1, g_mle, 'b', 'filled');
% title('Estimated Impulse Response (MLE)');
% xlabel('Time Step');
% ylabel('Amplitude');
% grid on;

% Comparison of LS, Regularized LS, and MLE
figure;
stem(0:size(g)-1, g', 'filled'); hold on;
stem(0:size(g_reg)-1, g_reg', 'r'); 
stem(0:size(impulse_true)-1,impulse_true',"filled")

legend('LS Estimate', 'Regularized LS Estimate', 'True Impulse Response');
title('Impulse Response Estimation Comparison');
xlabel('Time Step');
ylabel('Amplitude');
grid on;