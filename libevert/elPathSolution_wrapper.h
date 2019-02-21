/*
* elPathSolution_wrapper.h
* ------------------------------------------------------------------------------
* Project title: EVERT_matlab - MATLAB Wrappers for the EVERT library.
* 			  https://users.aalto.fi/~laines9/publications/laine2009aa_code.zip
* Description: Wrapper for class "PathSolution"
* Author: Harish Venkatesan
*		  M.A., Music Technology
* 		  McGill University
* ------------------------------------------------------------------------------
*/

#include "mex.h"
#include <iostream>

////////////////////////  BEGIN Step 1: Configuration  ////////////////////////
#include "src/elPathSolution.h"
#include "src/material.h"
#include "src/elVector.h"

namespace evert
{
	typedef EL::PathSolution pathSolution_class;
	typedef std::pair<handle_type, std::shared_ptr<pathSolution_class>> pathSol_indPtrPair_type;
	typedef std::map<pathSol_indPtrPair_type::first_type, pathSol_indPtrPair_type::second_type> pathSol_instanceMap_type;
	typedef pathSol_indPtrPair_type::second_type pathSol_instPtr_t;

	static pathSol_instanceMap_type pathSol_instanceTab;

	// checkHandle gets the position in the instance table
	pathSol_instanceMap_type::const_iterator pathSol_checkHandle(const pathSol_instanceMap_type& m, handle_type h)
	{
		auto it = m.find(h);

		if (it == m.end())
		{
			std::stringstream ss; ss << "No path solution corresponding to handle " << h << " found.";
			mexErrMsgTxt(ss.str().c_str());
		}

		return it;
	}
};

// List actions
enum class PathSol_Action
{
	New,			// Constructor
	Delete, 		// Destructor
	Solve,			// Build beam tree
	Update,			// Find paths from listener to source
	NumPaths,		// Get number of paths
	GetPath,		// Get all points of intersection, polygons and source, listener positions in the path
	GetBeamTree		// Get beam tree
};

// Map string (first input argument to mexFunction) to an PathSol_Action
const std::map<std::string, PathSol_Action> pathSol_actionTypeMap =
{
	{ "new",			PathSol_Action::New			},
	{ "delete", 		PathSol_Action::Delete		},
	{ "solve",			PathSol_Action::Solve		},
	{ "update", 		PathSol_Action::Update		},
	{ "numpaths",		PathSol_Action::NumPaths	},
	{ "getpath",		PathSol_Action::GetPath		},
	{ "getbeamtree",	PathSol_Action::GetBeamTree	}
};

/////////////////////////  END Step 1: Configuration  /////////////////////////

void pathSolution_wrapper(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	using namespace evert;

	if (nrhs < 1 || !mxIsChar(prhs[0]))
			mexErrMsgTxt("Second input must be an action string ('new', 'delete', or a method name).");

	char *actionCstr = mxArrayToString(prhs[0]); // convert char16_t to char
    std::string actionStr(actionCstr); mxFree(actionCstr);

	for (auto & c : actionStr) c = ::tolower(c); // remove this for case sensitivity

	if (pathSol_actionTypeMap.count(actionStr) == 0)
        mexErrMsgTxt(("Unrecognized action (not in pathSol_actionTypeMap): " + actionStr).c_str());

    // If action is not "new" or "delete" try to locate an existing instance based on input handle
    pathSol_instPtr_t instance;
    if (pathSol_actionTypeMap.at(actionStr) != PathSol_Action::New && pathSol_actionTypeMap.at(actionStr) != PathSol_Action::Delete)
	{
        handle_type h = getHandle(nrhs, prhs);
        pathSol_instanceMap_type::const_iterator instIt = pathSol_checkHandle(pathSol_instanceTab, h);
        instance = instIt->second;
    }

	//////// Step 2: customize the each action in the switch in mexFuction ////////
	switch (pathSol_actionTypeMap.at(actionStr))
    {
    case PathSol_Action::New:
    {
		if (nrhs != 6)
            mexErrMsgTxt("Incorrect number of input arguments. (Argin: room_handle, source_handle, listener_handle, maxOrder)");

		// check if room has been instantiated
		auto roomInstIt = room_instanceTab.find(mxGetScalar(prhs[2]));
		if (roomInstIt == room_instanceTab.end())
			mexErrMsgTxt("Room handle not found. Instantiate a room before creating PathSolution object");
		room_instPtr_t roomInstance = roomInstIt->second;

		// check if source has been instantiated
		auto sourceInstIt = source_instanceTab.find(mxGetScalar(prhs[3]));
		if (sourceInstIt == source_instanceTab.end())
			mexErrMsgTxt("Source handle not found. Instantiate a source before creating PathSolution object");
		source_instPtr_t sourceInstance = sourceInstIt->second;

		// check if listener has been instantiated
		auto listenerInstIt = listener_instanceTab.find(mxGetScalar(prhs[4]));
		if (listenerInstIt == listener_instanceTab.end())
			mexErrMsgTxt("Listener handle not found. Instantiate a listener before creating PathSolution object");
		listener_instPtr_t listenerInstance = listenerInstIt->second;

		handle_type newHandle = pathSol_instanceTab.size() ? (pathSol_instanceTab.rbegin())->first + 1 : 1;

		std::pair<pathSol_instanceMap_type::iterator, bool> insResult;
		int maxOrder = static_cast<int>(mxGetScalar(prhs[5]));
		insResult = pathSol_instanceTab.insert(pathSol_indPtrPair_type(newHandle, std::make_shared<pathSolution_class>(*roomInstance, *sourceInstance, *listenerInstance, maxOrder, true)));

		mexLock();

		plhs[0] = mxCreateDoubleScalar(insResult.first->first);	// new handle

		break;
	}
	case PathSol_Action::Delete:
	{
		handle_type tempHandle = getHandle(nrhs, prhs);
		pathSol_instanceMap_type::const_iterator instIt = pathSol_checkHandle(pathSol_instanceTab, tempHandle);
		pathSol_instanceTab.erase(instIt);
		mexUnlock();
		plhs[0] = mxCreateLogicalScalar(pathSol_instanceTab.find(tempHandle) == pathSol_instanceTab.end());

        break;

	}
	case PathSol_Action::Solve:
	{
		if (nrhs > 2)
			mexWarnMsgTxt("Ignoring unnecessary arguments.");
		instance->solve();
		plhs[0] = mxCreateLogicalScalar(true);

        break;

	}
	case PathSol_Action::Update:
	{
		if (nrhs > 2)
			mexWarnMsgTxt("Ignoring unnecessary arguments.");
		instance->update();
		plhs[0] = mxCreateLogicalScalar(true);

        break;

	}
	case PathSol_Action::NumPaths:
	{
		if (nrhs > 2)
			mexWarnMsgTxt("Ignoring unnecessary arguments.");
		int numPaths = instance->numPaths();
		plhs[0] = mxCreateDoubleScalar(numPaths);

        break;

	}
	case PathSol_Action::GetPath:
	{
		if (nrhs != 3 || mxGetNumberOfElements(prhs[2]) != 1)
			mexErrMsgTxt("Specify the path to display.");
		if (nlhs != 3)
			mexErrMsgTxt("Specify 3 output variables. (order, points, materials)");

		int pathNum = static_cast<int>(mxGetScalar(prhs[2]));
		EL::PathSolution::Path curPath = instance->getPath(pathNum);
		plhs[0] = mxCreateDoubleScalar(curPath.m_order);
		//std::cout << "Order: " << curPath.m_order << std::endl;
		double* outPointsPtr;
		// outPointsPtr = (double**)mxCreateDoubleMatrix(curPath.m_points.size(), 3, mxREAL );
		// plhs[1] = mxGetPr(outPointsPtr);
		plhs[1] = mxCreateDoubleMatrix(curPath.m_points.size(), 3, mxREAL );
		//std::cout << "Number of points: " << curPath.m_points.size() << std::endl;
		outPointsPtr = (double*)mxGetPr(plhs[1]);
		int numReflections = curPath.m_polygons.size();
		//std::cout << "Number of polygons: " << numReflections << std::endl;

		plhs[2] = mxCreateCellMatrix(numReflections, 1);

		int numPoints = numReflections + 2;
		EL::Vector3 point = curPath.m_points[0];
		//std::cout << point[0] << "\t" << point[1] << "\t" << point[2] << std::endl;
		for (int j = 0; j < 3; j++)
			outPointsPtr[j*numPoints] = point[j];
		for (int i = 0; i < numReflections; i++)
		{
			point = curPath.m_points[i+1];
			//std::cout << point[0] << "\t" << point[1] << "\t" << point[2] << std::endl;
			for (int j = 0; j < 3; j++)
				outPointsPtr[(i+1) + j*numPoints] = point[j];
			Material mat = curPath.m_polygons[i]->getMaterial();
			mxArray* materialName = mxCreateString((const char*)mat.name);
			mxSetCell(plhs[2], i, materialName);
		}
		point = curPath.m_points[numReflections+1];
		//std::cout << point[0] << "\t" << point[1] << "\t" << point[2] << std::endl;
		for (int j = 0; j < 3; j++)
			outPointsPtr[(numReflections+1) + j*numPoints] = point[j];

        break;

	}
	case PathSol_Action::GetBeamTree:
	{
		if (nrhs > 2)
			mexWarnMsgTxt("Ignoring unnecessary arguments.");

		std::vector<EL::PathSolution::SolutionNode> bTree = instance->getBeamTree();

		plhs[0] = mxCreateDoubleMatrix(1, bTree.size(), mxREAL);

		double* parent = (double*)mxGetPr(plhs[0]);
		for (int i = 0; i < bTree.size(); i++)
			parent[i] = bTree[i].m_parent+1;

		break;
	}
	default:
		mexErrMsgTxt(("Unrecognized function: " + actionStr).c_str());
		break;
	}
}
