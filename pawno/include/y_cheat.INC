/*

		<><><>Anti Cheat<><><>
		<><><>  Yiakin  <><><>
		<><><>22/01/2014<><><>



*/

//includes
#include <	a_samp	>


//defines

#undef 	MAX_PLAYERS
#define MAX_PLAYERS   (	151	)

//news

new 
	bool:y_adminAviso,
	y_punicao, // 1 = kick .. 2 = ban
	y_veiculo[ MAX_PLAYERS ],
	y_tempo[ MAX_PLAYERS ]

;

//forwards

forward y_AntiCheat();
forward CheatEncontrado( playerid );
forward y_Fudeo( playerid );
forward y_OnPlayerConnect( playerid );
forward y_OnPlayerStateChange( playerid, newstate, oldstate );
//publics

public OnFilterScriptInit(){

	y_adminAviso = true;
	y_punicao = 1;
	printf( "Anti Cheat iniciado com sucesso\nAutor: Yiakin_Ruffles" );

}
public OnPlayerConnect( playerid ){
	y_tempo[ playerid ] = 0;
	y_veiculo[ playerid ] = -1;
	return CallRemoteFunction( "OnPlayerConnect", "i", playerid );
}
public OnPlayerStateChange( playerid, newstate, oldstate ){
	if( newstate == 2 ){
		if( y_veiculo[ playerid ] ^ -1 ){
			if( y_veiculo[ playerid ] ^ GetPlayerVehicleID( playerid ) ){
				if( gettime() < y_tempo[ playerid ] ){
					CheatEncontrado( playerid );	
				}
			}
		}
		y_tempo[ playerid ] = gettime() + 1;
		y_veiculo[ playerid ] = GetPlayerVehicleID( playerid );
	}			
	return CallRemoteFunction( "OnPlayerStateChange", "iii", playerid, newstate, oldstate );
}
public CheatEncontrado( playerid ){
	new 
		y_str[ 128 ],
		y_nome[ 25 ]
	;
	GetPlayerName( playerid, y_nome, sizeof y_nome );
	if( y_adminAviso == true ){
		if( y_punicao == 1 ){//kick
			format( y_str, sizeof y_str, "[ {00FFFF}y_AntiCheat ] {FFFFFF}O player %s foi kickado suspeita de: {00FFFF} CarSpawner",y_nome );
		}
		else{//ban
			format( y_str, sizeof y_str, "[ {00FFFF}y_AntiCheat ] {FFFFFF}O player %s foi banido suspeita de: {00FFFF} CarSpawner",y_nome );
		}
		SendClientMessageToAll( -1, y_str );
	}
	SetTimerEx( "y_Fudeo", 500, false, "d", playerid );
}
public y_Fudeo( playerid ){

	if( y_punicao == 1 )
		Kick( playerid );
	else 
		Ban( playerid );
}