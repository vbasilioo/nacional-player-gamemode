#include <a_samp>
#include <crashdetect>

enum {
	DIALOG_CAMERAS_COPOM=9193,
	DIALOG_CAMERAS_LS,
	DIALOG_CAMERAS_SF,
	DIALOG_CAMERAS_LV
};

stock SetPlayerPosNew(playerid, Float:spawnX, Float:spawnY, Float:spawnZ)
{
	SetPlayerPos(playerid, spawnX, spawnY, spawnZ);
}

stock LoadObjects(playerid)
{
	printf("Carregado objetos %d", playerid);
}

// -=-=-=-=-=-=-=-==-=-=-=-=-=-
new g_camerasCopomLS[13][2];
new g_camerasCopomSF[9][2];
new g_camerasCopomLV[7][2];

enum {
	CAMERA_CITY_NONE=-1,
	CAMERA_CITY_LS,
	CAMERA_CITY_SF,
	CAMERA_CITY_LV,
}

enum E_CAMERA_COPOM_DATA {
	bool:CAMERA_IS_ENABLE,
	bool:CAMERA_IS_LEAVING,
	CAMERA_CITY,
	CAMERA_ID,
	Float:CAMERA_SPAWN_X,
	Float:CAMERA_SPAWN_Y,
	Float:CAMERA_SPAWN_Z,
	CAMERA_SPAWN_INT,
	CAMERA_SPAWN_WORLD,
};

new g_camerasPlayerData[MAX_PLAYERS][E_CAMERA_COPOM_DATA];

stock CleanCopomCameraData(playerid, bool:isLeaving=false)
{
	g_camerasPlayerData[playerid][CAMERA_IS_ENABLE] = false;
	g_camerasPlayerData[playerid][CAMERA_IS_LEAVING] = isLeaving;
	g_camerasPlayerData[playerid][CAMERA_CITY] = CAMERA_CITY_NONE;
	g_camerasPlayerData[playerid][CAMERA_ID] = -1;

	if(!isLeaving)
	{
		g_camerasPlayerData[playerid][CAMERA_SPAWN_X] = 0.0;
		g_camerasPlayerData[playerid][CAMERA_SPAWN_Y] = 0.0;
		g_camerasPlayerData[playerid][CAMERA_SPAWN_Z] = 0.0;
	}
}

forward SetPlayerOriginalPos(playerid);
public SetPlayerOriginalPos(playerid)
{
	new Float:spawnX = g_camerasPlayerData[playerid][CAMERA_SPAWN_X];
	new Float:spawnY = g_camerasPlayerData[playerid][CAMERA_SPAWN_Y];
	new Float:spawnZ = g_camerasPlayerData[playerid][CAMERA_SPAWN_Z];
	new interiorid = g_camerasPlayerData[playerid][CAMERA_SPAWN_INT];
	new worldid = g_camerasPlayerData[playerid][CAMERA_SPAWN_WORLD];

	LoadObjects(playerid);

	SetPlayerPosNew(playerid, spawnX, spawnY, spawnZ);
	SetPlayerInterior(playerid, interiorid);
	SetPlayerVirtualWorld(playerid, worldid);

	CleanCopomCameraData(playerid);
}

public OnFilterScriptInit()
{
	g_camerasCopomLS[0][0] = CreateObject(19300, 1505.41, -1660.76, 18.65, 0.0, 0.0, 0.0); // DP-LS
	g_camerasCopomLS[0][1] = 0;
	g_camerasCopomLS[1][0] = CreateObject(19300, 350.69, 1842.10, 2244.94, 0.0, 0.0, 0.0); // Interior DP-LS
	g_camerasCopomLS[1][1] = 1;
	g_camerasCopomLS[2][0] = CreateObject(19300, 1481.19, -1750.34, 27.66, 0.0, 0.0, 0.0); // Sala SP
	g_camerasCopomLS[2][1] = 0;
	g_camerasCopomLS[3][0] = CreateObject(19300, -1031.00, -1303.05, 3121.54, 0.0, 0.0, 0.0); // Interior Sala SP
	g_camerasCopomLS[3][1] = 1;
	g_camerasCopomLS[4][0] = CreateObject(19300, 1332.74, -1267.60, 29.47, 0.0, 0.0, 0.0); // Loja de armas (Ammu-Nation Market)
	g_camerasCopomLS[4][1] = 0;
	g_camerasCopomLS[5][0] = CreateObject(19300, 1833.57, -1191.48, 30.72, 0.0, 0.0, 0.0); // Glen Park
	g_camerasCopomLS[5][1] = 0;
	g_camerasCopomLS[6][0] = CreateObject(19300, 1788.88, -1884.45, 27.11, 0.0, 0.0, 0.0); // Estação Unity
	g_camerasCopomLS[6][1] = 0;
	g_camerasCopomLS[7][0] = CreateObject(19300, 1122.28, -2037.17, 76.70, 0.0, 0.0, 0.0); // Palácio do Governo
	g_camerasCopomLS[7][1] = 0;
	g_camerasCopomLS[8][0] = CreateObject(19300, -378.96, -1481.27, 4008.75, 0.0, 0.0, 0.0); // Interior Palacio Governo
	g_camerasCopomLS[8][1] = 1;
	g_camerasCopomLS[9][0] = CreateObject(19300, 1292.35, -1327.99, 35.73, 0.0, 0.0, 0.0); // HP Market LS
	g_camerasCopomLS[9][1] = 0;
	g_camerasCopomLS[10][0] = CreateObject(19300, 2436.52, -1797.30, 4226.52, 0.0, 0.0, 0.0); // Interior HP Market LS
	g_camerasCopomLS[10][1] = 1;
	g_camerasCopomLS[11][0] = CreateObject(19300, 1975.70, -1431.78, 25.68, 0.0, 0.0, 0.0); // HP Jefferson
	g_camerasCopomLS[11][1] = 0;
	g_camerasCopomLS[12][0] = CreateObject(19300, 1170.39, -1317.50, 1003.44, 0.0, 0.0, 0.0); // Interior HP Jefferson
	g_camerasCopomLS[12][1] = 1;

	g_camerasCopomSF[0][0] = CreateObject(19300, -2399.54, 756.57, 40.46, 0.0, 0.0, 0.0); // 24/7 SF
	g_camerasCopomSF[0][1] = 0;
	g_camerasCopomSF[1][0] = CreateObject(19300, -1911.60, 828.51, 46.97, 0.0, 0.0, 0.0); // Burgershot SF
	g_camerasCopomSF[1][1] = 0;
	g_camerasCopomSF[2][0] = CreateObject(19300, -2018.73, 1025.90, 69.05, 0.0, 0.0, 0.0); // IML SF
	g_camerasCopomSF[2][1] = 0;
	g_camerasCopomSF[3][0] = CreateObject(19300, -1605.92, 743.29, 21.99, 0.0, 0.0, 0.0); // DP SF
	g_camerasCopomSF[3][1] = 0;
	g_camerasCopomSF[4][0] = CreateObject(19300, 240.64, 107.48, 1008.84, 0.0, 0.0, 0.0); // DP Interior SF
	g_camerasCopomSF[4][1] = 0;
	g_camerasCopomSF[5][0] = CreateObject(19300, -2589.32, 717.85, 38.80, 0.0, 0.0, 0.0); // Hospital SF
	g_camerasCopomSF[5][1] = 0;
	g_camerasCopomSF[6][0] = CreateObject(19300, 2073.53, -766.78, 1721.01, 0.0, 0.0, 0.0); // Hospital interior SF
	g_camerasCopomSF[6][1] = 1;
	g_camerasCopomSF[7][0] = CreateObject(19300, -2731.12, 355.23, 10.63, 0.0, 0.0, 0.0); // Prefeitura SF
	g_camerasCopomSF[7][1] = 0;
	g_camerasCopomSF[8][0] = CreateObject(19300, 711.93, 405.07, 1026.32, 0.0, 0.0, 0.0); // Preifeitura Interior SF
	g_camerasCopomSF[8][1] = 1;

	g_camerasCopomLV[0][0] = CreateObject(19300, 1776.57, 886.34, 24.77, 0.0, 0.0, 0.0); // Avenida Principal LV
	g_camerasCopomLV[0][1] = 0;
	g_camerasCopomLV[1][0] = CreateObject(19300, 2352.62, 2347.92, 25.51, 0.0, 0.0, 0.0); // Prefeitura LV
	g_camerasCopomLV[1][1] = 0;
	g_camerasCopomLV[2][0] = CreateObject(19300, -486.09, 298.65, 2010.70, 0.0, 0.0, 0.0); // Prefeitura Interior LV
	g_camerasCopomLV[2][1] = 1;
	g_camerasCopomLV[3][0] = CreateObject(19300, 2411.87, 2345.21, 26.90, 0.0, 0.0, 0.0); // Banco Central LV
	g_camerasCopomLV[3][1] = 0;
	g_camerasCopomLV[4][0] = CreateObject(19300, 1348.98, 529.56, 4841.03, 0.0, 0.0, 0.0); // Banco Central Interior LV
	g_camerasCopomLV[4][1] = 1;
	g_camerasCopomLV[5][0] = CreateObject(19300, 1617.00, 1861.37, 20.40, 0.0, 0.0, 0.0); // Hospital LV
	g_camerasCopomLV[5][1] = 0;
	g_camerasCopomLV[6][0] = CreateObject(19300, 2046.15, -1406.45, 1719.17, 0.0, 0.0, 0.0); // Hospital Interior LV
	g_camerasCopomLV[6][1] = 0;
}

public OnPlayerConnect(playerid)
{
	CleanCopomCameraData(playerid);
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	new idx;
	new cmd[256];
	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd, "/comando", true) == 0) {
		ShowPlayerDialog(playerid, DIALOG_CAMERAS_COPOM, DIALOG_STYLE_LIST, "Cameras segurança","Cameras: LSSP\nCameras: SFSP\nCameras: LVSP\nSair do Painel\n","Acessar","Cancelar");
	}

    return 0;
}



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_CAMERAS_COPOM)
	{
		if(response >= 1)
		{
			new stringCameras[500];

			if(!g_camerasPlayerData[playerid][CAMERA_IS_ENABLE])
			{
				GetPlayerPos(playerid, g_camerasPlayerData[playerid][CAMERA_SPAWN_X], g_camerasPlayerData[playerid][CAMERA_SPAWN_Y], g_camerasPlayerData[playerid][CAMERA_SPAWN_Z]);
				g_camerasPlayerData[playerid][CAMERA_SPAWN_INT] = GetPlayerInterior(playerid);
				g_camerasPlayerData[playerid][CAMERA_SPAWN_WORLD] = GetPlayerVirtualWorld(playerid);
			}

			switch(listitem)
			{
				case 0: // LS
				{
					format(stringCameras, sizeof(stringCameras), "%s", "1º Distrito Policial de LSSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "1º Distrito Policial de LSSP - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Sala São Paulo");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Sala São Paulo - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Avenida Market");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Gleen Park");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Estação Unity");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Palácio do Governo");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Palácio do Governo - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital Market");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital Market - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital Jefferson");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital Jefferson - Interior");

					ShowPlayerDialog(playerid, DIALOG_CAMERAS_LS, DIALOG_STYLE_LIST, "Cameras de Segurança LSSP", stringCameras, "Acessar", "Voltar");
				}
				case 1: // SF
				{
					format(stringCameras, sizeof(stringCameras), "%s", "24/7");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Burgershot");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "IML SFSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "DP SFSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "DP SFSP - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital SFSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital SFSP - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Prefeitura SFSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Prefeitura SFSP - Interior");

					ShowPlayerDialog(playerid, DIALOG_CAMERAS_SF, DIALOG_STYLE_LIST, "Cameras de Segurança SFSP", stringCameras, "Acessar", "Voltar");
				}
				case 2: // LV
				{
					format(stringCameras, sizeof(stringCameras), "%s", "Avenida Principal");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Prefeitura LVSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Prefeitura LVSP - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Banco Central");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Banco Central - Interior");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital LVSP");
					format(stringCameras, sizeof(stringCameras), "%s\n%s", stringCameras, "Hospital LVSP - Interior");

					ShowPlayerDialog(playerid, DIALOG_CAMERAS_LV, DIALOG_STYLE_LIST, "Cameras de Segurança SFSP", stringCameras, "Acessar", "Voltar");
				}
				default:
				{
					if(g_camerasPlayerData[playerid][CAMERA_IS_ENABLE])
					{
						CleanCopomCameraData(playerid, true);
						TogglePlayerSpectating(playerid, 0);
						SetTimerEx("SetPlayerOriginalPos", 1000, false, "d", playerid);
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_CAMERAS_LS)
	{
		if(response >= 1)
		{
			TogglePlayerSpectating(playerid, true);
			SetPlayerVirtualWorld(playerid, 0);
			
			AttachCameraToObject(playerid, g_camerasCopomLS[listitem][0]);
			SetPlayerInterior(playerid, g_camerasCopomLS[listitem][1]);

			g_camerasPlayerData[playerid][CAMERA_CITY] = CAMERA_CITY_LS;
			g_camerasPlayerData[playerid][CAMERA_ID] = listitem;
			g_camerasPlayerData[playerid][CAMERA_IS_ENABLE] = true;
		}
		else
			ShowPlayerDialog(playerid, DIALOG_CAMERAS_COPOM, DIALOG_STYLE_LIST, "Cameras segurança","Cameras: LSSP\nCameras: SFSP\nCameras: LVSP\nSair do Painel\n","Acessar","Cancelar");
	}
	if(dialogid == DIALOG_CAMERAS_SF)
	{
		if(response >= 1)
		{
			TogglePlayerSpectating(playerid, true);
			SetPlayerVirtualWorld(playerid, 0);

			AttachCameraToObject(playerid, g_camerasCopomSF[listitem][0]);
			SetPlayerInterior(playerid, g_camerasCopomSF[listitem][1]);

			g_camerasPlayerData[playerid][CAMERA_CITY] = CAMERA_CITY_SF;
			g_camerasPlayerData[playerid][CAMERA_ID] = listitem;
			g_camerasPlayerData[playerid][CAMERA_IS_ENABLE] = true;

		}
		else
			ShowPlayerDialog(playerid, DIALOG_CAMERAS_COPOM, DIALOG_STYLE_LIST, "Cameras segurança","Cameras: LSSP\nCameras: SFSP\nCameras: LVSP\nSair do Painel\n","Acessar","Cancelar");
	}
	if(dialogid == DIALOG_CAMERAS_LV)
	{
		if(response >= 1)
		{
			TogglePlayerSpectating(playerid, true);
			SetPlayerVirtualWorld(playerid, 0);

			AttachCameraToObject(playerid, g_camerasCopomLV[listitem][0]);
			SetPlayerInterior(playerid, g_camerasCopomLV[listitem][1]);

			g_camerasPlayerData[playerid][CAMERA_CITY] = CAMERA_CITY_LV;
			g_camerasPlayerData[playerid][CAMERA_ID] = listitem;
			g_camerasPlayerData[playerid][CAMERA_IS_ENABLE] = true;
		}
		else
			ShowPlayerDialog(playerid, DIALOG_CAMERAS_COPOM, DIALOG_STYLE_LIST, "Cameras segurança","Cameras: LSSP\nCameras: SFSP\nCameras: LVSP\nSair do Painel\n","Acessar","Cancelar");
	}
	
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