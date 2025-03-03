function [R, h] = intcor(u, y)
%INTCOR Correlation of signal u with signal y
%   Detailed explanation goes here

M = seqperiod(u);
assert(M == seqperiod(y), "the periods of the two signals must match...")

h = -M:1:M;
R = zeros(length(h), 1);

for i=1:length(h)
    for k=0:M-1
        k_wrapped = mod(k, M) + 1;
        kh_wrapped = mod(k - h(i), M) + 1;
        R(i) = R(i) + u(k_wrapped)*u(kh_wrapped);
    end
    R(i) = R(i) * 1/M;
end

end

