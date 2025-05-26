clear all
close all

load("data/data_stable.mat")
%% 
% FIR Model Getter

d = 1;
m = 200; 

N = size(y,1);
information_matrix = zeros(m, m);

multiplicand = zeros(m, 1);
for k=1:N
    phi_entry = zeros(m, 1);
    ys = zeros(m, 1);


    start_ = k - m;
    end_ = k - d;
    start_ = max(start_, 1);
    end_ = max(end_, 1);
    range = end_ - start_ + 1;
    phi_entry(1:range) = u(start_:end_);
    ys(1:range) = y(start_:end_);
    
    
    phi = phi_entry * phi_entry';
    information_matrix = information_matrix + phi;
    multiplicand = multiplicand + phi_entry * y(k);
end


% note: this is opposite from the convention 
%       in the book. Theta_hat(1) = b_m, Theta_hat(m) = b_d
Theta_hat = information_matrix\multiplicand;

%% 
% 

y_pred = zeros(N, 1);
for k=1:N
    for i=1:m
       input = 0;
       if k - i - d + 1 >= 1
           input = u(k - i - d + 1);
       end
       y_pred(k) = y_pred(k) +  Theta_hat(m - i + 1) * input;
    end
end
%% 
% 

plot(y)
hold on
plot(y_pred)
legend(["true", "predicted"])