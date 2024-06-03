#include <a_samp>
#include <core>
#include <float>
#include <voipnp>
#include <strlib>
#include  <      a_http        >
#include <Joel>
#pragma tabsize 0
//
new SV_LPSTREAM:Radio[100];
new Freq;
new stringradio[248];
//
main() {}
//
new SV_RADIO:radio[MAX_PLAYERS] = { SV_NULL, ... }; //
//
new SV_GSTREAM:gstream;
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

public SV_VOID:OnPlayerActivationKeyPress(
	SV_UINT:playerid,
	SV_UINT:keyid
) {
	if (keyid == 0x5A && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
	if (keyid == 0x42 && gstream) SvAttachSpeakerToStream(gstream, playerid);
	//
	if (keyid == 0x5A && radio[playerid]){
	 SvAttachSpeakerToStream(radio[playerid], playerid); ApplyAnimation(playerid,"PED","phone_talk",4.1,0,1,1,1,1);
	 SetPlayerAttachedObject(playerid, 0, 19942, 6, 0.067999, 0.041999, 0.032000, 3.799999, 1.099997, -162.100051, 1.000000, 1.000000, 1.000000);
	 }
}

public SV_VOID:OnPlayerActivationKeyRelease(
	SV_UINT:playerid,
	SV_UINT:keyid
) {
	if (keyid == 0x5A && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
	if (keyid == 0x42 && gstream) SvDetachSpeakerFromStream(gstream, playerid);
	//
	if (keyid == 0x5A && radio[playerid]) {
	SvDetachSpeakerFromStream(radio[playerid], playerid); ApplyAnimation(playerid,"PED","SHOT_partial_B",4.1,0,1,1,1,1);
	RemovePlayerAttachedObject(playerid, 0);
	}
	//
	}

public OnPlayerConnect(playerid) {

	if (!SvGetVersion(playerid))
	{
		SendClientMessage(playerid, -1, "VOIP OF.");
	}
	if (SvGetVersion(playerid))
	{
		SvAddKey(playerid, 0x5A);
		lstream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid, 0xff0000ff, "L"); // Stream em Text3d em r:20.0, modelo red no canto esquerdo.
		SendClientMessage(playerid, -1, "VOIP ON.");
	}
	Module_Joel2(playerid);
	return 1;

}
public OnPlayerDisconnect(playerid, reason) {

	if (lstream[playerid]) {
		SvDeleteStream(lstream[playerid]);
		lstream[playerid] = SV_NULL;
	}
//    SvDetachListenerFromStream(radio, playerid);
	return 1;

}

public OnPlayerSpawn(playerid) {

	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);

	return 1;

}

public OnPlayerDeath(playerid, killerid, reason) {

   	return 1;

}

SetupPlayerForClassSelection(playerid) {
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid) {
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit() {

	gstream = SvCreateGStream(0xffff0000, "G"); // blue color

	CreateVehicle(400, 1945.0226, 1321.6926, 9.1094, 180.2150, -1, -1, -1);
	Create3DTextLabel("TextLabel", 0x008080FF, 1945.0226, 1321.6926, 9.1094, 40.0, 0, 0);
	// Rádio
	Module_Joel();
	Freq = CreateObject(3763, -350.255523, -188.005630, 90.192871, 0.000000, 0.000000, -8.000008);
	Radio[0] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1900kHz");
	Radio[1] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1901kHz");
	Radio[2] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1902kHz");
	Radio[3] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1903kHz");
	Radio[4] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1904kHz");
	Radio[5] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1905kHz");
	Radio[6] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1906kHz");
	Radio[7] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1907kHz");
	Radio[8] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1908kHz");
	Radio[9] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1909kHz");
	Radio[10] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1910kHz");
	Radio[11] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1911kHz");
	Radio[12] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1912kHz");
	Radio[13] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1913kHz");
	Radio[14] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1914kHz");
	Radio[15] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1915kHz");
	Radio[16] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1916kHz");
	Radio[17] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1917kHz");
	Radio[18] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1918kHz");
	Radio[19] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1919kHz");
	Radio[20] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1920kHz");
	Radio[21] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1921kHz");
	Radio[22] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1922kHz");
	Radio[23] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1923kHz");
	Radio[24] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1924kHz");
	Radio[25] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1925kHz");
	Radio[26] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1926kHz");
	Radio[27] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1927kHz");
	Radio[28] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1928kHz");
	Radio[29] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1929kHz");
	Radio[30] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1930kHz");
	Radio[31] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1931kHz");
	Radio[32] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1932kHz");
	Radio[33] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1933kHz");
	Radio[34] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1934kHz");
	Radio[35] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1935kHz");
	Radio[36] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1936kHz");
	Radio[37] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1937kHz");
	Radio[38] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1938kHz");
	Radio[39] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1939kHz");
	Radio[40] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1940kHz");
	Radio[41] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1941kHz");
	Radio[42] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1942kHz");
	Radio[43] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1943kHz");
	Radio[44] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1944kHz");
	Radio[45] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1945kHz");
	Radio[46] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1946kHz");
	Radio[47] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1947kHz");
	Radio[48] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1948kHz");
	Radio[49] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1949kHz");
	Radio[50] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1950kHz");
	Radio[51] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1951kHz");
	Radio[52] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1952kHz");
	Radio[53] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1953kHz");
	Radio[54] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1954kHz");
	Radio[55] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1955kHz");
	Radio[56] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1956kHz");
	Radio[57] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1957kHz");
	Radio[58] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1958kHz");
	Radio[59] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1959kHz");
	Radio[60] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1960kHz");
	Radio[61] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1961kHz");
	Radio[62] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1962kHz");
	Radio[63] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1963kHz");
	Radio[64] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1964kHz");
	Radio[65] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1965kHz");
	Radio[66] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1966kHz");
	Radio[67] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1967kHz");
	Radio[68] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1968kHz");
	Radio[69] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1969kHz");
	Radio[70] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1970kHz");
	Radio[71] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1971kHz");
	Radio[72] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1972kHz");
	Radio[73] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1973kHz");
	Radio[74] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1974kHz");
	Radio[75] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1975kHz");
	Radio[76] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1976kHz");
	Radio[77] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1977kHz");
	Radio[78] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1978kHz");
	Radio[79] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1979kHz");
	Radio[80] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1980kHz");
	Radio[81] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1981kHz");
	Radio[82] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1982kHz");
	Radio[83] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1983kHz");
	Radio[84] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1984kHz");
	Radio[85] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1985kHz");
	Radio[86] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1986kHz");
	Radio[87] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1987kHz");
	Radio[88] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1988kHz");
	Radio[89] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1989kHz");
	Radio[90] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1990kHz");
	Radio[91] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1991kHz");
	Radio[92] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1992kHz");
	Radio[93] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1993kHz");
	Radio[94] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1994kHz");
	Radio[95] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1995kHz");
	Radio[96] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1996kHz");
	Radio[97] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1997kHz");
	Radio[98] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1998kHz");
	Radio[99] = SvCreateSLStreamAtObject(6000.0, Freq, 0x1E90FFAA, "FREQUENCY 1999kHz");
	//
	return 1;

}
public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];
	new tmp[150];

	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/yadayada", true) == 0) {
    	return 1;
	}
	if(strcmp(cmd, "/calm", true) == 0)
	{
 		tmp = strtok(cmdtext, idx);
 		new call;
 		call = strval(tmp);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, -1, "Use: /calm [frequenc 1900 a 1999.]");
			return 1;
		}
  		if(call > 2000 && call < 1899)
  		{
		  SendClientMessage(playerid, -1, "Frequências de 1900 a 1999.");
		  return 1;
  		}
		format(stringradio, sizeof(stringradio), "Você entrou na frequência: %d",call);
		call -= 1900;

		radio[playerid] = SV_NULL;
		SvDetachSpeakerFromStream(Radio[call], playerid);
		SvDetachListenerFromStream(Radio[call], playerid);
		//
  		radio[playerid] = Radio[call];
  		SvAttachListenerToStream(Radio[call], playerid);
		SendClientMessage(playerid, -1, stringradio);
		return 1;
	}
	if(strcmp(cmd, "/ecalm", true) == 0)
	{
 		tmp = strtok(cmdtext, idx);
 		new call;
 		call = strval(tmp);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, -1, "Use: /ecalm [frequenc 1900 - 1999]");
			return 1;
		}
  		if(call > 2000 && call < 1899)
  		{
		  SendClientMessage(playerid, -1, "Frequências de 1900 a 1999.");
		  return 1;
  		}
		call -= 1900;
		radio[playerid] = SV_NULL;
		SvDetachSpeakerFromStream(Radio[call], playerid);
		SvDetachListenerFromStream(Radio[call], playerid);
		format(stringradio, sizeof(stringradio), "Você saiu da frequência: %d",call);
		SendClientMessage(playerid, -1, stringradio);
		return 1;
	}
	if(strcmp(cmd, "/Radinho", true) == 0) {
		TextDrawShowForPlayer(playerid, Radinho);
		for(new B; B <2; B++)
		{
			PlayerTextDrawShow(playerid, ButtonRad[playerid][B]);
			SelectTextDraw(playerid, 0x00FFFFFF);
		}
    	return 1;
	}
	if(strcmp(cmd, "/fRadinho", true) == 0) {
		TextDrawHideForPlayer(playerid, Radinho);
		for(new B; B <2; B++)
		{
			PlayerTextDrawHide(playerid, ButtonRad[playerid][B]);
			CancelSelectTextDraw(playerid);
		}
    	return 1;
	}
	return 0;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	if(playertextid == ButtonRad[playerid][0]){ // Buton 1
		SelectTextDraw(playerid, 0xCD0400FF);
		GameTextForPlayer(playerid,"Button 1",5000,5);
		return 1;
	}
	if(playertextid == ButtonRad[playerid][1]){ // Buton 2
		SelectTextDraw(playerid, 0xCD0400FF);
		GameTextForPlayer(playerid,"Button 2",5000,5);
		return 1;
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

