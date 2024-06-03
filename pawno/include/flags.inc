/*

			_____           _     _       
			|  __ \         | |   (_)      
			| |  | |_ __ ___| |__  _ _ __  
			| |  | | '__/ _ \ '_ \| | '_ \ 
			| |__| | | |  __/ |_) | | | | |
			|_____/|_|  \___|_.__/|_|_| |_|

					©Drebin 2012
					
				Textdraw Flags V 1.0

*/
//===============================================================
//---------------------------------------------------------------
//===============================================================
#include <a_samp>

#define FLAG_TYPE_GERMANY			0
#define FLAG_TYPE_NETHERLANDS		1
#define FLAG_TYPE_RUSSIA			2
#define FLAG_TYPE_AUSTRIA			3
#define FLAG_TYPE_BULGARIA			4
#define FLAG_TYPE_LITHUANIA			5	
#define FLAG_TYPE_ESTONIA			6
#define FLAG_TYPE_LUXEMBOURG		7
#define FLAG_TYPE_HUNGARY			8
#define FLAG_TYPE_ARMENIA			9
#define FLAG_TYPE_POLAND			10
#define FLAG_TYPE_CZECH_REPUBLIC	11
#define FLAG_TYPE_UKRAINE			12
#define FLAG_TYPE_ITALY				13
#define FLAG_TYPE_FRANCE			14
#define FLAG_TYPE_IRELAND			15
#define FLAG_TYPE_ROMANIA			16
#define FLAG_TYPE_BELGIUM			17
#define FLAG_TYPE_SWEDEN			18
#define FLAG_TYPE_FINLAND			19
#define FLAG_TYPE_DENMARK			20
#define FLAG_TYPE_NORWAY			21
#define FLAG_TYPE_ICELAND			22
#define FLAG_TYPE_SPAIN				23
#define FLAG_TYPE_USA				24
#define FLAG_TYPE_SWITZERLAND		25
#define FLAG_TYPE_ENGLAND			26
#define FLAG_TYPE_CANADA			27
#define FLAG_TYPE_BRAZIL			28
#define FLAG_TYPE_TURKEY			29
#define FLAG_TYPE_JAPAN				30
#define FLAG_TYPE_CHINA				31
#define FLAG_TYPE_ARGENTINIA		32
#define FLAG_TYPE_PORTUGAL			33

//===========================================================
//		Enum to save whether a flag is shown or not
//===========================================================
enum shownFlags {
	Germany,
	Netherlands,
	Russia,
	Austria,
	Bulgaria,
	Lithuania,
	Estonia,
	Luxembourg,
	Hungary,
	Armenia,
	Poland,
	CzechRepublic,
	Ukraine,
	Italy,
	France,
	Ireland,
	Romania,
	Belgium,
	Sweden,
	Finland,
	Denmark,
	Norway,
	Iceland,
	Spain,
	USA,
	Switzerland,
	England,
	Canada,
	Brazil,
	Turkey,
	Japan,
	China,
	Argentinia,
	Portugal
}
new flag_S[MAX_PLAYERS][shownFlags];

//===========================================================
//			The arrays to store the textdraw IDs
//===========================================================
new PlayerText:flag_Germany[MAX_PLAYERS][3];
new PlayerText:flag_Netherlands[MAX_PLAYERS][3];
new PlayerText:flag_Russia[MAX_PLAYERS][3];
new PlayerText:flag_Austria[MAX_PLAYERS][3];
new PlayerText:flag_Bulgaria[MAX_PLAYERS][3];
new PlayerText:flag_Lithuania[MAX_PLAYERS][3];
new PlayerText:flag_Estonia[MAX_PLAYERS][3];
new PlayerText:flag_Luxembourg[MAX_PLAYERS][3];
new PlayerText:flag_Hungary[MAX_PLAYERS][3];
new PlayerText:flag_Armenia[MAX_PLAYERS][3];
new PlayerText:flag_Poland[MAX_PLAYERS][2];
new PlayerText:flag_CzechRepublic[MAX_PLAYERS][7];
new PlayerText:flag_Ukraine[MAX_PLAYERS][2];
new PlayerText:flag_Italy[MAX_PLAYERS][3];
new PlayerText:flag_France[MAX_PLAYERS][3];
new PlayerText:flag_Ireland[MAX_PLAYERS][3];
new PlayerText:flag_Romania[MAX_PLAYERS][3];
new PlayerText:flag_Belgium[MAX_PLAYERS][3];
new PlayerText:flag_Sweden[MAX_PLAYERS][3];
new PlayerText:flag_Finland[MAX_PLAYERS][3];
new PlayerText:flag_Denmark[MAX_PLAYERS][3];
new PlayerText:flag_Norway[MAX_PLAYERS][6];
new PlayerText:flag_Iceland[MAX_PLAYERS][6];
new PlayerText:flag_Spain[MAX_PLAYERS][3];
new PlayerText:flag_USA[MAX_PLAYERS][9];
new PlayerText:flag_Switzerland[MAX_PLAYERS][2];
new PlayerText:flag_England[MAX_PLAYERS][3];
new PlayerText:flag_Canada[MAX_PLAYERS][8];
new PlayerText:flag_Brazil[MAX_PLAYERS][13];
new PlayerText:flag_Turkey[MAX_PLAYERS][3];
new PlayerText:flag_Japan[MAX_PLAYERS][2];
new PlayerText:flag_China[MAX_PLAYERS][6];
new PlayerText:flag_Argentinia[MAX_PLAYERS][3];
new PlayerText:flag_Portugal[MAX_PLAYERS][3];

//===========================================================
//			The clickable boxes ontop of the flags
//===========================================================
new PlayerText:FLAG_GERMANY[MAX_PLAYERS];
new PlayerText:FLAG_NETHERLANDS[MAX_PLAYERS];
new PlayerText:FLAG_RUSSIA[MAX_PLAYERS];
new PlayerText:FLAG_AUSTRIA[MAX_PLAYERS];
new PlayerText:FLAG_BULGARIA[MAX_PLAYERS];
new PlayerText:FLAG_LITHUANIA[MAX_PLAYERS];
new PlayerText:FLAG_ESTONIA[MAX_PLAYERS];
new PlayerText:FLAG_LUXEMBOURG[MAX_PLAYERS];
new PlayerText:FLAG_HUNGARY[MAX_PLAYERS];
new PlayerText:FLAG_ARMENIA[MAX_PLAYERS];
new PlayerText:FLAG_POLAND[MAX_PLAYERS];
new PlayerText:FLAG_CZECH_REPUBLIC[MAX_PLAYERS];
new PlayerText:FLAG_UKRAINE[MAX_PLAYERS];
new PlayerText:FLAG_ITALY[MAX_PLAYERS];
new PlayerText:FLAG_FRANCE[MAX_PLAYERS];
new PlayerText:FLAG_IRELAND[MAX_PLAYERS];
new PlayerText:FLAG_ROMANIA[MAX_PLAYERS];
new PlayerText:FLAG_BELGIUM[MAX_PLAYERS];
new PlayerText:FLAG_SWEDEN[MAX_PLAYERS];
new PlayerText:FLAG_FINLAND[MAX_PLAYERS];
new PlayerText:FLAG_DENMARK[MAX_PLAYERS];
new PlayerText:FLAG_NORWAY[MAX_PLAYERS];
new PlayerText:FLAG_ICELAND[MAX_PLAYERS];
new PlayerText:FLAG_SPAIN[MAX_PLAYERS];
new PlayerText:FLAG_USA[MAX_PLAYERS];
new PlayerText:FLAG_SWITZERLAND[MAX_PLAYERS];
new PlayerText:FLAG_ENGLAND[MAX_PLAYERS];
new PlayerText:FLAG_CANADA[MAX_PLAYERS];
new PlayerText:FLAG_BRAZIL[MAX_PLAYERS];
new PlayerText:FLAG_TURKEY[MAX_PLAYERS];
new PlayerText:FLAG_JAPAN[MAX_PLAYERS];
new PlayerText:FLAG_CHINA[MAX_PLAYERS];
new PlayerText:FLAG_ARGENTINIA[MAX_PLAYERS];
new PlayerText:FLAG_PORTUGAL[MAX_PLAYERS];

forward TextDrawFlagShowForPlayer(playerid, flagtype, Float:X, Float:Y, clickable);
public TextDrawFlagShowForPlayer(playerid, flagtype, Float:X, Float:Y, clickable)
{
	switch(flagtype)
	{
		case FLAG_TYPE_GERMANY:			f_showGermany(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_NETHERLANDS:		f_showNetherlands(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_RUSSIA:			f_showRussia(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_AUSTRIA:			f_showAustria(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_BULGARIA:		f_showBulgaria(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_LITHUANIA:		f_showLithuania(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ESTONIA:			f_showEstonia(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_LUXEMBOURG:		f_showLuxembourg(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_HUNGARY:			f_showHungary(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ARMENIA:			f_showArmenia(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_POLAND:			f_showPoland(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_CZECH_REPUBLIC:	f_showCzechRepublic(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_UKRAINE:			f_showUkraine(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ITALY:			f_showItaly(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_FRANCE:			f_showFrance(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_IRELAND:			f_showIreland(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ROMANIA:			f_showRomania(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_BELGIUM:			f_showBelgium(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_SWEDEN:			f_showSweden(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_FINLAND:			f_showFinland(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_DENMARK:			f_showDenmark(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_NORWAY:			f_showNorway(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ICELAND:			f_showIceland(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_SPAIN:			f_showSpain(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_USA:				f_showUSA(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_SWITZERLAND:		f_showSwitzerland(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ENGLAND:			f_showEngland(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_CANADA:			f_showCanada(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_BRAZIL:			f_showBrazil(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_TURKEY:			f_showTurkey(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_JAPAN:			f_showJapan(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_CHINA:			f_showChina(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_ARGENTINIA:		f_showArgentinia(playerid, Float:X, Float:Y, clickable);
		case FLAG_TYPE_PORTUGAL:		f_showPortugal(playerid, Float:X, Float:Y, clickable);
	}
}


forward TextDrawFlagHideForPlayer(playerid, flagtype);
public TextDrawFlagHideForPlayer(playerid, flagtype)
{
	switch(flagtype)
	{
		case FLAG_TYPE_GERMANY:			f_hideGermany(playerid);
		case FLAG_TYPE_NETHERLANDS:		f_hideNetherlands(playerid);
		case FLAG_TYPE_RUSSIA:			f_hideRussia(playerid);
		case FLAG_TYPE_AUSTRIA:			f_hideAustria(playerid);
		case FLAG_TYPE_BULGARIA:		f_hideBulgaria(playerid);
		case FLAG_TYPE_LITHUANIA:		f_hideLithuania(playerid);
		case FLAG_TYPE_ESTONIA:			f_hideEstonia(playerid);
		case FLAG_TYPE_LUXEMBOURG:		f_hideLuxembourg(playerid);
		case FLAG_TYPE_HUNGARY:			f_hideHungary(playerid);
		case FLAG_TYPE_ARMENIA:			f_hideArmenia(playerid);
		case FLAG_TYPE_POLAND:			f_hidePoland(playerid);
		case FLAG_TYPE_CZECH_REPUBLIC:	f_hideCzechRepublic(playerid);
		case FLAG_TYPE_UKRAINE:			f_hideUkraine(playerid);
		case FLAG_TYPE_ITALY:			f_hideItaly(playerid);
		case FLAG_TYPE_FRANCE:			f_hideFrance(playerid);
		case FLAG_TYPE_IRELAND:			f_hideIreland(playerid);
		case FLAG_TYPE_ROMANIA:			f_hideRomania(playerid);
		case FLAG_TYPE_BELGIUM:			f_hideBelgium(playerid);
		case FLAG_TYPE_SWEDEN:			f_hideSweden(playerid);
		case FLAG_TYPE_FINLAND:			f_hideFinland(playerid);
		case FLAG_TYPE_DENMARK:			f_hideDenmark(playerid);
		case FLAG_TYPE_NORWAY:			f_hideNorway(playerid);
		case FLAG_TYPE_ICELAND:			f_hideIceland(playerid);
		case FLAG_TYPE_SPAIN:			f_hideSpain(playerid);
		case FLAG_TYPE_USA:				f_hideUSA(playerid);
		case FLAG_TYPE_SWITZERLAND:		f_hideSwitzerland(playerid);
		case FLAG_TYPE_ENGLAND:			f_hideEngland(playerid);
		case FLAG_TYPE_CANADA:			f_hideCanada(playerid);
		case FLAG_TYPE_BRAZIL:			f_hideBrazil(playerid);
		case FLAG_TYPE_TURKEY:			f_hideTurkey(playerid);
		case FLAG_TYPE_JAPAN:			f_hideJapan(playerid);
		case FLAG_TYPE_CHINA:			f_hideChina(playerid);
		case FLAG_TYPE_ARGENTINIA:		f_hideArgentinia(playerid);
		case FLAG_TYPE_PORTUGAL:		f_hidePortugal(playerid);
	}
	return 1;
}

stock f_showGermany(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Germany] == 1) return 1;
	flag_Germany[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Germany[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Germany[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Germany[playerid][0], 255);
	PlayerTextDrawTextSize(								playerid, flag_Germany[playerid][0], 33.0, 55.000000);
	PlayerTextDrawAlignment(							playerid, flag_Germany[playerid][0], 2);

	flag_Germany[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Germany[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Germany[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Germany[playerid][1], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Germany[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Germany[playerid][1], 2);

	flag_Germany[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Germany[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Germany[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Germany[playerid][2], -65281);
	PlayerTextDrawTextSize(								playerid, flag_Germany[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Germany[playerid][2], 2);
	
	FLAG_GERMANY[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment( 							playerid, FLAG_GERMANY[playerid], 2);
	PlayerTextDrawLetterSize( 							playerid, FLAG_GERMANY[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox( 								playerid, FLAG_GERMANY[playerid], 1);
	PlayerTextDrawBoxColor( 							playerid, FLAG_GERMANY[playerid], 0);
	PlayerTextDrawTextSize( 							playerid, FLAG_GERMANY[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_GERMANY[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Germany[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Germany[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Germany[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_GERMANY[playerid]);
	}
	flag_S[playerid][Germany] = 1;
	return 1;
}

stock f_showNetherlands(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Netherlands] == 1) return 1;
	flag_Netherlands[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_Netherlands[playerid][0], 2);
	PlayerTextDrawLetterSize(								playerid, flag_Netherlands[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(									playerid, flag_Netherlands[playerid][0], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Netherlands[playerid][0], -16776961);
	PlayerTextDrawTextSize(									playerid, flag_Netherlands[playerid][0], 33.0, 54.000000);

	flag_Netherlands[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(								playerid, flag_Netherlands[playerid][1], 2);
	PlayerTextDrawLetterSize(								playerid, flag_Netherlands[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(									playerid, flag_Netherlands[playerid][1], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Netherlands[playerid][1], -1);
	PlayerTextDrawTextSize(									playerid, flag_Netherlands[playerid][1], 33.0, 54.000000);

	flag_Netherlands[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawAlignment(								playerid, flag_Netherlands[playerid][2], 2);
	PlayerTextDrawLetterSize(								playerid, flag_Netherlands[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(									playerid, flag_Netherlands[playerid][2], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Netherlands[playerid][2], 65535);
	PlayerTextDrawTextSize(									playerid, flag_Netherlands[playerid][2], 33.0, 54.000000);
	
	FLAG_NETHERLANDS[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, FLAG_NETHERLANDS[playerid], 2);
	PlayerTextDrawLetterSize(								playerid, FLAG_NETHERLANDS[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(									playerid, FLAG_NETHERLANDS[playerid], 1);
	PlayerTextDrawBoxColor(									playerid, FLAG_NETHERLANDS[playerid], 0);
	PlayerTextDrawTextSize(									playerid, FLAG_NETHERLANDS[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_NETHERLANDS[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Netherlands[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Netherlands[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Netherlands[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_NETHERLANDS[playerid]);
	}
	flag_S[playerid][Netherlands] = 1;
	return 1;
}

stock f_showRussia(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Russia] == 1) return 1;
	flag_Russia[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Russia[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Russia[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Russia[playerid][0], -1);
	PlayerTextDrawAlignment(							playerid, flag_Russia[playerid][0], 2);
	PlayerTextDrawTextSize(								playerid, flag_Russia[playerid][0], 33.0, 54.000000);

	flag_Russia[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Russia[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Russia[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Russia[playerid][1], 65535);
	PlayerTextDrawAlignment(							playerid, flag_Russia[playerid][1], 2);
	PlayerTextDrawTextSize(								playerid, flag_Russia[playerid][1], 33.0, 54.000000);

	flag_Russia[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Russia[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Russia[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Russia[playerid][2], -16776961);
	PlayerTextDrawAlignment(							playerid, flag_Russia[playerid][2], 2);
	PlayerTextDrawTextSize(								playerid, flag_Russia[playerid][2], 33.0, 54.000000);
	
	FLAG_RUSSIA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_RUSSIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_RUSSIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_RUSSIA[playerid], 1);
	PlayerTextDrawBoxColor(								playerid, FLAG_RUSSIA[playerid], 0);
	PlayerTextDrawAlignment(							playerid, FLAG_RUSSIA[playerid], 2);
	PlayerTextDrawTextSize(								playerid, FLAG_RUSSIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_RUSSIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Russia[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Russia[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Russia[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_RUSSIA[playerid]);
	}
	flag_S[playerid][Russia] = 1;
	return 1;
}

stock f_showAustria(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Austria] == 1) return 1;
	flag_Austria[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Austria[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Austria[playerid][0], 1);
	PlayerTextDrawAlignment(							playerid, flag_Austria[playerid][0], 2);
	PlayerTextDrawBoxColor(								playerid, flag_Austria[playerid][0], -669121025);
	PlayerTextDrawTextSize(								playerid, flag_Austria[playerid][0], 33.0, 54.000000);

	flag_Austria[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Austria[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Austria[playerid][1], 1);
	PlayerTextDrawAlignment(							playerid, flag_Austria[playerid][1], 2);
	PlayerTextDrawBoxColor(								playerid, flag_Austria[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Austria[playerid][1], 33.0, 54.000000);

	flag_Austria[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Austria[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Austria[playerid][2], 1);
	PlayerTextDrawAlignment(							playerid, flag_Austria[playerid][2], 2);
	PlayerTextDrawBoxColor(								playerid, flag_Austria[playerid][2], -669121025);
	PlayerTextDrawTextSize(								playerid, flag_Austria[playerid][2], 33.0, 54.000000);
	
	FLAG_AUSTRIA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_AUSTRIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_AUSTRIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_AUSTRIA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_AUSTRIA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_AUSTRIA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_AUSTRIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_AUSTRIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Austria[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Austria[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Austria[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_AUSTRIA[playerid]);
	}
	flag_S[playerid][Austria] = 1;
	return 1;
}

stock f_showBulgaria(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Bulgaria] == 1) return 1;
	flag_Bulgaria[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Bulgaria[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Bulgaria[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Bulgaria[playerid][0], -1);
	PlayerTextDrawTextSize(								playerid, flag_Bulgaria[playerid][0], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Bulgaria[playerid][0], 2);

	flag_Bulgaria[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Bulgaria[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Bulgaria[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Bulgaria[playerid][1], 9858815);
	PlayerTextDrawTextSize(								playerid, flag_Bulgaria[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Bulgaria[playerid][1], 2);

	flag_Bulgaria[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Bulgaria[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Bulgaria[playerid][2], 1);
	PlayerTextDrawUseBox(								playerid, flag_Bulgaria[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Bulgaria[playerid][2], -702147841);
	PlayerTextDrawTextSize(								playerid, flag_Bulgaria[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Bulgaria[playerid][2], 2);
	
	FLAG_BULGARIA[playerid] = CreatePlayerTextDraw(playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_BULGARIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_BULGARIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_BULGARIA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_BULGARIA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_BULGARIA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_BULGARIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_BULGARIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Bulgaria[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Bulgaria[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Bulgaria[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_BULGARIA[playerid]);
	}
	flag_S[playerid][Bulgaria] = 1;
	return 1;
}

stock f_showLithuania(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Lithuania] == 1) return 1;
	flag_Lithuania[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Lithuania[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Lithuania[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_Lithuania[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Lithuania[playerid][0], -38202369);
	PlayerTextDrawTextSize(								playerid, flag_Lithuania[playerid][0], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Lithuania[playerid][0], 2);

	flag_Lithuania[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Lithuania[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Lithuania[playerid][1], 1);
	PlayerTextDrawUseBox(								playerid, flag_Lithuania[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Lithuania[playerid][1], 6964479);
	PlayerTextDrawTextSize(								playerid, flag_Lithuania[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Lithuania[playerid][1], 2);

	flag_Lithuania[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Lithuania[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Lithuania[playerid][2], 1);
	PlayerTextDrawUseBox(								playerid, flag_Lithuania[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Lithuania[playerid][2], -1054396929);
	PlayerTextDrawTextSize(								playerid, flag_Lithuania[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Lithuania[playerid][2], 2);

	FLAG_LITHUANIA[playerid] = CreatePlayerTextDraw(playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_LITHUANIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_LITHUANIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_LITHUANIA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_LITHUANIA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_LITHUANIA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_LITHUANIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(						playerid, FLAG_LITHUANIA[playerid], 1);
	PlayerTextDrawShow(									playerid, flag_Lithuania[playerid][0]);
	PlayerTextDrawShow(									playerid, flag_Lithuania[playerid][1]);
	PlayerTextDrawShow(									playerid, flag_Lithuania[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_LITHUANIA[playerid]);
	}
	flag_S[playerid][Lithuania] = 1;
	return 1;
}

stock f_showEstonia(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Estonia] == 1) return 1;
	flag_Estonia[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Estonia[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Estonia[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_Estonia[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Estonia[playerid][0], 980796671);
	PlayerTextDrawTextSize(								playerid, flag_Estonia[playerid][0], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Estonia[playerid][0], 2);

	flag_Estonia[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Estonia[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Estonia[playerid][1], 1);
	PlayerTextDrawUseBox(								playerid, flag_Estonia[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Estonia[playerid][1], 255);
	PlayerTextDrawTextSize(								playerid, flag_Estonia[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Estonia[playerid][1], 2);

	flag_Estonia[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Estonia[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawSetShadow(							playerid, flag_Estonia[playerid][2], 1);
	PlayerTextDrawUseBox(								playerid, flag_Estonia[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Estonia[playerid][2], -1);
	PlayerTextDrawTextSize(								playerid, flag_Estonia[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Estonia[playerid][2], 2);
	
	FLAG_ESTONIA[playerid] = CreatePlayerTextDraw(playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_ESTONIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_ESTONIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_ESTONIA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_ESTONIA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_ESTONIA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_ESTONIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ESTONIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Estonia[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Estonia[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Estonia[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ESTONIA[playerid]);
	}
	flag_S[playerid][Estonia] = 1;
	return 1;
}

stock f_showLuxembourg(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Luxembourg] == 1) return 1;
	flag_Luxembourg[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(								playerid, flag_Luxembourg[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(									playerid, flag_Luxembourg[playerid][0], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Luxembourg[playerid][0], -316065281);
	PlayerTextDrawTextSize(									playerid, flag_Luxembourg[playerid][0], 33.0, 54.000000);
	PlayerTextDrawAlignment(								playerid, flag_Luxembourg[playerid][0], 2);

	flag_Luxembourg[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(								playerid, flag_Luxembourg[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(									playerid, flag_Luxembourg[playerid][1], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Luxembourg[playerid][1], -1);
	PlayerTextDrawTextSize(									playerid, flag_Luxembourg[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(								playerid, flag_Luxembourg[playerid][1], 2);

	flag_Luxembourg[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(								playerid, flag_Luxembourg[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(									playerid, flag_Luxembourg[playerid][2], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Luxembourg[playerid][2], 44302079);
	PlayerTextDrawTextSize(									playerid, flag_Luxembourg[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(								playerid, flag_Luxembourg[playerid][2], 2);
	
	FLAG_LUXEMBOURG[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, FLAG_LUXEMBOURG[playerid], 2);
	PlayerTextDrawLetterSize(								playerid, FLAG_LUXEMBOURG[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(									playerid, FLAG_LUXEMBOURG[playerid], 1);
	PlayerTextDrawAlignment(								playerid, FLAG_LUXEMBOURG[playerid], 2);
	PlayerTextDrawBoxColor(									playerid, FLAG_LUXEMBOURG[playerid], 0);
	PlayerTextDrawTextSize(									playerid, FLAG_LUXEMBOURG[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_LUXEMBOURG[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Luxembourg[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Luxembourg[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Luxembourg[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_LUXEMBOURG[playerid]);
	}
	flag_S[playerid][Luxembourg] = 1;
	return 1;
}

stock f_showHungary(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Hungary] == 1) return 1;
	flag_Hungary[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Hungary[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Hungary[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Hungary[playerid][0], -769438465);
	PlayerTextDrawTextSize(								playerid, flag_Hungary[playerid][0], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Hungary[playerid][0], 2);

	flag_Hungary[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Hungary[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Hungary[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Hungary[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Hungary[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Hungary[playerid][1], 2);

	flag_Hungary[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Hungary[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Hungary[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Hungary[playerid][2], 11355903);
	PlayerTextDrawTextSize(								playerid, flag_Hungary[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Hungary[playerid][2], 2);
	
	FLAG_HUNGARY[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_HUNGARY[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_HUNGARY[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_HUNGARY[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_HUNGARY[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_HUNGARY[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_HUNGARY[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_HUNGARY[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Hungary[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Hungary[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Hungary[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_HUNGARY[playerid]);
	}
	flag_S[playerid][Hungary] = 1;
	return 1;
}

stock f_showArmenia(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Armenia] == 1) return 1;
	flag_Armenia[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Armenia[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Armenia[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Armenia[playerid][0], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Armenia[playerid][0], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Armenia[playerid][0], 2);

	flag_Armenia[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Armenia[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Armenia[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Armenia[playerid][1], 43775);
	PlayerTextDrawTextSize(								playerid, flag_Armenia[playerid][1], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Armenia[playerid][1], 2);

	flag_Armenia[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Armenia[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Armenia[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Armenia[playerid][2], -6749953);
	PlayerTextDrawTextSize(								playerid, flag_Armenia[playerid][2], 33.0, 54.000000);
	PlayerTextDrawAlignment(							playerid, flag_Armenia[playerid][2], 2);
	
	FLAG_ARMENIA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_ARMENIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_ARMENIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_ARMENIA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_ARMENIA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_ARMENIA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_ARMENIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ARMENIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Armenia[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Armenia[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Armenia[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ARMENIA[playerid]);
	}
	flag_S[playerid][Armenia] = 1;
	return 1;
}

stock f_showPoland(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Poland] == 1) return 1;
	flag_Poland[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Poland[playerid][0], 0.500000, 1.700000);
	PlayerTextDrawUseBox(								playerid, flag_Poland[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Poland[playerid][0], -1);
	PlayerTextDrawTextSize(								playerid, flag_Poland[playerid][0], 33.0, 55.000000);
	PlayerTextDrawAlignment(							playerid, flag_Poland[playerid][0], 2);

	flag_Poland[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 19.5, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Poland[playerid][1], 0.500000, 1.700000);
	PlayerTextDrawUseBox(								playerid, flag_Poland[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Poland[playerid][1], -602653185);
	PlayerTextDrawTextSize(								playerid, flag_Poland[playerid][1], 33.0, 55.000000);
	PlayerTextDrawAlignment(							playerid, flag_Poland[playerid][1], 2);
	
	FLAG_POLAND[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_POLAND[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_POLAND[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_POLAND[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_POLAND[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_POLAND[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_POLAND[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_POLAND[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Poland[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Poland[playerid][1]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_POLAND[playerid]);
	}
	flag_S[playerid][Poland] = 1;
	return 1;
}

stock f_showCzechRepublic(playerid, Float:X, Float:Y, clickable)
{	
	if(flag_S[playerid][CzechRepublic] == 1) return 1;
	flag_CzechRepublic[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][0], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][0], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][0], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][0], 0.500000, 1.700000);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][0], -1);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][0], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][0], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][0], 1);
	PlayerTextDrawUseBox(									playerid, flag_CzechRepublic[playerid][0], 1);
	PlayerTextDrawBoxColor(									playerid, flag_CzechRepublic[playerid][0], -1);
	PlayerTextDrawTextSize(									playerid, flag_CzechRepublic[playerid][0], 33.0, 55.000000);

	flag_CzechRepublic[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 19.5, "_");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][1], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][1], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][1], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][1], 0.500000, 1.700000);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][1], 289767167);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][1], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][1], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][1], 1);
	PlayerTextDrawUseBox(									playerid, flag_CzechRepublic[playerid][1], 1);
	PlayerTextDrawBoxColor(									playerid, flag_CzechRepublic[playerid][1], -686548993);
	PlayerTextDrawTextSize(									playerid, flag_CzechRepublic[playerid][1], 33.0, 55.000000);

	flag_CzechRepublic[playerid][2] = CreatePlayerTextDraw(	playerid, X - 18.5, Y - 20.5, ">");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][2], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][2], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][2], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][2], 1.209999, 7.999999);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][2], 289767167);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][2], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][2], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][2], 0);

	flag_CzechRepublic[playerid][3] = CreatePlayerTextDraw(	playerid, X - 18.5, Y - 20.5, ">");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][3], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][3], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][3], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][3], 1.209999, 7.999999);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][3], 289767167);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][3], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][3], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][3], 0);

	flag_CzechRepublic[playerid][4] = CreatePlayerTextDraw(	playerid, X - 17.5, Y - 7.5, ">");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][4], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][4], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][4], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][4], 0.859999, 5.300000);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][4], 289767167);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][4], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][4], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][4], 0);

	flag_CzechRepublic[playerid][5] = CreatePlayerTextDraw(	playerid, X - 17.5, Y - 7.5, ">");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][5], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][5], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][5], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][5], 0.859999, 5.300000);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][5], 289767167);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][5], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][5], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][5], 0);

	flag_CzechRepublic[playerid][6] = CreatePlayerTextDraw(	playerid, X - 23.0, Y + 9.5, "_");
	PlayerTextDrawAlignment(								playerid, flag_CzechRepublic[playerid][6], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_CzechRepublic[playerid][6], 255);
	PlayerTextDrawFont(										playerid, flag_CzechRepublic[playerid][6], 1);
	PlayerTextDrawLetterSize(								playerid, flag_CzechRepublic[playerid][6], 0.859999, 2.000000);
	PlayerTextDrawColor(									playerid, flag_CzechRepublic[playerid][6], 289767167);
	PlayerTextDrawSetOutline(								playerid, flag_CzechRepublic[playerid][6], 0);
	PlayerTextDrawSetProportional(							playerid, flag_CzechRepublic[playerid][6], 1);
	PlayerTextDrawSetShadow(								playerid, flag_CzechRepublic[playerid][6], 0);
	PlayerTextDrawUseBox(									playerid, flag_CzechRepublic[playerid][6], 1);
	PlayerTextDrawBoxColor(									playerid, flag_CzechRepublic[playerid][6], 289767167);
	PlayerTextDrawTextSize(									playerid, flag_CzechRepublic[playerid][6], 343.000000, 10.000000);
	
	FLAG_CZECH_REPUBLIC[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(									playerid, FLAG_CZECH_REPUBLIC[playerid], 2);
	PlayerTextDrawLetterSize(									playerid, FLAG_CZECH_REPUBLIC[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(										playerid, FLAG_CZECH_REPUBLIC[playerid], 1);
	PlayerTextDrawAlignment(									playerid, FLAG_CZECH_REPUBLIC[playerid], 2);
	PlayerTextDrawBoxColor(										playerid, FLAG_CZECH_REPUBLIC[playerid], 0);
	PlayerTextDrawTextSize(										playerid, FLAG_CZECH_REPUBLIC[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_CZECH_REPUBLIC[playerid], 1);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][0]);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][1]);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][2]);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][3]);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][4]);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][5]);
	PlayerTextDrawShow(playerid, flag_CzechRepublic[playerid][6]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_CZECH_REPUBLIC[playerid]);
	}
	flag_S[playerid][CzechRepublic] = 1;
	return 1;
}

stock f_showUkraine(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Ukraine] == 1) return 1;
	flag_Ukraine[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Ukraine[playerid][0], 0.500000, 1.700000);
	PlayerTextDrawUseBox(								playerid, flag_Ukraine[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Ukraine[playerid][0], 980796671);
	PlayerTextDrawTextSize(								playerid, flag_Ukraine[playerid][0], 33.0, 55.000000);
	PlayerTextDrawAlignment(							playerid, flag_Ukraine[playerid][0], 2);

	flag_Ukraine[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 19.5, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Ukraine[playerid][1], 0.500000, 1.700000);
	PlayerTextDrawUseBox(								playerid, flag_Ukraine[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Ukraine[playerid][1], -102951169);
	PlayerTextDrawTextSize(								playerid, flag_Ukraine[playerid][1], 33.0, 55.000000);
	PlayerTextDrawAlignment(							playerid, flag_Ukraine[playerid][1], 2);
	
	FLAG_UKRAINE[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_UKRAINE[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_UKRAINE[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_UKRAINE[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_UKRAINE[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_UKRAINE[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_UKRAINE[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_UKRAINE[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Ukraine[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Ukraine[playerid][1]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_UKRAINE[playerid]);
	}
	flag_S[playerid][Ukraine] = 1;
	return 1;
}

stock f_showItaly(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Italy] == 1) return 1;
	flag_Italy[playerid][0] = CreatePlayerTextDraw(		playerid, X - 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Italy[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Italy[playerid][0], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, flag_Italy[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Italy[playerid][0], 9586431);
	PlayerTextDrawTextSize(								playerid, flag_Italy[playerid][0], 33.0, 15.0);

	flag_Italy[playerid][1] = CreatePlayerTextDraw(		playerid, X, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Italy[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Italy[playerid][1], 0.500000, 3.899999);
	PlayerTextDrawUseBox(								playerid, flag_Italy[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Italy[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Italy[playerid][1], 33.0, 15.0);

	flag_Italy[playerid][2] = CreatePlayerTextDraw(		playerid, X + 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Italy[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Italy[playerid][2], 0.500000, 3.899999);
	PlayerTextDrawUseBox(								playerid, flag_Italy[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Italy[playerid][2], -836028417);
	PlayerTextDrawTextSize(								playerid, flag_Italy[playerid][2], 33.0, 15.0);
	
	FLAG_ITALY[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_ITALY[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_ITALY[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_ITALY[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_ITALY[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_ITALY[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_ITALY[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ITALY[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Italy[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Italy[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Italy[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ITALY[playerid]);
	}
	flag_S[playerid][Italy] = 1;
	return 1;
}

stock f_showFrance(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][France] == 1) return 1;
	flag_France[playerid][0] = CreatePlayerTextDraw(	playerid, X - 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_France[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_France[playerid][0], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, flag_France[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_France[playerid][0], 2138111);
	PlayerTextDrawTextSize(								playerid, flag_France[playerid][0], 33.0, 15.0);

	flag_France[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_France[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_France[playerid][1], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_France[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_France[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_France[playerid][1], 33.0, 15.0);

	flag_France[playerid][2] = CreatePlayerTextDraw(	playerid, X + 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_France[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_France[playerid][2], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_France[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_France[playerid][2], -198557185);
	PlayerTextDrawTextSize(								playerid, flag_France[playerid][2], 33.0, 15.0);
	
	FLAG_FRANCE[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_FRANCE[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_FRANCE[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_FRANCE[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_FRANCE[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_FRANCE[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_FRANCE[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_FRANCE[playerid], 1);
	PlayerTextDrawShow(playerid, flag_France[playerid][0]);
	PlayerTextDrawShow(playerid, flag_France[playerid][1]);
	PlayerTextDrawShow(playerid, flag_France[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_FRANCE[playerid]);
	}
	flag_S[playerid][France] = 1;
	return 1;
}

stock f_showIreland(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Ireland] == 1) return 1;
	flag_Ireland[playerid][0] = CreatePlayerTextDraw(	playerid, X - 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Ireland[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Ireland[playerid][0], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, flag_Ireland[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Ireland[playerid][0], 9782271);
	PlayerTextDrawTextSize(								playerid, flag_Ireland[playerid][0], 33.0, 15.0);

	flag_Ireland[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Ireland[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Ireland[playerid][1], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_Ireland[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Ireland[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Ireland[playerid][1], 33.0, 15.0);

	flag_Ireland[playerid][2] = CreatePlayerTextDraw(	playerid, X + 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Ireland[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Ireland[playerid][2], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_Ireland[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Ireland[playerid][2], -9240321);
	PlayerTextDrawTextSize(								playerid, flag_Ireland[playerid][2], 33.0, 15.0);
	
	FLAG_IRELAND[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_IRELAND[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_IRELAND[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_IRELAND[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_IRELAND[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_IRELAND[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_IRELAND[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_IRELAND[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Ireland[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Ireland[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Ireland[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_IRELAND[playerid]);
	}
	flag_S[playerid][Ireland] = 1;
	return 1;
}

stock f_showRomania(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Romania] == 1) return 1;
	flag_Romania[playerid][0] = CreatePlayerTextDraw(	playerid, X - 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Romania[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Romania[playerid][0], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, flag_Romania[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Romania[playerid][0], 2850815);
	PlayerTextDrawTextSize(								playerid, flag_Romania[playerid][0], 33.0, 15.0);

	flag_Romania[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Romania[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Romania[playerid][1], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_Romania[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Romania[playerid][1], -53405953);
	PlayerTextDrawTextSize(								playerid, flag_Romania[playerid][1], 33.0, 15.0);

	flag_Romania[playerid][2] = CreatePlayerTextDraw(	playerid, X + 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Romania[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Romania[playerid][2], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_Romania[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Romania[playerid][2], -837736705);
	PlayerTextDrawTextSize(								playerid, flag_Romania[playerid][2], 33.0, 15.0);
	
	FLAG_ROMANIA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_ROMANIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_ROMANIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_ROMANIA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_ROMANIA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_ROMANIA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_ROMANIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ROMANIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Romania[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Romania[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Romania[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ROMANIA[playerid]);
	}
	flag_S[playerid][Romania] = 1;
	return 1;
}

stock f_showBelgium(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Belgium] == 1) return 1;
	flag_Belgium[playerid][0] = CreatePlayerTextDraw(	playerid, X - 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Belgium[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Belgium[playerid][0], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, flag_Belgium[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Belgium[playerid][0], 255);
	PlayerTextDrawTextSize(								playerid, flag_Belgium[playerid][0], 33.0, 15.0);

	flag_Belgium[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Belgium[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Belgium[playerid][1], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_Belgium[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Belgium[playerid][1], -2227969);
	PlayerTextDrawTextSize(								playerid, flag_Belgium[playerid][1], 33.0, 15.0);

	flag_Belgium[playerid][2] = CreatePlayerTextDraw(	playerid, X + 19.0, Y - 0.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Belgium[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Belgium[playerid][2], 0.500000, 3.899998);
	PlayerTextDrawUseBox(								playerid, flag_Belgium[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Belgium[playerid][2], -301989633);
	PlayerTextDrawTextSize(								playerid, flag_Belgium[playerid][2], 33.0, 15.0);
	
	FLAG_BELGIUM[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_BELGIUM[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_BELGIUM[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_BELGIUM[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_BELGIUM[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_BELGIUM[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_BELGIUM[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_BELGIUM[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Belgium[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Belgium[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Belgium[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_BELGIUM[playerid]);
	}
	flag_S[playerid][Belgium] = 1;
	return 1;
}

stock f_showSweden(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Sweden] == 1) return 1;
	flag_Sweden[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Sweden[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Sweden[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Sweden[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Sweden[playerid][0], 189827583);
	PlayerTextDrawTextSize(								playerid, flag_Sweden[playerid][0], 33.0, 54.000000);

	flag_Sweden[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Sweden[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Sweden[playerid][1], 0.500000, 0.599900);
	PlayerTextDrawUseBox(								playerid, flag_Sweden[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Sweden[playerid][1], -4128513);
	PlayerTextDrawTextSize(								playerid, flag_Sweden[playerid][1], 33.0, 54.000000);

	flag_Sweden[playerid][2] = CreatePlayerTextDraw(	playerid, X - 8.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Sweden[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Sweden[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Sweden[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Sweden[playerid][2], -4128513);
	PlayerTextDrawTextSize(								playerid, flag_Sweden[playerid][2], 33.0, 6.000000);
	
	FLAG_SWEDEN[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_SWEDEN[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_SWEDEN[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_SWEDEN[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_SWEDEN[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_SWEDEN[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_SWEDEN[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_SWEDEN[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Sweden[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Sweden[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Sweden[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_SWEDEN[playerid]);
	}
	flag_S[playerid][Sweden] = 1;
	return 1;
}

stock f_showFinland(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Finland] == 1) return 1;
	flag_Finland[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Finland[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Finland[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Finland[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Finland[playerid][0], -1);
	PlayerTextDrawTextSize(								playerid, flag_Finland[playerid][0], 33.0, 54.000000);

	flag_Finland[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Finland[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Finland[playerid][1], 0.500000, 0.599900);
	PlayerTextDrawUseBox(								playerid, flag_Finland[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Finland[playerid][1], 3506431);
	PlayerTextDrawTextSize(								playerid, flag_Finland[playerid][1], 33.0, 54.000000);

	flag_Finland[playerid][2] = CreatePlayerTextDraw(	playerid, X - 8.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Finland[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Finland[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Finland[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Finland[playerid][2], 3506431);
	PlayerTextDrawTextSize(								playerid, flag_Finland[playerid][2], 33.0, 6.000000);
	
	FLAG_FINLAND[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_FINLAND[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_FINLAND[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_FINLAND[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_FINLAND[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_FINLAND[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_FINLAND[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_FINLAND[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Finland[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Finland[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Finland[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_FINLAND[playerid]);
	}
	flag_S[playerid][Finland] = 1;
	return 1;
}

stock f_showDenmark(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Denmark] == 1) return 1;
	flag_Denmark[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Denmark[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Denmark[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Denmark[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Denmark[playerid][0], -804506625);
	PlayerTextDrawTextSize(								playerid, flag_Denmark[playerid][0], 33.0, 54.000000);

	flag_Denmark[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Denmark[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Denmark[playerid][1], 0.500000, 0.599900);
	PlayerTextDrawUseBox(								playerid, flag_Denmark[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Denmark[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Denmark[playerid][1], 33.0, 54.000000);

	flag_Denmark[playerid][2] = CreatePlayerTextDraw(	playerid, X - 8.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Denmark[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Denmark[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Denmark[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Denmark[playerid][2], -1);
	PlayerTextDrawTextSize(								playerid, flag_Denmark[playerid][2], 33.0, 6.000000);
	
	FLAG_DENMARK[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_DENMARK[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_DENMARK[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_DENMARK[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_DENMARK[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_DENMARK[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_DENMARK[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_DENMARK[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Denmark[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Denmark[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Denmark[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_DENMARK[playerid]);
	}
	flag_S[playerid][Denmark] = 1;
	return 1;
}

stock f_showNorway(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Norway] == 1) return 1;
	flag_Norway[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Norway[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Norway[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Norway[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Norway[playerid][0], -282382849);
	PlayerTextDrawTextSize(								playerid, flag_Norway[playerid][0], 33.0, 54.000000);

	flag_Norway[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Norway[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Norway[playerid][1], 0.500000, 0.599900);
	PlayerTextDrawUseBox(								playerid, flag_Norway[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Norway[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Norway[playerid][1], 33.0, 54.000000);

	flag_Norway[playerid][2] = CreatePlayerTextDraw(	playerid, X - 8.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Norway[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Norway[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Norway[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Norway[playerid][2], -1);
	PlayerTextDrawTextSize(								playerid, flag_Norway[playerid][2], 33.0, 6.000000);

	flag_Norway[playerid][3] = CreatePlayerTextDraw(	playerid, X, Y + 14.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Norway[playerid][3], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Norway[playerid][3], 0.500000, 0.199900);
	PlayerTextDrawUseBox(								playerid, flag_Norway[playerid][3], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Norway[playerid][3], 2648319);
	PlayerTextDrawTextSize(								playerid, flag_Norway[playerid][3], 33.0, 54.000000);

	flag_Norway[playerid][4] = CreatePlayerTextDraw(	playerid, X - 8.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Norway[playerid][4], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Norway[playerid][4], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Norway[playerid][4], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Norway[playerid][4], 2648319);
	PlayerTextDrawTextSize(								playerid, flag_Norway[playerid][4], 33.0, 4.000000);

	flag_Norway[playerid][5] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Norway[playerid][5], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Norway[playerid][5], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Norway[playerid][5], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Norway[playerid][5], 0);
	PlayerTextDrawTextSize(								playerid, flag_Norway[playerid][5], 33.0, 54.000000);
	
	FLAG_NORWAY[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_NORWAY[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_NORWAY[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_NORWAY[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_NORWAY[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_NORWAY[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_NORWAY[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_NORWAY[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Norway[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Norway[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Norway[playerid][2]);
	PlayerTextDrawShow(playerid, flag_Norway[playerid][3]);
	PlayerTextDrawShow(playerid, flag_Norway[playerid][4]);
	PlayerTextDrawShow(playerid, flag_Norway[playerid][5]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_NORWAY[playerid]);
	}
	flag_S[playerid][Norway] = 1;
	return 1;
}

stock f_showIceland(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Iceland] == 1) return 1;
	flag_Iceland[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Iceland[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Iceland[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Iceland[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Iceland[playerid][0], 3708927);
	PlayerTextDrawTextSize(								playerid, flag_Iceland[playerid][0], 33.0, 54.000000);

	flag_Iceland[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Iceland[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Iceland[playerid][1], 0.500000, 0.599900);
	PlayerTextDrawUseBox(								playerid, flag_Iceland[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Iceland[playerid][1], -1);
	PlayerTextDrawTextSize(								playerid, flag_Iceland[playerid][1], 33.0, 54.000000);

	flag_Iceland[playerid][2] = CreatePlayerTextDraw(	playerid, X - 8.0, Y,  "_");
	PlayerTextDrawAlignment(							playerid, flag_Iceland[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Iceland[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Iceland[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Iceland[playerid][2], -1);
	PlayerTextDrawTextSize(								playerid, flag_Iceland[playerid][2], 33.0, 6.000000);

	flag_Iceland[playerid][3] = CreatePlayerTextDraw(	playerid, X, Y + 14.5, "_");
	PlayerTextDrawAlignment(							playerid, flag_Iceland[playerid][3], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Iceland[playerid][3], 0.500000, 0.199900);
	PlayerTextDrawUseBox(								playerid, flag_Iceland[playerid][3], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Iceland[playerid][3], -685233921);
	PlayerTextDrawTextSize(								playerid, flag_Iceland[playerid][3], 33.0, 54.000000);

	flag_Iceland[playerid][4] = CreatePlayerTextDraw(	playerid, X - 8.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Iceland[playerid][4], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Iceland[playerid][4], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Iceland[playerid][4], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Iceland[playerid][4], -685233921);
	PlayerTextDrawTextSize(								playerid, flag_Iceland[playerid][4], 33.0, 4.000000);

	flag_Iceland[playerid][5] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Iceland[playerid][5], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Iceland[playerid][5], 0.500000, 3.899899);
	PlayerTextDrawBoxColor(								playerid, flag_Iceland[playerid][5], 0);
	PlayerTextDrawTextSize(								playerid, flag_Iceland[playerid][5], 33.0, 54.000000);
	
	FLAG_ICELAND[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_ICELAND[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_ICELAND[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_ICELAND[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_ICELAND[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_ICELAND[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_ICELAND[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ICELAND[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Iceland[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Iceland[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Iceland[playerid][2]);
	PlayerTextDrawShow(playerid, flag_Iceland[playerid][3]);
	PlayerTextDrawShow(playerid, flag_Iceland[playerid][4]);
	PlayerTextDrawShow(playerid, flag_Iceland[playerid][5]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ICELAND[playerid]);
	}
	flag_S[playerid][Iceland] = 1;
	return 1;
}

stock f_showSpain(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Spain] == 1) return 1;
	flag_Spain[playerid][0] = CreatePlayerTextDraw(		playerid, X, Y - 1.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Spain[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Spain[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Spain[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Spain[playerid][0], -3931905);
	PlayerTextDrawTextSize(								playerid, flag_Spain[playerid][0], 33.0, 54.000000);

	flag_Spain[playerid][1] = CreatePlayerTextDraw(		playerid, X, Y - 1.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Spain[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Spain[playerid][1], 0.500000, 0.799900);
	PlayerTextDrawUseBox(								playerid, flag_Spain[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Spain[playerid][1], -972349697);
	PlayerTextDrawTextSize(								playerid, flag_Spain[playerid][1], 33.0, 54.000000);

	flag_Spain[playerid][2] = CreatePlayerTextDraw(		playerid, X, Y + 27.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Spain[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Spain[playerid][2], 0.500000, 0.799900);
	PlayerTextDrawUseBox(								playerid, flag_Spain[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Spain[playerid][2], -972349697);
	PlayerTextDrawTextSize(								playerid, flag_Spain[playerid][2], 33.0, 54.000000);
	
	FLAG_SPAIN[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_SPAIN[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_SPAIN[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_SPAIN[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_SPAIN[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_SPAIN[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_SPAIN[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_SPAIN[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Spain[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Spain[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Spain[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_SPAIN[playerid]);
	}
	flag_S[playerid][Spain] = 1;
	return 1;
}

stock f_showUSA(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][USA] == 1) return 1;
	flag_USA[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][0], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][0], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][0], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][0], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][0], -1306381057);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][0], 33.0, 54.000000);

	flag_USA[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y + 3.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][1], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][1], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][1], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][1], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][1], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][1], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][1], 33.0, 54.000000);

	flag_USA[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 9.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][2], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][2], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][2], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][2], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][2], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][2], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][2], 33.0, 54.000000);

	flag_USA[playerid][3] = CreatePlayerTextDraw(	playerid, X, Y + 15.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][3], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][3], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][3], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][3], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][3], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][3], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][3], 33.0, 54.000000);

	flag_USA[playerid][4] = CreatePlayerTextDraw(	playerid, X, Y + 21.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][4], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][4], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][4], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][4], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][4], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][4], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][4], 33.0, 54.000000);

	flag_USA[playerid][5] = CreatePlayerTextDraw(	playerid, X, Y + 27.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][5], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][5], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][5], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][5], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][5], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][5], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][5], 33.0, 54.000000);

	flag_USA[playerid][6] = CreatePlayerTextDraw(	playerid, X, Y + 33.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][6], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][6], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][6], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][6], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][6], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][6], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][6], 33.0, 54.000000);

	flag_USA[playerid][7] = CreatePlayerTextDraw(	playerid, X - 16.0, Y, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][7], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][7], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][7], 0.500000, 1.799898);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][7], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][7], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][7], 5416447);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][7], 33.0, 22.000000);

	flag_USA[playerid][8] = CreatePlayerTextDraw(	playerid, X - 16.0, Y - 2.0, "]]]]]]~n~]]]]]~n~]]]]]]~n~]]]]]~n~]]]]]]~n~]]]]]~n~]]]]]]~n~]]]]]~n~]]]]]]");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][8], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][8], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][8], 0);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][8], 0.129998, 0.250000);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][8], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][8], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][8], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][8], 0);
	
	FLAG_USA[playerid] = CreatePlayerTextDraw(		playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_USA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_USA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_USA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_USA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_USA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_USA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_USA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_USA[playerid][0]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][1]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][2]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][3]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][4]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][5]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][6]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][7]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][8]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_USA[playerid]);
	}
	flag_S[playerid][USA] = 1;
	return 1;
}

stock f_showSwitzerland(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Switzerland] == 1) return 1;
	flag_Switzerland[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_Switzerland[playerid][0], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Switzerland[playerid][0], 255);
	PlayerTextDrawFont(										playerid, flag_Switzerland[playerid][0], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Switzerland[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(									playerid, flag_Switzerland[playerid][0], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Switzerland[playerid][0], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Switzerland[playerid][0], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Switzerland[playerid][0], 1);
	PlayerTextDrawUseBox(									playerid, flag_Switzerland[playerid][0], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Switzerland[playerid][0], -718594305);
	PlayerTextDrawTextSize(									playerid, flag_Switzerland[playerid][0], 33.0, 54.000000);

	flag_Switzerland[playerid][1] = CreatePlayerTextDraw(	playerid, X - 3.0, Y - 5.0, "+");
	PlayerTextDrawAlignment(								playerid, flag_Switzerland[playerid][1], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Switzerland[playerid][1], -1);
	PlayerTextDrawFont(										playerid, flag_Switzerland[playerid][1], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Switzerland[playerid][1], 1.179999, 4.899899);
	PlayerTextDrawColor(									playerid, flag_Switzerland[playerid][1], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Switzerland[playerid][1], 1);
	PlayerTextDrawSetProportional(							playerid, flag_Switzerland[playerid][1], 1);
	
	FLAG_SWITZERLAND[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_SWITZERLAND[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_SWITZERLAND[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_SWITZERLAND[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_SWITZERLAND[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_SWITZERLAND[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_SWITZERLAND[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_SWITZERLAND[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Switzerland[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Switzerland[playerid][1]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_SWITZERLAND[playerid]);
	}
	flag_S[playerid][Switzerland] = 1;
	return 1;
}

stock f_showEngland(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][England] == 1) return 1;
	flag_England[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_England[playerid][0], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_England[playerid][0], 255);
	PlayerTextDrawFont(									playerid, flag_England[playerid][0], 1);
	PlayerTextDrawLetterSize(							playerid, flag_England[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_England[playerid][0], -1);
	PlayerTextDrawSetOutline(							playerid, flag_England[playerid][0], 0);
	PlayerTextDrawSetProportional(						playerid, flag_England[playerid][0], 1);
	PlayerTextDrawSetShadow(							playerid, flag_England[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_England[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_England[playerid][0], -1);
	PlayerTextDrawTextSize(								playerid, flag_England[playerid][0], 33.0, 54.000000);

	flag_England[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_England[playerid][1], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_England[playerid][1], 255);
	PlayerTextDrawFont(									playerid, flag_England[playerid][1], 1);
	PlayerTextDrawLetterSize(							playerid, flag_England[playerid][1], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_England[playerid][1], -1);
	PlayerTextDrawSetOutline(							playerid, flag_England[playerid][1], 0);
	PlayerTextDrawSetProportional(						playerid, flag_England[playerid][1], 1);
	PlayerTextDrawSetShadow(							playerid, flag_England[playerid][1], 1);
	PlayerTextDrawUseBox(								playerid, flag_England[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_England[playerid][1], -837737217);
	PlayerTextDrawTextSize(								playerid, flag_England[playerid][1], 33.0, 10.000000);

	flag_England[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 13.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_England[playerid][2], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_England[playerid][2], 255);
	PlayerTextDrawFont(									playerid, flag_England[playerid][2], 1);
	PlayerTextDrawLetterSize(							playerid, flag_England[playerid][2], 0.500000, 0.999899);
	PlayerTextDrawColor(								playerid, flag_England[playerid][2], -1);
	PlayerTextDrawSetOutline(							playerid, flag_England[playerid][2], 0);
	PlayerTextDrawSetProportional(						playerid, flag_England[playerid][2], 1);
	PlayerTextDrawSetShadow(							playerid, flag_England[playerid][2], 1);
	PlayerTextDrawUseBox(								playerid, flag_England[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_England[playerid][2], -837737217);
	PlayerTextDrawTextSize(								playerid, flag_England[playerid][2], 33.0, 54.000000);
	
	FLAG_ENGLAND[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_ENGLAND[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_ENGLAND[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_ENGLAND[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_ENGLAND[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_ENGLAND[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_ENGLAND[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ENGLAND[playerid], 1);
	PlayerTextDrawShow(playerid, flag_England[playerid][0]);
	PlayerTextDrawShow(playerid, flag_England[playerid][1]);
	PlayerTextDrawShow(playerid, flag_England[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ENGLAND[playerid]);
	}
	flag_S[playerid][England] = 1;
	return 1;
}

stock f_showCanada(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Canada] == 1) return 1;
	flag_Canada[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][0], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][0], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][0], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][0], -1);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][0], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][0], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][0], -1);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][0], 33.0, 54.000000);

	flag_Canada[playerid][1] = CreatePlayerTextDraw(	playerid, X - 21.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][1], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][1], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][1], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][1], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][1], -1);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][1], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][1], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][1], 1);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][1], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][1], 33.0, 13.000000);

	flag_Canada[playerid][2] = CreatePlayerTextDraw(	playerid, X + 21.0, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][2], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][2], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][2], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][2], -1);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][2], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][2], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][2], 1);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][2], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][2], 33.0, 13.000000);

	flag_Canada[playerid][3] = CreatePlayerTextDraw(	playerid, X, Y + 17.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][3], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][3], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][3], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][3], 0.500000, 0.799899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][3], -16776961);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][3], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][3], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][3], 0);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][3], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][3], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][3], 8.000000, -2.000000);

	flag_Canada[playerid][4] = CreatePlayerTextDraw(	playerid, X, Y + 17.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][4], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][4], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][4], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][4], 0.500000, 0.099899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][4], -16776961);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][4], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][4], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][4], 0);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][4], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][4], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][4], 8.000000, 5.000000);

	flag_Canada[playerid][5] = CreatePlayerTextDraw(	playerid, X - 0.1,Y + 9.0, "ld_beat:upr");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][5], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][5], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][5], 4);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][5], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][5], -16776961);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][5], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][5], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][5], 1);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][5], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][5], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][5], 8.000000, 12.000000);

	flag_Canada[playerid][6] = CreatePlayerTextDraw(	playerid, X - 7.0, Y + 9.0, "ld_beat:upl");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][6], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][6], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][6], 4);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][6], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][6], -16776961);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][6], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][6], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][6], 1);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][6], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][6], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][6], 8.000000, 12.000000);

	flag_Canada[playerid][7] = CreatePlayerTextDraw(	playerid, X - 4.0, Y + 7.0, "ld_beat:up");
	PlayerTextDrawAlignment(							playerid, flag_Canada[playerid][7], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Canada[playerid][7], 255);
	PlayerTextDrawFont(									playerid, flag_Canada[playerid][7], 4);
	PlayerTextDrawLetterSize(							playerid, flag_Canada[playerid][7], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Canada[playerid][7], -16776961);
	PlayerTextDrawSetOutline(							playerid, flag_Canada[playerid][7], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Canada[playerid][7], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Canada[playerid][7], 1);
	PlayerTextDrawUseBox(								playerid, flag_Canada[playerid][7], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Canada[playerid][7], -16776961);
	PlayerTextDrawTextSize(								playerid, flag_Canada[playerid][7], 8.000000, 12.000000);
	
	FLAG_CANADA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_CANADA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_CANADA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_CANADA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_CANADA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_CANADA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_CANADA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_CANADA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][2]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][3]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][4]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][5]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][6]);
	PlayerTextDrawShow(playerid, flag_Canada[playerid][7]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_CANADA[playerid]);
	}
	flag_S[playerid][Canada] = 1;
	return 1;
}

stock f_showBrazil(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Brazil] == 1) return 1;
	flag_Brazil[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Brazil[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Brazil[playerid][0], 10173183);
	PlayerTextDrawTextSize(								playerid, flag_Brazil[playerid][0], 33.0, 54.000000);

	flag_Brazil[playerid][1] = CreatePlayerTextDraw(	playerid, X - 10.0, Y - 8.0, "<");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][1], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][1], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][1], 0.970000, 5.199897);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][1], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][1], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][1], 0);

	flag_Brazil[playerid][2] = CreatePlayerTextDraw(	playerid, X + 7.0, Y - 8.0, ">");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][2], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][2], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][2], 0.970000, 5.199897);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][2], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][2], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][2], 0);

	flag_Brazil[playerid][3] = CreatePlayerTextDraw(	playerid, X - 10.0, Y - 8.0, "<");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][3], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][3], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][3], 0.970000, 5.199897);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][3], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][3], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][3], 0);

	flag_Brazil[playerid][4] = CreatePlayerTextDraw(	playerid, X + 7.0, Y - 8.0, ">");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][4], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][4], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][4], 0.970000, 5.199897);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][4], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][4], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][4], 0);

	flag_Brazil[playerid][5] = CreatePlayerTextDraw(	playerid, X - 8.0, Y - 3.0, "<");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][5], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][5], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][5], 0.620000, 4.199898);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][5], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][5], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][5], 0);

	flag_Brazil[playerid][6] = CreatePlayerTextDraw(	playerid, X - 8.0, Y - 3.0, "<");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][6], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][6], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][6], 0.620000, 4.199898);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][6], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][6], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][6], 0);

	flag_Brazil[playerid][7] = CreatePlayerTextDraw(	playerid, X + 6.0, Y - 3.0, ">");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][7], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][7], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][7], 0.620000, 4.199898);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][7], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][7], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][7], 0);

	flag_Brazil[playerid][8] = CreatePlayerTextDraw(	playerid, X + 6.0, Y - 3.0, ">");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][8], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][8], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][8], 0.620000, 4.199898);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][8], -18939649);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][8], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][8], 0);

	flag_Brazil[playerid][9] = CreatePlayerTextDraw(	playerid, X - 2.0, Y + 12.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][9], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][9], 0.620000, 1.099898);
	PlayerTextDrawUseBox(								playerid, flag_Brazil[playerid][9], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Brazil[playerid][9], -18939649);
	PlayerTextDrawTextSize(								playerid, flag_Brazil[playerid][9], 33.0, 12.000000);

	flag_Brazil[playerid][10] = CreatePlayerTextDraw(	playerid, X - 2.0, Y + 4.0, "O");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][10], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][10], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][10], 0.719999, 2.699898);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][10], 2586367);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][10], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][10], 0);

	flag_Brazil[playerid][11] = CreatePlayerTextDraw(	playerid, X - 2.0, Y + 4.0, "O");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][11], 2);
	PlayerTextDrawFont(									playerid, flag_Brazil[playerid][11], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][11], 0.719999, 2.699898);
	PlayerTextDrawColor(								playerid, flag_Brazil[playerid][11], 2586367);
	PlayerTextDrawSetOutline(							playerid, flag_Brazil[playerid][11], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Brazil[playerid][11], 0);

	flag_Brazil[playerid][12] = CreatePlayerTextDraw(	playerid, X - 2.0, Y + 14.0, "_");
	PlayerTextDrawAlignment(							playerid, flag_Brazil[playerid][12], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Brazil[playerid][12], 0.719999, 0.799898);
	PlayerTextDrawUseBox(								playerid, flag_Brazil[playerid][12], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Brazil[playerid][12], 2586367);
	PlayerTextDrawTextSize(								playerid, flag_Brazil[playerid][12], 33.0, 8.000000);
	
	FLAG_BRAZIL[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_BRAZIL[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_BRAZIL[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_BRAZIL[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_BRAZIL[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_BRAZIL[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_BRAZIL[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_BRAZIL[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][2]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][3]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][4]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][5]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][6]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][7]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][8]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][9]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][10]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][11]);
	PlayerTextDrawShow(playerid, flag_Brazil[playerid][12]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_BRAZIL[playerid]);
	}
	flag_S[playerid][Brazil] = 1;
	return 1;
}

stock f_showTurkey(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Turkey] == 1) return 1;
	flag_Turkey[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Turkey[playerid][0], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Turkey[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawUseBox(								playerid, flag_Turkey[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Turkey[playerid][0], -485877761);
	PlayerTextDrawTextSize(								playerid, flag_Turkey[playerid][0], 33.0, 54.000000);

	flag_Turkey[playerid][1] = CreatePlayerTextDraw(	playerid, X - 9.0, Y - 1.0, "C");
	PlayerTextDrawAlignment(							playerid, flag_Turkey[playerid][1], 2);
	PlayerTextDrawFont(									playerid, flag_Turkey[playerid][1], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Turkey[playerid][1], 0.899999, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Turkey[playerid][1], -1);
	PlayerTextDrawSetOutline(							playerid, flag_Turkey[playerid][1], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Turkey[playerid][1], 0);

	flag_Turkey[playerid][2] = CreatePlayerTextDraw(	playerid, X + 8.0, Y + 10.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_Turkey[playerid][2], 2);
	PlayerTextDrawFont(									playerid, flag_Turkey[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_Turkey[playerid][2], 0.480000, 1.899899);
	PlayerTextDrawColor(								playerid, flag_Turkey[playerid][2], -1);
	PlayerTextDrawSetOutline(							playerid, flag_Turkey[playerid][2], 0);
	PlayerTextDrawSetShadow(							playerid, flag_Turkey[playerid][2], 0);
	
	FLAG_TURKEY[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_TURKEY[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_TURKEY[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_TURKEY[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_TURKEY[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_TURKEY[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_TURKEY[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_TURKEY[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Turkey[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Turkey[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Turkey[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_TURKEY[playerid]);
	}
	flag_S[playerid][Turkey] = 1;
	return 1;
}

stock f_showJapan(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Japan] == 1) return 1;
	flag_Japan[playerid][0] = CreatePlayerTextDraw(		playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_Japan[playerid][0], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Japan[playerid][0], 255);
	PlayerTextDrawFont(									playerid, flag_Japan[playerid][0], 1);
	PlayerTextDrawLetterSize(							playerid, flag_Japan[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Japan[playerid][0], -1);
	PlayerTextDrawSetOutline(							playerid, flag_Japan[playerid][0], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Japan[playerid][0], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Japan[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_Japan[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Japan[playerid][0], -1);
	PlayerTextDrawTextSize(								playerid, flag_Japan[playerid][0], 33.0, 54.000000);

	flag_Japan[playerid][1] = CreatePlayerTextDraw(		playerid, X - 10.0, Y + 8.0, "ld_dual:light");
	PlayerTextDrawAlignment(							playerid, flag_Japan[playerid][1], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_Japan[playerid][1], 255);
	PlayerTextDrawFont(									playerid, flag_Japan[playerid][1], 4);
	PlayerTextDrawLetterSize(							playerid, flag_Japan[playerid][1], 0.899999, 3.899899);
	PlayerTextDrawColor(								playerid, flag_Japan[playerid][1], -1140838913);
	PlayerTextDrawSetOutline(							playerid, flag_Japan[playerid][1], 0);
	PlayerTextDrawSetProportional(						playerid, flag_Japan[playerid][1], 1);
	PlayerTextDrawSetShadow(							playerid, flag_Japan[playerid][1], 0);
	PlayerTextDrawUseBox(								playerid, flag_Japan[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Japan[playerid][1], 10173183);
	PlayerTextDrawTextSize(								playerid, flag_Japan[playerid][1], 20.000000, 20.000000);
	
	FLAG_JAPAN[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_JAPAN[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_JAPAN[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_JAPAN[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_JAPAN[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_JAPAN[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_JAPAN[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_JAPAN[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Japan[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Japan[playerid][1]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_JAPAN[playerid]);
	}
	flag_S[playerid][Japan] = 1;
	return 1;
}

stock f_showChina(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][China] == 1) return 1;
	flag_China[playerid][0] = CreatePlayerTextDraw(		playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][0], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][0], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][0], 1);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][0], -1);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][0], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][0], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_China[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_China[playerid][0], -567734017);
	PlayerTextDrawTextSize(								playerid, flag_China[playerid][0], 33.0, 54.000000);

	flag_China[playerid][1] = CreatePlayerTextDraw(		playerid, X - 19.0, Y - 2.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][1], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][1], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][1], 0.549999, 2.399899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][1], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][1], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][1], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][1], 0);

	flag_China[playerid][2] = CreatePlayerTextDraw(		playerid, X - 7.0, Y - 1.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][2], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][2], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][2], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][2], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][2], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][2], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][2], 0);

	flag_China[playerid][3] = CreatePlayerTextDraw(		playerid, X - 7.0, Y + 14.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][3], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][3], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][3], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][3], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][3], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][3], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][3], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][3], 0);

	flag_China[playerid][4] = CreatePlayerTextDraw(		playerid, X - 4.0, Y + 4.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][4], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][4], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][4], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][4], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][4], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][4], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][4], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][4], 0);

	flag_China[playerid][5] = CreatePlayerTextDraw(		playerid, X - 4.0, Y + 9.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][5], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][5], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][5], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][5], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][5], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][5], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][5], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][5], 0);
	
	FLAG_CHINA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_CHINA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_CHINA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_CHINA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_CHINA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_CHINA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_CHINA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_CHINA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_China[playerid][0]);
	PlayerTextDrawShow(playerid, flag_China[playerid][1]);
	PlayerTextDrawShow(playerid, flag_China[playerid][2]);
	PlayerTextDrawShow(playerid, flag_China[playerid][3]);
	PlayerTextDrawShow(playerid, flag_China[playerid][4]);
	PlayerTextDrawShow(playerid, flag_China[playerid][5]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_CHINA[playerid]);
	}
	flag_S[playerid][China] = 1;
	return 1;
}

stock f_showArgentinia(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Argentinia] == 1) return 1;
	flag_Argentinia[playerid][0] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_Argentinia[playerid][0], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Argentinia[playerid][0], 255);
	PlayerTextDrawFont(										playerid, flag_Argentinia[playerid][0], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Argentinia[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(									playerid, flag_Argentinia[playerid][0], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Argentinia[playerid][0], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Argentinia[playerid][0], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Argentinia[playerid][0], 1);
	PlayerTextDrawUseBox(									playerid, flag_Argentinia[playerid][0], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Argentinia[playerid][0], -1);
	PlayerTextDrawTextSize(									playerid, flag_Argentinia[playerid][0], 33.0, 54.000000);

	flag_Argentinia[playerid][1] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_Argentinia[playerid][1], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Argentinia[playerid][1], 255);
	PlayerTextDrawFont(										playerid, flag_Argentinia[playerid][1], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Argentinia[playerid][1], 0.500000, 0.899899);
	PlayerTextDrawColor(									playerid, flag_Argentinia[playerid][1], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Argentinia[playerid][1], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Argentinia[playerid][1], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Argentinia[playerid][1], 1);
	PlayerTextDrawUseBox(									playerid, flag_Argentinia[playerid][1], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Argentinia[playerid][1], 1974263807);
	PlayerTextDrawTextSize(									playerid, flag_Argentinia[playerid][1], 33.0, 54.000000);

	flag_Argentinia[playerid][2] = CreatePlayerTextDraw(	playerid, X, Y + 27.0, "_");
	PlayerTextDrawAlignment(								playerid, flag_Argentinia[playerid][2], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Argentinia[playerid][2], 255);
	PlayerTextDrawFont(										playerid, flag_Argentinia[playerid][2], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Argentinia[playerid][2], 0.500000, 0.899899);
	PlayerTextDrawColor(									playerid, flag_Argentinia[playerid][2], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Argentinia[playerid][2], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Argentinia[playerid][2], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Argentinia[playerid][2], 1);
	PlayerTextDrawUseBox(									playerid, flag_Argentinia[playerid][2], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Argentinia[playerid][2], 1974263807);
	PlayerTextDrawTextSize(									playerid, flag_Argentinia[playerid][2], 33.0, 54.000000);
	
	FLAG_ARGENTINIA[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, FLAG_ARGENTINIA[playerid], 2);
	PlayerTextDrawLetterSize(								playerid, FLAG_ARGENTINIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(									playerid, FLAG_ARGENTINIA[playerid], 1);
	PlayerTextDrawAlignment(								playerid, FLAG_ARGENTINIA[playerid], 2);
	PlayerTextDrawBoxColor(									playerid, FLAG_ARGENTINIA[playerid], 0);
	PlayerTextDrawTextSize(									playerid, FLAG_ARGENTINIA[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_ARGENTINIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Argentinia[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Argentinia[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Argentinia[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_ARGENTINIA[playerid]);
	}
	flag_S[playerid][Argentinia] = 1;
	return 1;
}

stock f_showPortugal(playerid, Float:X, Float:Y, clickable)
{
	if(flag_S[playerid][Portugal] == 1) return 1;
	flag_Portugal[playerid][0] = CreatePlayerTextDraw(		playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_Portugal[playerid][0], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Portugal[playerid][0], 255);
	PlayerTextDrawFont(										playerid, flag_Portugal[playerid][0], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Portugal[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(									playerid, flag_Portugal[playerid][0], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Portugal[playerid][0], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Portugal[playerid][0], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Portugal[playerid][0], 1);
	PlayerTextDrawUseBox(									playerid, flag_Portugal[playerid][0], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Portugal[playerid][0], -16776961);
	PlayerTextDrawTextSize(									playerid, flag_Portugal[playerid][0], 33.0, 54.000000);

	flag_Portugal[playerid][1] = CreatePlayerTextDraw(		playerid, X - 18.0, Y, "_");
	PlayerTextDrawAlignment(								playerid, flag_Portugal[playerid][1], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Portugal[playerid][1], 255);
	PlayerTextDrawFont(										playerid, flag_Portugal[playerid][1], 1);
	PlayerTextDrawLetterSize(								playerid, flag_Portugal[playerid][1], 0.500000, 3.899899);
	PlayerTextDrawColor(									playerid, flag_Portugal[playerid][1], -1);
	PlayerTextDrawSetOutline(								playerid, flag_Portugal[playerid][1], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Portugal[playerid][1], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Portugal[playerid][1], 1);
	PlayerTextDrawUseBox(									playerid, flag_Portugal[playerid][1], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Portugal[playerid][1], 6684927);
	PlayerTextDrawTextSize(									playerid, flag_Portugal[playerid][1], 33.0, 18.000000);

	flag_Portugal[playerid][2] = CreatePlayerTextDraw(		playerid, X - 16.0, Y + 8.0, "ld_dual:light");
	PlayerTextDrawAlignment(								playerid, flag_Portugal[playerid][2], 2);
	PlayerTextDrawBackgroundColor(							playerid, flag_Portugal[playerid][2], 255);
	PlayerTextDrawFont(										playerid, flag_Portugal[playerid][2], 4);
	PlayerTextDrawLetterSize(								playerid, flag_Portugal[playerid][2], 0.500000, 3.899899);
	PlayerTextDrawColor(									playerid, flag_Portugal[playerid][2], -65281);
	PlayerTextDrawSetOutline(								playerid, flag_Portugal[playerid][2], 0);
	PlayerTextDrawSetProportional(							playerid, flag_Portugal[playerid][2], 1);
	PlayerTextDrawSetShadow(								playerid, flag_Portugal[playerid][2], 1);
	PlayerTextDrawUseBox(									playerid, flag_Portugal[playerid][2], 1);
	PlayerTextDrawBoxColor(									playerid, flag_Portugal[playerid][2], -65281);
	PlayerTextDrawTextSize(									playerid, flag_Portugal[playerid][2], 18.000000, 18.000000);
	
	FLAG_PORTUGAL[playerid] = CreatePlayerTextDraw(	playerid, X, Y, "_");
	PlayerTextDrawAlignment(								playerid, FLAG_PORTUGAL[playerid], 2);
	PlayerTextDrawLetterSize(								playerid, FLAG_PORTUGAL[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(									playerid, FLAG_PORTUGAL[playerid], 1);
	PlayerTextDrawAlignment(								playerid, FLAG_PORTUGAL[playerid], 2);
	PlayerTextDrawBoxColor(									playerid, FLAG_PORTUGAL[playerid], 0);
	PlayerTextDrawTextSize(									playerid, FLAG_PORTUGAL[playerid], 33.0, 54.5);
	
	PlayerTextDrawSetSelectable(playerid, FLAG_PORTUGAL[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Portugal[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Portugal[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Portugal[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_PORTUGAL[playerid]);
	}
	flag_S[playerid][Portugal] = 1;
	return 1;
}


//=========================================================================

stock f_hideGermany(playerid)
{	
	PlayerTextDrawDestroy(playerid, flag_Germany[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Germany[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Germany[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_GERMANY[playerid]);
	flag_S[playerid][Germany] = 0;
	return 1;
}

stock f_hideNetherlands(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Netherlands[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Netherlands[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Netherlands[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_NETHERLANDS[playerid]);
	flag_S[playerid][Netherlands] = 0;
	return 1;
}

stock f_hideRussia(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Russia[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Russia[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Russia[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_RUSSIA[playerid]);
	flag_S[playerid][Russia] = 0;
	return 1;
}

stock f_hideAustria(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Austria[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Austria[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Austria[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_AUSTRIA[playerid]);
	flag_S[playerid][Austria] = 0;
	return 1;
}

stock f_hideBulgaria(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Bulgaria[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Bulgaria[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Bulgaria[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_BULGARIA[playerid]);
	flag_S[playerid][Bulgaria] = 0;
	return 1;
}

stock f_hideLithuania(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Lithuania[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Lithuania[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Lithuania[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_LITHUANIA[playerid]);
	flag_S[playerid][Lithuania] = 0;
	return 1;
}

stock f_hideEstonia(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Estonia[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Estonia[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Estonia[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_ESTONIA[playerid]);
	flag_S[playerid][Estonia] = 0;
	return 1;
}

stock f_hideLuxembourg(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Luxembourg[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Luxembourg[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Luxembourg[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_LUXEMBOURG[playerid]);
	flag_S[playerid][Luxembourg] = 0;
	return 1;
}

stock f_hideHungary(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Hungary[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Hungary[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Hungary[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_HUNGARY[playerid]);
	flag_S[playerid][Hungary] = 0;
	return 1;
}

stock f_hideArmenia(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Armenia[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Armenia[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Armenia[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_ARMENIA[playerid]);
	flag_S[playerid][Armenia] = 0;
	return 1;
}

stock f_hidePoland(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Poland[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Poland[playerid][1]);
	PlayerTextDrawDestroy(playerid, FLAG_POLAND[playerid]);
	flag_S[playerid][Poland] = 0;
	return 1;
}

stock f_hideCzechRepublic(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][5]);
	PlayerTextDrawDestroy(playerid, flag_CzechRepublic[playerid][6]);
	PlayerTextDrawDestroy(playerid, FLAG_CZECH_REPUBLIC[playerid]);
	flag_S[playerid][CzechRepublic] = 0;
	return 1;
}

stock f_hideUkraine(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Ukraine[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Ukraine[playerid][1]);
	PlayerTextDrawDestroy(playerid, FLAG_UKRAINE[playerid]);
	flag_S[playerid][Ukraine] = 0;
	return 1;
}

stock f_hideItaly(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Italy[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Italy[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Italy[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_ITALY[playerid]);
	flag_S[playerid][Italy] = 0;
	return 1;
}

stock f_hideFrance(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_France[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_France[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_France[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_FRANCE[playerid]);
	flag_S[playerid][France] = 0;
	return 1;
}

stock f_hideIreland(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Ireland[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Ireland[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Ireland[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_IRELAND[playerid]);
	flag_S[playerid][Ireland] = 0;
	return 1;
}

stock f_hideRomania(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Romania[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Romania[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Romania[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_ROMANIA[playerid]);
	flag_S[playerid][Romania] = 0;
	return 1;
}

stock f_hideBelgium(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Belgium[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Belgium[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Belgium[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_BELGIUM[playerid]);
	flag_S[playerid][Belgium] = 0;
	return 1;
}

stock f_hideSweden(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Sweden[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Sweden[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Sweden[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_SWEDEN[playerid]);
	flag_S[playerid][Sweden] = 0;
	return 1;
}

stock f_hideFinland(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Finland[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Finland[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Finland[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_FINLAND[playerid]);
	flag_S[playerid][Finland] = 0;
	return 1;
}

stock f_hideDenmark(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Denmark[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Denmark[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Denmark[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_DENMARK[playerid]);
	flag_S[playerid][Denmark] = 0;
	return 1;
}

stock f_hideNorway(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Norway[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Norway[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Norway[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_Norway[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_Norway[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_Norway[playerid][5]);
	PlayerTextDrawDestroy(playerid, FLAG_NORWAY[playerid]);
	flag_S[playerid][Norway] = 0;
	return 1;
}

stock f_hideIceland(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Iceland[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Iceland[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Iceland[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_Iceland[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_Iceland[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_Iceland[playerid][5]);
	PlayerTextDrawDestroy(playerid, FLAG_ICELAND[playerid]);
	flag_S[playerid][Iceland] = 0;
	return 1;
}

stock f_hideSpain(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Spain[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Spain[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Spain[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_SPAIN[playerid]);
	flag_S[playerid][Spain] = 0;
	return 1;
}

stock f_hideUSA(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][5]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][6]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][7]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][8]);
	PlayerTextDrawDestroy(playerid, FLAG_USA[playerid]);
	flag_S[playerid][USA] = 0;
	return 1;
}

stock f_hideSwitzerland(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Switzerland[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Switzerland[playerid][1]);
	PlayerTextDrawDestroy(playerid, FLAG_SWITZERLAND[playerid]);
	flag_S[playerid][Switzerland] = 0;
	return 1;
}

stock f_hideEngland(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_England[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_England[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_England[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_ENGLAND[playerid]);
	flag_S[playerid][England] = 0;
	return 1;
}

stock f_hideCanada(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][5]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][6]);
	PlayerTextDrawDestroy(playerid, flag_Canada[playerid][7]);
	PlayerTextDrawDestroy(playerid, FLAG_CANADA[playerid]);
	flag_S[playerid][Canada] = 0;
	return 1;
}

stock f_hideBrazil(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][5]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][6]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][7]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][8]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][9]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][10]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][11]);
	PlayerTextDrawDestroy(playerid, flag_Brazil[playerid][12]);
	PlayerTextDrawDestroy(playerid, FLAG_BRAZIL[playerid]);
	flag_S[playerid][Brazil] = 0;
	return 1;
}

stock f_hideTurkey(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Turkey[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Turkey[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Turkey[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_TURKEY[playerid]);
	flag_S[playerid][Turkey] = 0;
	return 1;
}

stock f_hideJapan(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Japan[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Japan[playerid][1]);
	PlayerTextDrawDestroy(playerid, FLAG_JAPAN[playerid]);
	flag_S[playerid][Japan] = 0;
	return 1;
}

stock f_hideChina(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_China[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][5]);
	PlayerTextDrawDestroy(playerid, FLAG_CHINA[playerid]);
	flag_S[playerid][China] = 0;
	return 1;
}

stock f_hideArgentinia(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Argentinia[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Argentinia[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Argentinia[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_ARGENTINIA[playerid]);
	flag_S[playerid][Argentinia] = 0;
	return 1;
}

stock f_hidePortugal(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Portugal[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Portugal[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Portugal[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_PORTUGAL[playerid]);
	flag_S[playerid][Portugal] = 0;
	return 1;
}