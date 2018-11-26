fs = 48000;
f = 31.5 .* (2.^[0:9]);
% filtOrder = 5;
% 
% filtCoeffs = cell(length(f),1);
% 
% [z, p, k] = butter(filtOrder, 3*f(1)/fs);
% filtCoeffs{1} = zp2sos(z, p, k);
% for i = 2:9
%     [a, b, c, d] = butter(filtOrder, 3*[f(i-1) f(i)]/fs);
%     filtCoeffs{i} = ss2sos(a, b, c, d);
% end
% [z, p, k] = butter(filtOrder, 0.5*(20000+f(end))/fs, 'high');
% filtCoeffs{end} = zp2sos(z, p, k);
% 
% save('filtCoeffs.mat', 'fs', 'filtCoeffs');

N = 512;
nCutoff = ceil([1, 1.5*f(1:end-1)*N/fs, 0.5*(20000+f(end))*N/fs]);
w = 3*f/fs;
w(end) = (20000 + f(end))/fs;

b = zeros(10, N);
b(1,:) = fir1(N-1, w(1), 'low', hann(N));

win = hann(N);
Win = fft(win, N);
for i = 2:length(w)
    b(i,:) = fir1(N-1, [w(i-1) w(i)], hann(N));
%     plot(abs(Y));
%     plot(abs(Win));
%     hold on;
end
save('filtImp.mat', 'fs', 'f', 'b');

