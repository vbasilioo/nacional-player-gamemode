#if defined _EttonInc

#endinput

#endif

#define _EttonInc_included


#include <a_samp>
#define MINIGAMES 10

new ProxMg;
new NomeMG[2][128] = {
"GameMode Base",
"The Walking Dead"

};
stock ProximoMG()
{
	printf("Próximo MiniGame %s",NomeMG[ProxMg]);
	new str[128];
	format(str,sizeof str,"Próximo MiniGame: {EEEE00}%s",NomeMG[ProxMg]);
	SendClientMessageToAll(-1,str);
	switch(ProxMg)
	{
	    case 0:
	    {
			SendRconCommand("changemode GMBASE");
	    }
	    case 1:
	    {
	        SendRconCommand("changemode 1");
	    }
	}
}