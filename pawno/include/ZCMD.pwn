CMD:convidar(playerid, params[])
{
	new tmp[128], idx;
	tmp = strtok(params, idx);
	if(!strlen(tmp))return SendClientMessage(playerid, BRANCO, "USO: /convidar [NomePlayer/ID]");
	new playa;
	playa = ReturnUser(tmp);
	/*if(PlayerInfo[playa][pMembro] > 0)return SendClientMessage(playa,BRANCO,"Este player j� possui uma Organiza��o.");*/
	if(playa == INVALID_PLAYER_ID) return SendClientMessage(playerid, BRANCO, "Jogador n�o existe.");
	GetPlayerName(playa, giveplayer, sizeof(giveplayer));
	GetPlayerName(playerid, name, sizeof(name));
	new ftext[30];
	if(PlayerInfo[playerid][pLider] == 1) ftext = "LSPD";
	format(string, sizeof(string), "[ATEN��O %s]:%s lhe mandou um convite para entrar para a Organiza��o: [%s].",giveplayer,name,ftext);
	SendClientMessage(playa,VERMELHO,string);
	SendClientMessage(playa,VERMELHO,"Voc� aceita este convite?");
	ShowPlayerDialog(playa, 28, DIALOG_STYLE_LIST, "Convite", "Aceito.\nN�o Aceito.", "Confirmar","Cancelar"); //mostrar� o dialog
	InviteJob[playa] = PlayerInfo[playerid][pLider]; InviteOffer[playa] = playerid;//Detalhe - ir� setar a variavel o ID da org/qm mandou convite
	SendClientMessage(playerid, BRANCO, "Voc� enviou o convite.");
	return 1;
}