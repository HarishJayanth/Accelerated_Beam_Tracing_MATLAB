classdef materialFile < cppclass
% Example class for how to derive from cppclass and interface with your C++
% class. Specifically, this demonstrates the use of a C++ priority queue.
% by Jonathan Chappelow (chappjc)
    methods

        % Use the name of your MEX file here
        function obj = materialFile(varargin)
            obj@cppclass('evert_wrapper','materialFile',varargin{:});
        end

        % new and delete are inherited, everything else calls cppmethod()

        % currentNumberOfElements = p.len()
        function varargout = readFile(obj,file)
            [varargout{1:nargout}] = obj.cppmethod('readfile', file);
        end
        
        function varargout = find(obj, matName)
            [varargout{1:nargout}] = obj.cppmethod('find', matName);
        end

    end

end
