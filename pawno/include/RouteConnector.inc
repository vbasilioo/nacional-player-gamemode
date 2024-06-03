/*
		ROUTER PLUGIN
		- GPS ADDITION TO SA-MP
		- Made By Gamer_Z a.k.a. grasmanek94 , Rafal Grasman

		October-


		contact: grasmanek94@live.nl

		http://gamer-gps.googlecode.com/
*/

#if defined ROUTE_CONNECTOR_PLUGIN_INCLUDED

#else

#define MAX_NODES (32768)
#define MAX_CONNECTIONS (5)

#define CONNECT_TYPE_BOTH (0)
#define CONNECT_TYPE_One_To_Two (1)

#define ROUTE_CONNECTOR_PLUGIN_INCLUDED
#pragma library "RouteConnectorPlugin"

native AddNode(Float:X,Float:Y,Float:Z,AddToPathFinder = 0);
/*
	Function: 
		AddNode
	Description: 
		Adds a node into the memory of the plugin,
		This node will be unavailable in route calculations.
	Parameters: 
		Position as X Y Z
		AddToPathFinder - if set to 1 it will also make sure the graph will be updated so when searching for a route it will be added to the list.
	Returns the added nodeID, -1 if failed.
	Note:
		NEVER EVER set AddToPathFinder to 1 when a calculation is in progress! THAT IS YOUR OWN RESPOSIBILITY IF IT HAPPENS.
*/
native AddNodeEx(ID,Float:X,Float:Y,Float:Z,AddToPathFinder = 0);
/*
	Function: 
		AddNodeEx
	Description: 
		The only difference with AddNode is that you can specify your own NodeID here,
		all nodes must be in order from 0 to <max>, if there will be a gap any node operations (like saving nodes from memory to file)
		will be terminated at the gap (so your nodes list will result in data loss when saved).
		Avoid this by doing GetNextEmptyNodeID();
	Parameters: 
		ID as Custom NodeID
		Position as X Y Z
		AddToPathFinder - if set to 1 it will also make sure the graph will be updated so when searching for a route it will be added to the list.
	Returns the added nodeID, -1 if failed.
	Note:
		NEVER EVER set AddToPathFinder to 1 when a calculation is in progress! THAT IS YOUR OWN RESPOSIBILITY IF IT HAPPENS.
*/
native ConnectNodes(NodeID_one,NodeID_two,AddToPathFinder = 0,direction = 0);
/*
	Function: 
		ConnectNodes
	Description: 
		This will connect two nodes stored in memory, same rules as for AddNode(Ex), it won't be available in path calculations.
		When you connect NodeID_one with NodeID_two it will automaticly connect the opposite, no distance suplying is needed as the XYZ are supplied at node creation.
	Parameters: 
		NodeID_one and NodeID_two as NodeID's
		AddToPathFinder - if set to 1 it will also make sure the graph will be updated so when searching for a route it will be added to the list.
		direction - you can choose to only connect nodeID one with nodeID two (One_To_Two = 1) or to connect them together (BOTH = 0)
	Returns:
		-1 - if one of the nodes doesn't exist
		0 - on failure
		1 - on success
		2 - nodes are already connected
	Note:
		NEVER EVER set AddToPathFinder to 1 when a calculation is in progress! THAT IS YOUR OWN RESPOSIBILITY IF IT HAPPENS.
*/
native NearestPlayerNode(playerid,Float:MaxDist=9999.99,IgnoreNodeID=(-1));
/*
	Function: 
		NearestPlayerNode
	Description: 
		This function will get the closest player node, if you used AddNode(Ex) this nodes will also be considered.
	Parameters: 
		playerid - the playerid to count from
		MaxDist - the maximal distance to search from the player
		IgnoreNodeID - this node ID will not be returned as the closest one, it will be ignored in the search.
	Returns the closest nodeID, -1 if no node Id is found in range
*/
native NearestNodeFromPoint(Float:X,Float:Y,Float:Z,Float:MaxDist=9999.99,IgnoreNodeID=(-1));
/*
	Function: 
		NearestNodeFromPoint
	Description: 
		Same as NearestPlayerNode, but here you can supply an point instead of an playerid
	Parameters: 
		XYZ - the position of the point to search from
		MaxDist - the maximal distance to search from the player
		IgnoreNodeID - this node ID will not be returned as the closest one, it will be ignored in the search.
	Returns the closest nodeID, -1 if no node Id is found in range
*/
native WriteNodesToFile(filename[]);
/*
	Function: 
		WriteNodesToFile
	Description: 
		Write all nodes, connections, contents of the memory into an loadable file,
		can be used by ReadNodesFromFile later.
	Parameters: 
		filename -	the "path/filename.extension" to store the information in,
					note that if you want to make a file in the scriptfiles folder you need to supply:
					WriteNodesToFile("scriptfiles/your.file.name");
	Returns 1 on success, 0 on failure.
*/
native ReadNodesFromFile(filename[]);
/*
	Function: 
		ReadNodesFromFile
	Description: 
		Read all nodes, connections, contents of the file into the memory,
		This function will automaticly create nodes, connect them, create the virtual graph to search paths on
		after it has been loaded into the memory.
	Parameters: 
		filename -	the "path/filename.extension" to read the information from,
					note that if you want to read a file in the scriptfiles folder you need to supply:
					ReadNodesFromFile("scriptfiles/your.file.name");
	Warning:
		It is not recommended to use this funcion, use at your own risk.
		The plugin calls this function only at server startup, however I have included it for you.
		You still can make aditional nodes with it (if you analyse the project source code correctly, you will know what I mean)
	Returns 1 on success, 0 on failure.
*/
native GetNodePos(NodeID,&Float:X,&Float:Y,&Float:Z);
/*
	Function: 
		GetNodePos
	Description: 
		Get the XYZ position of the supplied NodeID
	Parameters: 
		NodeID - The NodeID to get the XYZ from
		(returns) X Y Z - The XYZ positions.
	Returns 0 on failure (Out Of Range?), -1 if node doesn't exist, 1 on success.
*/
native CalculatePath(Start,End,routeID = 0);//Threaded calculating, everything done here will be added to an Queue
/*
	Function: 
		CalculatePath
	Description: 
		Get the XYZ position of the supplied NodeID
	Parameters: 
		Start - The start NodeID
		End - the destination NodeID
		routeID (optional) - [custom integer supply] Here you can specify an integer value that will be passed 
		to the callback, along with the calculated path information, for example the PlayerID.
	Note:
		if you will be using the routeID parameter for recognizing routes, make sure they all are unique,
		once started route search cannot be aborted and will just be queued and the callback will still be called.

		This function is Threaded, this means that if the CalculatePath search takes 3 seconds, it won't lagg your server.
		Your server will continue to work normally.

		Only the callback in the script which calls the plugin will get executed with this, if you do CalculatePath in Script1, 
		and have your callback in Script2 then it won't get executed

		Returns always 1.
*/
native IsNodeIntersection(NodeID);
/*
	Function: 
		IsNodeIntersection
	Description: 
		Check if a node has 3 or more connections
	Parameters: 
		NodeID - The ID of the node
	Return 1 if true, 0 if false, -1 if node doesn't exist.
*/
native Float:GetAngleBetweenNodes(NodeID_one,NodeID_middle_aka_two,NodeID_three);
/*
	Function: 
		GetAngleBetweenNodes (Returns Float)
	Description: 
		Gets the angle between 3 nodes (2 connections/lines).
	Parameters: 
		NodeID* - The ID of the node
	Return 0.0 if one of the three nodes doesn't exist
*/
native GetConnectedNodes(NodeID);
/*
	Function: 
		GetConnectedNodes
	Description: 
		returns the amount of other nodes that are connected to this node, max is 5
	Parameters: 
		NodeID* - The ID of the node
	Returns amount of nodes connected (0 to 5), on failure -1.
*/
native GetNextEmptyNodeID();
/*
	Function: 
		GetNextEmptyNodeID
	Description: 
		returns the closest empty node ID (closest starting from 0 to up);
	Note:
		Example: 

				 new id = GetNextEmptyNodeID();
				 if(id != -1)AddNodeEx(id,X,Y,Z); 

				 However this example results in:

				 AddNode(X,Y,Z);
		Returns -1 if no more available node slots.
*/
native GetQueueSize();
/*
	Function: 
		GetQueueSize
	Description: 
		gets the size of all queued path calculations to do.
	Returns -1 if the vector was locked when tried to access (Threading crash prevention), else it returns the vector size.
*/
native GetConnectedNodeID(NodeID,ConnectID);
/*
	Function: 
		GetConnectedNodeID
	Description: 
		gets the ID of an connection to NodeID, -1 if ConnectID has no connection, connectid must be between 0 and (MAX_CONNECTIONS-1), however there is OFB prevention check.
*/
native Float:GetConnectedNodeDistance(NodeID,ConnectID);
/*
	Function: 
		GetConnectedNodeDistance (Returns Float)
	Description: 
		gets the distance to a connected node (ConnectID) from the selected node (NodeID).
*/
native Float:GetDistanceBetweenNodes(NodeID_one,NodeID_two);
/*
	Function: 
		GetDistanceBetweenNodes (Returns Float)
	Description: 
		gets the distance between the two nodes (NOT VIA OTHER NODES, THIS JUST DOES THE X Y Z POSITION CALCULATION).
*/
native IsNodeInPathFinder(NodeID);
/*
	Function: 
		IsNodeInPathFinder
	Description: 
		Checks if NodeID is added to the routecalculator.
	Returns -1 if the NodeID is invalid and 0 if node is not in the route calculator, 1 if yes.
*/
native GetRouteArray(ID,destination[],size = sizeof(destination));
/*
	Function: 
		GetRouteArray
	Description: 
		Stores an saved array with assigned ID to destination[]
	Returns the amount of nodes in array at ID, Returns 0 if array is empty or ID doesn't exist.
*/
native GetRouteAtPos(ID,Array_Pos,&amount_of_nodes=0);
/*
	Function: 
		GetRouteAtPos
	Description: 
		Returns the NodeID in array[Array_Pos] at ID.
		Optionally you can specify an variable to store the amount of nodes in it.
*/
native StoreRouteArray(amount_of_nodes,array[]);
/*
	Function: 
		StoreRouteArray
	Description: 
		Stores an array to the plugins vector memory, returns the ID you can use in GetRouteArray or DeleteArray.
*/
native DeleteArray(ID);
/*
	Function: 
		DeleteArray
	Description: 
		Remove contents of the memory at ID.
*/
native AddExistingNodeToPathFinder(NodeID);
/*
	Function: 
		AddExistingNodeToPathFinder
	Description: 
		Adds an created node to the routecalculator.
	Returns -1 if the NodeID is invalid and 0 if node id does not exist or is already added, 1 on success.
*/
native RemoveNode(NodeID);
/*
	Function: 
		RemoveNode
	Description: 
		Deletes an node from the memory, to use in Write data, nodes loaded into the calculator won't be deleted, connections too.
	Returns -1 if the NodeID is invalid and 0 if node id does not exist, 1 on success.
*/
native DisconnectNodeFromNode(NodeIDOne,NodeIDTwo);
/*
	Function: 
		DisconnectNodeFromNode
	Description: 
		Disconnects Node ID One from Two, please see RemoveNode for information about the calculator memory.
	Returns -1 if the NodeID is invalid and 0 if node id does not exist, 1 on success.
*/
native DisconnectAllFromNode(NodeID);
/*
	Function: 
		DisconnectAllFromNode
	Description: 
		Disconnects all other nodes from NodeID, and NodeID from them.
	Returns -1 if the NodeID is invalid and 0 if node id does not exist, 1 on success.
*/
native DeleteNodeSystemAtNode(NodeID,array[],size = sizeof(array));
/*
	Function: 
		DeleteNodeSystemAtNode
	Description: 
		Get ALL nodeIDs that are CONNECTED IN ANY WAY, ALSO VIA OTHER NODES to NodeID into the array[].
		Usefull for deleting big-not-connected chunks of nodes.
	Returns 0 on failure, the array size on success.
*/
native GetNodeDirectionToConnect(NodeID,ConnectID);
/*
	Function: 
		GetNodeDirectionToConnect
	Description: 
		Get the direction this node[connectid] is connected in, 
		0 means that :
			connectid is connected to nodeid
			nodeid is connected to connectid
		1 means that:
			nodeid is connected to connectid
			connectid is NOT connected to nodeid
		2 means that:
			nodeid is NOT connected to connectid
			connectid is connected to nodeid
	Note:
		Usefull for making 'left and right' road sides.
	Returns -1 on failure.
*/
native SetNodeDirectionToConnect(NodeID,ConectID,Direction);
/*
	Function: 
		SetNodeDirectionToConnect
	Description: 
		See GetNodeDirectionToConnect, this SETS the direction manually.
		It automaticly get the nodeID of 'ConectID' and sets the connection_direction to the good value.
	Returns 0 on failure, 1 on success.
*/
forward GPS_WhenRouteIsCalculated(routeid,node_id_array[],amount_of_nodes,distance);//Every processed Queue will be called here
/*
	Called when a path finding calculation is done.
	
	routeid - the id you specified for recognition of calls
	node_id_array -	this array is up to 1792 cells long
					it is build from the following information:

					node_id_array[0] ... node_id_array[1791] - 
						all points (Node ID's) on the route
						in following order:
							from start, to end
	amount_of_nodes - this is the amount of nodes the total path is.
	distance - the total distance all nodes take, rounded to an integer.
	so you can do:
	public GPS_WhenRouteIsCalculated(routeid,node_id_array[],amount_of_nodes,distance)
	{
		for(new i = 0; i < amount_of_nodes; ++i)
		{
			printf("Point(%d)=NodeID(%d)",i,node_id_array[i]);
		}
		return 1;
	}
*/
forward OnPlayerClosestNodeIDChange(playerid,old_NodeID,new_NodeID);
/*
	Called when a player's closest nodeID changes.
	
	playerid - the id of the player
	old_NodeID and new_NodeID - the node ID's, old and new.
		new_NodeID is 'now' the closest node ID.

*/
#endif