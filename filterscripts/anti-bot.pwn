#include  <      a_samp        >
#include  <      crashdetect   >

#if !defined varGet
#define varGet(%0)      getproperty(0,%0)
#endif


#if !defined varSet
#define varSet(%0,%1) setproperty(0, %0, %1)
#endif

stock botGetIP[24];

#define IsPlayerBot(%0)\
            GetPlayerPing(%0) == 65535 && (gettime() - varGet((GetPlayerIp(%0, botGetIP, sizeof botGetIP), botGetIP)) > 5)

public OnPlayerConnect(playerid)
{

    if(IsPlayerNPC(playerid)) return false;
    static playerip[24];
    GetPlayerIp(playerid, playerip, 24);
    if(gettime() - varGet(playerip) < 2)
    {
        strcat(playerip, "di_S");
        if(gettime() - varGet(playerip) < 3)
        {
            return false;
        }
        printf("%d Entrou em menos de 2 segundos", playerid);
        GetPlayerIp(playerid, playerip, 20);
        varSet(playerip, gettime());
        strcat(playerip, "x");
        static timers ;
        timers = varGet(playerip);
        varSet(playerip, 1+ timers);
        if(timers > 2)
        {
            playerip[strlen(playerip) - 2] = 0;
            printf("BOT: ID -> %d IP -> %s", playerid, playerip);
            BanEx(playerid, "Bot Connect");
        }
    }
    return varSet(playerip, gettime());
}

public OnPlayerDisconnect(playerid, reason)
{
    if(reason == 2)
    {
        static playerip[20];
        GetPlayerIp(playerid, playerip, 20);
        strcat(playerip, "di_S");
        varSet(playerip, gettime());
    }
    return 1;
} 