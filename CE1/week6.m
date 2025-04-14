Ts = 0.25;          
N = 2000;          
stop_time = (N-1) * Ts; 

% u = sign(randn(N, 1)); 
u = randsample([-1, 0, 1], N, true)';
u = randn(N, 1);
% u = randi([-3, 3], N, 1); 


out = get_system_response(u, Ts);
y = out.Data;

[Ryu, h] = intcor(u, y);
[Ruu, h] = intcor(u, u);
window = hamming(N);  
Ryu_windowed = Ryu .* window';  
Ruu_windowed = Ruu .* window';  

Syu = fft(Ryu, N);  
Suu = fft(Ruu, N);

H_est = mean(Syu,2)./mean(Suu, 2);

fs = 1 / Ts;  
f = (0:N-1) * (fs / N); 


f_half = f(1:floor(N/2)); % only +ve
H_half = H_est(1:floor(N/2));


H_frd = frd(H_half, 2*pi*f_half);  


sys_true = tf([1.2], [1, 2, 1.35, 1.2]);
sys_true = c2d(sys_true, Ts);


figure;
bode(H_frd, {0, 4});
hold on
bode(sys_true, {0, 4})
grid on;
title('Frequency Response ');
