
n = 3;      
p = 2;      
uinit = ones(1, n); 

u = prbs(n, p, uinit);


[R, h] = intcor(u, u); 


figure;
stem(h, R, 'filled');
xlabel('Lag (h)');
ylabel('Autocorrelation R_{uu}(h)');
title('Autocorrelation of PRBS Signal');
grid on;
