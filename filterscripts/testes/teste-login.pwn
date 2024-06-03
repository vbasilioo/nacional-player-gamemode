#include <a_samp>
#include <crashdetect>

new bool:gIsProtect = false;
new gPlayerPingTimer[MAX_PLAYERS] = {-1, ...};

const MAX_ACCEPTED_PING = 450;

forward CheckPing(playerid);
public CheckPing(playerid) {
	if (GetPlayerPing(playerid) > MAX_ACCEPTED_PING)
    {
        Kick(playerid);
    }
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(gIsProtect)
		gPlayerPingTimer[playerid] = SetTimerEx("CheckPing", 3 * 1000, true, "i", playerid);
}

public OnPlayerDisconnect(playerid, reason)
{
    KillTimer(gPlayerPingTimer[playerid]);
    gPlayerPingTimer[playerid] = -1;
}


public OnPlayerCommandText(playerid, cmdtext[]) {
	new idx;
	new cmd[256];
	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd, "/xcz45asdas", true) == 0) {
		if(gIsProtect)
		{
			SendClientMessage(playerid, -1, "Desativado");
        	gIsProtect = false;
		}
		else
		{
			SendClientMessage(playerid, -1, "Ativado");
        	gIsProtect = true;
		}
		return 0;
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