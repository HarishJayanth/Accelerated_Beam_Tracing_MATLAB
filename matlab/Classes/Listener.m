% Listener.m
% ------------------------------------------------------------------------------
% Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
% 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
% Description: Matlab Class that mirrors "Listener" C++ class.
% Author: Harish Venkatesan
%		  M.A., Music Technology
% 		  McGill University
% ------------------------------------------------------------------------------

classdef Listener < cppclass
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
