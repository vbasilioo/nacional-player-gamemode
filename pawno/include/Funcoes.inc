forward fcreate(filename[]);
public fcreate(filename[])
{
    if (fexist(filename)){return false;}
    new File:fhandle = fopen(filename,io_write);
    fclose(fhandle);
    return true;
}
stock SetarSkin(p, s){

	PI[ p ][ pSkin ] = s;
	SetPlayerSkin(p, PI[ p ][ pSkin ]);
    TextDrawSetPreviewModel(TStatus[ 0 ][ p ], PI[ p ][ pSkin ]);
	TextDrawHideForPlayer(p, TStatus[ 0 ][ p ]);
	TextDrawShowForPlayer(p, TStatus[ 0 ][ p ]);
}
stock TrocouCasa( _i ){
	new str[ 400 ];
	DestroyPickup( PCasa[ _i ] );
	Delete3DTextLabel( TCasa[ _i ] );
	if(CI[_i][C_comprada] == false){
		format(str,sizeof str,"{FF0000}<!> {32CD32}Casa a venda:\n\n{32CD32}Casa Nº {E0FFFF}%d\n{32CD32}Valor: {006400}$ {E0FFFF}%d\n{32CD32}Level: {E0FFFF}%d\n{32CD32}Descrição: {E0FFFF}%s\n\n{E0FFFF}Para compra-la use: {32CD32}/comprarcasa",_i,CI[_i][C_valor],CI[_i][C_level],CI[_i][C_descricao]);
		TCasa[_i] = Create3DTextLabel(str,-1,CI[_i][C_entradax],CI[_i][C_entraday],CI[_i][C_entradaz]+0.5,35,0,1);
		PCasa[_i] = CreatePickup(1273,1,CI[_i][C_entradax],CI[_i][C_entraday],CI[_i][C_entradaz],0);
	}
	else{
		format(str,sizeof str,"{4169E1}Casa Nº {E0FFFF}%d\n{4169E1}Proprietário: {E0FFFF}%s\n{4169E1}Level: {E0FFFF}%d\n{4169E1}Descrição: {E0FFFF}%s\n{4169E1}Aluguel: {006400}$ {E0FFFF}%d\n\n{E0FFFF}Para entrar use: {4169E1}/entrar {E0FFFF}ou aperte {4169E1}'ENTER' ",_i,CI[_i][C_dono],CI[_i][C_level],CI[_i][C_descricao],CI[_i][C_aluguel]);
		TCasa[_i] = Create3DTextLabel(str,-1,CI[_i][C_entradax],CI[_i][C_entraday],CI[_i][C_entradaz]+0.5,35,0,1);
		PCasa[_i] = CreatePickup(1239,1,CI[_i][C_entradax],CI[_i][C_entraday],CI[_i][C_entradaz],0);
	}
}
stock cargoAdmin(playerid)
{
	new cargo[24];
	if(PI[playerid][pAdmin] == 1) cargo = "Moderador";
	else if(PI[playerid][pAdmin] == 2) cargo = "Administrador";
	else if(PI[playerid][pAdmin] == 3) cargo = "Administrador Master";
	else if(PI[playerid][pAdmin] == 4) cargo = "Dono";
	else cargo = "Desconhecido";
	return cargo;
}
stock VerificarVeiculo(idd)
{
    for(new i = 0; i < Players; i++)
    {
        if(IsPlayerInVehicle(i,idd))
        {
            return 0;
        }
    }
    SetVehicleToRespawn(idd);
    return 1;
}
stock chatAdmin(playerid,t[]){
	new str[129];
	format(str,sizeof(str),"{FF8C00}[%s %s]: {FFFFFF}%s{FF8C00}.",cargoAdmin(playerid),Nome(playerid),t);
	for(new i=0;i<Players; i++)
	{
	    if(PI[i][pAdmin] > 0) SendClientMessage(i,-1,str);
	}
}
stock Nome(p){
	new n[26];
	GetPlayerName(p,n,sizeof n);
	return n;
}
stock Conta(p){
	new string[50];
	format(string,sizeof string,"Contas/%s.ini",Nome(p));
	return string;
}
stock SalvarConta(p){
	if(Logou[p] == true){
	    printf("%s",Logou[p]);
		DOF2_SetInt(Conta(p),"Level",PI[p][pLevel]);//isso
		DOF2_SetInt(Conta(p),"Dolar",PI[p][pDolar]);
		DOF2_SetInt(Conta(p),"Avisos",PI[p][pAvisos]);
		DOF2_SetInt(Conta(p),"Admin",PI[p][pAdmin]);
		DOF2_SetInt(Conta(p),"Fome",PI[p][pFome]);
		DOF2_SetInt(Conta(p),"Energia",PI[p][pEnergia]);
		DOF2_SetInt(Conta(p),"Vicio",PI[p][pVicio]);
		DOF2_SetInt(Conta(p),"SkillVicio",SkillInfo[p][sVicio]);
		DOF2_SetInt(Conta(p),"SkillEnergia",SkillInfo[p][sEnergia]);
		DOF2_SetInt(Conta(p),"SkillFome",SkillInfo[p][sFome]);
		DOF2_SetInt(Conta(p),"Viciado",PI[p][pViciado]);
		DOF2_SetBool(Conta(p),"Dormiu",PI[p][pDormiu]);
		DOF2_SetInt(Conta(p),"Skin",PI[p][pSkin]);
		DOF2_SetInt(Conta(p),"Respeito",PI[p][pXp]);
		DOF2_SetInt(Conta(p),"HoraConectado",PI[p][pHConectado]);
		DOF2_SetInt(Conta(p),"Contando",PI[p][pCLevel]);
		DOF2_SetInt(Conta(p),"Upgrade",PI[p][pUpgrade]);
		DOF2_SetInt(Conta(p),"GamePoint",PI[p][pGp]);
		DOF2_SetInt(Conta(p),"Organizacao",PI[p][pOrg]);
		new carro[16];
		for(new _i = 0; _i < 5;_i ++){
		    format(carro,sizeof carro,"ChaveCarro%d",_i);
		    DOF2_SetInt(Conta(p),carro,PI[p][pChaveCarro][_i]);
		}
		new Data[12],Hora[16];
		new dia,mes,ano;
		getdate(ano,mes,dia);
		new s,m,h;
		gettime(h,m,s);
		format(Data,sizeof Data,"%02d/%02d/%04d",dia,mes,ano);
		DOF2_SetString(Conta(p),"UltimoLoginD",Data);
		format(Hora,sizeof Hora,"%02d:%02d:%02d",h,m,s);
		DOF2_SetString(Conta(p),"UltimoLoginH",Hora);
		DOF2_SaveFile();
	}
	return 1;
}
stock DarDolar(p,v){
    PI[p][pDolar] += v;
	SetPlayerMoney(p,PI[p][pDolar]);
	new str[16];
	if(v > 0){
		format(str,sizeof str,"~g~$%d",v);
	}
	else{
	    format(str,sizeof str,"~r~$%d",v);
	}
	TextDrawSetString(TGrana[ p ], str);
	TextDrawShowForPlayer(p, TGrana[ p ]);
	SetTimerEx("ApagarTxt",5000,false,"d",p);
	return 1;
}
forward ApagarTxt( p );
public ApagarTxt( p ){

	TextDrawHideForPlayer(p ,TGrana[ p ]);

}
stock SetarDolar(p){
	SetPlayerMoney(p,PI[p][pDolar]);
	return 1;
}
stock DarGp( p, valor ){
	PI[ p ][ pGp ] += valor;
}
stock ResetarVeiculo(v){

	VI[v][vdono] = 0;
	VI[v][vmodelo] = 0;
	VI[v][vvalor] = 0;
	VI[v][vx] = 0;
	VI[v][vy] = 0;
	VI[v][vz] = 0;
	VI[v][va] = 0;
	VI[v][vcor] = 0;
	VI[v][vcor2] = 0;
 	DestroyVehicle(VeiculoConc[v]);


}
forward Atualizar(p);
public Atualizar(p){
	if(Logou[p] == true){
	
        new zone[28], string[30];
		GetPlayer2DZone(p, zone, 28);
		format(string,sizeof(string),"%s", zone);
		TextDrawSetString(Textodraw[ p ], string);
		TextDrawShowForPlayer(p, Textodraw[ p ]);
		
	    Fome[p] = 17+(SkillInfo[p][sFome]*10);
	    Stamina[p] = 35+(SkillInfo[p][sEnergia]*10);
	    Vicio[p] = 20+((SkillInfo[p][sVicio]*10)/(PI[p][pViciado]+1));
		for(new i_ = 0;i_< 3;i_++){
		    Contador[i_][p]++;
		}
	    if(PI[p][pFome] < 1){
	        TaComFome(p);
	    }
	    else{
	        if(Contador[0][p] >= Fome[p]){
				PI[p][pFome] --;
				AtualizarBarra(p);
		    	Contador[0][p] = 0;
			}
	    }
	    if(PI[p][pDormiu] == false){
		    if(PI[p][pEnergia] < 1){
		        TaComSono(p);
		    }
		    else{
		        if(Contador[1][p] >= Stamina[p]){
			        PI[p][pEnergia] --;
					AtualizarBarra(p);
			    	Contador[1][p] = 0;
			    }
		    }
		}
	    if(PI[p][pViciado] > 0){
        	if(PI[p][pVicio] < 1){
		        TaNaBrisa(p);
		    }
		    else{
				if(Contador[2][p] >= Vicio[p]){
			        PI[p][pVicio] --;
					AtualizarBarra(p);
			    	Contador[2][p] = 0;
			    }
		    }
	    }
	    SistemaLevel( p );
	}
}
stock SistemaLevel( p ){

	PI[ p ][ pCLevel ] ++;
	if( PI[ p ][ pCLevel ] >= 3600){
	
		DarXp(p , 1000);
		PI[ p ][ pCLevel ] = 0;
		PI[ p ][ pHConectado ] ++;
		
	}
	if( PI[ p ][ pXp ] >= Respeito[ p ]){
	
        PI[ p ][ pXp ] = PI[ p ][ pXp ] - Respeito[ p ];

		DarLevel(p , 1);

	}
}
stock DarXp(p ,v){
	new str[128];
	format(str, sizeof str,"~n~~n~~n~~y~~h~Parabens %s~n~~w~Voce recebeu~r~~h~~h~ %d xp",Nome( p ), v);
	GameTextForPlayer(p , str, 5000, 3);
    PI[ p ][ pXp ] += v;
	format(str,sizeof str,"Level %d~n~xp %d / %d~n~upgrade %d",PI[ p ][ pLevel ],PI[ p ][ pXp ], Respeito[ p ],PI[ p ][ pUpgrade ]);
	TextDrawSetString(TStatus[ 1 ][ p ],str);
}
stock DarLevel(p ,v){
	new str[128];
	format(str, sizeof str,"~n~~n~~n~~g~~h~~h~Parabens %s~n~~w~Level ~b~~h~~h~UP +%d",Nome( p ), v);
	GameTextForPlayer(p , str, 5000, 3);
    PI[ p ][ pLevel ] += v;
    SetPlayerScore( p, PI[ p ][ pLevel ]);
 	//new str[40];
	SistemaRespeito( p );
	SistemaUpgrade( p );
	format(str,sizeof str,"Level %d~n~xp %d / %d~n~upgrade %d",PI[ p ][ pLevel ],PI[ p ][ pXp ], Respeito[ p ],PI[ p ][ pUpgrade ]);
	TextDrawSetString(TStatus[ 1 ][ p ],str);
}
stock SistemaRespeito( p ){

	if( PI[ p ][ pLevel ] > 0 && PI[ p ][ pLevel ] < 6 ){

	    Respeito[ p ] = PI[ p ][ pLevel ] * 2000;

	}
	else if( PI[ p ][ pLevel ] > 5 && PI[ p ][ pLevel ] < 16){

	    Respeito[ p ] = PI[ p ][ pLevel ] * 3000;

	}
	else if( PI[ p ][ pLevel ] > 15 && PI[ p ][ pLevel ] < 25){

		Respeito[ p ] = PI[ p ][ pLevel ] * 3500;

	}
	else{

        Respeito[ p ] = PI[ p ][ pLevel ] * 4000;

	}


}
stock SistemaUpgrade( p ){

	if( PI[ p ][ pLevel ] > 0 && PI[ p ][ pLevel ] < 6 ){

	    PI[ p ][ pUpgrade ] += 2;
	    SendClientMessage(p, -1, "{FFD700}[ Upgrade ] {FFFFFF}Você ganhou {FFD700}2 pontos {FFFFFF}para upar sua habilidade {FFD700}[ /upgrade ]. Você também pode vende-los.");

	}
	else if( PI[ p ][ pLevel ] > 5 && PI[ p ][ pLevel ] < 16){

	    PI[ p ][ pUpgrade ] += 4;
	    SendClientMessage(p, -1, "{FFD700}[ Upgrade ] {FFFFFF}Você ganhou {FFD700}4 pontos {FFFFFF}para upar sua habilidade {FFD700}[ /upgrade ]. Você também pode vende-los.");

	}
	else if( PI[ p ][ pLevel ] > 15 && PI[ p ][ pLevel ] < 25){

		PI[ p ][ pUpgrade ] += 6;
		SendClientMessage(p, -1, "{FFD700}[ Upgrade ] {FFFFFF}Você ganhou {FFD700}6 pontos {FFFFFF}para upar sua habilidade {FFD700}[ /upgrade ]. Você também pode vende-los.");

	}
	else{

        PI[ p ][ pUpgrade ] += 10+PI[ p ][ pLevel ];
        new str[ 200 ];
        format(str,sizeof str, "{FFD700}[ Upgrade ] {FFFFFF}Você ganhou {FFD700}%d pontos {FFFFFF}para upar sua habilidade {FFD700}[ /upgrade ]{FFFFFF}. Você também pode vende-los.",10+PI[ p ][ pLevel ]);
		SendClientMessage(p,-1,str);
	}


}
stock TaNaBrisa(p){
	new Float:h;
	GetPlayerHealth(p,h);
	SetPlayerHealth(p,h-1.0);
	return GameTextForPlayer(p,"~b~~n~~n~~n~~n~Vicio",999,3);
}
stock TaComSono(p){
	if(GetPlayerDrunkLevel(p) < 1500){
	    SetPlayerDrunkLevel(p,2000);
	}
	else if(GetPlayerDrunkLevel(p) > 4999)
	{
	    if(!IsPlayerInAnyVehicle(p))
		{
		    ClearAnimations(p);
			ApplyAnimation(p, "CRACK", "Crckidle2",4.1,1,0,0,0,0);
		}
		PI[p][pDormiu] = true;
		TogglePlayerControllable(p,0);
		ContadorSono[p] = SetTimerEx("Dormindo",1000,true,"d",p);
	}
	else
	{
	    new b;
	    b = GetPlayerDrunkLevel(p)+100;
	    SetPlayerDrunkLevel(p,b);
	}
	return GameTextForPlayer(p,"~y~~n~~n~~n~~n~Cansado",999,3);
}
forward Dormindo(p);
public Dormindo(p){
	if(PI[p][pDormiu] == true){
		if(PI[p][pEnergia] < 100){
		    if(SkillInfo[p][sEnergia] == 1) PI[p][pEnergia] += (14/10);
		    else if(SkillInfo[p][sEnergia] == 2) PI[p][pEnergia] += (16/10);
		    else if(SkillInfo[p][sEnergia] == 3) PI[p][pEnergia] += 2;
		    else if(SkillInfo[p][sEnergia] == 4) PI[p][pEnergia] += (25/10);
		    else if(SkillInfo[p][sEnergia] == 5) PI[p][pEnergia] += (33/10);
			GameTextForPlayer(p,"~r~Dormiu~n~~n~aguarde um tempo enquanto recarrega sua energia!",1000,3);
		    AtualizarBarra(p);
		}
		else Acordou(p);
	}
	else KillTimer(ContadorSono[p]);
}
stock Acordou(p){
	PI[p][pDormiu] = false;
	ClearAnimations(p);
	SetPlayerDrunkLevel(p,0);
	TogglePlayerControllable(p,1);
}
stock TaComFome(p){
	new Float:h;
	GetPlayerHealth(p,h);
	SetPlayerHealth(p,h-0.5);
	return GameTextForPlayer(p,"~r~~n~~n~~n~~n~Fome",999,3);
}
stock AtualizarBarra(p){
   	SetProgressBarValue(BFome[p], PI[p][pFome]);
    UpdateProgressBar(BFome[p], p);

 	SetProgressBarValue(BEnergia[p], PI[p][pEnergia]);
    UpdateProgressBar(BEnergia[p], p);

/*	SetProgressBarValue(BVicio[p], PI[p][pVicio]);
    UpdateProgressBar(BVicio[p], p);*/
	return 1;
}
stock EditarCoresPlayer( p ){

	if( PI[ p ][ pOrg ] == DESEMPREGADO ) SetPlayerColor( p, 0xFFFFFF00 );

}
stock Logar(p){

	
	Logou[p] = true;
	PI[p][pLevel] = DOF2_GetInt(Conta(p),"Level");//isso
	PI[p][pDolar] = DOF2_GetInt(Conta(p),"Dolar");
	PI[p][pAdmin] = DOF2_GetInt(Conta(p),"Admin");
	PI[p][pAvisos] = DOF2_GetInt(Conta(p),"Avisos");
	PI[p][pFome] = DOF2_GetInt(Conta(p),"Fome");
	PI[p][pEnergia] = DOF2_GetInt(Conta(p),"Energia");
	PI[p][pVicio] = DOF2_GetInt(Conta(p),"Vicio");
	SkillInfo[p][sVicio] = DOF2_GetInt(Conta(p),"SkillVicio");
	SkillInfo[p][sEnergia] = DOF2_GetInt(Conta(p),"SkillEnergia");
	SkillInfo[p][sFome] = DOF2_GetInt(Conta(p),"SkillFome");
	PI[p][pViciado] = DOF2_GetInt(Conta(p),"Viciado");
	PI[p][pDormiu] = DOF2_GetBool(Conta(p),"Dormiu");
	PI[p][pRegistrado] = DOF2_GetBool(Conta(p),"Registrado");
	PI[p][pSkin] = DOF2_GetInt(Conta(p),"Skin");
	PI[p][pXp] = DOF2_GetBool(Conta(p),"Respeito");
	PI[p][pHConectado] = DOF2_GetInt(Conta(p),"HoraConectado");
	PI[p][pCLevel] = DOF2_GetInt(Conta(p),"Contando");
	PI[p][pUpgrade] = DOF2_GetInt(Conta(p),"Upgrade");
	PI[p][pGp] = DOF2_GetInt(Conta(p),"GamePoint");
	PI[p][pOrg] = DOF2_GetInt(Conta(p),"Organizacao");
	
	new carro[16];
	for(new _i = 0; _i < 5;_i ++){
	    format(carro,sizeof carro,"ChaveCarro%d",_i);
	    PI[p][pChaveCarro][_i] = DOF2_GetInt(Conta(p),carro);
	}
	CarregarVip( p );
	SetarDolar(p);
	SetPlayerScore(p,PI[p][pLevel]);
	SetarSkin(p , PI[ p ][ pSkin ]);
	Log_Conexao(p,"logou","-");
	
	SistemaRespeito( p );
	EditarCoresPlayer( p );
	
	BFome[p] = CreateProgressBar(548.00, 135.00, 55.50, 3.20, 0x008B8Bff, 100.0);
	ShowProgressBarForPlayer(p,BFome[p]);
   	SetProgressBarValue(BFome[p], PI[p][pFome]);
    UpdateProgressBar(BFome[p], p);
    
	BEnergia[p] = CreateProgressBar(548.00, 150.00, 55.50, 3.20, 0x008B8BFF, 100.0);
	ShowProgressBarForPlayer(p,BEnergia[p]);
 	SetProgressBarValue(BEnergia[p], PI[p][pEnergia]);
    UpdateProgressBar(BEnergia[p], p);
    
	/*BVicio[p] = CreateProgressBar(548.00, 165.00, 55.50, 3.20, 979357183, 100.0);
	ShowProgressBarForPlayer(p,BVicio[p]);
	SetProgressBarValue(BVicio[p], PI[p][pVicio]);
    UpdateProgressBar(BVicio[p], p);*/

	TGrana[ p ] = TextDrawCreate(501.000000, 100.000000, "_");
	TextDrawBackgroundColor(TGrana[ p ], 255);
	TextDrawFont(TGrana[ p ], 3);
	TextDrawLetterSize(TGrana[ p ], 0.340000, 1.300000);
	TextDrawColor(TGrana[ p ], -1);
	TextDrawSetOutline(TGrana[ p ], 1);
	TextDrawSetProportional(TGrana[ p ], 1);
	
	TStatus[ 0 ][ p ] = TextDrawCreate(-29.000000, 325.000000, "-");
	TextDrawBackgroundColor(TStatus[ 0 ][ p ], 0);
	TextDrawFont(TStatus[ 0 ][ p ], 5);
	TextDrawLetterSize(TStatus[ 0 ][ p ], 0.500000, 1.000000);
	TextDrawColor(TStatus[ 0 ][ p ], -1);
	TextDrawSetOutline(TStatus[ 0 ][ p ], 0);
	TextDrawSetProportional(TStatus[ 0 ][ p ], 1);
	TextDrawSetShadow(TStatus[ 0 ][ p ], 1);
	TextDrawUseBox(TStatus[ 0 ][ p ], 1);
	TextDrawBoxColor(TStatus[ 0 ][ p ], 255);
	TextDrawTextSize(TStatus[ 0 ][ p ], 89.000000, 101.000000);
	TextDrawSetPreviewModel(TStatus[ 0 ][ p ], PI[ p ][ pSkin ]);
	TextDrawSetPreviewRot(TStatus[ 0 ][ p ], -16.000000, 0.000000, 0.000000, 1.000000);
	
	TStatus[ 1 ][ p ] = TextDrawCreate(6.000000, 416.000000, "_");
	TextDrawBackgroundColor(TStatus[ 1  ][ p ], 50);
	TextDrawFont(TStatus[ 1 ][ p ], 2);
	TextDrawLetterSize(TStatus[ 1 ][ p ], 0.160000, 1.100000);
	TextDrawColor(TStatus[ 1 ][ p ], -1);
	TextDrawSetOutline(TStatus[ 1 ][ p ], 1);
	TextDrawSetProportional(TStatus[ 1 ][ p ], 1);
	TextDrawSetSelectable(TStatus[ 1 ][ p ], 0);
    
	TFome[p] = TextDrawCreate(561.000000, 127.000000, "Fome");
	TextDrawBackgroundColor(TFome[p], 255);
	TextDrawFont(TFome[p], 2);
	TextDrawLetterSize(TFome[p], 0.230000, 0.699999);
	TextDrawColor(TFome[p], -1);
	TextDrawSetOutline(TFome[p], 0);
	TextDrawSetProportional(TFome[p], 1);
	TextDrawSetShadow(TFome[p], 0);

	TEnergia[p] = TextDrawCreate(557.000000, 143.000000, "Energia");
	TextDrawBackgroundColor(TEnergia[p], 255);
	TextDrawFont(TEnergia[p], 2);
	TextDrawLetterSize(TEnergia[p], 0.230000, 0.599999);
	TextDrawColor(TEnergia[p], -1);
	TextDrawSetOutline(TEnergia[p], 0);
	TextDrawSetProportional(TEnergia[p], 1);
	TextDrawSetShadow(TEnergia[p], 0);

	TVicio[p] = TextDrawCreate(562.000000, 157.000000, "Vicio");
	TextDrawBackgroundColor(TVicio[p], 255);
	TextDrawFont(TVicio[p], 2);
	TextDrawLetterSize(TVicio[p], 0.230000, 0.699999);
	TextDrawColor(TVicio[p], -1);
	TextDrawSetOutline(TVicio[p], 0);
	TextDrawSetProportional(TVicio[p], 1);
	TextDrawSetShadow(TVicio[p], 0);
	
	Textodraw[p] = TextDrawCreate(87.000000, 324.000000, "_");
	TextDrawBackgroundColor(Textodraw[p], 255);
	TextDrawFont(Textodraw[p], 1);
	TextDrawLetterSize(Textodraw[p], 0.350000, 1.100000);
	TextDrawColor(Textodraw[p], -1);
	TextDrawSetOutline(Textodraw[p], 0);
	TextDrawSetProportional(Textodraw[p], 1);
	TextDrawSetShadow(Textodraw[p], 1);
	TextDrawAlignment(Textodraw[p], 2);

	
	TextDrawShowForPlayer(p,TFome[p]);
	
	TextDrawShowForPlayer(p,TEnergia[p]);
	
	TextDrawShowForPlayer(p ,TStatus[ 1 ][ p ]);
	new str[60];
	format(str,sizeof str,"Level %d~n~xp %d / %d~n~upgrade %d",PI[ p ][ pLevel ],PI[ p ][ pXp ], Respeito[ p ],PI[ p ][ pUpgrade ]);
	TextDrawSetString(TStatus[ 1 ][ p ],str);
	TextDrawShowForPlayer(p , TStatus[ 0 ][ p ]);
	//TextDrawShowForPlayer(p,TVicio[p]);
	
	CriarTextoCarro(p);

    TAtualizar[ p ] = SetTimerEx("Atualizar",1000,true,"d",p);
    
    for(new _i = 0;_i < Player_Veiculo;_i++){
        if(PI[p][pChaveCarro][_i] > -1){
			new file[56];
			format(file,sizeof file,"Veiculos/%d.ini",PI[p][pChaveCarro][_i]);
			if(!DOF2_FileExists(file)){
			    PI[p][pChaveCarro][_i] = -1;
			    Atencao(p,"Você perdeu seu veículo.");
	        }
        }
    }
	return 1;
}
stock Registrar(p){

	DOF2_CreateFile(Conta(p));
	DOF2_SetInt(Conta(p),"Senha",PI[p][pSenha]);//isso
	DOF2_SetInt(Conta(p),"Level",1);
	DOF2_SetInt(Conta(p),"Dolar",1000);
	DOF2_SetInt(Conta(p),"Fome",100);
	DOF2_SetInt(Conta(p),"Energia",100);
	DOF2_SetInt(Conta(p),"Vicio",100);
	DOF2_SetInt(Conta(p),"SkillVicio",1);
	DOF2_SetInt(Conta(p),"SkillEnergia",1);
	DOF2_SetInt(Conta(p),"SkillFome",1);
	DOF2_SetInt(Conta(p),"Viciado",0);
	DOF2_SetBool(Conta(p),"Dormiu",false);
	DOF2_SetBool(Conta(p),"Registrado",false);
	DOF2_SetString(Conta(p),"Sexo","N/A");
	DOF2_SetString(Conta(p),"Nascimento","N/A");
	DOF2_SetInt(Conta(p),"Idade",0);
	DOF2_SetString(Conta(p),"Email","N/A");
	DOF2_SetString(Conta(p),"Origem","N/A");
	DOF2_SetInt(Conta(p),"Respeito",0);
	DOF2_SetInt(Conta(p),"HoraConectado",0);
	DOF2_SetInt(Conta(p),"Upgrade",0);
	
	new carro[16];
	for(new _i = 0; _i < 5;_i ++){
	    format(carro,sizeof carro,"ChaveCarro%d",_i);
	    DOF2_SetInt(Conta(p),carro,-1);
	}
	DOF2_SaveFile();
	new str[128];
	format(str,sizeof str,"{FF1493}Parabéns %s.\n\n\n{FFFFFF}Sua conta foi registrada com sucesso!\n\n{FFFFFF}Digite abaixo sua senha para logar.",Nome(p));
	ShowPlayerDialog(p,DLogar,Senha,"Logando",str,"Confirmar","Sair");
	return 1;
}
stock VResetando(p){
    TogglePlayerClock(p,0);
	ResetandoLinhas(p,100);//isso
	Logou[p] = false;
	SErrou[p] = 0;
	PI[p][pXp] = 0;
	PI[p][pHConectado] = 0;
	PI[p][pCLevel] = 0;
	PI[p][pUpgrade] = 0;
	PI[p][pLevel] = 0;
	PI[p][pDolar] = 0;
	PI[p][pGp] = 0;
	PI[p][pOrg] = 0;
	PI[p][pAdmin] = 0;
	PI[p][pAvisos] = 0;
	PI[p][pEnergia] = 0;
	PI[p][pFome] = 0;
	PI[p][pVicio] = 0;
	SkillInfo[p][sVicio] = 0;
	SkillInfo[p][sEnergia] = 0;
	SkillInfo[p][sFome] = 0;
	TipoCarro[p] = 0;
	PI[p][pViciado] = 0;
	PI[p][pDormiu] = false;
	PI[p][pRegistrado] = false;
	PI[p][pSkin] = 0;
	SistemaVip[ p ][ vipLevel ] = 0;
	SistemaVip[ p ][ vipTempo ] = 0;
	TextDrawHideForPlayer(p,Login[p]);
	TextDrawHideForPlayer(p,Fundo[p]);
	TextDrawHideForPlayer(p,Credito[p]);
	TextDrawHideForPlayer(p,Tutorial[p]);
	TextDrawHideForPlayer(p,Saindo[p]);
	Selecionando[p] = false;
	CP[p] = 0;
	for(new _i = 0; _i < 5;_i ++){
	    PI[p][pChaveCarro][_i] = -1;
	}
	return 1;
}
stock Atencao(p,msg[]){
	new str[128];
	format(str,sizeof str,"{EE0000}<!> {C1CDC1}%s",msg);
	SendClientMessage(p,-1,str);
	return true;
}
stock ResetandoLinhas(p,l){
	for(new i = 0;i < l;i++){
	    SendClientMessage(p,-1,"");
	}
	return 1;
}
stock Restricao(p){
	return Atencao(p,"Sem autorização para usar este comando.");
}
stock Log_Conexao(playerid,tipo[],razao[]){
    if(fexist("Logs/Players.log")){
		new data[20],hora[20],h,m,s,dia,mes,ano,ip[20],str[128];
		gettime(h,m,s);
		getdate(ano,mes,dia);
		format(data,sizeof data,"%02d/%02d/%04d",dia,mes,ano);
		format(hora,sizeof hora,"%02d:%02d:%02d",h,m,s);
		GetPlayerIp(playerid,ip,sizeof ip);
		format(str,sizeof str,"** [%s][%s] %s %s - %s[IP: %s] **\r\n",data,hora,Nome(playerid),tipo,razao,ip);
		new File:file = fopen("Logs/Players.log",io_append);
		fwrite(file, str);
		fclose(file);
    }
}
forward Contando();
public Contando(){
/*	static _C,_T;
	_C ++;
	if(_C > 59){
	    _T ++;
	    _C = 0;
	}
	else if(_T > 23){
	    _T = 0;
	}
 SetWorldTime( _T );*/
	for(new playerid = 0;playerid < Players;playerid ++){
	    if(Logou[playerid] == true){
			new h,m,s,a,mm,d;
			gettime(h,m,s);
			getdate(a,mm,d);
			new str[32];
			format(str,sizeof str,"%02d/%02d/%04d %02d:%02d:%02d",d,mm,a,h,m,s);
			TextDrawSetString(Relogio[playerid],str);
			TextDrawShowForPlayer(playerid,Relogio[playerid]);
			/*format(str,sizeof str,"%02d:%02d",_T,_C);
			TextDrawSetString(TRelogio[playerid],str);
			TextDrawShowForPlayer(playerid,TRelogio[playerid]);*/
			SetWorldTime( h );
			if((m  == 15 && s == 0) || (m == 45 && s == 0)){
				new stra[129];
				new r = random(21);
				PlayerPlaySound(playerid,1058,0,0,0);
				format(stra,sizeof stra,"{%s}[ Dica ] {FFFFFF}Para saber mais sobre as barras de necessidades. Use: {%s}/necessidade.",Cores[r],Cores[r]);
				SendClientMessage(playerid,-1,stra);
			}
		}
	}
}
stock GerarCodigo( p ){

	new
		file [ 100 ],
		str[ 400 ]
	;
	format( file, sizeof file, "Codigos/%s.ini", SistemaCodigo[ p ][ codigoVip ] );
	if( DOF2_FileExists( file ) ){
		SistemaCodigo[ p ][ codigoVip ] = 0;
		SistemaCodigo[ p ][ codigoValor ] = 0;
		SistemaCodigo[ p ][ codigoEmail ] = 0;
		SendClientMessage( p, -1, "[ ERRO ]Código já criado!");
	    return true;
	}
	else{
		DOF2_CreateFile( file );
		DOF2_SetString( file,"Email", SistemaCodigo[ p ][ codigoEmail ] );
		DOF2_SetInt( file, "Valor", SistemaCodigo[ p ][ codigoValor ] );
		DOF2_SaveFile();
		format( str, sizeof str,"Olá\n\nSegue abaixo os dados para ativar seu GamePoint:\n\nCódigo: %s\nValor de GP: %d\n\n\nPara ativar seu código use: /ativarcodigo.\n\n*Lembre-se será necessário usar este e-mail para tiver sua bonificação.\n\n\n\n\nAtenciosamente\nEquipe %s",SistemaCodigo[ p ][ codigoVip ], SistemaCodigo[ p ][ codigoValor ],NServer );
		SendMail(SistemaCodigo[ p ][ codigoEmail ], EMAIL_SERVIDOR, EMAIL_SERVIDOR, "Codigo gerado", str);
		SistemaCodigo[ p ][ codigoVip ] = 0;
		SistemaCodigo[ p ][ codigoValor ] = 0;
		SistemaCodigo[ p ][ codigoEmail ] = 0;
		SendClientMessage( p, -1, "Código criado com sucesso!");
	}
	return true;
}
stock Log_Adm(playerid,comando[],valor,outroplayer){
    if(fexist("Logs/CmdAdm.log")){
		new data[20],hora[20],h,m,s,dia,mes,ano,str[128];
		gettime(h,m,s);
		getdate(ano,mes,dia);
		format(data,sizeof data,"%02d/%02d/%04d",dia,mes,ano);
		format(hora,sizeof hora,"%02d:%02d:%02d",h,m,s);
		if(valor > 0){
			format(str,sizeof str,"** [%s][%s] Admin: %s usou o comando %s < %d > no player %s **\r\n",data,hora,Nome(playerid),comando,valor,Nome(outroplayer));
		}
		else{
			format(str,sizeof str,"** [%s][%s] Admin: %s usou o comando %s no player %s **\r\n",data,hora,Nome(playerid),comando,Nome(outroplayer));
		}
		new File:file = fopen("Logs/CmdAdm.log",io_append);
		fwrite(file, str);
		fclose(file);
		AnuncioComando(playerid,comando,valor,outroplayer);
    }
}

stock SpawnPlayerEx(playerid) {
    if(IsPlayerInAnyVehicle(playerid)) {
         RemovePlayerFromVehicle(playerid); SetPlayerPos(playerid, 10.0,10.0,10.0);
    }
    return SpawnPlayer(playerid);
}
stock Registro(p){
	CriarTextos(p);
}
stock DestruirTextos(p){
	for(new i = 0;i < 21;i++){
	    TextDrawHideForPlayer(p,TInfo[p][i]);
	}
}
stock CriarLogo( playerid ){

	TextoLogo[ 0 ][ playerid ] = TextDrawCreate(491.000000, 397.000000, "-");
	TextDrawBackgroundColor(TextoLogo[ 0 ][ playerid ], 255);
	TextDrawFont(TextoLogo[ 0 ][ playerid ], 2);
	TextDrawLetterSize(TextoLogo[ 0 ][ playerid ], 13.280014, 2.099999);
	TextDrawColor(TextoLogo[ 0 ][ playerid ], -1);
	TextDrawSetOutline(TextoLogo[ 0 ][ playerid ], 0);
	TextDrawSetProportional(TextoLogo[ 0 ][ playerid ], 1);
	TextDrawSetShadow(TextoLogo[ 0 ][ playerid ], 1);
	TextDrawSetSelectable(TextoLogo[ 0 ][ playerid ], 0);
	
	TextoLogo[ 4 ][ playerid ] = TextDrawCreate(511.000000, 388.000000, "Revolut");
	TextDrawBackgroundColor(TextoLogo[ 4 ][ playerid ], 255);
	TextDrawFont(TextoLogo[ 4 ][ playerid ], 2);
	TextDrawLetterSize(TextoLogo[ 4 ][ playerid ], 0.450000, 2.000000);
	TextDrawColor(TextoLogo[ 4 ][ playerid ], -1);
	TextDrawSetOutline(TextoLogo[ 4 ][ playerid ], 0);
	TextDrawSetProportional(TextoLogo[ 4 ][ playerid ], 1);
	TextDrawSetShadow(TextoLogo[ 4 ][ playerid ], 1);
	TextDrawSetSelectable(TextoLogo[ 4 ][ playerid ], 0);

	TextoLogo[ 1  ][ playerid ] = TextDrawCreate(593.000000, 377.000000, "i");
	TextDrawBackgroundColor(TextoLogo[ 1  ][ playerid ], 255);
	TextDrawFont(TextoLogo[ 1  ][ playerid ], 2);
	TextDrawLetterSize(TextoLogo[ 1  ][ playerid ], 0.679999, 6.099997);
	TextDrawColor(TextoLogo[ 1  ][ playerid ], -1);
	TextDrawSetOutline(TextoLogo[ 1  ][ playerid ], 0);
	TextDrawSetProportional(TextoLogo[ 1  ][ playerid ], 1);
	TextDrawSetShadow(TextoLogo[ 1  ][ playerid ], 1);
	TextDrawSetSelectable(TextoLogo[ 1  ][ playerid ], 0);

	TextoLogo[ 2 ][ playerid ] = TextDrawCreate(601.000000, 388.000000, "on");
	TextDrawBackgroundColor(TextoLogo[ 2 ][ playerid ], 255);
	TextDrawFont(TextoLogo[ 2 ][ playerid ], 2);
	TextDrawLetterSize(TextoLogo[ 2 ][ playerid ], 0.450000, 2.000000);
	TextDrawColor(TextoLogo[ 2 ][ playerid ], 6553855);
	TextDrawSetOutline(TextoLogo[ 2 ][ playerid ], 0);
	TextDrawSetProportional(TextoLogo[ 2 ][ playerid ], 1);
	TextDrawSetShadow(TextoLogo[ 2 ][ playerid ], 1);
	TextDrawSetSelectable(TextoLogo[ 2 ][ playerid ], 0);

	TextoLogo[ 3 ][ playerid ] = TextDrawCreate(602.000000, 409.000000, "RPG");
	TextDrawBackgroundColor(TextoLogo[ 3 ][ playerid ], 255);
	TextDrawFont(TextoLogo[ 3 ][ playerid ], 2);
	TextDrawLetterSize(TextoLogo[ 3 ][ playerid ], 0.320000, 1.499999);
	TextDrawColor(TextoLogo[ 3 ][ playerid ], 6553855);
	TextDrawSetOutline(TextoLogo[ 3 ][ playerid ], 0);
	TextDrawSetProportional(TextoLogo[ 3 ][ playerid ], 1);
	TextDrawSetShadow(TextoLogo[ 3 ][ playerid ], 1);
	TextDrawSetSelectable(TextoLogo[ 3 ][ playerid ], 0);


	
	TextDrawShowForPlayer( playerid, TextoLogo[ 4 ][ playerid ] );
	TextDrawShowForPlayer( playerid, TextoLogo[ 3 ][ playerid ] );
	TextDrawShowForPlayer( playerid, TextoLogo[ 2 ][ playerid ] );
	TextDrawShowForPlayer( playerid, TextoLogo[ 1 ][ playerid ] );
	TextDrawShowForPlayer( playerid, TextoLogo[ 0 ][ playerid ] );

}
stock CriarTextos(p){

	// In OnGameModeInit prefferably, we procced to create our textdraws:
	TextDrawHideForPlayer(p,TVicio[p]);
	TextDrawHideForPlayer(p,TEnergia[p]);
	TextDrawHideForPlayer(p,TFome[p]);
	TInfo[p][0] = TextDrawCreate(334.000000, -6.000000, "I");
	TextDrawBackgroundColor(TInfo[p][0], 255);
	TextDrawFont(TInfo[p][0], 1);
	TextDrawLetterSize(TInfo[p][0], 0.300000, 52.099998);
	TextDrawColor(TInfo[p][0], -1);
	TextDrawSetOutline(TInfo[p][0], 0);
	TextDrawSetProportional(TInfo[p][0], 1);
	TextDrawSetShadow(TInfo[p][0], 1);
	TextDrawUseBox(TInfo[p][0], 1);
	TextDrawBoxColor(TInfo[p][0], 255);
	TextDrawTextSize(TInfo[p][0], 641.000000, -90.000000);

	TInfo[p][1] = TextDrawCreate(397.000000, 29.000000, ".::Dados Pessoais::.");
	TextDrawBackgroundColor(TInfo[p][1], 255);
	TextDrawFont(TInfo[p][1], 2);
	TextDrawLetterSize(TInfo[p][1], 0.500000, 2.000000);
	TextDrawColor(TInfo[p][1], 16777215);
	TextDrawSetOutline(TInfo[p][1], 0);
	TextDrawSetProportional(TInfo[p][1], 1);
	TextDrawSetShadow(TInfo[p][1], 1);

	TInfo[p][2] = TextDrawCreate(430.000000, 77.000000, "Escolha abaixo seu sexo:");
	TextDrawBackgroundColor(TInfo[p][2], 16711935);
	TextDrawFont(TInfo[p][2], 2);
	TextDrawLetterSize(TInfo[p][2], 0.230000, 1.400000);
	TextDrawColor(TInfo[p][2], -65281);
	TextDrawSetOutline(TInfo[p][2], 0);
	TextDrawSetProportional(TInfo[p][2], 1);
	TextDrawSetShadow(TInfo[p][2], 0);

	TInfo[p][3] = TextDrawCreate(473.000000, 99.000000, "Homem");
	TextDrawBackgroundColor(TInfo[p][3], 255);
	TextDrawFont(TInfo[p][3], 2);
	TextDrawLetterSize(TInfo[p][3], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][3], -1);
	TextDrawSetOutline(TInfo[p][3], 0);
	TextDrawSetProportional(TInfo[p][3], 1);
	TextDrawSetShadow(TInfo[p][3], 1);
	TextDrawSetSelectable(TInfo[p][3], 1);
	TextDrawUseBox(TInfo[p][3], 1);
	TextDrawBoxColor(TInfo[p][3], 255);
	TextDrawTextSize(TInfo[p][3], 513.000000, 15.000000);

	TInfo[p][4] = TextDrawCreate(471.000000, 119.000000, "Mulher");
	TextDrawBackgroundColor(TInfo[p][4], 255);
	TextDrawFont(TInfo[p][4], 2);
	TextDrawLetterSize(TInfo[p][4], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][4], -1);
	TextDrawSetOutline(TInfo[p][4], 0);
	TextDrawSetProportional(TInfo[p][4], 1);
	TextDrawSetShadow(TInfo[p][4], 1);
	TextDrawSetSelectable(TInfo[p][4], 1);
	TextDrawUseBox(TInfo[p][4], 1);
	TextDrawBoxColor(TInfo[p][4], 255);
	TextDrawTextSize(TInfo[p][4], 514.000000, 15.000000);

	TInfo[p][5] = TextDrawCreate(403.000000, 149.000000, "digite abaixo sua data de nascimento:");
	TextDrawBackgroundColor(TInfo[p][5], 16711935);
	TextDrawFont(TInfo[p][5], 2);
	TextDrawLetterSize(TInfo[p][5], 0.230000, 1.400000);
	TextDrawColor(TInfo[p][5], -65281);
	TextDrawSetOutline(TInfo[p][5], 0);
	TextDrawSetProportional(TInfo[p][5], 1);
	TextDrawSetShadow(TInfo[p][5], 0);

	TInfo[p][6] = TextDrawCreate(403.000000, 176.000000, "Data:");
	TextDrawBackgroundColor(TInfo[p][6], 255);
	TextDrawFont(TInfo[p][6], 2);
	TextDrawLetterSize(TInfo[p][6], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][6], -1);
	TextDrawSetOutline(TInfo[p][6], 0);
	TextDrawSetProportional(TInfo[p][6], 1);
	TextDrawSetShadow(TInfo[p][6], 1);

	TInfo[p][7] = TextDrawCreate(318.000000, 132.000000, "-");
	TextDrawBackgroundColor(TInfo[p][7], 255);
	TextDrawFont(TInfo[p][7], 1);
	TextDrawLetterSize(TInfo[p][7], 24.010055, 1.000000);
	TextDrawColor(TInfo[p][7], -16776961);
	TextDrawSetOutline(TInfo[p][7], 0);
	TextDrawSetProportional(TInfo[p][7], 1);
	TextDrawSetShadow(TInfo[p][7], 1);

	TInfo[p][8] = TextDrawCreate(402.000000, 192.000000, "Idade:");
	TextDrawBackgroundColor(TInfo[p][8], 255);
	TextDrawFont(TInfo[p][8], 2);
	TextDrawLetterSize(TInfo[p][8], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][8], -1);
	TextDrawSetOutline(TInfo[p][8], 0);
	TextDrawSetProportional(TInfo[p][8], 1);
	TextDrawSetShadow(TInfo[p][8], 1);

	TInfo[p][9] = TextDrawCreate(451.000000, 176.000000, "clique aqui!");
	TextDrawBackgroundColor(TInfo[p][9], 255);
	TextDrawFont(TInfo[p][9], 2);
	TextDrawLetterSize(TInfo[p][9], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][9], -1);
	TextDrawSetOutline(TInfo[p][9], 0);
	TextDrawSetProportional(TInfo[p][9], 1);
	TextDrawSetShadow(TInfo[p][9], 1);
	TextDrawUseBox(TInfo[p][9], 1);
	TextDrawBoxColor(TInfo[p][9], 0xCD0000FF);
	TextDrawTextSize(TInfo[p][9], 520.000000, 15.000000);
	TextDrawSetSelectable(TInfo[p][9], 1);

	TInfo[p][10] = TextDrawCreate(451.000000, 192.000000, "xxx");
	TextDrawBackgroundColor(TInfo[p][10], 255);
	TextDrawFont(TInfo[p][10], 2);
	TextDrawLetterSize(TInfo[p][10], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][10], 16777215);
	TextDrawSetOutline(TInfo[p][10], 0);
	TextDrawSetProportional(TInfo[p][10], 1);
	TextDrawSetShadow(TInfo[p][10], 1);

	TInfo[p][11] = TextDrawCreate(318.000000, 219.000000, "-");
	TextDrawBackgroundColor(TInfo[p][11], 255);
	TextDrawFont(TInfo[p][11], 1);
	TextDrawLetterSize(TInfo[p][11], 24.010055, 1.000000);
	TextDrawColor(TInfo[p][11], -16776961);
	TextDrawSetOutline(TInfo[p][11], 0);
	TextDrawSetProportional(TInfo[p][11], 1);
	TextDrawSetShadow(TInfo[p][11], 1);

	TInfo[p][12] = TextDrawCreate(402.000000, 239.000000, "escolha abaixo sua cidade de origem:");
	TextDrawBackgroundColor(TInfo[p][12], 16711935);
	TextDrawFont(TInfo[p][12], 2);
	TextDrawLetterSize(TInfo[p][12], 0.230000, 1.400000);
	TextDrawColor(TInfo[p][12], -65281);
	TextDrawSetOutline(TInfo[p][12], 0);
	TextDrawSetProportional(TInfo[p][12], 1);
	TextDrawSetShadow(TInfo[p][12], 0);

	TInfo[p][13] = TextDrawCreate(402.000000, 269.000000, "origem:");
	TextDrawBackgroundColor(TInfo[p][13], 255);
	TextDrawFont(TInfo[p][13], 2);
	TextDrawLetterSize(TInfo[p][13], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][13], -1);
	TextDrawSetOutline(TInfo[p][13], 0);
	TextDrawSetProportional(TInfo[p][13], 1);
	TextDrawSetShadow(TInfo[p][13], 1);

	TInfo[p][14] = TextDrawCreate(455.000000, 268.000000, "clique aqui!");
	TextDrawBackgroundColor(TInfo[p][14], 255);
	TextDrawFont(TInfo[p][14], 2);
	TextDrawLetterSize(TInfo[p][14], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][14], -1);
	TextDrawSetOutline(TInfo[p][14], 0);
	TextDrawSetProportional(TInfo[p][14], 1);
	TextDrawSetShadow(TInfo[p][14], 1);
	TextDrawUseBox(TInfo[p][14], 1);
	TextDrawBoxColor(TInfo[p][14], 0xCD0000FF);
	TextDrawTextSize(TInfo[p][14], 522.000000, 15.000000);
	TextDrawSetSelectable(TInfo[p][14], 1);


	TInfo[p][15] = TextDrawCreate(355.000000, 398.000000, "Resetar");
	TextDrawBackgroundColor(TInfo[p][15], 255);
	TextDrawFont(TInfo[p][15], 2);
	TextDrawLetterSize(TInfo[p][15], 0.260000, 1.400000);
	TextDrawColor(TInfo[p][15], -1);
	TextDrawSetOutline(TInfo[p][15], 0);
	TextDrawSetProportional(TInfo[p][15], 1);
	TextDrawSetShadow(TInfo[p][15], 1);
	TextDrawUseBox(TInfo[p][15], 1);
	TextDrawBoxColor(TInfo[p][15], 0xCD0000FF);
	TextDrawTextSize(TInfo[p][15], 404.000000, 15.000000);
	TextDrawSetSelectable(TInfo[p][15], 1);

	TInfo[p][16] = TextDrawCreate(547.000000, 397.000000, "Confirmar");
	TextDrawBackgroundColor(TInfo[p][16], 255);
	TextDrawFont(TInfo[p][16], 2);
	TextDrawLetterSize(TInfo[p][16], 0.260000, 1.400000);
	TextDrawColor(TInfo[p][16], -1);
	TextDrawSetOutline(TInfo[p][16], 0);
	TextDrawSetProportional(TInfo[p][16], 1);
	TextDrawSetShadow(TInfo[p][16], 1);
	TextDrawUseBox(TInfo[p][16], 1);
	TextDrawBoxColor(TInfo[p][16], 0xCD0000FF);
	TextDrawTextSize(TInfo[p][16], 606.000000, 15.000000);
	TextDrawSetSelectable(TInfo[p][16], 1);

	TInfo[p][17] = TextDrawCreate(318.000000, 292.000000, "-");
	TextDrawBackgroundColor(TInfo[p][17], 255);
	TextDrawFont(TInfo[p][17], 1);
	TextDrawLetterSize(TInfo[p][17], 24.010055, 1.000000);
	TextDrawColor(TInfo[p][17], -16776961);
	TextDrawSetOutline(TInfo[p][17], 0);
	TextDrawSetProportional(TInfo[p][17], 1);
	TextDrawSetShadow(TInfo[p][17], 1);

	TInfo[p][18] = TextDrawCreate(402.000000, 306.000000, "digite abaixo seu e-mail:");
	TextDrawBackgroundColor(TInfo[p][18], 16711935);
	TextDrawFont(TInfo[p][18], 2);
	TextDrawLetterSize(TInfo[p][18], 0.230000, 1.400000);
	TextDrawColor(TInfo[p][18], -65281);
	TextDrawSetOutline(TInfo[p][18], 0);
	TextDrawSetProportional(TInfo[p][18], 1);
	TextDrawSetShadow(TInfo[p][18], 0);

	TInfo[p][19] = TextDrawCreate(402.000000, 332.000000, "e-mail:");
	TextDrawBackgroundColor(TInfo[p][19], 255);
	TextDrawFont(TInfo[p][19], 2);
	TextDrawLetterSize(TInfo[p][19], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][19], -1);
	TextDrawSetOutline(TInfo[p][19], 0);
	TextDrawSetProportional(TInfo[p][19], 1);
	TextDrawSetShadow(TInfo[p][19], 1);

	TInfo[p][20] = TextDrawCreate(453.000000, 332.000000, "clique aqui!");
	TextDrawBackgroundColor(TInfo[p][20], 255);
	TextDrawFont(TInfo[p][20], 2);
	TextDrawLetterSize(TInfo[p][20], 0.260000, 1.100000);
	TextDrawColor(TInfo[p][20], -1);
	TextDrawSetOutline(TInfo[p][20], 0);
	TextDrawSetProportional(TInfo[p][20], 1);
	TextDrawSetShadow(TInfo[p][20], 1);
	TextDrawUseBox(TInfo[p][20], 1);
	TextDrawBoxColor(TInfo[p][20],0xCD0000FF);
	TextDrawTextSize(TInfo[p][20], 522.000000, 15.000000);
	TextDrawSetSelectable(TInfo[p][20], 1);
	SelectTextDraw(p, 0x008B8BEE);
	Selecionando[p] = true;
	for(new i = 0;i < 21;i++){
	    TextDrawShowForPlayer(p,TInfo[p][i]);
	}
	for(new i = 0;i < 5;i++){
	    Reg[p][i] = false;
	}
	SendClientMessage(p,-1,"Complete seu registro com os dados solicitados.");
}
stock DestruirTCor(p){
	for(new _u = 0; _u < 13; _u++){
	    TextDrawSetSelectable(TCor[p][_u], false);
	    TextDrawHideForPlayer(p,TCor[_u][p]);
	    TextDrawDestroy(TCor[_u][p]);
	}
}
stock CriarTCor(p){

	TCor[0][p] = TextDrawCreate(641.375000, 303.083312, "usebox");
	TextDrawLetterSize(TCor[0][p], 0.000000, 15.887041);
	TextDrawTextSize(TCor[0][p], 415.500000, 0.000000);
	TextDrawAlignment(TCor[0][p], 1);
	TextDrawColor(TCor[0][p], 125);
	TextDrawUseBox(TCor[0][p], true);
	TextDrawBoxColor(TCor[0][p], 125);
	TextDrawSetShadow(TCor[0][p], 0);
	TextDrawSetOutline(TCor[0][p], 0);
	TextDrawFont(TCor[0][p], 0);

	TCor[1][p] = TextDrawCreate(452.500000, 307.416625, "Escolha a cor abaixo:");
	TextDrawLetterSize(TCor[1][p], 0.449999, 1.600000);
	TextDrawAlignment(TCor[1][p], 1);
	TextDrawColor(TCor[1][p], -1);
	TextDrawSetShadow(TCor[1][p], 1);
	TextDrawSetOutline(TCor[1][p], 0);
	TextDrawBackgroundColor(TCor[1][p], 255);
	TextDrawFont(TCor[1][p], 1);
	TextDrawSetProportional(TCor[1][p], 1);

	TCor[2][p] = TextDrawCreate(428.125000, 338.916809, "Cor 1");
	TextDrawLetterSize(TCor[2][p], 0.355624, 1.302498);
	TextDrawAlignment(TCor[2][p], 1);
	TextDrawColor(TCor[2][p], -1);
	TextDrawSetShadow(TCor[2][p], 0);
	TextDrawSetOutline(TCor[2][p], 1);
	TextDrawBackgroundColor(TCor[2][p], 51);
	TextDrawFont(TCor[2][p], 1);
	TextDrawSetProportional(TCor[2][p], 1);

	TCor[3][p] = TextDrawCreate(478.125000, 335.999725, "<");
	TextDrawLetterSize(TCor[3][p], 0.343748, 1.833333);
	TextDrawTextSize(TCor[3][p], 488.125000, 15.416649);
	TextDrawAlignment(TCor[3][p], 1);
	TextDrawColor(TCor[3][p], -5963521);
	TextDrawUseBox(TCor[3][p], true);
	TextDrawBoxColor(TCor[3][p], 0);
	TextDrawSetShadow(TCor[3][p], 0);
	TextDrawSetOutline(TCor[3][p], 1);
	TextDrawBackgroundColor(TCor[3][p], 51);
	TextDrawFont(TCor[3][p], 1);
	TextDrawSetProportional(TCor[3][p], 1);
	TextDrawSetSelectable(TCor[3][p], true);

	TCor[4][p] = TextDrawCreate(537.250000, 335.833068, ">");
	TextDrawLetterSize(TCor[4][p], 0.343748, 1.833333);
	TextDrawTextSize(TCor[4][p], 546.250000, 15.499987);
	TextDrawAlignment(TCor[4][p], 1);
	TextDrawColor(TCor[4][p], -5963521);
	TextDrawUseBox(TCor[4][p], true);
	TextDrawBoxColor(TCor[4][p], 0);
	TextDrawSetShadow(TCor[4][p], 0);
	TextDrawSetOutline(TCor[4][p], 1);
	TextDrawBackgroundColor(TCor[4][p], 51);
	TextDrawFont(TCor[4][p], 1);
	TextDrawSetProportional(TCor[4][p], 1);
	TextDrawSetSelectable(TCor[4][p], true);

	TCor[5][p] = TextDrawCreate(499.750000, 338.166778, "_");
	TextDrawLetterSize(TCor[5][p], 0.355624, 1.302498);
	TextDrawTextSize(TCor[5][p], 525.125000, 10.500035);
	TextDrawAlignment(TCor[5][p], 1);
	TextDrawColor(TCor[5][p], 0xEEDD82FF);
	TextDrawUseBox(TCor[5][p], true);
	TextDrawBoxColor(TCor[5][p], 50);
	TextDrawSetShadow(TCor[5][p], 1);
	TextDrawSetOutline(TCor[5][p], 0);
	TextDrawBackgroundColor(TCor[5][p], 255);
	TextDrawFont(TCor[5][p], 1);
	TextDrawSetProportional(TCor[5][p], 1);

	TCor[7][p] = TextDrawCreate(428.125000, 374.333801, "Cor 2");
	TextDrawLetterSize(TCor[7][p], 0.355624, 1.302498);
	TextDrawAlignment(TCor[7][p], 1);
	TextDrawColor(TCor[7][p], -1);
	TextDrawSetShadow(TCor[7][p], 0);
	TextDrawSetOutline(TCor[7][p], 1);
	TextDrawBackgroundColor(TCor[7][p], 51);
	TextDrawFont(TCor[7][p], 1);
	TextDrawSetProportional(TCor[7][p], 1);



	TCor[6][p] = TextDrawCreate(479.125000, 370.833160, "<");
	TextDrawLetterSize(TCor[6][p], 0.343748, 1.833333);
	TextDrawTextSize(TCor[6][p], 488.125000, 15.499985);
	TextDrawAlignment(TCor[6][p], 1);
	TextDrawColor(TCor[6][p], -5963521);
	TextDrawUseBox(TCor[6][p], true);
	TextDrawBoxColor(TCor[6][p], 0);
	TextDrawSetShadow(TCor[6][p], 0);
	TextDrawSetOutline(TCor[6][p], 1);
	TextDrawBackgroundColor(TCor[6][p], 51);
	TextDrawFont(TCor[6][p], 1);
	TextDrawSetProportional(TCor[6][p], 1);
	TextDrawSetSelectable(TCor[6][p], true);

	TCor[8][p] = TextDrawCreate(540.125000, 370.083282, ">");
	TextDrawLetterSize(TCor[8][p], 0.343748, 1.833333);
	TextDrawTextSize(TCor[8][p], 549.375000, 15.499982);
	TextDrawAlignment(TCor[8][p], 1);
	TextDrawColor(TCor[8][p], -5963521);
	TextDrawUseBox(TCor[8][p], true);
	TextDrawBoxColor(TCor[8][p], 0);
	TextDrawSetShadow(TCor[8][p], 0);
	TextDrawSetOutline(TCor[8][p], 1);
	TextDrawBackgroundColor(TCor[8][p], 51);
	TextDrawFont(TCor[8][p], 1);
	TextDrawSetProportional(TCor[8][p], 1);
	TextDrawSetSelectable(TCor[8][p], true);

	TCor[9][p] = TextDrawCreate(502.000000, 373.000091, "_");
	TextDrawLetterSize(TCor[9][p], 0.355624, 1.302498);
	TextDrawTextSize(TCor[9][p], 525.125000, 10.500035);
	TextDrawAlignment(TCor[9][p], 1);
	TextDrawColor(TCor[9][p], 0xEEDD82FF);
	TextDrawUseBox(TCor[9][p], true);
	TextDrawBoxColor(TCor[9][p], 50);
	TextDrawSetShadow(TCor[9][p], 1);
	TextDrawSetOutline(TCor[9][p], 0);
	TextDrawBackgroundColor(TCor[9][p], 255);
	TextDrawFont(TCor[9][p], 1);
	TextDrawSetProportional(TCor[9][p], 1);

	TCor[10][p] = TextDrawCreate(446.875000, 397.833160, "~w~Para mudar a cor sera cobrado ~g~$: 1000");
	TextDrawLetterSize(TCor[10][p], 0.234374, 1.162499);
	TextDrawAlignment(TCor[10][p], 1);
	TextDrawColor(TCor[10][p], 8388863);
	TextDrawSetShadow(TCor[10][p], 0);
	TextDrawSetOutline(TCor[10][p], 1);
	TextDrawBackgroundColor(TCor[10][p], 51);
	TextDrawFont(TCor[10][p], 1);
	TextDrawSetProportional(TCor[10][p], 1);

	TCor[11][p] = TextDrawCreate(431.250000, 424.083221, "Cancelar");
	TextDrawLetterSize(TCor[11][p], 0.368749, 1.512500);
	TextDrawTextSize(TCor[11][p], 486.125000, 15.500000);
	TextDrawAlignment(TCor[11][p], 1);
	TextDrawColor(TCor[11][p], 0xEEDD82FF);
	TextDrawUseBox(TCor[11][p], true);
	TextDrawBoxColor(TCor[11][p], 75);
	TextDrawSetShadow(TCor[11][p], 0);
	TextDrawSetOutline(TCor[11][p], 1);
	TextDrawBackgroundColor(TCor[11][p], 51);
	TextDrawFont(TCor[11][p], 1);
	TextDrawSetProportional(TCor[11][p], 1);
	TextDrawSetSelectable(TCor[11][p], true);

	TCor[12][p] = TextDrawCreate(568.500000, 424.083221, "Confirmar");
	TextDrawLetterSize(TCor[12][p], 0.368749, 1.512500);
	TextDrawTextSize(TCor[12][p], 633.000000, 15.499996);
	TextDrawAlignment(TCor[12][p], 1);
	TextDrawColor(TCor[12][p], 0xEEDD82FF);
	TextDrawUseBox(TCor[12][p], true);
	TextDrawBoxColor(TCor[12][p], 75);
	TextDrawSetShadow(TCor[12][p], 0);
	TextDrawSetOutline(TCor[12][p], 1);
	TextDrawBackgroundColor(TCor[12][p], 51);
	TextDrawFont(TCor[12][p], 1);
	TextDrawSetProportional(TCor[12][p], 1);
	TextDrawSetSelectable(TCor[12][p], true);

	for( new _x = 0; _x < 13; _x++ ){
	
	    TextDrawShowForPlayer(p,TCor[_x][p]);
	
	}

}
stock AnuncioComando(playerid,cmd[],valor,outroplayer){
		new str[256];
		if(valor > 0){
			format(str,sizeof str,"{FF6A6A}[ Administração ] {FFFFFF}O admin %s usou o comando {FF6A6A}%s [ %d ] {FFFFFF}no player %s.",Nome(playerid),cmd,valor,Nome(outroplayer));
		}
		else{
		    format(str,sizeof str,"{FF6A6A}[ Administração ] {FFFFFF}O admin %s usou o comando {FF6A6A}%s {FFFFFF}no player %s.",Nome(playerid),cmd,Nome(outroplayer));
		}
		return SendClientMessageToAll(-1,str);
}
stock DestruirTextoMenu(r){
	TextDrawDestroy(Login[r]);
	TextDrawDestroy(Fundo[r]);
	TextDrawDestroy(Tutorial[r]);
	TextDrawDestroy(Credito[r]);
	TextDrawDestroy(Saindo[r]);
}
stock CriarTextoCarro(playerid){


	VNome[playerid] = TextDrawCreate(292.000000, 347.000000, "_");
	TextDrawBackgroundColor(VNome[playerid], 255);
	TextDrawFont(VNome[playerid], 1);
	TextDrawLetterSize(VNome[playerid], 0.569999, 2.100000);
	TextDrawColor(VNome[playerid], -1);
	TextDrawSetOutline(VNome[playerid], 0);
	TextDrawSetProportional(VNome[playerid], 1);
	TextDrawSetShadow(VNome[playerid], 1);
	TextDrawSetSelectable(VNome[playerid], 0);

	VVelo[playerid] = TextDrawCreate(244.000000, 372.000000, "_");
	TextDrawBackgroundColor(VVelo[playerid], 255);
	TextDrawFont(VVelo[playerid], 2);
	TextDrawLetterSize(VVelo[playerid], 0.190000, 1.000000);
	TextDrawColor(VVelo[playerid], -1);
	TextDrawSetOutline(VVelo[playerid], 0);
	TextDrawSetProportional(VVelo[playerid], 3);
	TextDrawSetShadow(VVelo[playerid], 0);
	TextDrawSetSelectable(VVelo[playerid], 0);

	VGas[playerid] = TextDrawCreate(244.000000, 386.000000, "_");
	TextDrawBackgroundColor(VGas[playerid], 255);
	TextDrawFont(VGas[playerid], 2);
	TextDrawLetterSize(VGas[playerid], 0.190000, 1.000000);
	TextDrawColor(VGas[playerid], -1);
	TextDrawSetOutline(VGas[playerid], 0);
	TextDrawSetProportional(VGas[playerid], 1);
	TextDrawSetShadow(VGas[playerid], 0);
	TextDrawSetSelectable(VGas[playerid], 0);

	VLata[playerid] = TextDrawCreate(347.000000, 372.000000, "_");
	TextDrawBackgroundColor(VLata[playerid], 255);
	TextDrawFont(VLata[playerid], 2);
	TextDrawLetterSize(VLata[playerid], 0.190000, 1.000000);
	TextDrawColor(VLata[playerid], -1);
	TextDrawSetOutline(VLata[playerid], 0);
	TextDrawSetProportional(VLata[playerid], 1);
	TextDrawSetShadow(VLata[playerid], 0);
	TextDrawSetSelectable(VLata[playerid], 0);

	VPlaca[playerid] = TextDrawCreate(347.000000, 385.000000, "_");
	TextDrawBackgroundColor(VPlaca[playerid], 255);
	TextDrawFont(VPlaca[playerid], 2);
	TextDrawLetterSize(VPlaca[playerid], 0.190000, 1.000000);
	TextDrawColor(VPlaca[playerid], -1);
	TextDrawSetOutline(VPlaca[playerid], 0);
	TextDrawSetProportional(VPlaca[playerid], 1);
	TextDrawSetShadow(VPlaca[playerid], 0);
	TextDrawSetSelectable(VPlaca[playerid], 0);

	VFundo[playerid] = TextDrawCreate(245.000000, 370.000000, "_");
	TextDrawBackgroundColor(VFundo[playerid], 255);
	TextDrawFont(VFundo[playerid], 1);
	TextDrawLetterSize(VFundo[playerid], 0.240000, 2.900000);
	TextDrawColor(VFundo[playerid], 100);
	TextDrawSetOutline(VFundo[playerid], 0);
	TextDrawSetProportional(VFundo[playerid], 1);
	TextDrawSetShadow(VFundo[playerid], 1);
	TextDrawUseBox(VFundo[playerid], 1);
	TextDrawBoxColor(VFundo[playerid], 100);
	TextDrawTextSize(VFundo[playerid], 413.000000, 0.000000);
	TextDrawSetSelectable(VFundo[playerid], 0);
	Selecionando[playerid] = true;
}
stock SalvarCasa(c){
    new file[56];
    format(file,sizeof file,"Casas/%d.ini",c);
    DOF2_SetFloat(file, "x",CI[c][C_entradax]);
    DOF2_SetFloat(file, "y",CI[c][C_entraday]);
    DOF2_SetFloat(file, "z",CI[c][C_entradaz]);
    DOF2_SetFloat(file, "sx",CI[c][C_saidax]);
    DOF2_SetFloat(file, "sy",CI[c][C_saiday]);
    DOF2_SetFloat(file, "sz",CI[c][C_saidaz]);
    DOF2_SetInt(file, "valor",CI[c][C_valor]);
    DOF2_SetInt(file, "level",CI[c][C_level]);
    DOF2_SetInt(file, "interior",CI[c][C_interior]);
    DOF2_SetInt(file, "virtual",CI[c][C_virtual]);
    DOF2_SetString(file, "dono",CI[c][C_dono]);
    DOF2_SetString(file, "descricao",CI[c][C_descricao]);
    DOF2_SetInt(file, "aluguel", CI[c][C_aluguel]);
    DOF2_SetBool(file, "alugavel",CI[c][C_alugavel]);
    DOF2_SetInt(file, "modelocarro",CI[c][C_modelocarro]);
    DOF2_SetFloat(file, "C_carrox",CI[c][C_carrox]);
    DOF2_SetFloat(file, "C_carroy",CI[c][C_carroy]);
    DOF2_SetFloat(file, "C_carroz",CI[c][C_carroz]);
    DOF2_SetInt(file, "cor1",CI[c][C_cor1]);
    DOF2_SetInt(file,"cor2",CI[c][C_cor2]);
    DOF2_SetBool(file,"comprada",CI[c][C_comprada]);
    DOF2_SetBool(file,"trancada",CI[c][C_trancada]);
    DOF2_SetInt(file,"cofre",CI[c][C_cofre]);
    DOF2_SetBool(file,"vip",CI[c][C_vip]);
    DOF2_SaveFile();
}
stock CarregarCasa(c){
    new file[56];
    format(file,sizeof file,"Casas/%d.ini",c);
    CI[c][C_entradax] = DOF2_GetFloat(file, "x");
    CI[c][C_entraday] = DOF2_GetFloat(file, "y");
    CI[c][C_entradaz] = DOF2_GetFloat(file, "z");
    CI[c][C_saidax] = DOF2_GetFloat(file, "sx");
    CI[c][C_saiday] = DOF2_GetFloat(file, "sy");
    CI[c][C_saidaz] = DOF2_GetFloat(file, "sz");
    CI[c][C_valor] = DOF2_GetInt(file, "valor");
    CI[c][C_level] = DOF2_GetInt(file, "level");
    CI[c][C_interior] = DOF2_GetInt(file, "interior");
    CI[c][C_virtual] = DOF2_GetInt(file, "virtual");
    format(CI[c][C_dono],26,"%s",DOF2_GetString(file, "dono"));
    format(CI[c][C_descricao],128,"%s",DOF2_GetString(file, "descricao"));
    CI[c][C_aluguel] = DOF2_GetInt(file, "aluguel");
    CI[c][C_alugavel] = DOF2_GetBool(file, "alugavel");
    CI[c][C_modelocarro] = DOF2_GetInt(file, "modelocarro");
    CI[c][C_carrox] = DOF2_GetFloat(file, "C_carrox");
    CI[c][C_carroy] = DOF2_GetFloat(file, "C_carroy");
    CI[c][C_carroz] = DOF2_GetFloat(file, "C_carroz");
    CI[c][C_cor1] = DOF2_GetInt(file, "cor1");
    CI[c][C_cor2] = DOF2_GetInt(file,"cor2");
    CI[c][C_comprada] = DOF2_GetBool(file,"comprada");
    CI[c][C_trancada] = DOF2_GetBool(file,"trancada");
    CI[c][C_cofre] = DOF2_GetBool(file,"cofre");
    CI[c][C_vip] = DOF2_GetBool(file,"vip");
}
stock DeletarTextoCarro(p){

	TextDrawHideForPlayer(p,VVelo[p]);
	TextDrawHideForPlayer(p,VGas[p]);
	TextDrawHideForPlayer(p,VLata[p]);
	TextDrawHideForPlayer(p,VFundo[p]);
	TextDrawHideForPlayer(p,VPlaca[p]);
	TextDrawHideForPlayer(p,VNome[p]);
	TextDrawDestroy(VVelo[p]);
	TextDrawDestroy(VGas[p]);
	TextDrawDestroy(VLata[p]);
	TextDrawDestroy(VFundo[p]);
	TextDrawDestroy(VPlaca[p]);
	TextDrawDestroy(VNome[p]);

}
forward MudarTempo();
public MudarTempo(){

	static sContador;
	static _y;
	new str[128];
	sContador ++;
	if(sContador == 10){
	    _y = random(sizeof(Clima));
	    switch(Clima[_y]){
	        case 0..3,10..13: format(str,sizeof str,"{00BFFF}[ Previsão Meteriológica ] {E0FFFF}Previsão de tempo ensolarado para as próximas horas.");
	        case 4,7,15:format(str,sizeof str,"{00BFFF}[ Previsão Meteriológica ] {E0FFFF}Previsão de tempo instável durante as próximas horas.");
	        case 8,16:format(str,sizeof str,"{00BFFF}[ Previsão Meteriológica ] {E0FFFF}Previsão de chuva forte para as próximas horas.");
	        case 9:format(str,sizeof str,"{00BFFF}[ Previsão Meteriológica ] {E0FFFF}Previsão de forte neblina em toda cidade de San Fierro.");
	        case 17:format(str,sizeof str,"{00BFFF}[ Previsão Meteriológica ] {E0FFFF}Um forte tempestade de areia se aproxima de San Fierro.");
	    }
	    SendClientMessageToAll(-1,str);
	    for(new i = 0;i < Players;i++){
	    	PlayerPlaySound(i,1138,0.0,0.0,0.0);
	    }
	}
	else if(sContador == 11){
	    sContador = 0;
		SetWeather(Clima[_y]);
	}
}
forward Gasolina(p);
public Gasolina(p){
	new engine,lights,alarm,doors,bonnet,boot,objective;
	new c = GetPlayerVehicleID(p);
	GetVehicleParamsEx(c,engine,lights,alarm,doors,bonnet,boot,objective);
	if(engine == 0)
		return 1;
    new h = GetVehicleModel(c);
    if(h == 481 || h == 509 || h == 510 || h == 464)
    {
        return 1;
    }
    else{
	   	if(Gas[c] >= 1)
	   	{
	        Gas[c]--;
		    switch(Gas[c]){

		        case 20,10,5: SendClientMessage(p,-1,"{FF3030}Seu veículo está na reserva. Abasteça imediatamente.");
		    }
	        new gas[40];
	        format(gas,sizeof gas,"~r~~h~~h~Combustivel: ~w~%dL",Gas[c]);
	        TextDrawSetString(VGas[p],gas);
	    }
	    else{
	        SendClientMessage(p,-1,"{FF3030}Veículo sem combustível.");
			SetVehicleParamsEx(c,0,lights,alarm,doors,bonnet,boot,objective);
		}
	}
	return true;
}
forward Velocimetro(p);
public Velocimetro(p){
	if(!IsPlayerInAnyVehicle(p)){
		TextDrawHideForPlayer(p,VVelo[p]);
		TextDrawHideForPlayer(p,VGas[p]);
		TextDrawHideForPlayer(p,VLata[p]);
		TextDrawHideForPlayer(p,VFundo[p]);
		TextDrawHideForPlayer(p,VPlaca[p]);
		TextDrawHideForPlayer(p,VNome[p]);
		KillTimer(TVelocimetro[p]);
		KillTimer(TGas[p]);
	}
	else{
		new velo[40],lata[40],gas[40];
 		new Float:ra;
 		new c = GetPlayerVehicleID(p);
        new v = GetVehicleModel(c);
        if(Gas[c] > 100) Gas[c] = 100;
        else if ( Gas [c] < 0) Gas [c] = 0;
        if(v == 481 || v == 509 || v == 510 || v == 464)
        {
            ra = 3;
            KillTimer(TGas[p]);
			format(gas,sizeof gas,"~r~~h~~h~Combustivel: ~w~N/A");
			TextDrawSetString(VGas[p],gas);
        }
        else
        {
            ra = 0.8;
        }
	    new Float:vPos[3], Float:Speed;
	    new Float: Life;
	    GetVehicleHealth(c,Life);
        GetVehicleVelocity(c, vPos[0], vPos[1], vPos[2]);
        Speed = floatsqroot(((vPos[0]*vPos[0])+(vPos[1]*vPos[1]))+(vPos[2]*vPos[2]))*136.666667;
        format(velo,sizeof velo,"~r~~h~~h~Velocimetro: ~w~%0.0fKM/H",Speed/ra);
        TextDrawSetString(VVelo[p],velo);
        format(lata,sizeof lata,"~r~~h~~h~Lataria: ~w~%0.0f%",Life/10);
        TextDrawSetString(VLata[p],lata);
	}
}
stock ComprandoCarro(p,valor){
	new Arquivo[56];
	if(valor > PI[p][pDolar]) return Atencao(p,"Sem dinheiro suficiente para comprar este veículo.");
	for(new _i = 0; _i < Max_Veiculos; _i++){
		format(Arquivo,sizeof Arquivo,"/Veiculos/%d.ini",_i);
		if(!DOF2_FileExists(Arquivo)){
		    for(new _x = 0;_x < Player_Veiculo;_x++){
		        if(PI[p][pChaveCarro][_x] < 0){
			        DOF2_CreateFile(Arquivo);
					DOF2_SetString(Arquivo,"Dono",Nome(p));
					if(TipoCarro[p] == 1){
						DOF2_SetInt(Arquivo,"Modelo",Camionetes[_r[p]]);
					}
					new r = random(sizeof(PosConc));
					DOF2_SetFloat(Arquivo,"_X",PosConc[r][0]);
					DOF2_SetFloat(Arquivo,"_Y",PosConc[r][1]);
					DOF2_SetFloat(Arquivo,"_Z",PosConc[r][2]);
					DOF2_SetFloat(Arquivo,"_A",PosConc[r][3]);
					DOF2_SetInt(Arquivo,"Cor1",0);
					DOF2_SetInt(Arquivo,"Cor2",0);
					DOF2_SetInt(Arquivo,"Valor",valor);
					DOF2_SaveFile();
					PI[p][pChaveCarro][_x] = _i;
					DarDolar(p,-valor);
					DestruirTextoVeiculo(p);
					CarregarVeiculo(_i);
					TipoCarro[p] = 0;
					SetPlayerCheckpoint(p,PosConc[r][0],PosConc[r][1],PosConc[r][2],5.0);
					CP[p] = 1;
					SendClientMessage(p,-1,"{FFBBFF}[Concessionária] {FFFFFF}Parabéns! Seu novo veículo já lhe foi entregue. Vá até a marca em vermelho no mapa.");
					SendClientMessage(p,-1,"{FFBBFF}[Concessionária] {FFFFFF}Para trocar a cor do veículo vá até a oficina de carros.");
					SendClientMessage(p,-1,"{FFBBFF}[Concessionária] {FFFFFF}Para mais informações USE: {FFBBFF}/infocarro");
					return true;
				}
		    }
		    Atencao(p,"Você não pode ter mais veiculos.");
		    return true;
		}
	}
	Atencao(p,"Não há mais veículos a venda!");
	return true;
}
stock CarregarVeiculo(_i){
	new Arquivo[56];
	format(Arquivo,sizeof Arquivo,"/Veiculos/%d.ini",_i);
	if(DOF2_GetInt(Arquivo,"Modelo") == 0){
	    return DOF2_RemoveFile(Arquivo);
	}
	VI[_i][vdono] = DOF2_GetString(Arquivo,"Dono");
	VI[_i][vmodelo] = DOF2_GetInt(Arquivo,"Modelo");
	VI[_i][vx] = DOF2_GetFloat(Arquivo,"_X");
    VI[_i][vy] = DOF2_GetFloat(Arquivo,"_Y");
    VI[_i][vz] = DOF2_GetFloat(Arquivo,"_Z");
    VI[_i][va] = DOF2_GetFloat(Arquivo,"_A");
    VI[_i][vcor] = DOF2_GetInt(Arquivo,"Cor1");
    VI[_i][vcor2] = DOF2_GetInt(Arquivo,"Cor2");
    VI[_i][vvalor] = DOF2_GetInt(Arquivo,"Valor");
    VeiculoConc[_i] = CreateVehicle(VI[_i][vmodelo],VI[_i][vx],VI[_i][vy],VI[_i][vz],VI[_i][va],VI[_i][vcor],VI[_i][vcor2],60*10);
	return true;
}
stock SalvarVeiculo(_i){
	new Arquivo[56];
	format(Arquivo,sizeof Arquivo,"/Veiculos/%d.ini",_i);

	DOF2_SetFloat(Arquivo,"_X",VI[_i][vx]);
    DOF2_SetFloat(Arquivo,"_Y",VI[_i][vy]);
    DOF2_SetFloat(Arquivo,"_Z",VI[_i][vz]);
    DOF2_SetFloat(Arquivo,"_A",VI[_i][va]);
    DOF2_SetInt(Arquivo,"Cor1",VI[_i][vcor]);
    DOF2_SetInt(Arquivo,"Cor2",VI[_i][vcor2]);
	DOF2_SaveFile();
    
	return true;
}
stock VerificandoCor2(p,tipo){
    new nomev[10];
    _c[p] = CorTipo[1][p];
	if(tipo > 0){
		_c[p] ++;
		if(_c[p] > 255)
		    _c[p] = 0;
		for(new _x = 0; _x < Player_Veiculo;_x ++){
		    if(VeiculoOficina[VeiculoConc[PI[p][pChaveCarro][_x]]] == true){
            	ChangeVehicleColor(VeiculoConc[PI[p][pChaveCarro][_x]],CorTipo[0][p],_c[p]);
            	CorTipo[1][p] = _c[p];
            	break;
		  	}
		}
		format(nomev,sizeof nomev,"%03d",_c[p]);
	    TextDrawSetString(TCor[9][p],nomev);
	}
	else{
		_c[p] --;
		if(_c[p] < 0)
		    _c[p] = 255;
		for(new _x = 0; _x < Player_Veiculo;_x ++){
		    if(VeiculoOficina[VeiculoConc[PI[p][pChaveCarro][_x]]] == true){
            	ChangeVehicleColor(VeiculoConc[PI[p][pChaveCarro][_x]],CorTipo[0][p],_c[p]);
            	CorTipo[1][p] = _c[p];
            	break;
		  	}
		}
		format(nomev,sizeof nomev,"%03d",_c[p]);
	    TextDrawSetString(TCor[9][p],nomev);
	}
}
stock VerificandoCor(p,tipo){
	_c[p] = CorTipo[0][p];
    new nomev[10];
	if(tipo > 0){
		_c[p] ++;
		if(_c[p] > 255)
		    _c[p] = 0;
		for(new _x = 0; _x < Player_Veiculo;_x ++){
		    if(VeiculoOficina[VeiculoConc[PI[p][pChaveCarro][_x]]] == true){
            	ChangeVehicleColor(VeiculoConc[PI[p][pChaveCarro][_x]],_c[p],CorTipo[1][p]);
            	CorTipo[0][p] = _c[p];
            	break;
		  	}
		}
		format(nomev,sizeof nomev,"%03d",_c[p]);
	    TextDrawSetString(TCor[5][p],nomev);
	}
	else{
		_c[p] --;
		if(_c[p] < 0)
		    _c[p] = 255;
		for(new _x = 0; _x < Player_Veiculo;_x ++){
		    if(VeiculoOficina[VeiculoConc[PI[p][pChaveCarro][_x]]] == true){
            	ChangeVehicleColor(VeiculoConc[PI[p][pChaveCarro][_x]],_c[p],CorTipo[1][p]);
            	CorTipo[0][p] = _c[p];
            	break;
		  	}
		}
		format(nomev,sizeof nomev,"%03d",_c[p]);
	    TextDrawSetString(TCor[5][p],nomev);
	}
}
stock SalvarVip( p ){
	new
		str[ 256 ],
		file[ 65 ]
	;
	format( file, sizeof file, "Vip/%s.ini", Nome( p ));
	if( DOF2_FileExists( file ) ){
	    DOF2_SetInt( file, "Level", SistemaVip[ p ][ vipLevel ] );
	    DOF2_SetInt( file, "Tempo", SistemaVip[ p ][ vipTempo ] );
	    DOF2_SaveFile();
	    new nvip[ 15 ];
	    if( SistemaVip[ p ][ vipLevel ] == PRATA ) nvip = "Prata";
	    else if( SistemaVip[ p ][ vipLevel ] == OURO ) nvip = "Ouro";
	    format( str, sizeof str, "{FFD700}[ Sistema Vip ] {FFFFFF}Parabéns {FFD700}%s{FFFFFF}. Sua conta VIP level: {FFD700}[ %s ] {FFFFFF}foi ativada.", Nome( p ), nvip );
	    SendClientMessage( p, -1, str );
	}
	else{
	    DOF2_CreateFile( file );
	    SalvarVip( p );
	}
	return true;
}
stock CarregarVip( p ){
	new
	    str[ 200 ],
		file[ 65 ]
	;
	format( file, sizeof file, "Vip/%s.ini", Nome( p ));
	if( DOF2_FileExists( file ) ){
		SistemaVip[ p ][ vipLevel ] = DOF2_GetInt( file, "Level" );
		SistemaVip[ p ][ vipTempo ] = DOF2_GetInt( file, "Tempo" );
		if( SistemaVip[ p ][ vipTempo ] <= gettime() ){
		    DOF2_RemoveFile( file );
	        SendClientMessage( p, -1, "{FFD700}[ Sistema Vip ] {FFFFFF}Sua conta vip expirou. Não perca tempo e continue recebendo benefícios exclusivos!" );
			return true;
		}
		new nvip[ 15 ];
	    if( SistemaVip[ p ][ vipLevel ] == PRATA ) nvip = "Prata";
	    else if( SistemaVip[ p ][ vipLevel ] == OURO ) nvip = "Ouro";
	    format( str, sizeof str, "{FFD700}[ Sistema Vip ] {FFFFFF}Sua conta VIP level: {FFD700}[ %s ] {FFFFFF}foi carregada com sucesso.", nvip );
	    SendClientMessage( p, -1, str );
	    format( str, sizeof str, "{FFD700}[ Sistema Vip ] {FFFFFF}Ainda lhe restam {FFD700}%d {FFFFFF}dias de conta vip.", ( ( ( SistemaVip[ p ][ vipTempo ] - gettime())/60 )/60 )/24 );
        SendClientMessage( p, -1, str );
	}
	return true;
}
stock VerificandoCarro(p,tipo){
    new nomev[56];
	if(tipo > 0){
		if(TipoCarro[p] == 1){
			_r[p] ++;
			if(_r[p] > 6)
			    _r[p] = 0;
			TextDrawHideForPlayer(p,TModelo[p]);
	        TextDrawSetPreviewModel(TModelo[p], Camionetes[_r[p]]);
	        TextDrawShowForPlayer(p,TModelo[p]);
	        format(nomev,sizeof nomev,"~g~$: %d",ValorCamionetes[_r[p]]);
	        TextDrawSetString(TValorV[p],nomev);
	        format(nomev,sizeof nomev,"~y~~h~%s",VeiculosNome[Camionetes[_r[p]]-400]);
	        TextDrawSetString(TNomeV[p],nomev);
	        TextDrawSetString(TClasseV[p],"~r~~h~Camionetes");
		}
	}
	else{
		if(TipoCarro[p] == 1){
			_r[p] --;
			if(_r[p] < 0)
			    _r[p] = 6;
			TextDrawHideForPlayer(p,TModelo[p]);
	        TextDrawSetPreviewModel(TModelo[p], Camionetes[_r[p]]);
	        TextDrawShowForPlayer(p,TModelo[p]);
	        format(nomev,sizeof nomev,"~g~$: %d",ValorCamionetes[_r[p]]);
	        TextDrawSetString(TValorV[p],nomev);
	        format(nomev,sizeof nomev,"~y~~h~%s",VeiculosNome[Camionetes[_r[p]]-400]);
	        TextDrawSetString(TNomeV[p],nomev);
	        TextDrawSetString(TClasseV[p],"~r~~h~Camionetes");
		}
	}
}

stock CriarTextoMenu(i){

    Login[i] = TextDrawCreate(267.000000, 137.000000, "Entrar");
	TextDrawBackgroundColor(Login[i], 255);
	TextDrawFont(Login[i], 2);
	TextDrawLetterSize(Login[i], 0.549999, 2.399999);
	TextDrawColor(Login[i], -1);
	TextDrawSetOutline(Login[i], 0);
	TextDrawSetProportional(Login[i], 1);
	TextDrawSetShadow(Login[i], 1);
	TextDrawUseBox(Login[i], 1);
	TextDrawBoxColor(Login[i], 255);
	TextDrawTextSize(Login[i], 347.000000, 20.000000);

	Fundo[i] = TextDrawCreate(0.000000, 0.000000, "I");
	TextDrawBackgroundColor(Fundo[i], 255);
	TextDrawFont(Fundo[i], 1);
	TextDrawLetterSize(Fundo[i], 0.500000, 50.099998);
	TextDrawColor(Fundo[i], 255);
	TextDrawSetOutline(Fundo[i], 0);
	TextDrawSetProportional(Fundo[i], 1);
	TextDrawSetShadow(Fundo[i], 1);
	TextDrawUseBox(Fundo[i], 1);
	TextDrawBoxColor(Fundo[i], 255);
	TextDrawTextSize(Fundo[i], 645.000000, 216.000000);

	Tutorial[i] = TextDrawCreate(258.000000, 174.000000, "Tutorial");
	TextDrawBackgroundColor(Tutorial[i], 255);
	TextDrawFont(Tutorial[i], 2);
	TextDrawLetterSize(Tutorial[i], 0.549998, 2.399998);
	TextDrawColor(Tutorial[i], -1);
	TextDrawSetOutline(Tutorial[i], 0);
	TextDrawSetProportional(Tutorial[i], 1);
	TextDrawSetShadow(Tutorial[i], 1);
	TextDrawUseBox(Tutorial[i], 1);
	TextDrawBoxColor(Tutorial[i], 255);
	TextDrawTextSize(Tutorial[i], 365.000000, 20.000000);

	Credito[i] = TextDrawCreate(258.000000, 214.000000, "Creditos");
	TextDrawBackgroundColor(Credito[i], 255);
	TextDrawFont(Credito[i], 2);
	TextDrawLetterSize(Credito[i], 0.549998, 2.399998);
	TextDrawColor(Credito[i], -1);
	TextDrawSetOutline(Credito[i], 0);
	TextDrawSetProportional(Credito[i], 1);
	TextDrawSetShadow(Credito[i], 1);
	TextDrawUseBox(Credito[i], 1);
	TextDrawBoxColor(Credito[i], 255);
	TextDrawTextSize(Credito[i], 366.000000, 20.000000);

	Saindo[i] = TextDrawCreate(281.000000, 255.000000, "Sair");
	TextDrawBackgroundColor(Saindo[i], 255);
	TextDrawFont(Saindo[i], 2);
	TextDrawLetterSize(Saindo[i], 0.549998, 2.399998);
	TextDrawColor(Saindo[i], -1);
	TextDrawSetOutline(Saindo[i], 0);
	TextDrawSetProportional(Saindo[i], 1);
	TextDrawSetShadow(Saindo[i], 1);
	TextDrawUseBox(Saindo[i], 1);
	TextDrawBoxColor(Saindo[i], 255);
	TextDrawTextSize(Saindo[i], 333.000000, 20.000000);

}
stock IsNumeric(const string[])
{
    for (new i = (string[0] == 0x2D && string[1] ? 1 : 0),j = strlen(string); i < j; i++)
    {
            if (string[i] > 0x39 || string[i] < 0x30) return false;
    }
    return true;
}
stock DestruirTextoVeiculo(p){

    Selecionando[p] = false;
    CancelSelectTextDraw(p);

	TextDrawHideForPlayer(p,TModelo[p]);
	TextDrawHideForPlayer(p,TSetaE[p]);
	TextDrawHideForPlayer(p,TSetaD[p]);
	TextDrawHideForPlayer(p,TNomeV[p]);
	TextDrawHideForPlayer(p,TValorV[p]);
	TextDrawHideForPlayer(p,TClasseV[p]);
	TextDrawHideForPlayer(p,TMenuV[p]);
	TextDrawHideForPlayer(p,TComprarV[p]);
	
	TextDrawDestroy(TModelo[p]);
	TextDrawDestroy(TSetaE[p]);
	TextDrawDestroy(TSetaD[p]);
	TextDrawDestroy(TNomeV[p]);
	TextDrawDestroy(TValorV[p]);
	TextDrawDestroy(TClasseV[p]);
	TextDrawDestroy(TMenuV[p]);
	TextDrawDestroy(TComprarV[p]);

}
stock CarregarPickups(){

	CreatePickup(1318,1,-2765.9456,375.5168,6.3347,0);//pref
	Create3DTextLabel("{FFD700}[ Prefeitura ]\n{E0FFFF}Para entrar aperte {FFD700}' F '\n{E0FFFF}Ou digite {FFD700}' ENTER '",-1,-2765.9456,375.5168,6.3347,50,0,1);

	CreatePickup(1210, 1,362.5911,173.4854,1008.3828,0);
	Create3DTextLabel("{FFC1C1}[ Emprego ]\n{E0FFFF}Para candidatar-se a uma vaga aperte {FFC1C1}' F '",-1,362.5911,173.4854,1008.3828,30,0,1);
}
stock CriarTextoVeiculo(p){

	TModelo[p] = TextDrawCreate(38.000000, 130.000000, "_");
	TextDrawBackgroundColor(TModelo[p], 100);
	TextDrawFont(TModelo[p], 5);
	TextDrawLetterSize(TModelo[p], 0.500000, 1.000000);
	TextDrawColor(TModelo[p], -1);
	TextDrawSetOutline(TModelo[p], 0);
	TextDrawSetProportional(TModelo[p], 1);
	TextDrawSetShadow(TModelo[p], 0);
	TextDrawUseBox(TModelo[p], 1);
	TextDrawBoxColor(TModelo[p], 255);
	TextDrawTextSize(TModelo[p], 190.000000, 155.000000);
	TextDrawSetPreviewModel(TModelo[p], 400);
	TextDrawSetPreviewRot(TModelo[p], -16.000000, 0.000000, -55.000000, 1.000000);

	TSetaE[p] = TextDrawCreate(46.000000, 260.000000, "ld_beat:left");
	TextDrawBackgroundColor(TSetaE[p], 255);
	TextDrawFont(TSetaE[p], 4);
	TextDrawLetterSize(TSetaE[p], 0.500000, 1.000000);
	TextDrawColor(TSetaE[p], -1);
	TextDrawSetOutline(TSetaE[p], 0);
	TextDrawSetProportional(TSetaE[p], 1);
	TextDrawSetShadow(TSetaE[p], 1);
	TextDrawUseBox(TSetaE[p], 1);
	TextDrawBoxColor(TSetaE[p], 255);
	TextDrawTextSize(TSetaE[p], 19.000000, 17.000000);

	TSetaD[p] = TextDrawCreate(197.000000, 260.000000, "ld_beat:right");
	TextDrawBackgroundColor(TSetaD[p], 255);
	TextDrawFont(TSetaD[p], 4);
	TextDrawLetterSize(TSetaD[p], 0.879998, 1.000000);
	TextDrawColor(TSetaD[p], -1);
	TextDrawSetOutline(TSetaD[p], 0);
	TextDrawSetProportional(TSetaD[p], 1);
	TextDrawSetShadow(TSetaD[p], 1);
	TextDrawUseBox(TSetaD[p], 1);
	TextDrawBoxColor(TSetaD[p], 255);
	TextDrawTextSize(TSetaD[p], 19.000000, 17.000000);

	TNomeV[p] = TextDrawCreate(102.000000, 263.000000, "~y~~h~nome veiculo");
	TextDrawBackgroundColor(TNomeV[p], 255);
	TextDrawFont(TNomeV[p], 2);
	TextDrawLetterSize(TNomeV[p], 0.209999, 0.899999);
	TextDrawColor(TNomeV[p], -1);
	TextDrawSetOutline(TNomeV[p], 0);
	TextDrawSetProportional(TNomeV[p], 1);
	TextDrawSetShadow(TNomeV[p], 1);

	TValorV[p] = TextDrawCreate(166.000000, 133.000000, "~g~$:1000.000");
	TextDrawBackgroundColor(TValorV[p], 255);
	TextDrawFont(TValorV[p], 3);
	TextDrawLetterSize(TValorV[p], 0.300000, 0.899999);
	TextDrawColor(TValorV[p], -1);
	TextDrawSetOutline(TValorV[p], 0);
	TextDrawSetProportional(TValorV[p], 1);
	TextDrawSetShadow(TValorV[p], 1);

	TClasseV[p] = TextDrawCreate(46.000000, 133.000000, "~r~~h~sportivo");
	TextDrawBackgroundColor(TClasseV[p], 255);
	TextDrawFont(TClasseV[p], 2);
	TextDrawLetterSize(TClasseV[p], 0.259999, 1.000000);
	TextDrawColor(TClasseV[p], -1);
	TextDrawSetOutline(TClasseV[p], 0);
	TextDrawSetProportional(TClasseV[p], 1);
	TextDrawSetShadow(TClasseV[p], 1);

	TMenuV[p] = TextDrawCreate(40.000000, 287.000000, "menu");
	TextDrawBackgroundColor(TMenuV[p], 255);
	TextDrawFont(TMenuV[p], 2);
	TextDrawLetterSize(TMenuV[p], 0.359999, 1.299998);
	TextDrawColor(TMenuV[p], 0x6495EDFF);
	TextDrawSetOutline(TMenuV[p], 0);
	TextDrawSetProportional(TMenuV[p], 1);
	TextDrawSetShadow(TMenuV[p], 1);
	TextDrawUseBox(TMenuV[p], 1);
	TextDrawBoxColor(TMenuV[p], 0);
	TextDrawTextSize(TMenuV[p], 81.000000, 20.000000);

	TComprarV[p] = TextDrawCreate(159.000000, 287.000000, "comprar");
	TextDrawBackgroundColor(TComprarV[p], 255);
	TextDrawFont(TComprarV[p], 2);
	TextDrawLetterSize(TComprarV[p], 0.359999, 1.299998);
	TextDrawColor(TComprarV[p], 0x6495EDFF);
	TextDrawSetOutline(TComprarV[p], 0);
	TextDrawSetProportional(TComprarV[p], 1);
	TextDrawSetShadow(TComprarV[p], 1);
	TextDrawUseBox(TComprarV[p], 1);
	TextDrawBoxColor(TComprarV[p], 0);
	TextDrawTextSize(TComprarV[p], 236.000000, 20.000000);

    Selecionando[p] = true;
	TextDrawSetSelectable(TSetaE[p], true);
	TextDrawSetSelectable(TSetaD[p], true);
	TextDrawSetSelectable(TMenuV[p], true);
	TextDrawSetSelectable(TComprarV[p], true);
	TextDrawShowForPlayer(p,TModelo[p]);
	TextDrawShowForPlayer(p,TSetaE[p]);
	TextDrawShowForPlayer(p,TSetaD[p]);
	TextDrawShowForPlayer(p,TNomeV[p]);
	TextDrawShowForPlayer(p,TValorV[p]);
	TextDrawShowForPlayer(p,TClasseV[p]);
	TextDrawShowForPlayer(p,TMenuV[p]);
	TextDrawShowForPlayer(p,TComprarV[p]);
	SelectTextDraw(p, 0xFF0000FF);

}
stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}