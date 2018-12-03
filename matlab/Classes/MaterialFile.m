% MaterialFile.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Matlab Class that mirrors "MaterialFile" C++ class.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------
classdef MaterialFile < cppclass
    methods

        % Use the name of your MEX file here
        function obj = MaterialFile(varargin)
            obj@cppclass('evert_wrapper','MaterialFile',varargin{:});
        end

        % new and delete are inherited, everything else calls cppmethod()
        function varargout = readFile(obj,file)
            [varargout{1:nargout}] = obj.cppmethod('readfile', file);
        end

        function varargout = find(obj, matName)
            [varargout{1:nargout}] = obj.cppmethod('find', matName);
        end

    end

end
