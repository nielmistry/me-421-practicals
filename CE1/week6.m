Ts = 0.4;          
N = 2000;          
stop_time = (N-1) * Ts; 
simin.time = (0:Ts:stop_time)';  

%u = rand(N, 1); 
%u = 2 * randi([0, 1], N, 1) - 1;
u = randi([-3, 3], N, 1); 



simin.signals.values = u; 
simin.signals.dimensions = 1;
set_param('model', 'StopTime', num2str(stop_time));
result = sim("model.slx");
y = result.simout.Data;

[Ryu, h] = intcor(u, y);
[Ruu, h] = intcor(u, u);
window = hamming(N);  
Ryu_windowed = Ryu .* window';  
Ruu_windowed = Ruu .* window';  

Syu = fft(Ryu, N);  
Suu = fft(Ruu, N);

fs = 1 / Ts;  
f = (0:N-1) * (fs / N); 

hest = Syu./Suu;

H_frd = frd(hest, 2*pi*f);  
figure;

bode(H_frd)
hold on
m=5;
group_length= floor(length(u)/m);
avg_sum_yu=zeros(1,group_length);
avg_sum_uu=zeros(1,group_length);

for k = 1:group_length:N
    chunk = u(k:k+group_length-1) ;

    simin.signals.values = chunk; 
    simin.signals.dimensions = 1;
    stop_time = (group_length-1) * Ts;
    simin.time = (0:Ts:stop_time)';  
    set_param('model', 'StopTime', num2str(stop_time));
    result = sim("model.slx");
    y = result.simout.Data;

    [Ryu, h] = intcor(chunk, y);
    [Ruu, h] = intcor(chunk, chunk);
    
    Syu = fft(Ryu, group_length);  
    Suu = fft(Ruu, group_length);
    avg_sum_uu = avg_sum_uu + Suu;
    avg_sum_yu = avg_sum_yu + Syu;

    
end
g = avg_sum_yu ./avg_sum_uu; 

f = (0:group_length-1) * (fs / group_length); 

H_frd = frd(g, 2*pi*f); 
bode(H_frd);
grid on;
legend(["nonaveraged","averaged"])
title('Frequency Response ');