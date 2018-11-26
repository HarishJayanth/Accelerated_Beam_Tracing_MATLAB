classdef source < cppclass
% Example class for how to derive from cppclass and interface with your C++ 
% class. Specifically, this demonstrates the use of a C++ priority queue.
% by Jonathan Chappelow (chappjc)
    methods
        
        % Use the name of your MEX file here
        function obj = source(varargin)
            obj@cppclass('evert_wrapper',varargin{:});
        end
        
        % new and delete are inherited, everything else calls cppmethod()
        
        % currentNumberOfElements = p.len()
        function varargout = getPosition(obj)
            [varargout{1:nargout}] = obj.cppmethod('source','getposition');
        end
        
        % currentNumberOfElements = p.len()
        function varargout = setPosition(obj, pos)
            [varargout{1:nargout}] = obj.cppmethod('source', 'setposition', pos);
        end
        
        % currentNumberOfElements = p.len()
        function varargout = getOrientation(obj)
            [varargout{1:nargout}] = obj.cppmethod('source','getorientation');
        end
        
        % currentNumberOfElements = p.len()
        function varargout = setOrientation(obj, orientation)
            [varargout{1:nargout}] = obj.cppmethod('source','setOrientation', orientation);
        end
        
        % currentNumberOfElements = p.len()
        function varargout = getPosition(obj)
            [varargout{1:nargout}] = obj.cppmethod('source','getposition');
        end
        
        % p.printHeap()
        function printHeap(obj)
            obj.cppmethod('print');
        end
        
        % init/reinit
        function varargout = init(obj,N)
            if (obj.len()>0),
                warning('pqheap:heapNotEmpty','Re-initializing non-empty heap'); end
            [varargout{1:nargout}] = obj.cppmethod('init',N);
        end
        
    end
        
end
