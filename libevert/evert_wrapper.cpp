/*
* evert_wrapper.cpp
* ------------------------------------------------------------------------------
* Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
* 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
* Description: EVERT matlab interface
* 				Calls to the mexFunction contain the following arguments
* 				1. Class Type - ex. PathSolution, Room, Source, Listener,...
* 				2. Function to be called - the ex. new, delete, ....
* 				3. Arguments to the function
* Author: Harish Venkatesan
*		  M.A., Music Technology
* 		  McGill University
* ------------------------------------------------------------------------------
*
*/
#include "mex.h"

#include <vector>
#include <map>
#include <algorithm>
#include <memory>
#include <string>
#include <sstream>

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////

namespace evert
{
	typedef unsigned int handle_type;

	// getHandle pulls the integer handle out of prhs passed to the function: called in class wrapper functions
	handle_type getHandle(int nrhs, const mxArray *prhs[])
	{
		if (nrhs < 2 || mxGetNumberOfElements(prhs[1]) != 1) // mxIsScalar in R2015a+
			mexErrMsgTxt("Specify an instance with an integer handle.");
		return static_cast<handle_type>(mxGetScalar(prhs[1]));
	}
}

#include "elSource_wrapper.h"
#include "elListener_wrapper.h"
#include "material_wrapper.h"
#include "elRoom_wrapper.h"
#include "elPathSolution_wrapper.h"

// List of classes
enum class Class
{
	Room,			// elRoom Class
	Source, 		// elSource Class
	Listener,		// elListener Class
	PathSolution,	// elPathSolution Class
	MaterialFile	// MaterialFile Class
};

// Map string (first input argument to mexFunction) to an Action
const std::map<std::string, Class> classTypeMap =
{
	{ "room",			Class::Room			},
	{ "source", 		Class::Source		},
	{ "listener",		Class::Listener		},
	{ "pathsolution", 	Class::PathSolution	},
	{ "materialfile", 	Class::MaterialFile	},
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    using namespace evert;

	if (nrhs < 1 || !mxIsChar(prhs[0]))
			mexErrMsgTxt("First input must be a class type ('pathSolution', 'source', 'listener', 'room', 'materialfile').");

	char *classCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string classStr(classCstr); mxFree(classCstr);

	for (auto & c : classStr) c = ::tolower(c); // remove this for case sensitivity

	if (classTypeMap.count(classStr) == 0)
        mexErrMsgTxt(("Unrecognized class (not in classTypeMap): " + classStr).c_str());

	//////// Step 2: pass the arguments to the corresponding class wrappers ////////
	switch (classTypeMap.at(classStr))
    {
    case Class::Room:
    {
		room_wrapper(nlhs, plhs, nrhs - 1, &prhs[1]);
		break;
	}
	case Class::Source:
    {
		source_wrapper(nlhs, plhs, nrhs - 1, &prhs[1]);
		break;
	}
	case Class::Listener:
    {
		listener_wrapper(nlhs, plhs, nrhs - 1, &prhs[1]);
		break;
	}
	case Class::PathSolution:
    {
		pathSolution_wrapper(nlhs, plhs, nrhs - 1, &prhs[1]);
		break;
	}
	case Class::MaterialFile:
	{
		materialFile_wrapper(nlhs, plhs, nrhs - 1, &prhs[1]);
		break;
	}
	default:
		mexErrMsgTxt(("Unhandled class: " + classStr).c_str());
		break;
	}
	////////////////////////////////  DONE!  ////////////////////////////////
}
