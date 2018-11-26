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
            if ~strcmp(rm.getType(), 'room') && ~strcmp(src.getType(),'source')...
                ~strcmp(lst.getType(),'listener')
                error('Invalid arguments: Argin = (room_inst, source_inst, listener_inst)')
            end
            obj@cppclass('evert_wrapper','pathsolution', 0,rm.getHandle(), ...
                src.getHandle(), lst.getHandle(), maxOrd);
%             obj.solve(obj);
        end

        % new and delete are inherited, everything else calls cppmethod()

        % currentNumberOfElements = p.len()
        function varargout = solve(obj, varargin)
            [varargout{1:nargout}] = obj.cppmethod('solve', varargin{:});
%             disp('Solution computed.')
            obj.changed = 1;
        end

        function varargout = update(obj)
            [varargout{1:nargout}] = obj.cppmethod('update');
%             disp('Solution updated.')
            obj.nPaths = numPaths(obj);
            obj.changed = 1;
        end

        function varargout = numPaths(obj)
            if isempty(obj.nPaths) || obj.changed
                [varargout{1:nargout}] = obj.cppmethod('numpaths');
                obj.changed = 0;
                obj.nPaths = varargout{1};
            end
        end

        function varargout = getPath(obj, pathInd)
            if isempty(obj.nPaths)
                error('Compute solution first');
            elseif pathInd < 1 || pathInd > length(obj.nPaths)
%                 error('Index out of bounds');
            end
            [varargout{1:nargout}] = obj.cppmethod('getpath', pathInd - 1);
        end

    end

end
