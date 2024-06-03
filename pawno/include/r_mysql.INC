/*

	:::: 		Sistema de salvamento MySQL 	::::
	:::: 		Autor Yiakin Ruffles 			::::
	:::: 		Data 20/01/2014 				::::

*/

//Includes
#include <	a_samp	>
#include <	a_mysql >
#include <	  md5	>


//Defines
#define 	r_host	"localhost"
#define 	r_user	"r_user"
#define 	r_banco	"revolution"
#define 	r_senha	"r08229040"


//news
new 
	r_mysql,
	r_admin[ 50 ],
	r_dinheiro[ 50 ],
	r_level[ 50 ],
	bool:r_registrado[ 50 ]
;

//forwards
forward ConectarMySQL();
forward CriarConta( playerid, senhaplayer[] );
forward CarregarConta( playerid, senhaplayer[] );





//publics
public ConectarMySQL(){

	mysql_debug( 1 );
	r_mysql = mysql_connect( r_host, r_user, r_banco, r_senha );
	printf( "Sistema MySQL iniciado..." );
	return true;

}
public OnQueryError(errorid, error[], callback[], query[], connectionHandle){
	printf("EID: %d | Error: %s | Query: %s", errorid, error, query);
	return true;
}
public CarregarConta( playerid, senhaplayer[] ){

	new query[ 300 ], nomeplayer[ 25 ];
	GetPlayerName( playerid, nomeplayer, sizeof nomeplayer );
	format( query, sizeof( query ), "SELECT * FROM `players` WHERE `nome` = '%s' AND `senha` ", nomeplayer, MD5_Hash(senhaplayer) );
	mysql_function_query( r_mysql, query, true, "CriarConta", "ds", playerid, MD5_Hash(senhaplayer) );
	return true;
}
public CriarConta( playerid, senhaplayer[] ){

	new 
		row,
		field,
		nomeplayer[ 25 ]
	;
	cache_get_data( row, field );
	GetPlayerName( playerid, nomeplayer, sizeof nomeplayer );
	if( row ){
		new tmp[ 64 ];
		cache_get_field_content( 0, "dinheiro", tmp );
		r_dinheiro[ playerid ] = strval( tmp );
		cache_get_field_content( 0, "level", tmp );
		r_level[ playerid ] = strval( tmp );
		cache_get_field_content( 0, "admin", tmp );
		r_admin[ playerid ] = strval( tmp );
		printf("[ MySQL ] Conta Carregada: %s", nomeplayer );
		r_registrado[ playerid ] = true;
	}
	else{

		new query[ 500 ];
		format( query, sizeof( query ), "INSERT INTO `players` ( nome, senha ) VALUES ( '%s','%s' )", nomeplayer, senhaplayer );
		mysql_function_query( r_mysql, query, false, "", "" );
		printf( "[ MySQL ] Conta Criada: %s", nomeplayer );
		r_registrado[ playerid ] = false;
	}
} 