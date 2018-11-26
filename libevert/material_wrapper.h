// materialFile_wrapper.h
#include "mex.h"
#include <iostream>

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////
#include "src/material.h"

namespace evert
{
	typedef MaterialFile materialFile_class;
	typedef std::pair<handle_type, std::shared_ptr<materialFile_class>> materialFile_indPtrPair_type;
	typedef std::map<materialFile_indPtrPair_type::first_type, materialFile_indPtrPair_type::second_type> materialFile_instanceMap_type;
	typedef materialFile_indPtrPair_type::second_type materialFile_instPtr_t;

	static materialFile_instanceMap_type materialFile_instanceTab;

	// checkHandle gets the position in the instance table
	materialFile_instanceMap_type::const_iterator materialFile_checkHandle(const materialFile_instanceMap_type& m, handle_type h)
	{
		auto it = m.find(h);

		if (it == m.end())
		{
			std::stringstream ss; ss << "No MaterialFile corresponding to handle " << h << " found.";
			mexErrMsgTxt(ss.str().c_str());
		}

		return it;
	}
};

// List actions
enum class MaterialFile_Action
{
	New,		// Constructor
	Delete,		// Destructor
	ReadFile,	// Read from file
	Find		// Find material
};

// Map string (first input argument to mexFunction) to an MaterialFile_Action
const std::map<std::string, MaterialFile_Action> materialFile_actionTypeMap =
{
	{ "new",		MaterialFile_Action::New		},
	{ "delete", 	MaterialFile_Action::Delete		},
	{ "readfile",	MaterialFile_Action::ReadFile	},
	{ "find", 		MaterialFile_Action::Find		}
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

void materialFile_wrapper(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	using namespace evert;

	if (nrhs < 1 || !mxIsChar(prhs[0]))
			mexErrMsgTxt("Second input must be an MaterialFile_Action string ('new', 'delete', 'readfile' or a method name).");

	char *actionCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string actionStr(actionCstr); mxFree(actionCstr);

	for (auto & c : actionStr) c = ::tolower(c); // remove this for case sensitivity

	if (materialFile_actionTypeMap.count(actionStr) == 0)
        mexErrMsgTxt(("Unrecognized MaterialFile_Action (not in materialFile_actionTypeMap): " + actionStr).c_str());

    // If MaterialFile_Action is not "new" or "delete" try to locate an existing instance based on input handle
    materialFile_instPtr_t instance;
    if (materialFile_actionTypeMap.at(actionStr) != MaterialFile_Action::New && materialFile_actionTypeMap.at(actionStr) != MaterialFile_Action::Delete)
	{
        handle_type h = getHandle(nrhs, prhs);
        materialFile_instanceMap_type::const_iterator instIt = materialFile_checkHandle(materialFile_instanceTab, h);
        instance = instIt->second;
    }

	//////// Step 2: customize the each MaterialFile_Action in the switch in mexFuction ////////
	switch (materialFile_actionTypeMap.at(actionStr))
    {
    case MaterialFile_Action::New:
	{
		if (nrhs > 1)
			mexWarnMsgTxt("Ignoring unnecessary arguments");

		handle_type newHandle = materialFile_instanceTab.size() ? (materialFile_instanceTab.rbegin())->first + 1 : 1;

		std::pair<materialFile_instanceMap_type::iterator, bool> insResult;
		insResult = materialFile_instanceTab.insert(materialFile_indPtrPair_type(newHandle, std::make_shared<materialFile_class>()));

		mexLock();

		plhs[0] = mxCreateDoubleScalar(insResult.first->first);

		break;
	}
	case MaterialFile_Action::Delete:
	{
		handle_type tempHandle = getHandle(nrhs, prhs);
		materialFile_instanceMap_type::const_iterator instIt = materialFile_checkHandle(materialFile_instanceTab, tempHandle);
		materialFile_instanceTab.erase(instIt);
		mexUnlock();
		plhs[0] = mxCreateLogicalScalar(materialFile_instanceTab.find(tempHandle) == materialFile_instanceTab.end());
		break;
	}
	case MaterialFile_Action::ReadFile:
	{
		if (nrhs != 3)
			mexErrMsgTxt("Incorrect number of input arguments. (Argin: function, materialFile_handle, import_file)");

		const char* filename = mxArrayToString(prhs[2]);
		instance->readFile(filename);
		plhs[0] = mxCreateLogicalScalar(true);
		break;
	}
	case MaterialFile_Action::Find:
	{
		const char* matName = mxArrayToString(prhs[2]);
		Material mat = instance->find(matName);

		char *fieldnames[3];
		fieldnames[0] = (char*)mxMalloc(20);
		fieldnames[1] = (char*)mxMalloc(20);
		fieldnames[2] = (char*)mxMalloc(20);

		memcpy(fieldnames[0], "Absorption", sizeof("Absorption"));
		memcpy(fieldnames[1], "Diffusion", sizeof("Diffusion"));
		memcpy(fieldnames[2], "Transmission", sizeof("Transmission"));

		plhs[0] = mxCreateStructMatrix(1, 1, 3, (const char**)fieldnames);

		mxFree(fieldnames[0]);
		mxFree(fieldnames[1]);
		mxFree(fieldnames[2]);

		mxArray *ab, *diff, *trans;
		double *abptr, *diffptr, *transptr;
		ab = mxCreateDoubleMatrix(1, 10, mxREAL);
		diff = mxCreateDoubleMatrix(1, 10, mxREAL);
		trans = mxCreateDoubleMatrix(1, 10, mxREAL);
		abptr = mxGetPr(ab);
		diffptr = mxGetPr(diff);
		transptr = mxGetPr(trans);

		for (int j = 0; j < 10; j++)
		{
			abptr[j] = mat.absorption[j];
			diffptr[j] = mat.diffusion[j];
			transptr[j] = mat.transmission[j];
		}

		mxSetFieldByNumber(plhs[0], 0, 0, ab);
		mxSetFieldByNumber(plhs[0], 0, 1, diff);
		mxSetFieldByNumber(plhs[0], 0, 2, trans);

		break;
	}
	default:
		mexErrMsgTxt(("Unrecognized function: " + actionStr).c_str());
		break;
	}
}
