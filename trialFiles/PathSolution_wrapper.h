#include "mex.h"

#include <vector>
#include <map>
#include <algorithm>
#include <memory>
#include <string>
#include <sstream>

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////
#include "elPathSolution.h"

typedef PathSolution pathSolution_class

// List actions
enum class Action
{
	New,		// Constructor
	Delete, 	// Destructor
	Solve,		// Build beam tree
	Update,		// Find paths from listener to source
	GetPath,	// Get all points of intersection, polygons and source, listener positions in the path
	//GetSolution	// Get beam tree
};

// Map string (first input argument to mexFunction) to an Action
const std::map<std::string, Action> actionTypeMap = 
{
	{ "new",	Action::New		},
	{ "delete", Action::Delete	},
	{ "init", 	Action::Init	},
	{ "solve",	Action::Solve	},
	{ "update", Action::Update	},
	{ "getPath",Action::GetPath	},
	/*{ "getSolution",	Action::GetSolution	*/
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

typedef unsigned int handle_type
typedef std::pair<handle_type, std::shared<class_type>> indPtrPair_type;
typedef std::map(indPtrPair::first_type, indPtrPair_type::second_type> instanceMap_type;
typedef indPtrPair_type::second_type instPtr_t;

// getHandle pulls the integer handle out of prhs[1]
handle_type getHandle(int nrhs, const mxArray *prhs[]);
// checkHandle gets the position in the instance table
instanceMap_type::const_iterator checkHandle(const instanceMap_type&, handle_type);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	 // static storage duration object for table mapping handles to instances
    static instanceMap_type instanceTab;
	
	if (nrhs < 1 || !mxIsChar(prhs[0]))
			mexErrMsgTxt("First input must be an action string ('new', 'delete', or a method name).");
		
	char *actionCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string actionStr(actionCstr); mxFree(actionCstr);
	
	for (auto & c : actionStr) c = ::tolower(c); // remove this for case sensitivity
	
	if (actionTypeMap.count(actionStr) == 0)
        mexErrMsgTxt(("Unrecognized action (not in actionTypeMap): " + actionStr).c_str());
	
    // If action is not "new" or "delete" try to locate an existing instance based on input handle
    instPtr_t instance;
    if (actionTypeMap.at(actionStr) != Action::New && actionTypeMap.at(actionStr) != Action::Delete) {
        handle_type h = getHandle(nrhs, prhs);
        instanceMap_type::const_iterator instIt = checkHandle(instanceTab, h);
        instance = instIt->second;
    }
	
	//////// Step 2: customize the each action in the switch in mexFuction ////////
	switch (actionTypeMap.at(actionStr))
    {
    case Action::New:
    {
		if (nrhs > 1 && mxGetNumberOfElements(prhs[1]) != 1)
            mexErrMsgTxt("Second argument (optional) must be a scalar, N.");
		
		handle_type newHandle = instanceTab.size() ? (instanceTab.rbegin())->first + 1 : 1;
		
		std::pair<instanceMap_type::iterator, bool> insResult;
		insResult = instanceTab.insert(indPtrPair_type(newHandle, std::make_shared<class_type>()));
		
		mexLock();
		
		plhs[0] = mxCreateDoubleScalar(instResult.first->first);	// new handle
		
		break;
	}
	case Action::Delete
	{
		handle_type tempHandle = getHandle(nrhs, prhs);
		instanceMap_type::const_iterator instIt = checkHandle(instanceTab, tempHandle);
		instanceTab.erase(instIt);
		mexUnlock();
		plhs[0] = mxCreateLogicalScalar(instanceTab.find(tempHandle) == instanceTab.end());
	}
	case Action::Init
	{
		
	}
}