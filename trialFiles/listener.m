classdef listener < cppclass
% Example class for how to derive from cppclass and interface with your C++ 
% class. Specifically, this demonstrates the use of a C++ priority queue.
% by Jonathan Chappelow (chappjc)
    methods
        
        % Use the name of your MEX file here
        function obj = listener(varargin)
            obj@cppclass('evert_wrapper','listener',varargin{:});
        end
        
        % new and delete are inherited, everything else calls cppmethod()
        
        % currentNumberOfElements = p.len()
        function varargout = getPosition(obj)
            [varargout{1:nargout}] = obj.cppmethod('getposition');
        end
        
        % currentNumberOfElements = p.len()
        function varargout = setPosition(obj, pos)
            [varargout{1:nargout}] = obj.cppmethod('setposition', pos);
        end
        
        % currentNumberOfElements = p.len()
        function varargout = getOrientation(obj)
            [varargout{1:nargout}] = obj.cppmethod('getorientation');
        end
        
        % currentNumberOfElements = p.len()
        function varargout = setOrientation(obj, orientation)
            [varargout{1:nargout}] = obj.cppmethod('setorientation', orientation);
        end
              
    end
        
end
