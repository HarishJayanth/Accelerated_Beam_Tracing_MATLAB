// elRoom_wrapper.h
#include "mex.h"

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////
#include "src/elRoom.h"

namespace evert
{
	typedef EL::Room room_class;
	typedef std::pair<handle_type, std::shared_ptr<room_class>> room_indPtrPair_type;
	typedef std::map<room_indPtrPair_type::first_type, room_indPtrPair_type::second_type> room_instanceMap_type;
	typedef room_indPtrPair_type::second_type room_instPtr_t;

	static room_instanceMap_type room_instanceTab;

	// checkHandle gets the position in the instance table
	room_instanceMap_type::const_iterator room_checkHandle(const room_instanceMap_type& m, handle_type h)
	{
		auto it = m.find(h);

		if (it == m.end())
		{
			std::stringstream ss; ss << "No room corresponding to handle " << h << " found.";
			mexErrMsgTxt(ss.str().c_str());
		}

		return it;
	}
};

// List actions
enum class Room_Action
{
	New,			// Constructor
	Delete, 		// Destructor
	Import			// Import room file
};

// Map string (first input argument to mexFunction) to an Room_Action
const std::map<std::string, Room_Action> room_actionTypeMap =
{
	{ "new",	Room_Action::New	},
	{ "delete", Room_Action::Delete	},
	{ "import",	Room_Action::Import	}
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

void room_wrapper(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	using namespace evert;

	if (nrhs < 1 || !mxIsChar(prhs[0]))
			mexErrMsgTxt("Second input must be an Room_Action string ('new', 'delete', or a method name).");

	char *actionCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string actionStr(actionCstr); mxFree(actionCstr);

	for (auto & c : actionStr) c = ::tolower(c); // remove this for case sensitivity

	if (room_actionTypeMap.count(actionStr) == 0)
        mexErrMsgTxt(("Unrecognized Room_Action (not in room_actionTypeMap): " + actionStr).c_str());

    // If Room_Action is not "new" or "delete" try to locate an existing instance based on input handle
    room_instPtr_t instance;
    if (room_actionTypeMap.at(actionStr) != Room_Action::New && room_actionTypeMap.at(actionStr) != Room_Action::Delete)
	{
        handle_type h = getHandle(nrhs, prhs);
        room_instanceMap_type::const_iterator instIt = room_checkHandle(room_instanceTab, h);
        instance = instIt->second;
    }

	//////// Step 2: customize the each Room_Action in the switch in mexFuction ////////
	switch (room_actionTypeMap.at(actionStr))
    {
    case Room_Action::New:
    {
		if (nrhs > 1)
            mexWarnMsgTxt("Ignoring unnecessary arguments");

		handle_type newHandle = room_instanceTab.size() ? (room_instanceTab.rbegin())->first + 1 : 1;

		std::pair<room_instanceMap_type::iterator, bool> insResult;
		insResult = room_instanceTab.insert(room_indPtrPair_type(newHandle, std::make_shared<room_class>()));

		mexLock();

		plhs[0] = mxCreateDoubleScalar(insResult.first->first);

		break;
	}
	case Room_Action::Delete:
	{
		handle_type tempHandle = getHandle(nrhs, prhs);
		room_instanceMap_type::const_iterator instIt = room_checkHandle(room_instanceTab, tempHandle);
		room_instanceTab.erase(instIt);
		mexUnlock();
		plhs[0] = mxCreateLogicalScalar(room_instanceTab.find(tempHandle) == room_instanceTab.end());

		break;

	}
	case Room_Action::Import:
	{
		if (nrhs != 4)
			mexErrMsgTxt("Incorrect number of input arguments. (Argin: function, room_handle, import_file, materials_handle)");

		auto materialFileInstIt = materialFile_instanceTab.find(mxGetScalar(prhs[3]));
		if (materialFileInstIt == materialFile_instanceTab.end())
			mexErrMsgTxt("Material object not found. Import materials from file before importing room.");
		materialFile_instPtr_t materialFileInstance = materialFileInstIt->second;

		const char* filename = mxArrayToString(prhs[2]);
		bool result = instance->import(filename, *materialFileInstance);
		plhs[0] = mxCreateLogicalScalar(result);

		break;

	}
	default:
		mexErrMsgTxt(("Unrecognized function: " + actionStr).c_str());
		break;
	}
}
