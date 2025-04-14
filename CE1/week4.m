
n = 8;      
p = 2;      
%uinit = ones(1, n); 
u = prbs(n, p);

s = tf('s');
G_s = 1.2 / (s^3 + 2*s^2 + 1.35*s + 1.2); 
G_z = c2d(G_s, 0.25, 'zoh');  

[y, t] = lsim(G_z, u, 0:0.25:(length(u)-1)*0.25);

[R, h] = intcor(y, u);

xu = xcorr(y, u, 'unbiased');
g_xcorr = xu(length(u):end); 

impulse_true = impulse(G_z, t)*Ts;

% Plot the results
figure;
subplot(3,1,1);
stem(h, R, 'filled');
title('Impulse Response using intcor');
xlabel('Time Step');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
stem(0:length(g_xcorr)-1, g_xcorr, 'filled');
title('Impulse Response using xcorr');
xlabel('Time Step');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
stem(0:length(impulse_true)-1, impulse_true, 'r', 'filled');
title('True Impulse Response');
xlabel('Time Step');
ylabel('Amplitude');
grid on;

legend('True Impulse Response'); 