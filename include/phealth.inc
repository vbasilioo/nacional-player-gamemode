// SetPlayerHealth hook.
#define AC_MASTER 1
#define AC_PUBLIC%0\32;%0(%1) \
	forward %0(%1); public %0(%1)
#define AC_STOCK%0\32;%0(%1) \
	stock %0(%1)
#define AC_STOCK_F%0\32;%0(%1) \
	forward %0(%1); stock %0(%1)

AC_PUBLIC AC_SetPlayerHealth(playerid, Float:health) {
	if (IsPlayerConnected(playerid) && PlayerDados[playerid][pAdmin] == 0) 
	{
		printf("Player ID %d teve a vida alterada pelo servidor para %f", playerid, health);
	}
	return SetPlayerHealth(playerid, health);
}

#if defined _ALS_SetPlayerHealth
	#undef SetPlayerHealth
#else
	#define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth AC_SetPlayerHealth
