clear all
close all

matlab = false;

load("data/data_stable.mat")
Ts = 0.01;
t = (0:Ts:(size(y) - 1)*(Ts))';
tt = timetable(u, y, 'SampleRate', 1/Ts);
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
Theta_hat_ml = impulseest(tt, 201, d).Numerator(2:202)';

%% 
% 

y_pred = zeros(N, 1);
y_pred_ml = zeros(N, 1);
for k=1:N
    for i=1:m
       input = 0;
       if k - i - d + 1 >= 1
           input = u(k - i - d + 1);
       end
       y_pred(k) = y_pred(k) +  Theta_hat(m - i + 1) * input;
       y_pred_ml(k) = y_pred_ml(k) + Theta_hat_ml(i) * input;
    end
end
%% 
% 
f = figure(1);
clf
plot(t, y, 'DisplayName', "True Output")
hold on
plot(t, y_pred, 'DisplayName', 'Predicted Output')
if matlab == true
    plot(t, y_pred_ml, 'DisplayName', 'MATLAB Output')
end
legend()
grid()
title("y vs FIR y_{pred}")
saveas(f, "plots/fir_y_ypred.png")
