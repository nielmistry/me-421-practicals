%%
close all 
clear

mkdir("plots/")

load("data/data_stable.mat")
Ts = 0.01;
t = (0:Ts:(size(y) - 1)*(Ts))';
tt = timetable(u, y, 'SampleRate', 1/Ts);

%% ARX Implementation
N = size(y, 1);
n = 2;
m = 2;
assert(m == n, "Assuming m == n here")
inf_matrix = zeros(2*m, 2*m);
multiplicand = zeros(2*m, 1);
for k=1:N
    y_vec = zeros(n, 1);
    u_vec = zeros(n, 1);

    start_ = max(1, k - m);
    end_ = max(1, k - 1);
    range_ = end_ - start_ + 1;

    y_vec(1:range_) = y(start_:end_);
    u_vec(1:range_) = u(start_:end_);
    
    sigma = [y_vec; u_vec];
    inf_matrix = inf_matrix + sigma*sigma';   
    multiplicand = multiplicand + sigma * y(k);
end

Theta_hat = inf_matrix\multiplicand;

