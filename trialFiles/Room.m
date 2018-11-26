classdef Room < cppclass
% Example class for how to derive from cppclass and interface with your C++
% class. Specifically, this demonstrates the use of a C++ priority queue.
% by Jonathan Chappelow (chappjc)
    methods

        % Use the name of your MEX file here
        function obj = Room(varargin)
            obj@cppclass('evert_wrapper','room',varargin{:});
        end

        % new and delete are inherited, everything else calls cppmethod()

        % currentNumberOfElements = p.len()
        function varargout = import(obj, filename, mat)
            if ~strcmp(mat.getType(), 'materialFile')
                error('Invalid Arguments: Argin = (filename, materialFile_inst)')
            end
            [varargout{1:nargout}] = obj.cppmethod('import', filename, mat.getHandle());
        end

    end

end
