function Fout = mps(Fin)
% converts frequency response into minimum phase response
    Fout = exp( fft( fold( ifft( log( clipdb(Fin,-100) )))));
end