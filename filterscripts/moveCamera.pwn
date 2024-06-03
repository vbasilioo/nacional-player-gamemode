#include <a_samp>

stock camera(playerid)
{
  SetPlayerInterior(playerid, 0);
  SetPlayerVirtualWorld(playerid, 0);
  TogglePlayerControllable(playerid, 0);
  // SetPlayerPosNew(playerid,-1881.480,889.117,69.695);
  InterpolateCameraPos(playerid, 1357.747802, -1997.679687, 80.036499, 1928.944702, -507.284393, 91.059158, 17000);
  InterpolateCameraLookAt(playerid, 1356.951660, -2002.516357, 79.050399, 1930.861694, -502.666534, 91.079406, 17000);
  return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
  new idx;
  new cmd[256];
  new tmp[150];

  cmd = strtok(cmdtext, idx);

  if(strcmp(cmd, "/camera", true) == 0) {
    camera(playerid);
  }

  return 1;
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