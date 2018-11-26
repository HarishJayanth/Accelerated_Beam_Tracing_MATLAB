// ellistener_wrapper.h
#include "mex.h"

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////
#include "src/elListener.h"
#include "src/elVector.h"

namespace evert
{
	typedef EL::Listener listener_class;
	typedef std::pair<handle_type, std::shared_ptr<listener_class>> listener_indPtrPair_type;
	typedef std::map<listener_indPtrPair_type::first_type, listener_indPtrPair_type::second_type> listener_instanceMap_type;
	typedef listener_indPtrPair_type::second_type listener_instPtr_t;

	static listener_instanceMap_type listener_instanceTab;

	// checkHandle gets the position in the instance table
	listener_instanceMap_type::const_iterator listener_checkHandle(const listener_instanceMap_type& m, handle_type h)
	{
		auto it = m.find(h);

		if (it == m.end())
		{
			std::stringstream ss; ss << "No Listener corresponding to handle " << h << " found.";
			mexErrMsgTxt(ss.str().c_str());
		}

		return it;
	}
};

// List actions
enum class Listener_Action
{
	New,			// Constructor
	Delete, 		// Destructor
	GetPosition,	// Get x, y, z coordinates
	SetPosition, 	// Set x, y, z coordinates
	GetOrientation,	// Get orientation
	SetOrientation	// Set orienation
};

// Map string (first input argument to mexFunction) to an Listener_Action
const std::map<std::string, Listener_Action> listener_actionTypeMap =
{
	{ "new",			Listener_Action::New			},
	{ "delete", 		Listener_Action::Delete			},
	{ "getposition",	Listener_Action::GetPosition	},
	{ "setposition",	Listener_Action::SetPosition	},
	{ "getorientation",	Listener_Action::GetOrientation	},
	{ "setorientation",	Listener_Action::SetOrientation	}
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

void listener_wrapper(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	using namespace evert;

	if (nrhs < 1 || !mxIsChar(prhs[0]))
		mexErrMsgTxt("Second input must be an Listener_Action string ('new', 'delete', or a method name).");

	char *actionCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string actionStr(actionCstr); mxFree(actionCstr);

	for (auto & c : actionStr) c = ::tolower(c); // remove this for case sensitivity

	if (listener_actionTypeMap.count(actionStr) == 0)
        mexErrMsgTxt(("Unrecognized Listener_Action (not in listener_actionTypeMap): " + actionStr).c_str());

    // If Listener_Action is not "new" or "delete" try to locate an existing instance based on input handle
    listener_instPtr_t instance;
    if (listener_actionTypeMap.at(actionStr) != Listener_Action::New && listener_actionTypeMap.at(actionStr) != Listener_Action::Delete)
	{
        handle_type h = getHandle(nrhs, prhs);
        listener_instanceMap_type::const_iterator instIt = listener_checkHandle(listener_instanceTab, h);
        instance = instIt->second;
    }

	//////// Step 2: customize the each Listener_Action in the switch in mexFuction ////////
	switch (listener_actionTypeMap.at(actionStr))
    {
    case Listener_Action::New:
	{
		if (nrhs > 1)
            mexWarnMsgTxt("Ignoring unnecessary arguments");

		handle_type newHandle = listener_instanceTab.size() ? (listener_instanceTab.rbegin())->first + 1 : 1;

		std::pair<listener_instanceMap_type::iterator, bool> insResult;
		insResult = listener_instanceTab.insert(listener_indPtrPair_type(newHandle, std::make_shared<listener_class>()));

		mexLock();

		plhs[0] = mxCreateDoubleScalar(insResult.first->first);

		break;
	}
	case Listener_Action::Delete:
	{
		handle_type tempHandle = getHandle(nrhs, prhs);
		listener_instanceMap_type::const_iterator instIt = listener_checkHandle(listener_instanceTab, tempHandle);
		listener_instanceTab.erase(instIt);
		mexUnlock();
		plhs[0] = mxCreateLogicalScalar(listener_instanceTab.find(tempHandle) == listener_instanceTab.end());

        break;
	}
	case Listener_Action::GetPosition:
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
	case Listener_Action::SetPosition:
	{
		if (nrhs != 3)
			mexErrMsgTxt("Specify [x, y, z] as input");

		double* coord = (double*)mxGetData(prhs[2]);
		EL::Vector3 pos((float)coord[0], (float)coord[1], (float)coord[2]);
		instance->setPosition(pos);
		plhs[0] = mxCreateLogicalScalar(true);

        break;
	}
    case Listener_Action::GetOrientation:
	{
		//if (nlhs != 1)
		//	mexErrMsgTxt("Specify 1 output variable. (rotation matrix)");

		EL::Matrix3 ornt = instance->getOrientation();
		double *rotMat;
		plhs[0] = mxCreateDoubleMatrix(3, 3, mxREAL);
		rotMat = (double*)mxGetPr(plhs[0]);

		for (int i = 0; i < 3; i++)
		{
			EL::Vector3 row = ornt.getRow(i);
			for (int j = 0; j < 3; j++)
				rotMat[i + j*3] = (double)row[j];
		}

        break;

	}
    case Listener_Action::SetOrientation:
	{
		if (nrhs != 3)
			mexErrMsgTxt("Specify orientation as rotation matrix");

		double* rotMat;
        rotMat = (double*)mxGetPr(prhs[3]);
		EL::Matrix3 ornt((float)rotMat[0], (float)rotMat[1], (float)rotMat[2],
					 (float)rotMat[3], (float)rotMat[4], (float)rotMat[5],
					 (float)rotMat[6], (float)rotMat[7], (float)rotMat[8]);
		instance->setOrientation(ornt);
		plhs[0] = mxCreateLogicalScalar(true);

        break;

	}
	default:
		mexErrMsgTxt(("Unrecognized function: " + actionStr).c_str());
		break;
	}
}
