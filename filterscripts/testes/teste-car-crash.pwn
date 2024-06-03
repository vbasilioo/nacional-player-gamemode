#include <a_samp>
#include <crashdetect>

stock GetVehicleSpeed(vehicleid)
{
    new Float:xPos[3];
    GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
    return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}
//0-0-0-=-=-=-=-=

enum E_VEHICLE_STATUS {
	E_VEHICLE_PANELS,
	E_VEHICLE_DOORS,
	E_VEHICLE_LIGHTS,
	E_VEHICLE_TIRES
};

new g_vehicleStatus[MAX_VEHICLES][E_VEHICLE_STATUS];

//Panels
decode_panels(panels, &front_left_panel, &front_right_panel, &rear_left_panel, &rear_right_panel, &windshield, &front_bumper, &rear_bumper)
{
    front_left_panel = panels & 15;
    front_right_panel = panels >> 4 & 15;
    rear_left_panel = panels >> 8 & 15;
    rear_right_panel = panels >> 12 & 15;
    windshield = panels >> 16 & 15;
    front_bumper = panels >> 20 & 15;
    rear_bumper = panels >> 24 & 15;
}

encode_panels(front_left_panel, front_right_panel, rear_left_panel, rear_right_panel, windshield, front_bumper, rear_bumper)
{
    return front_left_panel | (front_right_panel << 4) | (rear_left_panel << 8) | (rear_right_panel << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}

//Doors
decode_doors(doors, &bonnet, &boot, &driver_door, &passenger_door)
{
    bonnet = doors & 7;
    boot = doors >> 8 & 7;
    driver_door = doors >> 16 & 7;
    passenger_door = doors >> 24 & 7;
}

encode_doors(bonnet, boot, driver_door, passenger_door)
{
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}

//Lights
decode_lights(lights, &front_left_light, &front_right_light, &back_lights)
{
    front_left_light = lights & 1;
    front_right_light = lights >> 2 & 1;
    back_lights = lights >> 6 & 1;
}

encode_lights(front_left_light, front_right_light, back_lights)
{
    return front_left_light | (front_right_light << 2) | (back_lights << 6);
}

stock UpdateStoredVehicleStatus(vehicleid)
{
	GetVehicleDamageStatus(
		vehicleid,
		g_vehicleStatus[vehicleid][E_VEHICLE_PANELS],
		g_vehicleStatus[vehicleid][E_VEHICLE_DOORS],
		g_vehicleStatus[vehicleid][E_VEHICLE_LIGHTS],
		g_vehicleStatus[vehicleid][E_VEHICLE_TIRES]
	);
}

stock SendTestMessage(vehicleid)
{
	new Float:vehiclehealth;
	GetVehicleHealth(vehicleid, vehiclehealth);
	new string[256];
	format(string, sizeof(string), "Veiculo %d sofreu uma batida. Vida: %.2f || Velocidade: %d", vehicleid, vehiclehealth, GetVehicleSpeed(vehicleid));
	SendClientMessageToAll(-1, string);
	
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	new front_left_light, front_right_light, back_lights;
	decode_lights(lights, front_left_light, front_right_light, back_lights);

	new bonnet, boot, driver_door, passenger_door;
	decode_doors(doors, bonnet, boot, driver_door, passenger_door);

	new front_left_panel, front_right_panel, rear_left_panel, rear_right_panel, windshield, front_bumper, rear_bumper;
	decode_panels(panels, front_left_panel, front_right_panel, rear_left_panel, rear_right_panel, windshield, front_bumper, rear_bumper);

	format(string, sizeof(string), "FarolE: %d | FarolD: %d | FarolT: %d", front_left_light, front_right_light, back_lights);
	SendClientMessageToAll(-1, string);

	format(string, sizeof(string), "bonnet: %d | boot: %d | driver: %d | passenger: %d", bonnet, boot, driver_door, passenger_door);
	SendClientMessageToAll(-1, string);

	format(string, sizeof(string), "ParaChoqueD: %d | ParaChoqueT: %d", front_bumper, rear_bumper);
	SendClientMessageToAll(-1, string);
}

stock GetOldVehicleDamageStatus(vehicleid, &panels, &doors, &lights, &tires)
{
	panels = g_vehicleStatus[vehicleid][E_VEHICLE_PANELS];
	doors = g_vehicleStatus[vehicleid][E_VEHICLE_DOORS];
	lights = g_vehicleStatus[vehicleid][E_VEHICLE_LIGHTS];
	tires = g_vehicleStatus[vehicleid][E_VEHICLE_TIRES];
}

stock hadBumpCrash(oldPanels, newPanels)
{
	new oldBumpArray[2], newBumpArray[2];
	new t;

	decode_panels(oldPanels, t, t, t, t, t, oldBumpArray[0], oldBumpArray[1]);
	decode_panels(newPanels, t, t, t, t, t, newBumpArray[0], newBumpArray[1]);

	for(new i=0; i < 2; i++)
		if(
			oldBumpArray[i] == 0 && newBumpArray[i] >= 1
			|| oldBumpArray[i] == 1 && newBumpArray[i] >= 2
		)
			return true;

	return false;
}

stock hadLigthCrash(oldLights, newLights)
{
	new oldLightsArray[3], newLightsArray[3];

	decode_lights(oldLights, oldLightsArray[0], oldLightsArray[1], oldLightsArray[2]);
	decode_lights(newLights, newLightsArray[0], newLightsArray[1], newLightsArray[2]);

	for(new i=0; i < 3; i++)
		if(oldLightsArray[i] == 0 && newLightsArray[i] == 1)
			return true;

	return false;
}

stock hadDoorCrash(oldDoors, newDoors)
{
	new oldDoorsArray[4], newDoorsArray[4];

	decode_doors(oldDoors, oldDoorsArray[0], oldDoorsArray[1], oldDoorsArray[2], oldDoorsArray[3]);
	decode_doors(newDoors, newDoorsArray[0], newDoorsArray[1], newDoorsArray[2], newDoorsArray[3]);

	for(new i=0; i < 4; i++)
		if((oldDoorsArray[i] == 0 || oldDoorsArray[i] == 1) && newDoorsArray[i] >= 2)
			return true;

	return false;
}

stock IsCarCrash(vehicleid, panels, doors, lights, tires)
{
	new oldPanels, oldDoors, oldLights, oldTires;
	GetOldVehicleDamageStatus(vehicleid, oldPanels, oldDoors, oldLights, oldTires);

	if(hadBumpCrash(oldPanels, panels))
		SendClientMessageToAll(0xFF0000AA, "Quebrou os parachoques!");
	if(hadLigthCrash(oldLights, lights))
		SendClientMessageToAll(0xFF0000AA, "Quebrou os farois!");
	if(hadDoorCrash(oldPanels, doors))
		SendClientMessageToAll(0xFF0000AA, "Quebrou as portas!");
}

stock VerifyCarCrash(vehicleid)
{
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	IsCarCrash(vehicleid, panels, doors, lights, tires);
	// SendTestMessage(vehicleid);
}

public OnVehicleSpawn(vehicleid)
{
	UpdateStoredVehicleStatus(vehicleid);
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	new string[256];
	format(string, sizeof(string), "Veiculo %d sofreu atualização do player %d.", vehicleid, playerid);
	SendClientMessageToAll(-1, string);
	VerifyCarCrash(vehicleid);
	UpdateStoredVehicleStatus(vehicleid);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	new idx;
	new cmd[256];
	cmd = strtok(cmdtext, idx);

    // if(strcmp(cmd, "/comando", true) == 0) {
	// 	new tmp[150] = strtok(cmdtext, idx);
    //     if(!strlen(tmp))
    //     {
    //         SendClientMessage(playerid, -1, "Use: /comando [id]");
    //         return 1;
    //     }
    //     new id = strval(tmp);
	// 	return 1;
	// }

    return 0;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// IsNumeric(const string[])
// {
// 	for (new i = 0, j = strlen(string); i < j; i++)
// 	{
// 		if (string[i] > '9' || string[i] < '0') return 0;
// 	}
// 	return 1;
// }

// ReturnUser(text[], playerid = INVALID_PLAYER_ID)
// {
// 	new pos = 0;
// 	while (text[pos] < 0x21) // Strip out leading spaces
// 	{
// 		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
// 		pos++;
// 	}
// 	new userid = INVALID_PLAYER_ID;
// 	if (IsNumeric(text[pos])) // Check whole passed string
// 	{
// 		// If they have a numeric name you have a problem (although names are checked on id failure)
// 		userid = strval(text[pos]);
// 		if (userid >=0 && userid < MAX_PLAYERS)
// 		{
// 			if(!IsPlayerConnected(userid))
// 			{
// 				/*if (playerid != INVALID_PLAYER_ID)
// 				{
// 					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
// 				}*/
// 				userid = INVALID_PLAYER_ID;
// 			}
// 			else
// 			{
// 				return userid; // A player was found
// 			}
// 		}
// 		/*else
// 		{
// 			if (playerid != INVALID_PLAYER_ID)
// 			{
// 				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
// 			}
// 			userid = INVALID_PLAYER_ID;
// 		}
// 		return userid;*/
// 		// Removed for fallthrough code
// 	}
// 	// They entered [part of] a name or the id search failed (check names just incase)
// 	new len = strlen(text[pos]);
// 	new count = 0;
// 	new name[MAX_PLAYER_NAME];
// 	for (new i = 0; i < MAX_PLAYERS; i++)
// 	{
// 		if (IsPlayerConnected(i))
// 		{
// 			GetPlayerName(i, name, sizeof (name));
// 			if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
// 			{
// 				if (len == strlen(name)) // Exact match
// 				{
// 					return i; // Return the exact player on an exact match
// 					// Otherwise if there are two players:
// 					// Me and MeYou any time you entered Me it would find both
// 					// And never be able to return just Me's id
// 				}
// 				else // Partial match
// 				{
// 					count++;
// 					userid = i;
// 				}
// 			}
// 		}
// 	}
// 	if (count != 1)
// 	{
// 		if (playerid != INVALID_PLAYER_ID)
// 		{
// 			if (count)
// 			{
// 				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
// 			}
// 			else
// 			{
// 				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
// 			}
// 		}
// 		userid = INVALID_PLAYER_ID;
// 	}
// 	return userid; // INVALID_USER_ID for bad return
// }