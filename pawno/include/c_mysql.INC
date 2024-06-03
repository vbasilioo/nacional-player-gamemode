#include <	a_samp	>
#include <	a_mysql	>


/*#define  d_host  "107.190.143.90"
#define  d_user  "bpcity_root"
#define  d_senha  "BHvF1M#pU^*N"
*/
#define  d_banco  "bpcity_erp"

#define		d_user		"admin"
#define		d_senha		"08229040"
#define		d_host		"localhost"

//id, org_id, org_name, leader_name org_color

new 
	d_mysql
;

forward AtualizarLider( gangid, gangnome[], nomelider[] );
forward ConexaoMySQL();
forward VerificarOrg( gangid, gangnome[], nomelider[] );
forward VerificarPlayer( nomeplayer[], senha[] );
forward d_VerificarPlayer( nomeplayer[], senha[] );
forward AtualizarPlayer( nomeplayer[], level, gender, money, bank, 
						phone, account_type, married_to[], time_played, job, kill, death, 
						respect, goldbar, organization_id, organization_position,
						skin, is_logged, AdminLevel, Lider, MV
					  	);
forward d_AtualizarPlayer( 	nomeplayer[], level, gender, money, bank, 
							phone, account_type, married_to[], time_played, job, kill, death, 
							respect, goldbar, organization_id, organization_position,
							skin, is_logged, AdminLevel, Lider, MV
					  	);
forward _GetSkin( playerid );
forward _SetSkin( playerid );
forward _GetInfoGZ( gz, p_name[], org );
forward _SetInfoGZ( gz, p_name[], org );


public ConexaoMySQL(){
	mysql_debug( 1 );
	d_mysql = mysql_connect( d_host, d_user, d_banco, d_senha );
}
public AtualizarLider( gangid, gangnome[], nomelider[] ){
	new query[ 500 ];
	format( query, sizeof( query ), "SELECT * FROM `leaders` WHERE `org_id` = '%d'", gangid );
	mysql_function_query( d_mysql, query, true, "VerificarOrg", "dss", gangid, gangnome, nomelider );
}
public VerificarPlayer( nomeplayer[], senha[] ){
      new query[500];
      format( query, sizeof query, "SELECT * FROM `accounts` WHERE `Nome` = '%s' AND `pKey` = '%s'", nomeplayer, senha );
      mysql_function_query(d_mysql,query,true,"d_VerificarPlayer", "ss", nomeplayer, senha );
}
public _GetInfoGZ( gz, p_name[], org ){
	new
		query[ 200 ],
		gzname[ 30 ]
	;
	switch( gz ){
		case 1: gzname = "Pista";
		case 2: gzname = "Parque Gleen";
		case 3: gzname = "Casarão";
	}
	format( query, sizeof query, "SELECT * FROM `territories` WHERE `territory_name` = '%s'", gzname );
	mysql_function_query( d_mysql, query, true, "_SetInfoGZ", "dsd", gz, p_name, org );
}
public _SetInfoGZ( gz, p_name[], org ){
	new
		rows,
		fields,
		gzname[ 30 ],
		query[ 200 ]
	;
	switch( gz ){
		case 1: gzname = "Pista";
		case 2: gzname = "Parque Gleen";
		case 3: gzname = "Casarão";
	}
	cache_get_data( rows, fields );
	if( rows ){
		format( query, sizeof query, "UPDATE `territories` SET `owner_id` = '%d', `player_name` = '%s' WHERE `territory_name` = '%s' ", org, p_name, gzname );
		mysql_function_query( d_mysql, query, false, "", "" );
		printf( "Gangzone %s atualizada com sucesso!", gzname );
	}
	else
		printf( "DB não encontrada, por isso os dados não foram salvos." );
}
public _GetSkin( playerid ){

	new query[ 500 ], nomeconta[ 25 ];
	GetPlayerName( playerid, nomeconta, sizeof nomeconta );
	format( query, sizeof query, "SELECT * FROM `accounts` WHERE `Nome` = '%s'", nomeconta );
	mysql_function_query( d_mysql, query, true, "_SetSkin", "d", playerid );
}
public _SetSkin( playerid ){
	new r, f, tmp[ 64 ];
	cache_get_data( r, f );
	if( r ){
		cache_get_field_content( 0, "skin", tmp );
		SetPlayerSkin( playerid, strval( tmp ) );
	}
}
public d_VerificarPlayer( nomeplayer[], senha[] ){
	new r,f, query[500];
	cache_get_data(r,f);
	if( r ){
		printf( "A conta %s já consta em nosso Banco de Dados", nomeplayer );
	}
	else{
		format(query, sizeof query, "INSERT INTO `accounts` ( Nome, pKey ) VALUES ( '%s', '%s' ) ", nomeplayer, senha );
		mysql_function_query( d_mysql, query, false, "", "" ); 
		printf("Conta MySQL criada: %s", nomeplayer );
	}

}
public AtualizarPlayer( nomeplayer[], level, gender, money, bank, 
						phone, account_type, married_to[], time_played, job, kill, death, 
						respect, goldbar, organization_id, organization_position,
						skin, is_logged, AdminLevel, Lider, MV
					  ){

	new query[500];
	format( query, sizeof query, "SELECT * FROM `accounts` WHERE `Nome` = '%s'", nomeplayer );
	mysql_function_query( d_mysql, query, true, "d_AtualizarPlayer", "sdddddsdddddddddddddd",
							nomeplayer, level, gender, money, bank,
							phone, account_type, married_to, time_played, job, 
							kill, death, respect, goldbar, organization_id, organization_position,
							skin, is_logged, AdminLevel, Lider, MV );
}
public d_AtualizarPlayer( 	nomeplayer[], 	level, 			gender, 		money, 				bank,
							phone, 			account_type, 	married_to[], 	time_played, 		job, 
							kill, 			death, 			respect, 		goldbar, 			organization_id, 	
							organization_position,
							skin, 			is_logged, 		AdminLevel, 	Lider, 				MV
						){

	new r,f, query[1000];
	cache_get_data( r, f );
	if( r ){
		format( query, sizeof query, 
		"UPDATE `accounts` SET `level` = '%d', `gender` = '%d', `money` = '%d', `bank` = '%d', `phone` = '%d', `account_type` = '%d', `married_to` = '%s',`time_played` = '%d', `job` = '%d', `kill` = '%d', `death` = '%d', `respect` = '%d', `goldbar` = '%d', `organization_id` = '%d',`organization_position` = '%d', `skin` = '%d', `is_logged` = '%d', `AdminLevel` = '%d', `Lider` = '%d', `MV` = '%d' WHERE `Nome` = '%s'",
		level, gender, money, bank,	phone, account_type, married_to, time_played, job, kill, death, respect, goldbar, 
		organization_id, organization_position,	skin, is_logged, AdminLevel, Lider, MV, nomeplayer );
		mysql_function_query( d_mysql, query, false, "", "" );
		printf( "Banco de Dados: Conta %s atualizada com sucesso!", nomeplayer );
	}
}
public VerificarOrg( gangid, gangnome[], nomelider[] ){
	new r,f,query[ 500 ];
	cache_get_data( r, f );
	if( r ){
	    format( query, sizeof( query ), "UPDATE `leaders` SET `leader_name` = '%s' WHERE `org_id` = '%d'", nomelider, gangid );
	    mysql_function_query( d_mysql, query, false, "", "" );
	}
	else{
	    new cor[ 10 ];
		switch( gangid ){
			case 1: cor = "#9999FF";
			case 2: cor = "#666699";
			case 3: cor = "#00660C";
			case 4: cor = "#CC6666";
			case 5: cor = "#109FFF";
			case 6: cor = "#20B2AA";
			case 7: cor = "#00688B";
			case 8: cor = "#A9A9A9";
			case 9: cor = "#FF9900";
			case 10: cor = "#66FFFF";
			case 11: cor = "#999966";
			case 12: cor = "#4682B4";
			case 13: cor = "#0000A0";
			case 14: cor = "#33FF00";
			case 15: cor = "#FFCC99";
			case 16: cor = "#ADD618";
			case 17: cor = "#9900CC";
			case 18: cor = "#FFFF33";
			case 19: cor = "#F60000";
			case 20: cor = "#CCFF99";
			case 21: cor = "#A80000";
			case 22: cor = "#209F86";
			case 23: cor = "#0063C6";
			case 24: cor = "#ADD8E6";
			case 25: cor = "#7356C2";
			case 26: cor = "#CCFF99";
			case 27: cor = "#FFFFFF";
			case 28: cor = "#4682B4";
			case 29: cor = "#FF1493";
			case 30: cor = "#ADFF2F";
			case 31: cor = "#D2691E";
			case 32: cor = "#27AE60";
			case 33: cor = "#F4A460";
			case 34: cor = "#FF4500";
			case 35: cor = "#A52A2A";
			case 36: cor = "#FFA500";
		}
        format( query, sizeof( query ), "INSERT INTO `leaders` ( org_id, org_name, leader_name, org_color  ) VALUES ( '%d', '%s', '%s', '%s' )", gangid, gangnome, nomelider, cor );
        mysql_function_query( d_mysql, query, false, "", "" );
        AtualizarLider( gangid, gangnome, nomelider );
	}
}
public OnQueryError(errorid, error[], callback[], query[], connectionHandle){
	printf("EID: %d | Error: %s | Query: %s", errorid, error, query);
	return 1;
}
