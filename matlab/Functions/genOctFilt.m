% genOctFilt.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Generates fir octave filter kernels of specified length for the
%               given sample rate fs.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------

fs = 48000;
fftSize = 128;

f = [0:fftSize/2 - 1]*fs/fftSize;
fcentre = 31.5 .* (2.^[0:9]);
freqBands = fcentre * 2^0.5;
faxis = log2([0:fs/2]/freqBands(1));

bands_warped = ones(size(faxis, 2), 10)*0.0000001;
bands_warped(1:find(faxis > 0,1)-1) = bands_warped(1:find(faxis > 0,1)-1) + 1;
t = 1;  % transition band taper parameter. 1 = Triangular passband, 0 = Square Passband
for i = 1:9
    b = i - 1;
    bands_warped(find(faxis > b, 1):find(faxis > b + t, 1) - 1, i) = (b + t - faxis(find(faxis > b, 1):find(faxis > b + t, 1) - 1))/t;
    bands_warped(find(faxis > b, 1):find(faxis > b + t, 1) - 1, i+1) = (faxis(find(faxis > b, 1):find(faxis > b+t, 1) - 1) - b - t)/t + 1;
    bands_warped(find(faxis > b + t,1):find(faxis > i, 1), i+1) = bands_warped(find(faxis > b + t,1):find(faxis > i, 1)) + 1;
end
bands_warped(find(faxis > 8 + t, 1):end, 10) = bands_warped(find(faxis > 8 + t, 1):end, 10) * 0 + 1;

flog = freqBands(1)*2.^faxis;
octBands = zeros(2*length(f),10);
ir = zeros(2*length(f),10);
win = hann(fftSize);
W = fft(win, fftSize);
for i= 1:size(bands_warped,2)
    octBands(1:end/2,i) = interp1(flog, bands_warped(:,i), f);
    octBands(end/2,i) = octBands(end/2 - 1, i);
    octBands(end/2+1:end,i) = octBands(end/2:-1:1,i);
end

save('octFilt_freqDomain.mat', 'octBands', 'fs');
