#include <a_samp>
#include <timerfix>
#include <DOF2>
#include <streamer>
#include <foreach>

new gPlayerLogged[MAX_PLAYERS];
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

enum PlayerData {
	pName[MAX_PLAYER_NAME],
	pFixedID
};

new PlayerDados[MAX_PLAYERS][PlayerData];

#define PASTA_TAGS "Players/Tags/%s"
#define PASTA_CONTAS "Players/Contas/%s"

CallBack:: GetPlayerNameEx(playerid) {
	return PlayerDados[playerid][pName];
}

CallBack:: GetPlayerFixedId(playerid) {
	return PlayerDados[playerid][pFixedID];
}

public OnGamemodeInit() {

}




public PlayerLogado {
 	new tagFile[256];
	format(tagFile, sizeof(tagFile), PASTA_TAGS, PlayerName(playerid));
	if(!DOF2_FileExists(tagFile))
	{
		DOF2_CreateFile(tagFile);
	  	new tag = CreatePlayerTag(playerid);
	  	DOF2_SetInt(tagFile, "Tag", tag);
	}
	
	PlayerDados[playerid][pTagImput] = DOF2_GetInt(tagFile, "Tag");
 	GetPlayerName(playerid, PlayerDados[playerid][pNomeMas]);
 	SetPlayerName(playerid, PlayerDados[playerid][pTagImput]);
	
}

stock CreatePlayerTag(playerid)
{
	new controlFile[] = "Players/Tags/Control";
	if(!DOF2_FileExists(controlFile))
	{
		DOF2_CreateFile(controlFile);
 		DOF2_SetInt(controlFile, "Ultimo", 1000);
	}
	new Ultimo = DOF2_GetInt(controlFile, "Ultimo");
	DOF2_SetInt(controlFile, "Ultimo", Ultimo+1);
	return Ultimo+1;
}
public OnPlayerConnect() {

}

forward AtualizarText();
public AtualizarText()
{
	foreach(Player, i)
	{
		if(gPlayerLogged[i])
		{
			new Joelw[MAX_CHATBUBBLE_LENGTH];
			if(PlayerDados[i][pChaoTime] == 0)
			{
				format(Joelw, sizeof Joelw, "\n\n %d", PlayerDados[i][pTagImput]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			else
			{
				new const cores[] = {"F90800", "F91400", "F92100", "F42C00", "F43900",
			 	"F44500", "EF4F00", "EF5B00", "EF6700", "EA7100", "EA7D00", "EA8800",
	  			"E59100", "E59900", "E5A400", "E0AC00", "E0B700", "E0C200", "DBC900",
			   	"DBD300", "D7DB00", "C7D600", "BDD600", "B2D600", "A3D100", "99D100",
			    "8ED100", "84CC00", "7ACC00", "70CC00", "63C600", "59C600", "4FC600",
			 	"43C100", "3AC100", "30C100", "25BC00", "1CBC00", "12BC00"};
				new const numberChangeColor = floatround(3600 / sizeof(cores), floatround_floor);
				new corAtualIndex = floatround(PlayerDados[playerid][pChaoTime] / numberChangeColor, floatround_floor);

				format(Joelw, sizeof Joelw, "\n\n {%s}%d", cores[corAtualIndex], PlayerDados[i][pTagImput]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			if(PlayerDados[i][Morto] == 1)
			{
				format(Joelw, sizeof Joelw, "\n\n {F90800}%d", PlayerDados[i][pTagImput]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
		} // FIM CONDICIONAL DO CARA CONECTADO
	}
}
