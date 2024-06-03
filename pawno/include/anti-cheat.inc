/*

	:::		Anti-Cheat 			:::

	::: 	Yiakin Ruffles 		:::

	:::		31/03/2014			:::


	OBSERVAÇÕES: Aconselhável usar como punição o Kick...

*/
#include 	<  a_samp  >
new
	y_punicao = 1,
	y_aviso = 1
;
new 
	VehicleID[ MAX_PLAYERS ]
;

stock _ALT_PutPlayerInVehicle( playerid,vehicle,position ){
    VehicleID[ playerid ] = vehicle;
    return PutPlayerInVehicle( playerid, vehicle, position );
}

stock _ALT_GivePlayerMoney( playerid, money ){
    return SetPVarInt( playerid, #money, ( GetPVarInt( playerid, #money ) + money ) ), GivePlayerMoney( playerid, money );
}


stock _ALT_ResetPlayerMoney( playerid ){
	return SetPVarInt( playerid, #money, 0 ), ResetPlayerMoney( playerid );
}


#define PutPlayerInVehicle 	_ALT_PutPlayerInVehicle
#define GivePlayerMoney 	_ALT_GivePlayerMoney
#define ResetPlayerMoney 	_ALT_ResetPlayerMoney

//=================== CALLBACKS ====================================

forward Punicao( playerid, punicao );
forward VerificarCar( playerid );
forward Loading( playerid );

public OnPlayerConnect( playerid ){
	VehicleID[ playerid ] = -1;
	SetTimerEx( "Loading", 3000, false, "d", playerid );
	#if defined Y_OnPlayerConnect
		Y_OnPlayerConnect( playerid );
	#endif

	return true;
}
public OnPlayerUpdate( playerid ){

	if( GetPVarInt( playerid, #money ) < GetPlayerMoney( playerid ) ){
		Cheat( playerid, "Money Hack" );
		ResetPlayerMoney( playerid );
	}
	else if( GetPVarInt( playerid, #money ) > GetPlayerMoney( playerid ) )
		SetPVarInt( playerid, #money, GetPlayerMoney( playerid ) );
	#if defined Y_OnPlayerUpdate
		Y_OnPlayerUpdate( playerid );
	#endif

	return true;
}
public OnPlayerSpawn( playerid ){

	#if defined Y_OnPlayerSpawn
		Y_OnPlayerSpawn( playerid );
	#endif

	return true;
}
public OnPlayerStateChange( playerid, newstate, oldstate ){
	if( newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER ){
		if( VehicleID[ playerid ] == -1 ){
			Cheat( playerid, "Car Spam" );
		}
		else{
			new vehicleid = GetPlayerVehicleID( playerid );
			VehicleID[ playerid ] = vehicleid;
			SetTimerEx( "VerificarCar", 99, false, "d", playerid );
		}
	}
	else if( newstate == PLAYER_STATE_ONFOOT && ( oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER ) ){
		VehicleID[ playerid ] = -1;
	}
	#if defined Y_OnPlayerStateChange
		Y_OnPlayerStateChange( playerid, newstate, oldstate );
	#endif
	return true;
}
public OnPlayerEnterVehicle( playerid, vehicleid, ispassenger ){
	VehicleID[ playerid ] = vehicleid;
	#if defined Y_OnPlayerEnterVehicle
		Y_OnPlayerEnterVehicle( playerid, vehicleid, ispassenger );
	#endif	
	return true;
}
public OnGameModeInit(){
	printf( "::::::: Anti Cheat by Yiakin :::::::" );
	#if defined Y_OnGameModeInit
		Y_OnGameModeInit();
	#endif
	return true;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Y_OnPlayerConnect
#if defined Y_OnPlayerConnect
    forward Y_OnPlayerConnect( playerid );
#endif

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Y_OnGameModeInit
#if defined Y_OnGameModeInit
    forward Y_OnGameModeInit();
#endif

#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange Y_OnPlayerStateChange
#if defined Y_OnPlayerStateChange
    forward Y_OnPlayerStateChange( playerid, newstate, oldstate );
#endif

#if defined _ALS_OnPlayerEnterVehicle
    #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle Y_OnPlayerEnterVehicle
#if defined Y_OnPlayerEnterVehicle
    forward Y_OnPlayerEnterVehicle( playerid, vehicleid, ispassenger );
#endif

#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Y_OnPlayerSpawn
#if defined Y_OnPlayerSpawn
    forward Y_OnPlayerSpawn( playerid );
#endif

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate Y_OnPlayerUpdate
#if defined Y_OnPlayerUpdate
    forward Y_OnPlayerUpdate( playerid );
#endif    
//=======================================================================================================================
Cheat( playerid, razao[] ){
	new
		y_name[ 25 ],
		y_str[ 128 ]
	;
	if( y_aviso == 1 ){
		GetPlayerName( playerid, y_name, sizeof y_name );
		if( y_punicao == 1 ){
			format( y_str, sizeof y_str, "{FFD700}»{708090} [ Anti Cheat ] %s foi kickado. Motivo: {FFD700}%s", y_name, razao );	
		}
		else{
			format( y_str, sizeof y_str, "{FFD700}»{708090} [ Anti Cheat ] %s foi banido. Motivo: {FFD700}%s", y_name, razao );	
		}
		SendClientMessageToAll( 0x828282FF, y_str );
	}
	SetTimerEx( "Punicao", 500, false, "dd", playerid, y_punicao );
}
public Punicao( playerid, punicao ){
	if( punicao == 1 )
		Kick( playerid ); 
	else
		Ban( playerid );
}
public VerificarCar( playerid ){
	if( IsPlayerInAnyVehicle( playerid ) ){
		if( GetPlayerVehicleID( playerid ) ^ VehicleID[ playerid ] )
			Cheat( playerid, "Car Spam" );
		else
			SetTimerEx( "VerificarCar", 99, false, "d", playerid );
	}
}
public Loading( playerid )
	SendClientMessage( playerid, 0x828282FF, "{FFD700}»{708090} Sistema de Anti Cheat ativo:{FFD700} By Yiakin" );
