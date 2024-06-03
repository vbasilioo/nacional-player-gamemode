#include <a_samp>
#include <crashdetect>

new NaCamera[MAX_PLAYERS];
new Text:Hidealto2[MAX_PLAYERS],Text:Hidebaixo2[MAX_PLAYERS], Text:TextRec[MAX_PLAYERS];

enum {
	DIALOG_MUDAR_NICK=1234,
	DIALOG_LINHAS_ONIBUS=8500,
	DIALOG_INFO_LINHAS_ONIBUS_LS,
	DIALOG_INFO_LINHAS_ONIBUS_LV,
	DIALOG_INFO_LINHAS_ONIBUS_SF,
	DIALOG_INFO_LINHAS_ONIBUS_DESC,
	DIALOG_REVISTA_TIPO,
	DIALOG_REVISTA_CORPO,
	DIALOG_REVISTA_MOCHILA,
	DIALOG_CAMERAS_COPOM,
	DIALOG_CAMERAS_LS,
	DIALOG_CAMERAS_SF,
	DIALOG_CAMERAS_LV
}

public OnFilterScriptInit()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		Hidealto2[i] = TextDrawCreate(1.000000,-45.000000,"__");
		Hidebaixo2[i] = TextDrawCreate(-2.000000,371.000000,"__");
		TextRec[i] = TextDrawCreate(460.000000, 345.000000,"     REC.");
	}
}

stock ClearChatbox(playerid, lines)
{
    if (IsPlayerConnected(playerid))
    {
        for(new i=0; i<lines; i++)
        {
            SendClientMessage(playerid, -1, " ");
        }
    }
    return 1;
}

//=-=-=-=-=-=

public OnPlayerCommandText(playerid, cmdtext[]) {
	new idx;
	new tmp[150];
	new cmd[256];
	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd, "/setcamera", true) == 0) {
		new plid;
		new Float:setpos[3];
        tmp = strtok(cmdtext,idx);
        if(!strlen(tmp)) return SendClientMessage(playerid, -1, "USE: /setcamera [id] [X] [Y] [Z]");
        plid = strval(tmp);
        for(new x=0;x<3;x++)
        {
            tmp = strtok(cmdtext,idx);
            if(!strlen(tmp)) return SendClientMessage(playerid, -1, "USE: /setcamera [id] [X] [Y] [Z]");
            setpos[x] = floatstr(tmp);
        }
        SetPlayerCameraPos(plid,setpos[0],setpos[1],setpos[2]);
		SetPlayerCameraLookAt(playerid, setpos[0],setpos[1],setpos[2]);
        SendClientMessage(playerid, -1, "Posição setada!");
        return 1;
	}

	if(strcmp(cmd, "/comando", true) == 0) {
		ShowPlayerDialog(playerid, DIALOG_CAMERAS_COPOM, DIALOG_STYLE_LIST, "Cameras segurança","Cameras: São Paulo\nCameras: San Fierro\nCameras: Las Venturas\nSair do Painel\n","Acessar","Cancelar");
		return 1;
	}

    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (dialogid == DIALOG_CAMERAS_COPOM)
	{
		new string[128];
		new DialogBPH[360];
        if(response >= 1)
        {
			switch(listitem)
			{
				case 0: // LS
				{
					format(string, 128, "Sala São Paulo\n");
					strcat(DialogBPH,string);
					format(string, 128, "1º Distrito Policial de LSSP\n");
					strcat(DialogBPH,string);
					format(string, 128, "Ammu-Nation Market\n");
					strcat(DialogBPH,string);
					format(string, 128, "Gleen Park\n");
					strcat(DialogBPH,string);
					format(string, 128, "Estação Unity\n");
					strcat(DialogBPH,string);
					format(string, 128, "Palácio do Governo\n");
					strcat(DialogBPH,string);
					format(string, 128, "Palácio do Governo - Interior\n");
					strcat(DialogBPH,string);
					ShowPlayerDialog(playerid, DIALOG_CAMERAS_LS, DIALOG_STYLE_LIST, "Cameras Segurança Los Santos",DialogBPH,"Acessar","Cancelar");
				}
				case 1: // SF
				{
					format(string, 128, "24/7\n");
					strcat(DialogBPH,string);
					format(string, 128, "Burgershot\n");
					strcat(DialogBPH,string);
					format(string, 128, "Instituto Médico Legal\n");
					strcat(DialogBPH,string);
					format(string, 128, "1º Distrito Policial de SFSP\n");
					strcat(DialogBPH,string);
					format(string, 128, "1º Distrito Policial de SFSP - Interior\n");
					strcat(DialogBPH,string);
					format(string, 128, "Hospital\n");
					strcat(DialogBPH,string);
					format(string, 128, "Hospital - Interior\n");
					strcat(DialogBPH,string);
					format(string, 128, "Prefeitura\n");
					strcat(DialogBPH,string);
					format(string, 128, "Prefeitura - Interior\n");
					strcat(DialogBPH,string);
					ShowPlayerDialog(playerid, DIALOG_CAMERAS_SF, DIALOG_STYLE_LIST, "Cameras Segurança San Fierro",DialogBPH,"Acessar","Cancelar");
				}
				case 2: // LV
				{
					format(string, 128, "Prefeitura\n");
					strcat(DialogBPH,string);
					format(string, 128, "Prefeitura - Interior\n");
					strcat(DialogBPH,string);
					format(string, 128, "Banco Central\n");
					strcat(DialogBPH,string);
					format(string, 128, "Banco Central - Interior\n");
					strcat(DialogBPH,string);
					format(string, 128, "Hospital\n");
					strcat(DialogBPH,string);
					format(string, 128, "Hospital - Interior\n");
					strcat(DialogBPH,string);
					format(string, 128, "Avenida principal\n");
					strcat(DialogBPH,string);
					ShowPlayerDialog(playerid, DIALOG_CAMERAS_LV, DIALOG_STYLE_LIST, "Cameras Segurança Las Venturas",DialogBPH,"Acessar","Cancelar");
				}
				default: // Sair
				{
					SetPlayerPos(playerid, 1505.4197,-1541.6450,10017.8174);
					SetPlayerInterior(playerid, 0);
					SetCameraBehindPlayer(playerid);
					NaCamera[playerid] = 1;
					SetPlayerVirtualWorld(playerid, 0);
					TextDrawHideForPlayer(playerid, Hidealto2[playerid]);
					TextDrawHideForPlayer(playerid, Hidebaixo2[playerid]);
					TextDrawHideForPlayer(playerid, TextRec[playerid]);
				}
			}
        }
        return 0;
	}
	if (dialogid == DIALOG_CAMERAS_LS)
	{
		if(response >= 1)
        {
			ClearChatbox(playerid, 100);
			SendClientMessage(playerid, 0x33FF00FF, "USE: /cameras para voltar ao menu, você pode mover a camera com o MOUSE!");
			TextDrawShowForPlayer(playerid, Hidealto2[playerid]);
			TextDrawShowForPlayer(playerid, Hidebaixo2[playerid]);
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			switch(listitem)
			{
				case 0: //Sala São Paulo
				{
					InterpolateCameraPos( playerid, x, y, z, 1481.19, -1750.34, 27.66, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
				case 1: //1º Distrito Policial de LSSP
				{
					InterpolateCameraPos( playerid, x, y, z, 1505.41, -1660.76, 18.65, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
				case 2: //Ammu-Nation Market
				{
					InterpolateCameraPos( playerid, x, y, z, 1332.74, -1267.60, 29.47, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
				case 3: //Gleen Park
				{
					InterpolateCameraPos( playerid, x, y, z, 1833.57, -1191.48, 30.72, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
				case 4: //Estação Unity
				{
					InterpolateCameraPos( playerid, x, y, z, 1788.88, -1884.45, 27.11, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
				case 5: //Palácio do Governo
				{
					InterpolateCameraPos( playerid, x, y, z, 1122.28, -2037.17, 76.70, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
				case 6: //Palácio do Governo - Interior
				{
					InterpolateCameraPos( playerid, x, y, z, -378.96, -1481.27, 4008.75, 5000, CAMERA_MOVE);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					NaCamera[playerid] = 5;
				}
			}
			// SetPlayerPosNew(playerid, 1370.9540,-1754.0128,13.5521);
			ApplyAnimation(playerid,"PED","SEAT_idle",1.0,1,0,0,0,0);
			ApplyAnimation(playerid,"PED","SEAT_idle",1.0,1,0,0,0,0);
			return 1;
        }
        return 0;
	}
	// if (dialogid == DIALOG_CAMERAS_SF)
	// {
		
	// }
	// if (dialogid == DIALOG_CAMERAS_LV)
	// {
		
	// }
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