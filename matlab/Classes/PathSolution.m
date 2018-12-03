% PathSolution.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Matlab Class that mirrors "PathSolution" C++ class.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------
classdef PathSolution < cppclass
% Example class for how to derive from cppclass and interface with your C++
% class. Specifically, this demonstrates the use of a C++ priority queue.
% by Jonathan Chappelow (chappjc)
    properties
        nPaths, changed
    end
    methods

        % Use the name of your MEX file here
        function obj = PathSolution(rm, src, lst, maxOrd)
            if ~strcmp(rm.getType(), 'Room') && ~strcmp(src.getType(),'Source')...
                ~strcmp(lst.getType(),'Listener')
                error('Invalid arguments: Argin = (room_inst, source_inst, listener_inst)')
            end
            obj@cppclass('evert_wrapper','pathsolution', 0,rm.getHandle(), ...
                src.getHandle(), lst.getHandle(), maxOrd);
        end

        % new and delete are inherited, everything else calls cppmethod()

        function varargout = solve(obj, varargin)
            [varargout{1:nargout}] = obj.cppmethod('solve', varargin{:});
            obj.changed = 1;
        end

        function varargout = update(obj)
            [varargout{1:nargout}] = obj.cppmethod('update');
            obj.nPaths = numPaths(obj);
            obj.changed = 1;
        end

        function varargout = numPaths(obj)
            [varargout{1:nargout}] = obj.cppmethod('numpaths');
            obj.changed = 0;
            obj.nPaths = varargout{1};
        end

        function varargout = getPath(obj, pathInd)
            if isempty(obj.nPaths)
                error('Compute solution first');
            end
            [varargout{1:nargout}] = obj.cppmethod('getpath', pathInd - 1);
        end

    end

end
