#include <a_samp>

#if defined _setgravity_included
  #endinput
#endif
#define _setgravity_included

static bool:moving[MAX_PLAYERS char];
static Float:gravity[MAX_PLAYERS];
static bool:setgravity[MAX_PLAYERS char];

stock SetPlayerGravity(playerid, Float:newgravity)
{
    setgravity{playerid} = true;
    gravity[playerid] = newgravity*50.0;
    moving{playerid} = false;
}

stock ResetPlayerGravity(playerid)
{
    setgravity{playerid} = false;
    gravity[playerid] = 0.0;
    moving{playerid} = false;
}