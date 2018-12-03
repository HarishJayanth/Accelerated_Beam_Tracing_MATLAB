% getPathLength.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Computes path length using points of reflection in the path.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------

function pathLen = getPathLength(path)

pathLen = 0;
for i = 1:size(path,1) - 1
    pathLen = pathLen + sum((path(i,:) - path(i+1,:)).^2).^0.5;
end

end
