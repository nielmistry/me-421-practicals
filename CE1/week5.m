

n = 10; 
Ts = 0.25;  
p = ceil(2000 / (2^n - 1)); 
uinit = ones(1, 2000);  
u = prbs(n, p);  

N = length(u); 
simin.time = (0:Ts:(N-1)*Ts)';  
simin.signals.values = u;
simin.signals.dimensions = 1;
result = sim("model.slx");
y = result.simout.data;  
%%


segment_length = 2^n - 1;  
num_periods = floor(N / segment_length);  

U_avg = zeros(segment_length, 1);  
Y_avg = zeros(segment_length, 1);  

for i = 1:num_periods
    idx_start = (i-1) * segment_length + 1;
    idx_end = idx_start + segment_length - 1;
    
    
    if idx_end > N
        break;
    end
    
    U_avg = U_avg + fft(u(idx_start:idx_end)) / segment_length;
    Y_avg = Y_avg + fft(y(idx_start:idx_end)) / segment_length;
end
U_avg = U_avg / num_periods;
Y_avg = Y_avg / num_periods;


fs = 1/Ts; 
freq = (0:floor(segment_length/2)-1) * (fs / segment_length);  

H_est = Y_avg ./ U_avg;  %
H_frd = frd(H_est(1:floor(segment_length/2)), freq);  

figure;
bode(H_frd); hold on;
bode(G_z); 
legend('Estimated Model', 'True Model');
title('Frequency Response Estimation Using PRBS');
grid on;
