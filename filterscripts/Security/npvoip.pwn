/*
					� VOICE CHAT (VOIP) �

Development: Joel Walker (Joel Wictor), Tezx_Atenue (Gio Tezo).

Nota: Proibimos a c�pia e uso do c�digo abaixo, para qualquer pessoa
ou qualquer outro servidor de SAN ANDREAS MULTIPLAYER (GTA:SA), em termos
de pl�gio para usos profissionais, apenas podendo utilizar no �mbito de aprimoramento,
a equipe de scripta��o do servidor de SAMP NACIONAL PLAYER cujo Presidente Lohan_Medina,
e a equipe de scripta��o do servidor de SAMP ATENUE ROLEPLAY GEORGIA cujo Presidente Gio_Tezo(Tezx_Atenue).

Nota esclarecida de acordo com a
Lei 9610/98 | Lei n� 9.610, de 19 de fevereiro de 1998 sobre Direitos Autorais.


										  Nacional Player 2020,
										 Copyright , All rights reserved. 	�
*/
#include <a_samp>
#include <core>
#include <float>
#include <sampvoice>

#pragma tabsize 0

main() {}

new SV_GSTREAM:gstream;
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

public SV_VOID:OnPlayerActivationKeyPress( // Reconhecendo parti do momento que o Z � pressionado.
	SV_UINT:playerid,
	SV_UINT:keyid
) {
	if (keyid == 0x5A && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
	if (keyid == 0x42 && gstream) SvAttachSpeakerToStream(gstream, playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease( // Reconhecendo quando o Z � solto.
	SV_UINT:playerid,
	SV_UINT:keyid
) {
	if (keyid == 0x5A && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
	if (keyid == 0x42 && gstream) SvDetachSpeakerFromStream(gstream, playerid);
}

public OnPlayerConnect(playerid) {

	if (!SvGetVersion(playerid)) SendClientMessage(playerid, -1, "{FF0000}[NP VOIP] {FFFFFF}N�o foi encontrado um voip na raiz de seu GTA, contate um Assistente Voip.");
	else if (!SvHasMicro(playerid)) SendClientMessage(playerid, -1, "{32CD32}[NP VOIP] {FFFFFF}N�o conseguimos localizar um microfone conectado.");
	else if (lstream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid, 0xff0000ff, "L")) { // (ATEN��O) Warning nessa linha de "=" para "==" corrigi, POR�M n�o mecha.
		SendClientMessage(playerid, -1, "{32CD32}[NP VOIP] {FFFFFF}O Voip foi carregado, pressione a tecla [Z] para dialogar & [F11] para configurar.");
//		if (gstream) SvAttachListenerToStream(gstream, playerid); Desconectado uma stream global com a tecla B.
		SvAddKey(playerid, 0x5A);
		SvAddKey(playerid, 0x5A);
	}

	return 1;

}

public OnPlayerDisconnect(playerid, reason) {

	if (lstream[playerid]) { // Deletando a mixagem de stream para n�o permacer um vacuo de som.
		SvDeleteStream(lstream[playerid]);
		lstream[playerid] = SV_NULL;
	}

	return 1;

}

public OnPlayerSpawn(playerid) {

	TogglePlayerClock(playerid,0); // Linha apenas para complementar o Spawn.

	return 1;

}

public OnPlayerDeath(playerid, killerid, reason) {

   	return 1;

}

public OnFilterScriptInit() {

	gstream = SvCreateGStream(0xffff0000, "G"); // Azul

	return 1;

}





