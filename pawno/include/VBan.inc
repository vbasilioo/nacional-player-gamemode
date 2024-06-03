/*
    Name: VBan
	Description: Bans system
	Author: ViniBorn
	Contact : vini-elite@hotmail.com
	Country : Brazil


        ***        ***   ***   *****     ***   ***   *** ***       *****      ********    ******    ***
         ***      ***    ***   *** ***   ***   ***   ***   **    ***   ***    ***  ***    *** ***   ***
          ***    ***     ***   ***  ***  ***   ***   *** **      ***   ***    *** ***     ***  ***  ***
           ***  ***      ***   ***   *** ***   ***   ***   **    ***   ***    ***  ***    ***   *** ***
            ******       ***   ***    ******   ***   *** ****      *****      ***   ***   ***    ******





        Do not remove the credits.
        Your name is valuable, do not mess it.


        Comments:

        - The default directory for saving bans is: scriptfiles/bans. Create bans folder.


*/

#include <Dini>
#include <a_samp>

#define BanDir     "/bans/%s.ini"     // Directory of bans
#define ErrorColor        0xAFAFAFAA
#define BanColor        0xE11D36AA

new VIP[32],Vnewban[32],Vstring[128],NICKBAN[20];

stock VBanID(playerid,giveid,reason[])
{
    format(NICKBAN,20,VBPlayer(giveid));
	if(playerid > -1)
	{
	    format(Vstring,128,"'- VBan -' The player %s was banned by %s. Reason: %s",VBPlayer(giveid),VBPlayer(playerid),reason);
	    SendClientMessageToAll(BanColor,Vstring);
	    GetPlayerIp(giveid, VIP, sizeof(VIP));
	    format(Vnewban,32,BanDir,VIP);
		dini_Create(Vnewban);
		VBanSaveInfo(playerid,Vnewban,reason);
	    format(Vnewban,32,BanDir,VBPlayer(giveid));
		dini_Create(Vnewban);
		VBanSaveInfo(playerid,Vnewban,reason);
	}
	else
	{
	    format(Vstring,128,"'- VBan -' The player %s was banned by VBot Admin. Reason: %s",VBPlayer(giveid),reason);
	    SendClientMessageToAll(BanColor,Vstring);
	    format(Vnewban,32,BanDir,VBPlayer(giveid));
		dini_Create(Vnewban);
		VBanSaveInfo(-1,Vnewban,reason);
	}
	if(IsPlayerConnected(giveid))
		VBanLoadInfo(giveid,Vnewban);

	Kick(giveid);

    return 1;
}

stock VBanNick(playerid,nick[],reason[])
{
    format(Vnewban,32,BanDir,nick);

    if(dini_Exists(Vnewban))
		return SendClientMessage(playerid, ErrorColor,"'- VBan -' This nickname is already banned.");

	new giveid;
	giveid = VBReturnUser(nick);
	if(!IsPlayerConnected(giveid))
	{
        format(NICKBAN,20,nick);
		format(Vstring,128,"'- VBan -' The nickname %s was banned by %s. Reason: %s",nick,VBPlayer(playerid),reason);
		SendClientMessageToAll(BanColor,Vstring);
		dini_Create(Vnewban);
	    return VBanSaveInfo(playerid,Vnewban,reason);
    }
	else
	    return VBanID(playerid,giveid,reason);
}

stock VBanIP(playerid,IP2[],reason[])
{
    format(Vnewban,32,BanDir,IP2);

    if(dini_Exists(Vnewban))
		return SendClientMessage(playerid, ErrorColor,"'- VBan -' This IP is already banned.");

	if(playerid > -1)
	{
	    new ban;

		for(new i=0, j = GetMaxPlayers(); i < j; i++)
		    if(IsPlayerConnected(i))
		    {
			    GetPlayerIp(i, VIP, sizeof(VIP));
			    if(!strcmp(VIP, IP2))
			    {
			        ban++;
		            VBanID(playerid,i,reason);
	            }
            }

		if(ban == 0)
		{
	        dini_Create(Vnewban);
		    format(Vstring,128,"'- VBan -' The IP %s was banned by %s. Reason: %s",IP2,VBPlayer(playerid),reason);
		    SendClientMessageToAll(BanColor,Vstring);
		    VBanSaveInfo(playerid,Vnewban,reason);
	    }
    }
    else
    {
        format(Vnewban,32,BanDir,IP2);
        dini_Create(Vnewban);
	    format(Vstring,128,"'- VBan -' The IP %s was banned by VBot Admin. Reason: Ban evade",IP2);
	    SendClientMessageToAll(BanColor,Vstring);
	    VBanSaveInfo(-1,Vnewban,"Ban evade");
    }
    return 1;
}

stock VUnBan(playerid,Arq[])
{
    format(Vnewban,32,BanDir,Arq);
    if(!dini_Exists(Vnewban))
		return SendClientMessage(playerid, ErrorColor,"'- VBan -' Ban non-existent.");

	new BANNEDIP[32];
	format(BANNEDIP,32,BanDir,dini_Get(Vnewban,"IP"));
    if(dini_Exists(BANNEDIP))
    {
        new BANNEDACC[32];
        if(VBIsIP(Arq))
            format(Vstring,128,"'- VBan -' The IP %s(%s) was unbanned by %s.",Arq,dini_Get(Vnewban,"Nick"),VBPlayer(playerid));
        else
	    	format(Vstring,128,"'- VBan -' The account %s(%s) was unbanned by %s.",Arq,dini_Get(Vnewban,"IP"),VBPlayer(playerid));

    	format(BANNEDACC,32,BanDir,dini_Get(Vnewban,"Nick"));
		dini_Remove(BANNEDACC);
    	dini_Remove(BANNEDIP);
   	}
    else
		format(Vstring,128,"'- VBan -' The account %s was unbanned by %s.",Arq,VBPlayer(playerid));

	SendClientMessageToAll(0x10B4EEAA,Vstring);
	dini_Remove(Vnewban);
	return 1;
}

stock VBanCheck(playerid)
{
    format(Vnewban,32,BanDir,VBPlayer(playerid));
    if(dini_Exists(Vnewban))
    {
		VBanLoadInfo(playerid,Vnewban);
		GetPlayerIp(playerid, VIP, sizeof(VIP));
		VBanIP(-1,VIP,dini_Get(Vnewban,"Reason"));
		return Kick(playerid);
	}
	GetPlayerIp(playerid, VIP, sizeof(VIP));
	format(Vnewban,32,BanDir,VIP);
	if(dini_Exists(Vnewban))
    {
        VBanLoadInfo(playerid,Vnewban);
        format(NICKBAN,20,VBPlayer(playerid));
        dini_Set(Vnewban,"Nick",NICKBAN);
        VBanID(-1,playerid,dini_Get(Vnewban,"Reason"));
		return Kick(playerid);
	}
    return 1;
}
stock VBanLoadInfo(playerid,Varq[])
{
    if(!dini_Exists(Varq))
		return SendClientMessage(playerid, ErrorColor,"'- VBan -' Ban non-existent.");

	new InfoString[300];
	format(InfoString,300,"\n\t{FFFFFF}Nickname : {E11D36}%s\n\t{FFFFFF}IP : {E11D36}%s\n\t{FFFFFF}Admin : {E11D36}%s\n\t{FFFFFF}Reason : {E11D36}%s\n\t{FFFFFF}Date : {E11D36}%s\n\t{FFFFFF}Hour : {E11D36}%s",dini_Get(Varq,"Nick"),dini_Get(Varq,"IP"),dini_Get(Varq,"Admin"),dini_Get(Varq,"Reason"),dini_Get(Varq,"Date"),dini_Get(Varq,"Hour"));
	ShowPlayerDialog(playerid, 231, DIALOG_STYLE_MSGBOX, "        {FFFFFF}VBan - BanInfo -       By: ViniBorn", InfoString,"Close", "");
    return 1;
}

stock VBanSaveInfo(playerid,Varq[],reason[])
{
    new Vyear, Vmonth, Vday, Vhour, Vminute, Vsecond;
	getdate(Vyear, Vmonth, Vday); gettime(Vhour, Vminute, Vsecond);
    dini_Set(Varq,"IP",VIP);
    dini_Set(Varq,"Nick",NICKBAN);
    if(playerid > -1)
	    dini_Set(Varq,"Admin",VBPlayer(playerid));
	else
	    dini_Set(Varq,"Admin","VBot Admin");
    format(Vstring,32,"%02d:%02d:%02d", Vhour, Vminute, Vsecond);
    dini_Set(Varq,"Hour",Vstring);
    format(Vstring,32,"%02d/%02d/%d", Vday, Vmonth, Vyear);
    dini_Set(Varq,"Date",Vstring);
    dini_Set(Varq,"Reason",reason);
    return 1;
}

stock VBPlayer(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	return pname;
}

stock VBReturnUser(PlayerName[])
{
    if(VBIsNumeric(PlayerName))
        return strval(PlayerName);
    else
    {
        new found=0, id;
        for(new i=0; i < GetMaxPlayers(); i++)
        {
            if(IsPlayerConnected(i))
            {
                new foundname[MAX_PLAYER_NAME];
                GetPlayerName(i, foundname, MAX_PLAYER_NAME);
                new namelen = strlen(foundname);
                new bool:searched=false;
                for(new pos=0; pos <= namelen; pos++)
                {
                    if(searched != true)
                    {
                        if(strfind(foundname,PlayerName,true) == pos)
                        {
                            found++;
                            id = i;
                        }
                    }
                }
            }
        }
        if(found == 1)
            return id;
        else
            return INVALID_PLAYER_ID;
    }
}

stock VBIsIP(const string[])
{
	new count;
    for (new i = 0, j = strlen(string); i < j; i++)
        if(string[i] > 47 && string[i] < 58)
			count++;

	if(count > 5)
	    return 1;

    return 0;
}

stock VBIsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
        if(string[i] > '9' || string[i] < '0') return 0;

    return 1;
}