#include <a_samp>
#include <crashdetect>

#define COLOR_GREY	0xAFAFAFAA

new MEGAString[2500];

new aNames[][] =
{
    "Desarmado", "Soqueira", "Taco de Golf", "Cacetete",
    "Faca", "Taco de Base-Ball", "Pá de pedreiro", "Cano", "Espada", "Motoserra", "Vibrador", "Vibrador", "Vibrador", "Vibrador",
    "Flores", "Pé de cabra", "Granada", "Bomba de Gás", "Coquetel-Molotov", "Desconhecido 19", "Desconhecido 20", "Jetpack", "9mm", "Pistola 9mm com Silenciador",
    "Eagle", "Shotgun", "Escopeta do cano serrado", "Escopeta de combate", "Micro Uzi", "MP5", "Ak-47", "M4", "Tec9", "Rifle", "Sniper Rifle",
    "Lança Missil", "Lança Missil RPG", "Lança Chamas", "Minigun", "Explosivo Remoto", "Detonador", "Spray", "Extintor", "Camera", "Òculos de Visão noturna", "Òculos Infra Vermelho",
    "Paraquedas", "Desconhecido", "Desconhecido", "Desconhecido", "Desconhecido", "Desconhecido", "Desconhecido", "Desconhecido", "Desconhecido"
};


// =-=-=-=-=-=-=-=-=-=-=-

enum {
	DIALOG_REVISTA_TIPO=9123,
	DIALOG_REVISTA_CORPO,
	DIALOG_REVISTA_MOCHILA
}

new inspectId[MAX_PLAYERS];

stock ShowInspectBodyDialog(playerid, inspectedid)
{
	new bool:hasWeapon = false;
	new 
		weaponString[500],
		inspectedName[MAX_PLAYER_NAME];

	GetPlayerName(inspectedid, inspectedName, MAX_PLAYER_NAME);

	format(MEGAString, sizeof(MEGAString), "{FFFFFF}Revistado: {808080}%s\n\n", inspectedName);
	format(MEGAString, sizeof(MEGAString), "%s{FFFFFF}Dinheiro: {00a000}R$%d,00\n\n", MEGAString, 100);

	for (new i = 0; i <= 12; i++)
	{
		new weapon[2];
		GetPlayerWeaponData(inspectedid, i, weapon[0], weapon[1]);

		if(weapon[0] != 0)
		{
			hasWeapon = true;
			format(weaponString, sizeof(weaponString), "%s{808080}Arma: %s\tMunição: %d\n", weaponString, aNames[weapon[0]], weapon[1]);
		}
	}

	if(hasWeapon)
		format(MEGAString, sizeof(MEGAString), "%s{FFFFFF}Armas encontradas:\n%s", MEGAString, weaponString);
	else
		format(MEGAString, sizeof(MEGAString), "%s{FFFFFF}Nenhuma arma encontrada", MEGAString);

	ShowPlayerDialog(playerid, DIALOG_REVISTA_CORPO, DIALOG_STYLE_MSGBOX, "Itens Encontrados na revista", MEGAString, "Fechar", "");
}

stock ShowInspectBackPackDialog(playerid, inspectedid)
{
	new bool:hasItem = false;
	new 
		itemsString[500],
		inspectedName[MAX_PLAYER_NAME];

	GetPlayerName(inspectedid, inspectedName, MAX_PLAYER_NAME);

	format(MEGAString, sizeof(MEGAString), "{FFFFFF}Revistado: {808080}%s\n\n", inspectedName);

	for (new i = 0; i <= 15; i++)
	{
		new itemid = InventarioInfo[giveplayerid][i][iSlot];
		new itemAmmout = InventarioInfo[giveplayerid][i][iUnidades];

		if(itemid != 19382)
		{
			hasItem = true;
			format(itemsString, sizeof(itemsString), "%s{808080}Item: %s\tQuantidade: %d\n", itemsString, NomeItemInventario(itemid), itemAmmout);
		}
	}

	if(hasItem)
		format(MEGAString, sizeof(MEGAString), "%s{FFFFFF}Itens encontrados:\n%s", MEGAString, itemsString);
	else
		format(MEGAString, sizeof(MEGAString), "%s{FFFFFF}A mochila do cidadão está vazia.", MEGAString);

	ShowPlayerDialog(playerid, DIALOG_REVISTA_MOCHILA, DIALOG_STYLE_MSGBOX, "Itens Encontrados na revista", MEGAString, "Fechar", "");
}

public OnPlayerConnect(playerid)
{
	inspectId[playerid] = INVALID_PLAYER_ID;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_REVISTA_TIPO)
	{
		if(response)
        {
			if(IsPlayerConnected(playerid))
			{
				if(IsPlayerConnected(inspectId[playerid]))
				{
					switch(listitem)
					{
						case 0:
							ShowInspectBodyDialog(playerid, inspectId[playerid]);
						case 1:
							ShowInspectBackPackDialog(playerid, inspectId[playerid]);
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_GREY, "O cidadão não está logado.");
				}
			}
		}
		else
		{
			inspectId[playerid] = INVALID_PLAYER_ID;
		}
	}

	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	new idx;
	new cmd[256];
    new tmp[150];
	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd, "/revistarteste", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
        if(!strlen(tmp))
        {
            SendClientMessage(playerid, -1, "Use: /revistar [id]");
            return 1;
        }
        new id = strval(tmp);

        ShowPlayerDialog(playerid, DIALOG_REVISTA_TIPO, DIALOG_STYLE_LIST, "Escolha o tipo de revista", "Revistar o cidadão\nRevistar mochila", "Revistar", "Cancelar");
		inspectId[playerid] = id;
		return 1;
	}

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