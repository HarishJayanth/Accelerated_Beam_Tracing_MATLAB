% Room.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Matlab Class that mirrors "Room" C++ class.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------
classdef Room < cppclass
    methods

        % Use the name of your MEX file here
        function obj = Room(varargin)
            obj@cppclass('evert_wrapper','room',varargin{:});
        end

        % new and delete are inherited, everything else calls cppmethod()

        function varargout = import(obj, filename, mat)
            if ~strcmp(mat.getType(), 'MaterialFile')
                error('Invalid Arguments: Argin = (filename, materialFile_inst)')
            end
            [varargout{1:nargout}] = obj.cppmethod('import', filename, mat.getHandle());
        end

    end

end
