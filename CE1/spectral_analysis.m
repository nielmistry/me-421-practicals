function [f, G] = spectral_analysis(u, y, Ts, window_name, chunks)

N = length(u);

group_len = floor(N/chunks);
Syu_sum = zeros(group_len, 1);
Suu_sum = zeros(group_len, 1);


if strcmp(window_name, "hamming") 
    window = hamming(group_len);
elseif strcmp(window_name, "hann")
    window = hann(group_len);
elseif strcmp(window_name, "none")
    window = ones(group_len, 1);
else
    disp("Improper window name")
end

for chunk=1:chunks
    idx = ((chunk - 1)*group_len + 1):(chunk*group_len);

    [Ryu, h] = xcorr(y(idx), u(idx), 'unbiased');
    [Ruu, h] = xcorr(u(idx), u(idx), 'unbiased');

    mid = group_len; 
    range = (mid - floor(group_len/2) + 1):(mid + floor(group_len/2));

    Syu = fft(Ryu(range) .* window, group_len);
    Suu = fft(Ruu(range), group_len);

    Syu_sum = Syu_sum + Syu;
    Suu_sum = Suu_sum + Suu;
end

Syu_avg = Syu_sum/chunks;
Suu_avg = Suu_sum/chunks;

G = Syu_avg ./ Suu_avg;
fs = 1 / Ts;
f = (0:(group_len - 1)) * (fs / group_len);
f = 2*pi*f;
end

