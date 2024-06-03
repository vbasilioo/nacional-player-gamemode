#include <a_samp>
#include <core>
#include <float>
#include <sampvoice>

#pragma tabsize 0

main() {}

new SV_GSTREAM:gstream;
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

public SV_VOID:OnPlayerActivationKeyPress(
	SV_UINT:playerid,
	SV_UINT:keyid
) {
	if (keyid == 0x5A && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
	if (keyid == 0x42 && gstream) SvAttachSpeakerToStream(gstream, playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease(
	SV_UINT:playerid,
	SV_UINT:keyid
) {
	if (keyid == 0x5A && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
	if (keyid == 0x42 && gstream) SvDetachSpeakerFromStream(gstream, playerid);
}

public OnPlayerConnect(playerid) {

	if (!SvGetVersion(playerid)) SendClientMessage(playerid, -1, "{FF0000}[NP VOIP] {FFFFFF}Voip n�o foi carregado.");
	else if (!SvHasMicro(playerid)) SendClientMessage(playerid, -1, "{32CD32}[NP VOIP] {FFFFFF}Microfone n�o foi reconhecido.");
	else if (lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "L")) { // red color
		SendClientMessage(playerid, -1, "{32CD32}[NP VOIP] {FFFFFF}Voip carregado com sucesso.");
//		if (gstream) SvAttachListenerToStream(gstream, playerid); 
		SvAddKey(playerid, 0x5A);
		SvAddKey(playerid, 0x5A);
	}

	return 1;

}

public OnPlayerDisconnect(playerid, reason) {

	if (lstream[playerid]) {
		SvDeleteStream(lstream[playerid]);
		lstream[playerid] = SV_NULL;
	}

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

public OnFilterScriptInit() {

	gstream = SvCreateGStream(0xffff0000, "G"); // blue color

	CreateVehicle(400, 1945.0226, 1321.6926, 9.1094, 180.2150, -1, -1, -1);
	Create3DTextLabel("TextLabel", 0x008080FF, 1945.0226, 1321.6926, 9.1094, 40.0, 0, 0);

	return 1;

}



