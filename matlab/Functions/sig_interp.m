% sig_interp.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Shifts filter kernel by a fraction sample time through linear
%               interpolation.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------
function y = sig_interp(x, fr)

x1 = [x(2:end); 0];
y = x + fr * (x1 - x);

end
