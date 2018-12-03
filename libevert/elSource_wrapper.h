/*
* elSource_wrapper.h
* ------------------------------------------------------------------------------
* Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
* 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
* Description: Wrapper for class "Source"
* Author: Harish Venkatesan
*		  M.A., Music Technology
* 		  McGill University
* ------------------------------------------------------------------------------
*/

#include "mex.h"

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////
#include "src/elSource.h"
#include "src/elVector.h"

namespace evert
{
	typedef EL::Source source_class;
	typedef std::pair<handle_type, std::shared_ptr<source_class>> source_indPtrPair_type;
	typedef std::map<source_indPtrPair_type::first_type, source_indPtrPair_type::second_type> source_instanceMap_type;
	typedef source_indPtrPair_type::second_type source_instPtr_t;

	static source_instanceMap_type source_instanceTab;

	// checkHandle gets the position in the instance table
	source_instanceMap_type::const_iterator source_checkHandle(const source_instanceMap_type& m, handle_type h)
	{
		auto it = m.find(h);

		if (it == m.end())
		{
			std::stringstream ss; ss << "No Source corresponding to handle " << h << " found.";
			mexErrMsgTxt(ss.str().c_str());
		}

		return it;
	}
};

// List actions
enum class Source_Action
{
	New,			// Constructor
	Delete, 		// Destructor
	GetPosition,	// Get x, y, z coordinates
	SetPosition, 	// Set x, y, z coordinates
	GetOrientation,	// Get orientation
	SetOrientation	// Set orienation
};

// Map string (first input argument to mexFunction) to an Source_Action
const std::map<std::string, Source_Action> source_actionTypeMap =
{
	{ "new",			Source_Action::New				},
	{ "delete", 		Source_Action::Delete			},
	{ "getposition",	Source_Action::GetPosition		},
	{ "setposition",	Source_Action::SetPosition		},
	{ "getorientation",	Source_Action::GetOrientation	},
	{ "setorientation",	Source_Action::SetOrientation	}
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

void source_wrapper(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	using namespace evert;

	if (nrhs < 1 || !mxIsChar(prhs[0]))
		mexErrMsgTxt("Second input must be an Source_Action string ('new', 'delete', or a method name).");

	char *actionCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string actionStr(actionCstr); mxFree(actionCstr);

	for (auto & c : actionStr) c = ::tolower(c); // remove this for case sensitivity

	if (source_actionTypeMap.count(actionStr) == 0)
        mexErrMsgTxt(("Unrecognized Source_Action (not in source_actionTypeMap): " + actionStr).c_str());

    // If Source_Action is not "new" or "delete" try to locate an existing instance based on input handle
    source_instPtr_t instance;
    if (source_actionTypeMap.at(actionStr) != Source_Action::New && source_actionTypeMap.at(actionStr) != Source_Action::Delete)
	{
        handle_type h = getHandle(nrhs, prhs);
        source_instanceMap_type::const_iterator instIt = source_checkHandle(source_instanceTab, h);
        instance = instIt->second;
    }

	//////// Step 2: customize the each Source_Action in the switch in mexFuction ////////
	switch (source_actionTypeMap.at(actionStr))
    {
    case Source_Action::New:
	{
		if (nrhs > 1)
            mexWarnMsgTxt("Ignoring unnecessary arguments");

		handle_type newHandle = source_instanceTab.size() ? (source_instanceTab.rbegin())->first + 1 : 1;

		std::pair<source_instanceMap_type::iterator, bool> insResult;
		insResult = source_instanceTab.insert(source_indPtrPair_type(newHandle, std::make_shared<source_class>()));

		mexLock();

		plhs[0] = mxCreateDoubleScalar(insResult.first->first);

		break;
	}
	case Source_Action::Delete:
	{
		handle_type tempHandle = getHandle(nrhs, prhs);
		source_instanceMap_type::const_iterator instIt = source_checkHandle(source_instanceTab, tempHandle);
		source_instanceTab.erase(instIt);
		mexUnlock();
		plhs[0] = mxCreateLogicalScalar(source_instanceTab.find(tempHandle) == source_instanceTab.end());

        break;
	}
	case Source_Action::GetPosition:
	{
		//if (nlhs != 1)
		//	mexErrMsgTxt("Specify 1 output variable. (x, y, z coordinates as an array)");

		EL::Vector3 pos = instance->getPosition();
		double *coord;
        plhs[0] = mxCreateDoubleMatrix(1, 3, mxREAL);
// 		coord = mxCreateDoubleMatrix(1, 3, mxREAL);
// 		plhs[0] = mxGetPr(coord);
        coord = (double*)mxGetPr(plhs[0]);

		for (int i = 0; i < 3; i++)
			coord[i] = pos[i];

        break;
    }
	case Source_Action::SetPosition:
	{
		if (nrhs != 3)
			mexErrMsgTxt("Specify [x, y, z] as input");

		double* coord = (double*)mxGetData(prhs[2]);
		EL::Vector3 pos((float)coord[0], (float)coord[1], (float)coord[2]);
		instance->setPosition(pos);
		plhs[0] = mxCreateLogicalScalar(true);

        break;
	}
    case Source_Action::GetOrientation:
	{
		//if (nlhs != 1)
		//	mexErrMsgTxt("Specify 1 output variable. (rotation matrix)");

		EL::Matrix3 ornt = instance->getOrientation();
		double **rotMat;
		plhs[0] = mxCreateDoubleMatrix(3, 3, mxREAL);
		rotMat = (double**)mxGetPr(plhs[0]);

		for (int i = 0; i < 3; i++)
		{
			EL::Vector3 row = ornt.getRow(i);
			for (int j = 0; j < 3; j++)
				rotMat[i][j] = row[j];
		}

        break;

	}
    case Source_Action::SetOrientation:
	{
		if (nrhs != 3)
			mexErrMsgTxt("Specify orientation as rotation matrix");

		double** rotMat;
        rotMat = (double**)mxGetPr(prhs[3]);
		EL::Matrix3 ornt((float)rotMat[0][0], (float)rotMat[0][1], (float)rotMat[0][2],
					 (float)rotMat[1][0], (float)rotMat[1][1], (float)rotMat[1][2],
					 (float)rotMat[2][0], (float)rotMat[2][1], (float)rotMat[2][2]);
		instance->setOrientation(ornt);
		plhs[0] = mxCreateLogicalScalar(true);

        break;

	}
	default:
		mexErrMsgTxt(("Unrecognized function: " + actionStr).c_str());
		break;
	}
}
