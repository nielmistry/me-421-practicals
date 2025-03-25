function [R, h] = intcor(u, y)

M = length(u);
R = zeros(1, M);
for lag = 0:M-1
    R(lag + 1) = sum(u .* circshift(y, lag)); 
end

h = 0:M-1;

R = R / M;  
end
