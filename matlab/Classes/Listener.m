classdef Listener < cppclass
% Example class for how to derive from cppclass and interface with your C++
% class. Specifically, this demonstrates the use of a C++ priority queue.
% by Jonathan Chappelow (chappjc)
    methods

        % Use the name of your MEX file here
        function obj = Listener(varargin)
            obj@cppclass('evert_wrapper','Listener',varargin{:});
        end

        % new and delete are inherited, everything else calls cppmethod()

        function varargout = getPosition(obj)
            [varargout{1:nargout}] = obj.cppmethod('getposition');
        end

        function varargout = setPosition(obj, pos)
            [varargout{1:nargout}] = obj.cppmethod('setposition', pos);
        end

        function varargout = getOrientation(obj)
            [varargout{1:nargout}] = obj.cppmethod('getorientation');
        end

        function varargout = setOrientation(obj, orientation)
            [varargout{1:nargout}] = obj.cppmethod('setorientation', orientation);
        end

    end

end
