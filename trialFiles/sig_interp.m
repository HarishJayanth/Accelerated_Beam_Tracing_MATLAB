function y = sig_interp(x, fr)

x1 = [x(2:end); 0];
y = x + fr * (x1 - x);

end