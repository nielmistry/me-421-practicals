Ts = 0.4;          
N = 2000;          
stop_time = (N-1) * Ts; 
simin.time = (0:Ts:stop_time)';  

%u = rand(N, 1); 
u = 2 * randi([0, 1], N, 1) - 1;
% u = randi([-3, 3], N, 1); 
simin.signals.values = u; 
simin.signals.dimensions = 1;
set_param('model', 'StopTime', num2str(stop_time));
result = sim("model.slx");
y = result.simout.Data;

[Ryu, h] = intcor(u, y);
[Ruu, h] = intcor(u, u);
window = hann(N);  
Ryu_windowed = Ryu .* window';  
Ruu_windowed = Ruu .* window';  

Syu = fft(Ryu, N);  
Suu = fft(Ruu, N);

fs = 1 / Ts;  
f = (0:N-1) * (fs / N); 

H_est = Syu./Suu;





H_frd = frd(H_est, 2*pi*f);  


figure;
bode(H_frd, []);
grid on;
title('Frequency Response ');

legend(["nonaveraged", "averaged"])