clear all
close all 

N = 2000;
Ts = 0.4; 
u = rand(N, 1)*1.4 - 0.7;

out = get_system_response(u, Ts);

%% Method 1: Vanilla Frequency Response

[Ryu, h1] = intcor(out.Data, u); 
[Ruu, h2] = intcor(u, u);
assert(all(h1 == h2))
Ryu = Ryu(h1 > 0);
Ruu = Ruu(h1 > 0);
h = h1(h1 > 0);
n = 0:1:N - 1;
exp_vec = exp(-1j.*h*2*pi.*n/N);

Syu = Ryu * exp_vec;
Suu = Ruu * exp_vec;

G = Syu./Suu;

fvec = 0:1/(Ts*N):(N-1)/(Ts*N);

stem(fvec, G);