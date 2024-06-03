#include <a_samp>
#include <timerfix>
#include <DOF2>
#include <Pawn.CMD>
#include <streamer>
#include <foreach>
#include <sscanf2>
// #include <mailer>
#include <PreviewModelDialog>
#include <TextDraw>
#include <FCNPC>
#include <mapandreas>
#include <scrpvoz>

#define MODO_DESENVOLVIMENTO

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
// DIALOGS
enum {
	DIALOG_REGISTRO,
	DIALOG_LOGIN,
	DIALOG_UTILITARIOS,
	DIALOG_SEMPARAR,
	DIALOG_IDENTIDADE,
	DIALOG_ADMIN_LEVEL,
	DIALOG_CONCE,
	DIALOG_ADMINS,
	DIALOG_VER_CHAVEIRO
}
// PASTAS DOF2
#define PASTA_CONTAS 				"Contas/%s.ini"
#define PASTA_CARROS				"Carros/%i.ini"
#define PASTA_CONTADOR_CARROS		"Carros/Count.ini"
#define PASTA_PLACAS_CARROS			"Carros/Placas.ini"
#define PASTA_CHAVEIROS				"Chaveiros/%i.ini"
#define PASTA_CONTADOR_CHAVEIROS	"Chaveiros/Count.ini"
// FIM PASTAS DOF2

// DEFINES ????
#define RETIRAR_KM  				5                            //- A Cada 2 KM ,retirar 1 de gasolina
#define MAX_OBJ                 	800
#define DISTANCIA_FALA				8
// FIM DEFINES ????

//DEFINES PAINEL ADMIN
#define MAX_ADMINS					15
new Iterator:Admins<MAX_ADMINS>;

#define COR_PAINEL_ADMIN			0xC7FCED
#define MAX_PAINEL_ID				4

#define PAINEL_GERAL_ID				0
#define PAINEL_DANO_ID				1
#define PAINEL_FERIDO_ID			2
#define PAINEL_LOGIN_ID				3

new bool:painelDesativado[MAX_PLAYERS][MAX_PAINEL_ID];
//FIM PAINEL ADMIN

// Animais

new Float:PosBot[3][99];

#define START_NPCS 8 // spawnando..
#define START_ZO 4
forward CreateNPC();
forward CreateZo();
forward DestroyNPC(npcid);
forward DestroyZo(npcid);

enum E_NPC {
	bool:E_VALID,
	E_MOVE_STAGE,
};

new Float:ZPos[][5] = { // Spawn de zombies.
	{-1628.1510,-2708.1997,48.5391},
	{-1617.2350,-2704.0098,48.5391},
	{-1606.2008,-2730.6279,48.5391},
	{-1594.0078,-2711.4553,48.5391},
	{-1589.6460,-2721.5396,48.5391}
};

new gNpc[MAX_PLAYERS][E_NPC];

new Float:gSpawns[][6] = {
	{-1448.2201,-2695.4109,56.2828},
	{-1684.3892,-2522.5139,15.9711},
	{-1631.3473,-2116.7571,33.9283},
	{-1359.9467,-2351.5593,36.2366},
	{-2048.0698,-2400.0938,30.6250},
	{-1698.7736,-2524.4995,13.4907}
};

new gNpcCount;
new zNpcCount;
new cNpcCount;

new Float:gMovements[][23] = {
	{-1448.2201,-2695.4109,56.2828},
	{-1485.6549,-2636.6785,44.6452},
	{-1555.1622,-2660.2117,57.7974},
	{-1625.0858,-2651.8313,55.4968},
	{-1684.3892,-2522.5139,15.9711},
	{-1645.6062,-2588.0862,35.2569},
	{-1769.3599,-2501.3552,8.4596},
	{-1784.4550,-2415.5798,27.4285},
	{-1781.6736,-2317.1880,40.8253},
	{-1709.5640,-2194.9209,46.8216},
	{-1631.3473,-2116.7571,33.9283},
	{-1520.5828,-2168.5378,1.1241},
	{-1439.1204,-2131.2864,10.4084},
	{-1350.2668,-2257.9473,34.9197},
	{-1359.9467,-2351.5593,36.2366},
	{-1488.9425,-2384.1389,19.0593},
	{-1465.8959,-2492.5422,53.3547},
	{-1422.7822,-2590.5134,66.2437},
	{-1333.2473,-2584.3857,41.1397},
	{-1214.8077,-2637.4353,9.5463},
	{-1698.7736,-2524.4995,13.4907},
	{-1701.9651,-2565.0698,15.7423},
	{-1720.8199,-2556.6238,11.8541}
};

// FIM ANIMAIS

new sstring[300];

#define 	SendClientFormat(%1,%2,%3,%4) do{format(sstring,sizeof(sstring),%3,%4);SendClientMessage(%1,%2,sstring);}while(IsPlayerConnected(-1))
#define   	IsStringIgual(%1,%2) strcmp(%1, %2, true) == 0

//DEFINES GRANA
#define     SetarGrana(%1, %2) Dados[%1][Dinheiro] = %2
#define     DarGrana(%1, %2) Dados[%1][Dinheiro] += %2
#define     TirarGrana(%1, %2) Dados[%1][Dinheiro] -= %2

//DEFINES MAILER
// #define MAILER_URL 					"SendMailer"
// #define EMAIL_SERVIDOR				"Email"

//DEFINES CORES
#define COR_ERRO 					0xFF4500FF

//DEFINES CONCE
#define CARROS 					    3
#define SPAWN_X 					528.3288
#define SPAWN_Y 					-1320.7841
#define SPAWN_Z 					17.2422
#define ANGULO 					    99.7823

//CORES PROFISSOES//
#define COR_SMS 					0xFFA500FF
#define COR_ADM						0x4169E1FF
#define COR_VERDE					0x32CD32FF
#define COR_BRANCO					0xFFFFFFFF
#define COR_VERMELHO 				0xFF0000FF
#define COR_DUVIDA					0x00CED1FF

// TEXTDRAWS • SOMAS: Globais criadas: 34, Pessoais: 25
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Aviso[MAX_PLAYERS];
new Text:TextFerido[1];
// VELOCIMETRO
new Text:Velocimetro[4];
new blackmap;
// HUD
new PlayerText:Debug[MAX_PLAYERS][1];
new Text:Hud;
new PlayerText:HudP[MAX_PLAYERS][4];
// Menu dacing
new Text:dacing[1];
// ESTATISTICAS
new Text:EstG[18];
new PlayerText:EstP[MAX_PLAYERS][14];
new PlayerText:TextFeridoG[MAX_PLAYERS][2];

// New de Empregos
new Caixa[MAX_PLAYERS];
new Caixas[MAX_PLAYERS];
new Madeira[MAX_PLAYERS];
new Caixinha[MAX_PLAYERS];
new Minerando[MAX_PLAYERS];
//new Tronco;

// Torreta BobCat
new turret[MAX_VEHICLES][5];
new gunturret[MAX_VEHICLES];
new Carturret[MAX_VEHICLES];
new TurretCarPlayer[MAX_PLAYERS];
new weapons[13][2];
// Horse
new PlayerInHorse[MAX_PLAYERS];
new HorseForPlayer[MAX_PLAYERS];
//FORWARDS
forward Horas(playerid);
forward Sumiu(playerid);
forward AtualizarVelo(playerid);
forward MovimentHorse(npcid);
//FIM FORWARDS
// Workbench
new tipitem[MAX_PLAYERS][32];
new Cont[MAX_PLAYERS][6];
new PaginaWork[MAX_PLAYERS];
// Pontes
// Ponte 1 (destroços)
new ponte1d[15];
new Ponte1[4];
new C4[MAX_PLAYERS];
new C4F[1];

enum playerSC {
	bool:RegistroNaoConcluido,
	pSenhaInvalida,
	Senha,
	Matou,
	Morreu,
	Dinheiro,
	Tag,
	Celular,
	Creditos,
	Admin,
	UltimoLoginD,
	UltimoLoginA,
	UltimoLoginM,
	Vulneravel,
	EmBlindado,
	Ferido,
	Saude,
	Armadura,
	Fome,
	Sede,
	Chao,
	Animal,
	Turret,
	Cavalo,
	Follow,
	FollowTwo,
	FollowThre,
	FollowFour,
	PlayerFire,
	Zombie,
	mZombie,
	Braco,
	Peso,
	Mancando,
	Skin,
	bool:IniciouCair,
	MancandoKeyPress,
	Morto,
	// Variaveis de Habilidade:
	PH,
	Agilidade,
	Forca,
	Carisma,
	Destreza,
	Resistencia,
	Inteligencia,
	Defesa,
	Sabedoria,
	Sapiencia,
	Engenharia,
	Talento,
	Power,
	Itwork[32],
	points,
	// FIM
	Level
}
// NEWS INVI
new TodosPlayers[MAX_PLAYERS][50];
new ItemVender[MAX_PLAYERS] = {-1, ...};
new Erquivo[41];
new Arquivo[41];
enum iInfo{
	iSlot,
	iUnidades,
}
enum aInfo{

	aModel,
	aSlot,
	aLocal,
	Float:aX,
	Float:aY,
	Float:aZ,
	Float:aRX,
	Float:aRY,
	Float:aRZ,
	Float:aTX,
	Float:aTY,
	Float:aTZ
};
enum dItEnum
{
	Float:ObjtPos[3],
	ObjtID,
	droptTimer,
	droptWorld,
	Text3D:textt3d,
	ObjtData[2]
};
new AcessorioInfo[MAX_PLAYERS][10][aInfo];

new InventarioInfo[MAX_PLAYERS][75][iInfo];

new PaginaInventario[MAX_PLAYERS];
new ItemSelecionado[MAX_PLAYERS];
new MovendoInventario[MAX_PLAYERS];
new CombinandoInventario[MAX_PLAYERS];
new VendendoInv[MAX_PLAYERS];
new InventarioAberto[MAX_PLAYERS];
new VendedorInv[MAX_PLAYERS];
new ValorCompraInv[MAX_PLAYERS];
new dItemData[MAX_OBJ][dItEnum];

// Defines de itens
#define ITEM_DINHEIRO 1212
#define ITEM_CHAVEIRO 2680
#define CAVALO 6
#define CAPA3 19141
#define CAPA2 19514
#define CAPA1 19101
#define CHAPEU 19100
#define COLETE0 19904
#define COLETE1 19515
#define COLETE2 373
#define COLETE3 19142
#define MOCHILA1 19559
#define MOCHILA2 3026
#define MOCHILA3 371
#define RADIO 2966
new Iten[MAX_PLAYERS];
new Ut[MAX_PLAYERS][12];
new uItem[MAX_PLAYERS][12];
new VidaItem[MAX_PLAYERS][8];

// FIM INV

new bool:Logado[MAX_PLAYERS];
new Float:Vuln[MAX_VEHICLES];
new vehEngine[MAX_VEHICLES];
new Gas[MAX_VEHICLES];
new Float:velokm[3], Retirada[500];
new Feridoo[MAX_PLAYERS]; // Condicional multi uso, usadas atualmente: Feridoo[playerid] = 1.
new StyleWalk[MAX_PLAYERS];
new NoFuel[MAX_PLAYERS];
new motor[MAX_PLAYERS];
new Dados[MAX_PLAYERS][playerSC];
new fundido[MAX_VEHICLES];
new SemParar[MAX_PLAYERS];
new CancelaP[MAX_PLAYERS][6];
new bool:PassouPedagio[MAX_PLAYERS];
new Calado[MAX_PLAYERS];
new Ausente[MAX_PLAYERS];
new TimerCalado[MAX_PLAYERS];
new bool:PlayerVelocimetro[MAX_PLAYERS];
new PlayerVelocimetroTimer[MAX_PLAYERS];
new Arrastando[MAX_PLAYERS];
// FIM News

// Carros
enum VeiculosConce {
	VeiculosID,
	VeiculoNome[28],
	Preco
};

new const VeiculosT[][VeiculosConce] =
{
	{400, "Landstalker", 35000},
	{401, "Bravura", 40000},
	{402, "Buffalo", 45000},
	{403, "Linerunner", 120000},
	{404, "Perennial", 30000},
	{405, "Sentinel", 28000},
	{408, "Trashmaster", 80000},
	{409, "Stretch", 60000},
	{410, "Manana", 60000},
	{411, "Infernus", 200000},
	{412, "Voodoo", 70000},
	{413, "Pony", 65000},
	{414, "Mule", 70000},
	{415, "Cheetah", 50000},
	{418, "Moonbeam", 50000},
	{419, "Esperanto", 50000},
	{421, "Washington", 50000},
	{422, "Bobcat", 50000},
	{424, "BF Injection", 50000},
	{426, "Premier", 50000},
	{429, "Banshee", 50000},
	{431, "Bus", 50000},
	{434, "Hotknife", 50000},
	{436, "Previon", 50000},
	{437, "Coach", 50000},
	{439, "Stallion", 50000},
	{440, "Rumpo", 50000},
	{442, "Romero", 50000},
	{445, "Admiral", 50000},
	{451, "Turismo", 50000},
	{455, "Flatbed", 50000},
	{456, "Yankee", 50000},
	{458, "Solair", 50000},
	{461, "PCJ-600", 50000},
	{462, "Faggio", 50000},
	{463, "Freeway", 50000},
	{466, "Glendale", 50000},
	{467, "Oceanic", 50000},
	{468, "Sanchez", 50000},
	{471, "Quad", 50000},
	{474, "Hermes", 50000},
	{475, "Sabre", 50000},
	{477, "ZR-350", 50000},
	{478, "Walton", 50000},
	{479, "Regina", 50000},
	{480, "Comet", 50000},
	{482, "Burrito", 50000},
	{483, "Camper", 50000},
	{489, "Rancher", 50000},
	{491, "Virgo", 50000},
	{492, "Greenwood", 50000},
	{494, "Hotring Racer", 50000},
	{495, "Sandking", 50000},
	{496, "Blista Compact", 50000},
	{498, "Boxville", 50000},
	{499, "Benson", 50000},
	{500, "Mesa", 50000},
	{502, "Hotring Racer A", 50000},
	{503, "Hotring Racer B", 50000},
	{505, "Rancher Lure", 50000},
	{506, "Super GT", 50000},
	{507, "Elegant", 50000},
	{508, "Journey", 50000},
	{514, "Tanker", 50000},
	{515, "Roadtrain", 50000},
	{516, "Nebula", 50000},
	{517, "Majestic", 50000},
	{518, "Buccaneer", 50000},
	{521, "FCR-900", 50000},
	{522, "NRG-500", 50000},
	{526, "Fortune", 50000},
	{527, "Cadrona", 50000},
	{529, "Willard", 50000},
	{533, "Feltzer", 50000},
	{534, "Remington", 50000},
	{535, "Slamvan", 50000},
	{536, "Blade", 50000},
	{539, "Vortex", 50000},
	{540, "Vincent", 50000},
	{541, "Bullet", 50000},
	{542, "Clover", 50000},
	{543, "Sadler", 50000},
	{545, "Hustler", 50000},
	{546, "Intruder", 50000},
	{547, "Primo", 50000},
	{550, "Sunrise", 50000},
	{551, "Merit", 50000},
	{554, "Yosemite", 50000},
	{555, "Windsor", 50000},
	{558, "Uranus", 50000},
	{559, "Jester", 50000},
	{560, "Sultan", 50000},
	{561, "Stratum", 50000},
	{562, "Elegy", 50000},
	{565, "Flash", 50000},
	{566, "Tahoma", 50000},
	{567, "Savanna", 50000},
	{568, "Bandito", 50000},
	{575, "Broadway", 50000},
	{576, "Tornado", 50000},
	{578, "DFT-30", 50000},
	{579, "Huntley", 50000},
	{580, "Stafford", 50000},
	{581, "BF-400", 50000},
	{585, "Emperor", 50000},
	{586, "Wayfarer", 50000},
	{587, "Euros", 50000},
	{589, "Club", 50000},
	{600, "Picador", 50000},
	{602, "Alpha", 50000},
	{603, "Phoenix", 50000}
};

new
vNames[212][] =
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider",
	"Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina",
	"Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood",
	"Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
	"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt", "Tanker", "RoadTrain",
	"Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
	"Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover",
	"Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster A",
	"Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer",
	"Kart", "Mower", "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer A", "Emperor",
	"Wayfarer", "Euros", "Hotdog", "Club", "Trailer B", "Trailer C", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)",
	"Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B",
	"Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
};

enum vehicleSC {
	idCar,
	modeloCar,
	latariaCar,
	blindagemCar,
	corCar[2],
	Float:posCar[4],
	placaCar[9]
}

new Veiculos[MAX_VEHICLES][vehicleSC];

// FIM Carros

// DEFINES Chaveiros
#define MAX_CHAVEIROS 50
#define MAX_CHAVES 5
#define SEM_CHAVE -1

#define CHAVE_CARRO 0
#define CHAVE_CASA 1

new const TipoChave[][15] = {"Veicular", "Residencial"};

enum chaveInfo {
	tipoC,
	idC,
	modeloC
}

new Chaveiros[MAX_CHAVEIROS][MAX_CHAVES][chaveInfo];
// FIM Chaveiros

// Radares
enum radarInfo {
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:Range,
	VelMax
}

new const Radares[][radarInfo] = {
	{182.3177, 59.5961, 2.0781, 15.0, 80}, // Radar Enfrete CBM / 80
	{298.5910, 66.7897, 2.5316, 15.0, 80}, // Radar Enfrete CBM / 80
	{398.6557, -143.2742, 6.7009, 15.0, 60}, // Radar Entra Blue 60
	{254.7233, -371.9756, 8.7554, 15.0, 60}, // Radar Entrada Blue 60
	{18.4239, -208.1157, 1.4912, 15.0, 60}, // Radar Entrada Blue 60
	{527.6857, 64.7874, 20.7683, 15.0, 80}, // Radar 80
	{612.1963, -415.0883, 18.5009, 15.0, 50}, // Radar entrada dillimore 50
	{682.5063, -737.6283, 17.7051, 15.0, 50}, // Radar 50
	{345.3249, -820.6894, 11.0581, 15.0, 60}, // Radar 60
	{913.1262, -176.4292, 10.5226, 15.0, 80}, // Radar 80
	{1255.1705, -359.2732, 3.5446, 15.0, 80}, // Radar 80
	{1225.4749, -419.2538, 5.2206, 15.0, 80}, // Radar 80
	{1282.0205, -94.8134, 37.0577, 15.0, 80}, // Radar 80
	{1238.5581, 55.2115, 23.3391, 15.0, 50}, // Radar 50
	{1462.6704, 174.9424, 25.9608, 15.0, 60}, // Radar 60
	{1281.5143, 494.1567, 19.8828, 15.0, 80}, // Radar 80
	{1516.1919, 389.6364, 19.8828, 15.0, 80}, // Radar 80
	{2199.3896, 228.6290, 14.4999, 15.0, 80} // Radar 80
};

new bool:dentroRadar[MAX_PLAYERS] = {false, ...};
// FIM Radares

// CARROS


// Dano Armas
#define TRONCO_ID 3
#define VIRILHA_ID 4
#define BRACO_ESQUERDO_ID 5
#define BRACO_DIREITO_ID 6
#define PERNA_ESQUERDA_ID 7
#define PERNA_DIREITA_ID 8
#define CABECA_ID 9

#define QUEDA_ID 54
#define ATROPELAMENTO_ID 49

enum arma {
	nomeArma[50],
	bool:isArmaDeFogo,
	dCabeca,
	dTronco,
	dBraco,
	dVirilha,
	dPerna
}

new const armaInfo[][arma] = {
	{"Punhos", false, 2, 2, 2, 2, 2},
	{"Soco Inglês", false, 0, 0, 0, 0, 0},
	{"Taco de Golf", false, 0, 0, 0, 0, 0},
	{"Cassetete", false, 0, 0, 0, 0, 0},
	{"Faca", false, 0, 0, 0, 0, 0},
	{"Bastão", false, 0, 0, 0, 0, 0},
	{"Pá", false, 0, 0, 0, 0, 0},
	{"Taco", false, 0, 0, 0, 0, 0},
	{"Espada", false, 0, 0, 0, 0, 0},
	{"Moto Serra", false, 0, 0, 0, 0, 0},
	{"Dildo 1", false, 0, 0, 0, 0, 0},
	{"Dildo 2", false, 0, 0, 0, 0, 0},
	{"Vibrador", false, 0, 0, 0, 0, 0},
	{"Inválida", false, 0, 0, 0, 0, 0},
	{"Buquê de Flores", false, 0, 0, 0, 0, 0},
	{"Bengala", false, 0, 0, 0, 0, 0},
	{"Granada", false, 0, 0, 0, 0, 0},
	{"Bomba de Gás", false, 0, 0, 0, 0, 0},
	{"Molotov", false, 0, 0, 0, 0, 0},
	{"Inválida", false, 0, 0, 0, 0, 0},
	{"Inválida", false, 0, 0, 0, 0, 0},
	{"Inválida", false, 0, 0, 0, 0, 0},
	{"Beretta .9mm", true, 5, 5, 5, 2, 2}, // 9mm
	{"Beretta Silenciada .9mm", true, 5, 5, 5, 2, 2}, // 9mm com silenciador
	{"Revólver .38", true, 10, 10, 10, 5, 5}, // Desert
	{"Espingarda .12", true, 15, 15, 15, 5, 5}, // Shotgun padrão
	{"Sparta 100", true, 0, 0, 0, 0, 0}, // Shotgun cano serrado
	{"Franchi .12", true, 0, 0, 0, 0, 0}, // Escopeta de Combat,
	{"Uzi 9mm", true, 5, 5, 5, 2, 2}, // UZI
	{"Heckler & Koch", true, 10, 10, 10, 5, 5}, // MP5
	{"AK 47", true, 15, 15, 15, 5, 5},
	{"M16A2", true, 20, 20, 20, 10, 10}, // M4
	{"Intratec TEC-9", true, 10, 10, 10, 5, 5},
	{"Rifle de Caça", true, 10, 10, 10, 5, 5},
	{"SVD", true, 20, 20, 20, 10, 10}, // Sniper
	{"Rocket Launcher", false, 0, 0, 0, 0, 0},
	{"Rocket Launcher HS", false, 0, 0, 0, 0, 0},
	{"Lança Chamas", false, 0, 0, 0, 0, 0},
	{"Minigun", true, 0, 0, 0, 0, 0},
	{"Bomba Adesiva", false, 0, 0, 0, 0, 0},
	{"Detonador", false, 0, 0, 0, 0, 0},
	{"Lata de Spray", false, 0, 0, 0, 0, 0},
	{"Extintor", false, 0, 0, 0, 0, 0},
	{"Camêra", false, 0, 0, 0, 0, 0},
	{"Oculos 1", false, 0, 0, 0, 0, 0},
	{"Oculos 2", false, 0, 0, 0, 0, 0},
	{"Para-Quedas", false, 0, 0, 0, 0, 0},
	{"Inválida", false, 0, 0, 0, 0, 0},
	{"Inválida", false, 0, 0, 0, 0, 0},
	{"Veiculo", false, 10, 10, 10, 10, 10}
};
// FIM DANO ARMAS

main()
{
	print("========================\n");
	print("  Last Day On Earth - RP\n");
	print("     GM Iniciada\n");
	print("========================\n");
}

new SV_TELEFONE:telefone[MAX_PLAYERS] = { SV_NULL, ... }; //
new SV_GSTREAM:gstream; // Global
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... }; // Local
new SV_SLSTREAM:slstream[MAX_PLAYERS] = { SV_NULL, ... }; // Veiculo
new SV_SSTREAM:sstream[MAX_PLAYERS] = { SV_NULL, ... }; // Microfone
public SV_VOID:OnPlayerActivationKeyPress( 	SV_UINT:playerid,SV_UINT:keyid)
{
	if (keyid == 0x58 && slstream[playerid]) SvAttachSpeakerToStream(slstream[playerid], playerid);
	if (keyid == 0x5A && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
 	if (keyid == 0x5A && sstream[playerid]) SvAttachSpeakerToStream(sstream[playerid], playerid);																									// • KEYS USADAS				    •
	if (keyid == 0x42 && gstream) SvAttachSpeakerToStream(gstream, playerid);
	if (keyid == 0x5A && telefone[playerid]) SvAttachSpeakerToStream(telefone[playerid], playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease( SV_UINT:playerid, SV_UINT:keyid)
{
	if (keyid == 0x58 && slstream[playerid]) SvDetachSpeakerFromStream(slstream[playerid], playerid);
	if (keyid == 0x5A && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
	if (keyid == 0x5A && sstream[playerid]) SvDetachSpeakerFromStream(sstream[playerid], playerid);
	if (keyid == 0x5A && telefone[playerid]) SvDetachSpeakerFromStream(telefone[playerid], playerid);
	if (keyid == 0x42 && gstream) SvDetachSpeakerFromStream(gstream, playerid);
}
stock EnviarMensagemPainel(msg[], painelid=PAINEL_GERAL_ID)
{
	new string[256];
	format(string, sizeof(string), "[PAINEL] %s", msg);
	foreach(new i : Admins)
	{
		if (!painelDesativado[i][painelid]) SendClientMessage(i, COR_PAINEL_ADMIN, string);
	}
}
stock GetCoordsInFront(Float:x, Float:y, Float:a, Float:distance, &Float:res_x, &Float:res_y)
{
	res_x = x + (distance * floatsin(-a, degrees));
	res_y = y + (distance * floatcos(-a, degrees));
}
stock DetonePonte1()
{
	for(new i; i < 4; i++)
	{
		DestroyObject(Ponte1[i]);
		DestroyObject(C4F[0]);
	}
	ponte1d[0] = CreateDynamicObject(3331, -1630.045654, -1630.782104, 31.830503, -22.926271, 7.101218, 115.139640, -1, -1, -1, 250.00, 250.00);
	ponte1d[1] = CreateDynamicObject(18450, -1630.615478, -1622.947387, 24.411626, -6.537750, -23.084974, 22.361457, -1, -1, -1, 250.00, 250.00);
	ponte1d[2] = CreateDynamicObject(18449, -1703.227172, -1651.839965, 18.534305, -10.598729, -26.502311, -159.752548, -1, -1, -1, 250.00, 250.00);
	ponte1d[3] = CreateDynamicObject(3331, -1697.110351, -1659.459960, 23.140237, 26.015935, -11.810048, 115.487472, -1, -1, -1, 250.00, 250.00);
	ponte1d[4] = CreateDynamicObject(16090, -1737.447631, -1667.191040, 35.813674, 0.000000, -97.399993, 20.699998, -1, -1, -1, 250.00, 250.00);
	ponte1d[5] = CreateDynamicObject(3098, -1737.938354, -1663.719970, 35.656890, 88.099975, 0.000000, 6.699999, -1, -1, -1, 250.00, 250.00);
	ponte1d[6] = CreateDynamicObject(3098, -1737.061157, -1666.800903, 35.719341, -86.699966, 0.000000, -79.200004, -1, -1, -1, 250.00, 250.00);
	ponte1d[7] = CreateDynamicObject(3098, -1736.355468, -1670.502807, 35.719341, -86.699966, 0.000000, -79.200004, -1, -1, -1, 250.00, 250.00);
	ponte1d[8] = CreateDynamicObject(18862, -1724.957397, -1664.536499, 34.311996, 5.599998, 29.599998, 8.399999, -1, -1, -1, 250.00, 250.00);
	ponte1d[9] = CreateDynamicObject(18862, -1594.380737, -1606.637573, 37.978214, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	ponte1d[10] = CreateDynamicObject(16090, -1598.434204, -1607.016479, 38.052349, 0.000000, 99.699981, 21.699998, -1, -1, -1, 250.00, 250.00);
	ponte1d[11] = CreateDynamicObject(3098, -1595.609985, -1607.463012, 39.082923, -71.100006, -2.200004, 0.000000, -1, -1, -1, 250.00, 250.00);
	ponte1d[12] = CreateDynamicObject(18726, -1662.631835, -1640.296264, 26.767013, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	ponte1d[12] = CreateDynamicObject(18726, -1662.631835, -1634.286254, 26.767013, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	ponte1d[14] = CreateDynamicObject(18726, -1662.631835, -1628.726318, 29.187017, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
}
forward ArrastarFerido(playerid);
public ArrastarFerido(playerid)
{
	if (Arrastando[playerid] == 5)
	{
		Feridoo[playerid] = 1;
		Arrastando[playerid]++;
		ApplyAnimation(playerid,"WUZI","CS_Dead_Guy",4.0,1,1,1,1,200,1);
  		SetTimerEx("ParrarDelayArrastando", 350, 0, "i", playerid);
		return 0;
	}
	if (Arrastando[playerid] > 5) return 0;

	Feridoo[playerid] = 0;
	if((GetPlayerState(playerid)==1&&GK(playerid,KEY_WALK))&& Dados[playerid][Agilidade] == 25 &&
	(GK(playerid,KEY_UP)||GK(playerid,KEY_DOWN)||GK(playerid,KEY_LEFT)||GK(playerid,KEY_RIGHT)))
	{

		SetTimerEx("ArrastarFerido", 200, 0, "i", playerid);
		Feridoo[playerid] = 1;
		Arrastando[playerid]++;
		ApplyAnimation(playerid,"PED","CAR_crawloutRHS",4.1,0,1,1,1,1,1);
	}
	else
	{

		Arrastando[playerid] = 0;
	}
	return 1;
}
stock GetPlayerSpeed(playerid,bool:kmh)
{
	new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
	rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
	return kmh?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}
/*stock TorretForCar(carid)
{
	DestroyObject(turret[carid]);
	DestroyObject(turret[carid]);
	DestroyObject(turret[carid]);
	DestroyObject(turret[carid]);
	DestroyObject(turret[carid]);
	DestroyObject(gunturret[carid]);
	Carturret[carid] = 0;
}*/
stock TorretForCar(carid)
{
	turret[carid][0] = CreateObject(19843,0.0,0.0,-1000.0,0.0,0.0,0.0,100);
	AttachObjectToVehicle(turret[carid][0], carid, 0.017, -0.294, 0.748, -91.100, 0.500, 0.000);
	turret[carid][1] = CreateObject(19843,0.0,0.0,-1000.0,0.0,0.0,0.0,100);
	AttachObjectToVehicle(turret[carid][1], carid, 0.629, -0.760, 1.016, -91.499, -13.300, 87.799);
	turret[carid][2] = CreateObject(19843,0.0,0.0,-1000.0,0.0,0.0,0.0,100);
	AttachObjectToVehicle(turret[carid][2], carid, -0.669, -0.747, 0.965, 2.100, -85.699, -22.200);
	gunturret[carid]= CreateObject(356,0.0,0.0,-1000.0,0.0,0.0,0.0,100);
	AttachObjectToVehicle(gunturret[carid], carid, -0.000, -0.500, 1.269, -2.500, 0.000, 90.799);
	turret[carid][3] = CreateObject(19843,0.0,0.0,-1000.0,0.0,0.0,0.0,100);
	AttachObjectToVehicle(turret[carid][3], carid, -0.949, -1.090, 0.519, 2.200, 86.899, 0.000);
	turret[carid][4] = CreateObject(19843,0.0,0.0,-1000.0,0.0,0.0,0.0,100);
	AttachObjectToVehicle(turret[carid][4], carid, 0.757, -1.222, 0.376, -89.099, 0.000, 101.000);
	Carturret[carid] = 1; // Veiculo equipado.
}
stock DestroyTorretCar(playerid)
{
	new carid = GetPlayerVehicleID(playerid);
	DestroyVehicle(carid);
 	DestroyObject(turret[carid][0]);
 	DestroyObject(turret[carid][1]);
 	DestroyObject(turret[carid][2]);
 	DestroyObject(turret[carid][3]);
 	DestroyObject(turret[carid][4]);
 	DestroyObject(gunturret[carid]);
}
stock AnexarItem(playerid) // Iten[playerid] | Homem de Inicio = 14 | Mulher de Inicio = 13 | Max = 8 | Sean = 310 | Sebastian = 305 | Nico = 7
{
	new Personation = GetPlayerSkin(playerid);
	if(Personation == 14) // Homem Inicial
	{
	 if(Iten[playerid] == 1) // Rádio
	 {
	 	SetPlayerAttachedObject(playerid, 0, 2966, 3, 0.147999, -0.018000, 0.067999, 166.700027, 174.199813, -95.599983, 0.731999, 0.772000, 1.000000);
	 }
	 if(Iten[playerid] == 2) // Mochila 1
	 {
	 	SetPlayerAttachedObject(playerid, 1, 19559, 15, 0.000000, 0.066999, -0.120999, 0.000000, 0.000000, 174.699981, 1.000000, 1.242000, 1.000000);
	 }
	 if(Iten[playerid] == 3) // Mochila 2
	 {
	 	SetPlayerAttachedObject(playerid, 1, 3026, 15, 0.012000, 0.097999, -0.374999, 24.000001, 85.400016, 162.199981, 1.000000, 1.083999, 1.113000);
	 }
	 if(Iten[playerid] == 4) // Mochila 3
	 {
	 	SetPlayerAttachedObject(playerid, 1, 371, 15, 0.022000, 0.186000, -0.165999, 0.000000, 0.000000, 165.899978, 1.000000, 1.000000, 1.000000);
	 }
	 if(Iten[playerid] == 5) // Chapeu
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19100, 2, 0.173000, 0.009000, -0.000999, 0.000000, 0.000000, 0.000000, 1.000000, 1.377999, 1.252001);
	 }
	 if(Iten[playerid] == 6) // Capacete 1
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19101, 2, 0.173999, 0.010000, -0.000999, 0.000000, 0.000000, 0.000000, 1.354000, 1.125999, 1.268000);
	 }
	 if(Iten[playerid] == 7) // Capacete 2
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.129999, 0.009000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.129001, 1.182001);
	 }
	 if(Iten[playerid] == 8) // Capacete 3
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19141, 2, 0.108999, 0.018000, 0.003000, 0.000000, 0.000000, 0.000000, 1.652999, 1.130999, 1.310000);
	 }
	 if(Iten[playerid] == 9) // Colete 0
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19904, 1, 0.079000, 0.036000, -0.009999, 0.000000, 87.100021, -170.399963, 1.096999, 1.304002, 1.019000);
	 }
	 if(Iten[playerid] == 10) // Colete 1
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.079999, 0.039999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.203999, 1.000000);
	 }
	 if(Iten[playerid] == 11) // Colete 2
	 {
	 	SetPlayerAttachedObject(playerid, 3, 373, 1, 0.263000, -0.011999, -0.181999, 72.300025, 32.900001, 37.200000, 1.000000, 1.000000, 0.971000);
	 }
	 if(Iten[playerid] == 12) // Colete 3
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19142, 1, 0.037000, 0.028000, 0.003000, 0.000000, 0.000000, 0.000000, 1.239000, 1.063000, 1.024000);
	 }
	}

	//
	if(Personation == 13) // Mulher Inicial
	{
	 if(Iten[playerid] == 1) // Rádio
	 {
	 	SetPlayerAttachedObject(playerid, 0, 2966, 3, 0.147999, 0.015000, 0.044999, 166.700027, 174.199813, -95.599983, 0.731999, 0.772000, 1.000000);
	 }
	 if(Iten[playerid] == 2) // Mochila 1
	 {
	 	SetPlayerAttachedObject(playerid, 1, 19559, 15, 0.013000, 0.042999, -0.161000, 0.000000, 0.000000, 166.999954, 0.771999, 1.094000, 1.000000);
	 }
	 if(Iten[playerid] == 3) // Mochila 2
	 {
	 	SetPlayerAttachedObject(playerid, 1, 3026, 15, -0.007000, 0.066000, -0.401999, -178.699935, 88.700004, 3.999998, 1.000000, 0.966000, 0.745999);
	 }
	 if(Iten[playerid] == 4) // Mochila 3
	 {
	 	SetPlayerAttachedObject(playerid, 1, 371, 15, 0.000000, 0.141000, -0.192000, 0.000000, 0.000000, 169.200012, 1.000000, 1.000000, 1.000000);
	 }
	 if(Iten[playerid] == 5) // Chapeu
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19100, 2, 0.205999, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.211999, 1.216000);
	 }
	 if(Iten[playerid] == 6) // Capacete 1
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19101, 2, 0.185999, -0.004999, 0.001999, 0.000000, 0.000000, 0.000000, 1.335000, 1.068000, 1.371000);
	 }
	 if(Iten[playerid] == 7) // Capacete 2
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.160000, -0.006000, 0.000000, 0.000000, 0.000000, 0.000000, 1.124999, 1.115999, 1.224999);
	 }
	 if(Iten[playerid] == 8) // Capacete 3
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19141, 2, 0.114999, 0.009000, 0.009999, 0.000000, 0.000000, 0.000000, 1.450999, 1.088000, 1.447001);
	 }
	 if(Iten[playerid] == 9) // Colete 0
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19904, 1, 0.134000, 0.066999, -0.004999, 0.000000, 85.600006, -177.200057, 1.000000, 1.067999, 0.779000);
	 }
	 if(Iten[playerid] == 10) // Colete 1
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.105000, 0.047999, 0.012000, 1.700004, 0.499995, 8.099994, 0.984999, 1.244005, 0.955999);
	 }
	 if(Iten[playerid] == 11) // Colete 2
	 {
	 	SetPlayerAttachedObject(playerid, 3, 373, 1, 0.294000, 0.051000, -0.143999, 79.900047, 30.299993, 35.700000, 0.800000, 0.816000, 0.851999);
	 }
	 if(Iten[playerid] == 12) // Colete 3
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19142, 1, 0.097999, 0.062999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	 }
	}
	//
	if(Personation == 8) // Max
	{
	 if(Iten[playerid] == 1) // Rádio
	 {
	 	SetPlayerAttachedObject(playerid, 0, 2966, 3, 0.147999, -0.018000, 0.067999, 166.700027, 174.199813, -95.599983, 0.731999, 0.772000, 1.000000);
	 }
	 if(Iten[playerid] == 2) // Mochila 1
	 {
	 	SetPlayerAttachedObject(playerid, 1, 19559, 15, 0.023000, 0.036000, -0.146999, 3.899998, -2.800005, 167.299911, 0.746000, 1.198000, 1.000000);
	 }
	 if(Iten[playerid] == 3) // Mochila 2
	 {
	 	SetPlayerAttachedObject(playerid, 1, 3026, 15, 0.000000, 0.104000, -0.397999, -11.799999, 90.099922, -158.299957, 1.000000, 1.019000, 0.806000);
	 }
	 if(Iten[playerid] == 4) // Mochila 3
	 {
	 	SetPlayerAttachedObject(playerid, 1, 371, 15, 0.017999, 0.154999, -0.182000, 8.099995, 0.000000, 171.699951, 1.000000, 1.000000, 1.000000);
	 }
	 if(Iten[playerid] == 5) // Chapeu
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19100, 2, 0.225000, 0.029000, 0.000000, 0.000000, 0.000000, 0.000000, 1.266000, 1.305000, 1.323000);
	 }
	 if(Iten[playerid] == 6) // Capacete 1
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19101, 2, 0.180999, 0.036999, 0.001000, 0.000000, 0.000000, 0.000000, 1.278999, 1.251000, 1.436000);
	 }
	 if(Iten[playerid] == 7) // Capacete 2
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.127999, 0.019999, 0.000000, -0.799999, 0.000000, 0.000000, 1.189000, 1.324000, 1.508001);
	 }
	 if(Iten[playerid] == 8) // Capacete 3
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19141, 2, 0.116000, 0.028000, 0.010000, 0.000000, 0.000000, 0.000000, 1.541000, 1.375000, 1.551000);
	 }
	 if(Iten[playerid] == 9) // Colete 0
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19904, 1, 0.136000, 0.045999, 0.000000, 0.400000, 87.399993, 178.500076, 0.883999, 1.036000, 0.726999);
	 }
	 if(Iten[playerid] == 10) // Colete 1
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.087999, 0.037999, -0.002000, 3.399995, -1.800000, 5.699994, 1.000000, 1.112001, 0.920998);
	 }
	 if(Iten[playerid] == 11) // Colete 2
	 {
		SetPlayerAttachedObject(playerid, 3, 373, 1, 0.283999, 0.005000, -0.140999, 76.000000, 29.299997, 38.400009, 0.784000, 0.786999, 0.809000);
	 }
	 if(Iten[playerid] == 12) // Colete 3
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19142, 1, 0.098000, 0.045999, -0.002000, -7.599997, -4.699994, 0.599997, 0.998000, 0.861999, 0.921999);
	 }
	}
	//
	if(Personation == 310) // Sean
	{
	 if(Iten[playerid] == 1) // Rádio
	 {
	 	SetPlayerAttachedObject(playerid, 0, 2966, 3, 0.109000, 0.030000, 0.057000, -24.500007, 9.899982, 91.800025, 0.581000, 0.631000, 1.000000);
	 }
	 if(Iten[playerid] == 2) // Mochila 1
	 {
	 	SetPlayerAttachedObject(playerid, 1, 19559, 15, 0.023000, 0.060000, -0.146999, 3.899998, -2.800005, 167.299911, 0.887000, 1.198000, 1.000000);
	 }
	 if(Iten[playerid] == 3) // Mochila 2
	 {
	 	SetPlayerAttachedObject(playerid, 1, 3026, 15, 0.027999, 0.125000, -0.378000, 69.099990, 83.899902, 118.500038, 1.000000, 1.019000, 0.873000);
	 }
	 if(Iten[playerid] == 4) // Mochila 3
	 {
	 	SetPlayerAttachedObject(playerid, 1, 371, 15, 0.022000, 0.159999, -0.157000, 8.099995, 0.000000, -178.200042, 1.000000, 1.000000, 1.000000);
	 }
	 if(Iten[playerid] == 5) // Chapeu
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19100, 2, 0.181999, -0.002999, 0.000000, 0.000000, 0.000000, 0.000000, 1.266000, 1.305000, 1.323000);
	 }
	 if(Iten[playerid] == 6) // Capacete 1
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19101, 2, 0.158999, 0.001999, 0.001999, 0.000000, 0.000000, 0.000000, 1.278999, 1.259999, 1.236999);
	 }
	 if(Iten[playerid] == 7) // Capacete 2
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.127999, 0.019999, 0.000000, -0.799999, 0.000000, 0.000000, 1.189000, 1.324000, 1.508001);
	 }
	 if(Iten[playerid] == 8) // Capacete 3
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19141, 2, 0.083000, 0.010000, 0.007000, 0.000000, 0.000000, 0.000000, 1.460999, 1.143000, 1.214000);
	 }
	 if(Iten[playerid] == 9) // Colete 0
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19904, 1, 0.089000, 0.028999, 0.003999, 0.400000, 87.399993, 178.500076, 0.935999, 1.081001, 0.850999);
	 }
	 if(Iten[playerid] == 10) // Colete 1
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.058999, 0.013999, 0.006999, 0.000000, -4.100000, 0.000000, 1.000000, 1.054000, 1.022999);
	 }
	 if(Iten[playerid] == 11) // Colete 2
	 {
		SetPlayerAttachedObject(playerid, 3, 373, 1, 0.220999, -0.034000, -0.166999, 69.800086, 27.700021, 36.299983, 1.004000, 0.938999, 0.953999);
	 }
	 if(Iten[playerid] == 12) // Colete 3
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19142, 1, 0.019999, 0.027999, -0.002000, -2.399999, 0.300006, -3.100000, 1.208000, 0.990999, 1.129999);
	 }
	}
	//
	if(Personation == 305) // Sebastian
	{
	 if(Iten[playerid] == 1) // Rádio
	 {
	 	SetPlayerAttachedObject(playerid, 0, 2966, 3, 0.109000, 0.001000, 0.080999, -24.500007, 9.899982, 91.800025, 0.581000, 0.631000, 1.000000);
	 }
	 if(Iten[playerid] == 2) // Mochila 1
	 {
	 	SetPlayerAttachedObject(playerid, 1, 19559, 15, 0.023000, 0.060000, -0.113999, 3.899998, -2.800005, 167.299911, 0.887000, 1.198000, 1.000000);
	 }
	 if(Iten[playerid] == 3) // Mochila 2
	 {
	 	SetPlayerAttachedObject(playerid, 1, 3026, 15, 0.027999, 0.106000, -0.347000, 69.099990, 83.899902, 118.500038, 1.000000, 1.019000, 0.873000);
	 }
	 if(Iten[playerid] == 4) // Mochila 3
	 {
	 	SetPlayerAttachedObject(playerid, 1, 371, 15, 0.022000, 0.159999, -0.100000, 8.099995, 0.000000, -178.200042, 1.000000, 1.000000, 1.000000);
	 }
	 if(Iten[playerid] == 5) // Chapeu
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19100, 2, 0.230999, 0.040000, 0.003000, 0.000000, 0.000000, 0.000000, 1.027000, 1.183000, 1.147002);
	 }
	 if(Iten[playerid] == 6) // Capacete 1
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19101, 2, 0.201000, 0.037999, 0.001999, 0.000000, 0.000000, 0.000000, 1.167998, 1.128999, 1.236999);
	 }
	 if(Iten[playerid] == 7) // Capacete 2
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.169000, 0.035999, 0.008999, -0.799999, 0.000000, 0.000000, 1.148000, 1.181003, 1.174003);
	 }
	 if(Iten[playerid] == 8) // Capacete 3
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19141, 2, 0.145000, 0.039000, 0.012000, 0.000000, 0.000000, 0.000000, 1.460999, 1.143000, 1.214000);
	 }
	 if(Iten[playerid] == 9) // Colete 0
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19904, 1, 0.133000, 0.068999, 0.003999, 0.400000, 87.399993, 178.500076, 1.087999, 1.204001, 0.933999);
	 }
	 if(Iten[playerid] == 10) // Colete 1
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.133999, 0.048999, 0.004999, 0.000000, 0.000000, 0.000000, 1.000000, 1.168000, 1.075999);
	 }
	 if(Iten[playerid] == 11) // Colete 2
	 {
		SetPlayerAttachedObject(playerid, 3, 373, 1, 0.309999, -0.015000, -0.166999, 69.800086, 27.700021, 36.299983, 1.004000, 0.938999, 0.953999);
	 }
	 if(Iten[playerid] == 12) // Colete 3
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19142, 1, 0.087999, 0.053999, 0.008999, -1.299999, -2.599999, 0.000000, 1.208000, 1.043999, 1.129999);
	 }
	}
	//
	if(Personation == 7) // Nico
	{
	 if(Iten[playerid] == 1) // Rádio
	 {
	 	SetPlayerAttachedObject(playerid, 0, 2966, 3, 0.109000, 0.030000, 0.065999, -24.500007, 9.899982, 91.800025, 0.581000, 0.631000, 1.000000);
	 }
	 if(Iten[playerid] == 2) // Mochila 1
	 {
	 	SetPlayerAttachedObject(playerid, 1, 19559, 15, 0.000000, 0.083000, -0.113999, 19.099998, -4.400006, 164.499938, 0.887000, 1.198000, 1.000000);
	 }
	 if(Iten[playerid] == 3) // Mochila 2
	 {
	 	SetPlayerAttachedObject(playerid, 1, 3026, 15, -0.005000, 0.104000, -0.343999, 69.099990, 83.899902, 118.500038, 1.000000, 1.019000, 0.806000);
	 }
	 if(Iten[playerid] == 4) // Mochila 3
	 {
	 	SetPlayerAttachedObject(playerid, 1, 371, 15, -0.010000, 0.159999, -0.157000, 8.099995, 0.000000, -178.200042, 1.000000, 1.000000, 1.000000);
	 }
	 if(Iten[playerid] == 5) // Chapeu
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19100, 2, 0.183999, -0.002999, 0.000000, 0.000000, 0.000000, 0.000000, 1.266000, 1.305000, 1.323000);
	 }
	 if(Iten[playerid] == 6) // Capacete 1
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19101, 2, 0.180999, 0.000999, 0.010000, 0.000000, 0.000000, 0.000000, 1.278999, 1.168999, 1.398000);
	 }
	 if(Iten[playerid] == 7) // Capacete 2
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.145000, 0.001999, 0.015000, -0.799999, 0.000000, 0.000000, 1.148000, 1.105001, 1.121001);
	 }
	 if(Iten[playerid] == 8) // Capacete 3
	 {
	 	SetPlayerAttachedObject(playerid, 2, 19141, 2, 0.116000, 0.010000, 0.011000, 0.000000, 0.000000, 0.000000, 1.460999, 1.143000, 1.214000);
	 }
	 if(Iten[playerid] == 9) // Colete 0
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19904, 1, 0.067000, 0.052999, 0.003999, 0.400000, 87.399993, 178.500076, 0.935999, 1.099001, 0.790999);
	 }
	 if(Iten[playerid] == 10) // Colete 1
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.021999, 0.057999, 0.006999, -3.799999, -4.100000, -3.100002, 1.000000, 1.161001, 1.022999);
	 }
	 if(Iten[playerid] == 11) // Colete 2
	 {
		SetPlayerAttachedObject(playerid, 3, 373, 1, 0.205999, 0.029000, -0.132999, 76.000000, 29.299997, 38.400009, 0.784000, 0.786999, 0.809000);
	 }
	 if(Iten[playerid] == 12) // Colete 3
	 {
	 	SetPlayerAttachedObject(playerid, 3, 19142, 1, 0.052000, 0.066999, -0.002000, -5.699998, -3.699993, -6.500002, 0.998000, 0.990999, 0.921999);
	 }
	}
	Iten[playerid] = 0;
}
forward ParrarDelayArrastando(playerid);
public ParrarDelayArrastando(playerid)
{
	Arrastando[playerid] = 0;
	ArrastarFerido(playerid);
}
forward CloseMsg(playerid);
public CloseMsg(playerid)
{
	for(new a; a < 6; a++){
	TextDrawHideForPlayer(playerid, msgw[a]); }
}
// forward CorrerComArma(playerid);
// public CorrerComArma(playerid)
// {
	// 	new Arm = GetPlayerWeapon(playerid);
	//    	if((GetPlayerState(playerid)==1&&GK(playerid,KEY_SPRINT))&& Arm == 30 || Arm == 31 || Arm == 32 || Arm == 33 || Arm == 34 &&
	// 	(GK(playerid,KEY_UP)||GK(playerid,KEY_DOWN)||GK(playerid,KEY_LEFT)||GK(playerid,KEY_RIGHT)))
	// 	{
		// 	    SetTimerEx("CorrerComArma", 100, 0, "i", playerid);
		// 	    //AplicarWalk(playerid);
		// 	    ApplyAnimation(playerid,"PED","run_armed",4.1,0,1,1,1,1,1);
		// 	}
	//    	else if(GK(playerid,KEY_SPRINT) && GetPlayerState(playerid)==1)
	// 		SetTimerEx("CorrerComArma", 500, 0, "i", playerid),
	// 		ApplyAnimation(playerid,"PED","facgum",3.5,0,1,1,1,1);
	// 	else ApplyAnimation(playerid,"PED","facgum",3.5,0,1,1,1,1);
	// 	return 0;
	// }
stock aEst(playerid)
{
	new string[48];
	SelectTextDraw(playerid, 0x00FFFFFF);
	format(string, sizeof (string), "%d", Dados[playerid][PH]);
	PlayerTextDrawSetString(playerid, EstP[playerid][12], string);
	//
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Agilidade]);
	PlayerTextDrawSetString(playerid, EstP[playerid][0], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Forca]);
	PlayerTextDrawSetString(playerid, EstP[playerid][1], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Carisma]);
	PlayerTextDrawSetString(playerid, EstP[playerid][2], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Destreza]);
	PlayerTextDrawSetString(playerid, EstP[playerid][3], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Resistencia]);
	PlayerTextDrawSetString(playerid, EstP[playerid][4], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Inteligencia]);
	PlayerTextDrawSetString(playerid, EstP[playerid][5], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Defesa]);
	PlayerTextDrawSetString(playerid, EstP[playerid][6], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Sabedoria]);
	PlayerTextDrawSetString(playerid, EstP[playerid][7], string);
	format(string, sizeof (string), "(%d/50)~n~", Dados[playerid][Sapiencia]);
	PlayerTextDrawSetString(playerid, EstP[playerid][8], string);
	format(string, sizeof (string), "(%d/100)~n~", Dados[playerid][Engenharia]);
	PlayerTextDrawSetString(playerid, EstP[playerid][9], string);
	format(string, sizeof (string), "(%d/25)~n~", Dados[playerid][Talento]);
	PlayerTextDrawSetString(playerid, EstP[playerid][10], string);
	format(string, sizeof (string), "(%d/30)~n~", Dados[playerid][Power]);
	PlayerTextDrawSetString(playerid, EstP[playerid][11], string);
	for( new text; text != 18; text++) TextDrawShowForPlayer(playerid, EstG[text]);
	for( new text; text != 14; text++) PlayerTextDrawShow(playerid, EstP[playerid][text]);
}
stock fEst(playerid)
{
	CancelSelectTextDraw(playerid);
	for( new text; text != 18; text++) TextDrawHideForPlayer(playerid, EstG[text]);
	for( new text; text != 14; text++) PlayerTextDrawHide(playerid, EstP[playerid][text]);
}
stock Joel(id)
{
	new dialogid=10+id;
	return dialogid;
}
stock AplicarWalk(playerid)
{
	switch(StyleWalk[playerid])
	{

		case 1:ApplyAnimation(playerid,"PED","WALK_civi",4.1,1,1,1,1,1);
		case 2:ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
		case 3:ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
		case 4:ApplyAnimation(playerid,"PED","WALK_old",4.1,1,1,1,1,1);
		case 5:ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1);
		case 6:ApplyAnimation(playerid,"PED","WALK_fat",4.1,1,1,1,1,1);
		case 7:ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 8:ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1);
		case 9:ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1);
		case 10:ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1);
		case 11:ApplyAnimation(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1);
		case 12:ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1);
		case 13:ApplyAnimation(playerid,"PED","Player_Sneak",6.1,1,1,1,1,1);
		case 14:ApplyAnimation(playerid,"PED","WOMAN_walkshop",4.1,1,1,1,1,1);
		case 15:ApplyAnimation(playerid,"PED","JOG_femaleA",4.1,1,1,1,1,1);
		case 16:ApplyAnimation(playerid,"PED","JOG_maleA",4.1,1,1,1,1,1);
		case 17:ApplyAnimation(playerid,"PED","run_civi",4.1,1,1,1,1,1);
		case 18:ApplyAnimation(playerid,"PED","run_fat",4.1,1,1,1,1,1);
		case 19:ApplyAnimation(playerid,"PED","run_fatold",4.1,1,1,1,1,1);
		case 20:ApplyAnimation(playerid,"PED","run_gang1",4.1,1,1,1,1,1);
		case 21:ApplyAnimation(playerid,"PED","run_old",4.1,1,1,1,1,1);
		case 22:ApplyAnimation(playerid,"PED","Run_Wuzi",4.1,1,1,1,1,1);
		case 23:ApplyAnimation(playerid,"PED","swat_run",4.1,1,1,1,1,1);
		case 24:ApplyAnimation(playerid,"PED","woman_run",4.1,1,1,1,1,1);
		case 25:ApplyAnimation(playerid,"PED","WOMAN_runbusy",4.1,1,1,1,1,1);
		case 26:ApplyAnimation(playerid,"PED","WOMAN_runsexy",4.1,1,1,1,1,1);
	}
	return 0xFFFF;
}
stock SetWalkStyle(playerid, style)
{
	if(style < 0 || style > 26)return true;

	StyleWalk[playerid] = style;

	return 0;
}
stock GetWalkStyle(playerid)return StyleWalk[playerid];
stock ResetWalkStyle(playerid)return StyleWalk[playerid] = 0;

stock GK(playerid, key)
{
	new keys, ud, lr;
	GetPlayerKeys(playerid, keys, ud, lr);
	if(keys & key || ud == key || lr == key)return true;
	return 0;
}
stock Float:GetVehicleHealthEx(vehicleid)
{
	new Float:health;
	GetVehicleHealth(vehicleid, health);

	if ( health > 900.0) {
		return health / 10.0;
	}
	else return ( health / 10.0 )-(24);
}

stock ChecarVeiculo(Float:radi, playerid, vehicleid)
{
	if(IsPlayerConnected(playerid))
	{

		new Float:PX,Float:PY,Float:PZ,Float:X,Float:Y,Float:Z;
		GetPlayerPos(playerid,PX,PY,PZ);
		GetVehiclePos(vehicleid, X,Y,Z);
		new Float:Distance = (X-PX)*(X-PX)+(Y-PY)*(Y-PY)+(Z-PZ)*(Z-PZ);
		if(Distance <= radi*radi)
		{

			return 1;
		}
	}
	return 0;
}
stock Nome(playerid)
{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
	return Name;
}
stock Atualizar(playerid)
{
	if(Dados[playerid][Saude] <= 0)
	{
		Dados[playerid][Saude] = 0;
	}
	if(Dados[playerid][Armadura] <= 0)
	{
		Dados[playerid][Armadura] = 0;
	}
	new Sedee[48];
	format(Sedee, sizeof (Sedee), "%d", Dados[playerid][Sede]);
	PlayerTextDrawSetString(playerid, HudP[playerid][0], Sedee);

	new Fomee[48];
	format(Fomee, sizeof (Fomee), "%d", Dados[playerid][Fome]);
	PlayerTextDrawSetString(playerid, HudP[playerid][3], Fomee);

	new string[48];
	format(string, sizeof (string), "%d", Dados[playerid][Saude]);
	PlayerTextDrawSetString(playerid, HudP[playerid][1], string);

	new Colete[48];
	format(Colete, sizeof (Colete), "%d", Dados[playerid][Armadura]);
	PlayerTextDrawSetString(playerid, HudP[playerid][2], Colete);

	if(Dados[playerid][Chao] == 0 && Dados[playerid][Ferido] == 0)
	{

		TextDrawHideForPlayer(playerid, TextFerido[0]);
		for(new text; text != 2; text++) PlayerTextDrawHide(playerid, TextFeridoG[playerid][text]);
	}
	return 1;
}
stock AtualizarItem(playerid)
{
	if(uItem[playerid][0] == 1) // Capacete 3
	{
		VidaItem[playerid][0] -= 10;
		if(VidaItem[playerid][0] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][17]);
			RemovePlayerAttachedObject(playerid, 2);
			Ut[playerid][0] = 0;
			uItem[playerid][0] = 0;
			VidaItem[playerid][0] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = CAPA3;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
		return 1;
	}
	if(uItem[playerid][1] == 1) // Capacete 2
	{
		VidaItem[playerid][1] -= 10;
		if(VidaItem[playerid][1] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][17]);
			RemovePlayerAttachedObject(playerid, 2);
			Ut[playerid][1] = 0;
			uItem[playerid][1] = 0;
			VidaItem[playerid][1] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = CAPA2;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
		return 1;
	}
	if(uItem[playerid][2] == 1) // Capacete 1
	{
		VidaItem[playerid][2] -= 10;
		if(VidaItem[playerid][2] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][17]);
			RemovePlayerAttachedObject(playerid, 2);
			Ut[playerid][2] = 0;
			uItem[playerid][2] = 0;
			VidaItem[playerid][2] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = CAPA1;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
		return 1;
	}
	if(uItem[playerid][10] == 1) // Chapéu
	{
		VidaItem[playerid][7] -= 10;
		if(VidaItem[playerid][7] <= 0) // Quebrou.
		{
			RemovePlayerAttachedObject(playerid, 2);
			Ut[playerid][10] = 0;
			uItem[playerid][10] = 0;
			VidaItem[playerid][7] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = CHAPEU;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
		return 1;
	}
	if(uItem[playerid][3] == 1) // Colete 0
	{
		VidaItem[playerid][3] -= 10;
		if(VidaItem[playerid][3] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][16]);
			RemovePlayerAttachedObject(playerid, 3);
			Ut[playerid][3] = 0;
			uItem[playerid][3] = 0;
			VidaItem[playerid][3] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = COLETE0;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
	}
	if(uItem[playerid][4] == 1) // Colete 1
	{
		VidaItem[playerid][4] -= 10;
		if(VidaItem[playerid][4] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][16]);
			RemovePlayerAttachedObject(playerid, 3);
			Ut[playerid][4] = 0;
			uItem[playerid][4] = 0;
			VidaItem[playerid][4] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = COLETE1;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
	}
	if(uItem[playerid][5] == 1) // Colete 2
	{
		VidaItem[playerid][5] -= 10;
		if(VidaItem[playerid][5] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][16]);
			RemovePlayerAttachedObject(playerid, 3);
			Ut[playerid][5] = 0;
			uItem[playerid][5] = 0;
			VidaItem[playerid][5] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = COLETE2;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
	}
	if(uItem[playerid][6] == 1) // Colete 3
	{
		VidaItem[playerid][6] -= 10;
		if(VidaItem[playerid][6] <= 0) // Quebrou.
		{
			//PlayerTextDrawDestroy(playerid, invPreview[playerid][16]);
			RemovePlayerAttachedObject(playerid, 3);
			Ut[playerid][6] = 0;
			uItem[playerid][6] = 0;
			VidaItem[playerid][6] = 0;
			for(new a; a<17; a++)
			{
				 if(InventarioInfo[playerid][a][iSlot] == 19382)
				 {
					InventarioInfo[playerid][a][iSlot] = COLETE3;
					InventarioInfo[playerid][a][iUnidades] = 0;
					return 1;
			     }
			}
		}
	}
	return 1;
}
public OnGameModeInit()
{
	WorkbenchMenu();
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL, "scriptfiles/SAFull.hmap");
	// Criando animais..
	for (new i = 0; i < START_NPCS; i++) {
		SetTimer("CreateNPC", 3000 * i + random(10000), 0);
	}
	// Criando zombies
	for (new i = 0; i < START_ZO; i++) {
		SetTimer("CreateZo", 3000* i + random(10000), 0);
	}
 	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	blackmap = GangZoneCreate(-3334.758544, -3039.903808, 3049.241455, 3184.096191);
	SendRconCommand("hostname Projeto SCRP");
	SetGameModeText("Roleplay");
	SendRconCommand("mapname Palomino");
	SendRconCommand("website forum.sa-mp.com");

	ShowNameTags(0); // Crachás [Desativados]

	AddPlayerClass(0, 1938.1903, -2645.8267, 13.5469, 355.7780, 0, 0, 0, 0, 0, 0);

	// Ferido
	TextFerido[0] = TextDrawCreate(507.999969, 100.399978, "estado:~n~tempo_de_vida:");
	TextDrawLetterSize(TextFerido[0], 0.226399, 1.102221);
	TextDrawAlignment(TextFerido[0], 1);
	TextDrawColor(TextFerido[0], -1);
	TextDrawSetShadow(TextFerido[0], 0);
	TextDrawSetOutline(TextFerido[0], -1);
	TextDrawBackgroundColor(TextFerido[0], 255);
	TextDrawFont(TextFerido[0], 2);
	TextDrawSetProportional(TextFerido[0], 1);
	// Velocimetro

	Velocimetro[0] = TextDrawCreate(563.199707, 402.053405, "L:");
	TextDrawLetterSize(Velocimetro[0], 0.318799, 1.231644);
	TextDrawAlignment(Velocimetro[0], 1);
	TextDrawColor(Velocimetro[0], -1);
	TextDrawSetShadow(Velocimetro[0], 0);
	TextDrawSetOutline(Velocimetro[0], -1);
	TextDrawBackgroundColor(Velocimetro[0], 255);
	TextDrawFont(Velocimetro[0], 2);
	TextDrawSetProportional(Velocimetro[0], 1);

	Velocimetro[1] = TextDrawCreate(562.799682, 414.497741, "G:");
	TextDrawLetterSize(Velocimetro[1], 0.318799, 1.231644);
	TextDrawAlignment(Velocimetro[1], 1);
	TextDrawColor(Velocimetro[1], -1);
	TextDrawSetShadow(Velocimetro[1], 0);
	TextDrawSetOutline(Velocimetro[1], -1);
	TextDrawBackgroundColor(Velocimetro[1], 255);
	TextDrawFont(Velocimetro[1], 2);
	TextDrawSetProportional(Velocimetro[1], 1);

	Velocimetro[2] = TextDrawCreate(563.199645, 427.439849, "T:");
	TextDrawLetterSize(Velocimetro[2], 0.318799, 1.231644);
	TextDrawAlignment(Velocimetro[2], 1);
	TextDrawColor(Velocimetro[2], -1);
	TextDrawSetShadow(Velocimetro[2], 0);
	TextDrawSetOutline(Velocimetro[2], -1);
	TextDrawBackgroundColor(Velocimetro[2], 255);
	TextDrawFont(Velocimetro[2], 2);
	TextDrawSetProportional(Velocimetro[2], 1);

	Velocimetro[3] = TextDrawCreate(561.599609, 389.111083, "V:");
	TextDrawLetterSize(Velocimetro[3], 0.318799, 1.231644);
	TextDrawAlignment(Velocimetro[3], 1);
	TextDrawColor(Velocimetro[3], -1);
	TextDrawSetShadow(Velocimetro[3], 0);
	TextDrawSetOutline(Velocimetro[3], -1);
	TextDrawBackgroundColor(Velocimetro[3], 255);
	TextDrawFont(Velocimetro[3], 2);
	TextDrawSetProportional(Velocimetro[3], 1);
	// FIM VELOCIMETRO

	// HUD
	Hud = TextDrawCreate(511.000000, 151.000000, "LD_RACE:Hud"); // Hud Saude/Armadura/Fome/Sede
	TextDrawFont(Hud, 4);
	TextDrawLetterSize(Hud, 0.600000, 2.000000);
	TextDrawTextSize(Hud, 127.000000, 107.000000);
	TextDrawSetOutline(Hud, 1);
	TextDrawSetShadow(Hud, 0);
	TextDrawAlignment(Hud, 1);
	TextDrawColor(Hud, -1);
	TextDrawBackgroundColor(Hud, 255);
	TextDrawBoxColor(Hud, 50);
	TextDrawUseBox(Hud, 1);
	TextDrawSetProportional(Hud, 1);
	TextDrawSetSelectable(Hud, 0);
	// FIM HUD

	// ESTATISTICAS
	EstG[0] = TextDrawCreate(484.399902, 132.257781, "box");
	TextDrawLetterSize(EstG[0], 0.000000, 30.479999);
	TextDrawTextSize(EstG[0], 0.000000, 202.000000);
	TextDrawAlignment(EstG[0], 2);
	TextDrawColor(EstG[0], -1);
	TextDrawUseBox(EstG[0], 1);
	TextDrawBoxColor(EstG[0], 81);
	TextDrawSetShadow(EstG[0], 0);
	TextDrawBackgroundColor(EstG[0], 255);
	TextDrawFont(EstG[0], 1);
	TextDrawSetProportional(EstG[0], 1);

	EstG[1] = TextDrawCreate(427.199981, 134.248901, "HABILIDADES");
	TextDrawLetterSize(EstG[1], 0.399598, 1.595021);
	TextDrawAlignment(EstG[1], 1);
	TextDrawColor(EstG[1], -1);
	TextDrawSetShadow(EstG[1], 0);
	TextDrawBackgroundColor(EstG[1], 255);
	TextDrawFont(EstG[1], 2);
	TextDrawSetProportional(EstG[1], 1);

	EstG[2] = TextDrawCreate(385.200073, 199.955596, "AGILIDADE~n~FORCA~n~carisma~n~destreza~n~resistencia~n~inteligencia~n~defesa~n~sabedoria~n~sapiencia~n~engenharia~n~talento~n~");
	TextDrawLetterSize(EstG[2], 0.407599, 1.814043);
	TextDrawAlignment(EstG[2], 1);
	TextDrawColor(EstG[2], -1);
	TextDrawSetShadow(EstG[2], 0);
	TextDrawSetOutline(EstG[2], 1);
	TextDrawBackgroundColor(EstG[2], 255);
	TextDrawFont(EstG[2], 2);
	TextDrawSetProportional(EstG[2], 1);

	EstG[3] = TextDrawCreate(387.600219, 155.653305, "PONTOS_DE_HABILIDADE_podem_ser_atribuidos_a_suas~n~habilidades,veja_o_que_cada_habilidade_faz_clican~n~cando_sobre_o_progresso.");
	TextDrawLetterSize(EstG[3], 0.167594, 0.674133);
	TextDrawTextSize(EstG[3], -100.000000, 0.000000);
	TextDrawAlignment(EstG[3], 1);
	TextDrawColor(EstG[3], -1);
	TextDrawSetShadow(EstG[3], 0);
	TextDrawBackgroundColor(EstG[3], 255);
	TextDrawFont(EstG[3], 2);
	TextDrawSetProportional(EstG[3], 1);

	EstG[4] = TextDrawCreate(386.400177, 204.933227, "box");
	TextDrawLetterSize(EstG[4], 0.000000, 1.000005);
	TextDrawTextSize(EstG[4], 583.000000, 0.000000);
	TextDrawAlignment(EstG[4], 1);
	TextDrawColor(EstG[4], -16711681);
	TextDrawUseBox(EstG[4], 1);
	TextDrawBoxColor(EstG[4], 80);
	TextDrawSetShadow(EstG[4], 0);
	TextDrawBackgroundColor(EstG[4], 255);
	TextDrawFont(EstG[4], 1);
	TextDrawSetProportional(EstG[4], 1);

	EstG[5] = TextDrawCreate(386.000152, 221.857666, "box");
	TextDrawLetterSize(EstG[5], 0.000000, 0.880005);
	TextDrawTextSize(EstG[5], 583.000000, 0.000000);
	TextDrawAlignment(EstG[5], 1);
	TextDrawColor(EstG[5], -16711681);
	TextDrawUseBox(EstG[5], 1);
	TextDrawBoxColor(EstG[5], 80);
	TextDrawSetShadow(EstG[5], 0);
	TextDrawBackgroundColor(EstG[5], 255);
	TextDrawFont(EstG[5], 1);
	TextDrawSetProportional(EstG[5], 1);

	EstG[6] = TextDrawCreate(385.600158, 237.288757, "box");
	TextDrawLetterSize(EstG[6], 0.000000, 1.000005);
	TextDrawTextSize(EstG[6], 583.000000, 0.000000);
	TextDrawAlignment(EstG[6], 1);
	TextDrawColor(EstG[6], -16711681);
	TextDrawUseBox(EstG[6], 1);
	TextDrawBoxColor(EstG[6], 80);
	TextDrawSetShadow(EstG[6], 0);
	TextDrawBackgroundColor(EstG[6], 255);
	TextDrawFont(EstG[6], 1);
	TextDrawSetProportional(EstG[6], 1);

	EstG[7] = TextDrawCreate(385.200134, 253.715393, "box");
	TextDrawLetterSize(EstG[7], 0.000000, 1.000005);
	TextDrawTextSize(EstG[7], 583.000000, 0.000000);
	TextDrawAlignment(EstG[7], 1);
	TextDrawColor(EstG[7], -16711681);
	TextDrawUseBox(EstG[7], 1);
	TextDrawBoxColor(EstG[7], 80);
	TextDrawSetShadow(EstG[7], 0);
	TextDrawBackgroundColor(EstG[7], 255);
	TextDrawFont(EstG[7], 1);
	TextDrawSetProportional(EstG[7], 1);

	EstG[8] = TextDrawCreate(385.600097, 269.644317, "box");
	TextDrawLetterSize(EstG[8], 0.000000, 1.000005);
	TextDrawTextSize(EstG[8], 583.000000, 0.000000);
	TextDrawAlignment(EstG[8], 1);
	TextDrawColor(EstG[8], -16711681);
	TextDrawUseBox(EstG[8], 1);
	TextDrawBoxColor(EstG[8], 80);
	TextDrawSetShadow(EstG[8], 0);
	TextDrawBackgroundColor(EstG[8], 255);
	TextDrawFont(EstG[8], 1);
	TextDrawSetProportional(EstG[8], 1);

	EstG[9] = TextDrawCreate(386.000061, 286.568756, "box");
	TextDrawLetterSize(EstG[9], 0.000000, 1.000005);
	TextDrawTextSize(EstG[9], 583.000000, 0.000000);
	TextDrawAlignment(EstG[9], 1);
	TextDrawColor(EstG[9], -16711681);
	TextDrawUseBox(EstG[9], 1);
	TextDrawBoxColor(EstG[9], 80);
	TextDrawSetShadow(EstG[9], 0);
	TextDrawBackgroundColor(EstG[9], 255);
	TextDrawFont(EstG[9], 1);
	TextDrawSetProportional(EstG[9], 1);

	EstG[10] = TextDrawCreate(386.000061, 303.493164, "box");
	TextDrawLetterSize(EstG[10], 0.000000, 1.000005);
	TextDrawTextSize(EstG[10], 583.000000, 0.000000);
	TextDrawAlignment(EstG[10], 1);
	TextDrawColor(EstG[10], -16711681);
	TextDrawUseBox(EstG[10], 1);
	TextDrawBoxColor(EstG[10], 80);
	TextDrawSetShadow(EstG[10], 0);
	TextDrawBackgroundColor(EstG[10], 255);
	TextDrawFont(EstG[10], 1);
	TextDrawSetProportional(EstG[10], 1);

	EstG[11] = TextDrawCreate(386.400024, 318.924285, "box");
	TextDrawLetterSize(EstG[11], 0.000000, 1.000005);
	TextDrawTextSize(EstG[11], 583.000000, 0.000000);
	TextDrawAlignment(EstG[11], 1);
	TextDrawColor(EstG[11], -16711681);
	TextDrawUseBox(EstG[11], 1);
	TextDrawBoxColor(EstG[11], 80);
	TextDrawSetShadow(EstG[11], 0);
	TextDrawBackgroundColor(EstG[11], 255);
	TextDrawFont(EstG[11], 1);
	TextDrawSetProportional(EstG[11], 1);

	EstG[12] = TextDrawCreate(386.400024, 335.848785, "box");
	TextDrawLetterSize(EstG[12], 0.000000, 1.000005);
	TextDrawTextSize(EstG[12], 583.000000, 0.000000);
	TextDrawAlignment(EstG[12], 1);
	TextDrawColor(EstG[12], -16711681);
	TextDrawUseBox(EstG[12], 1);
	TextDrawBoxColor(EstG[12], 80);
	TextDrawSetShadow(EstG[12], 0);
	TextDrawBackgroundColor(EstG[12], 255);
	TextDrawFont(EstG[12], 1);
	TextDrawSetProportional(EstG[12], 1);

	EstG[13] = TextDrawCreate(386.800018, 351.777709, "box");
	TextDrawLetterSize(EstG[13], 0.000000, 1.040004);
	TextDrawTextSize(EstG[13], 583.000000, 0.000000);
	TextDrawAlignment(EstG[13], 1);
	TextDrawColor(EstG[13], -16711681);
	TextDrawUseBox(EstG[13], 1);
	TextDrawBoxColor(EstG[13], 80);
	TextDrawSetShadow(EstG[13], 0);
	TextDrawBackgroundColor(EstG[13], 255);
	TextDrawFont(EstG[13], 1);
	TextDrawSetProportional(EstG[13], 1);

	EstG[14] = TextDrawCreate(386.400024, 368.204406, "box");
	TextDrawLetterSize(EstG[14], 0.000000, 1.040004);
	TextDrawTextSize(EstG[14], 582.000000, 0.000000);
	TextDrawAlignment(EstG[14], 1);
	TextDrawColor(EstG[14], -16711681);
	TextDrawUseBox(EstG[14], 1);
	TextDrawBoxColor(EstG[14], 80);
	TextDrawSetShadow(EstG[14], 0);
	TextDrawBackgroundColor(EstG[14], 255);
	TextDrawFont(EstG[14], 1);
	TextDrawSetProportional(EstG[14], 1);

	EstG[15] = TextDrawCreate(386.400024, 384.133300, "box");
	TextDrawLetterSize(EstG[15], 0.000000, 1.040004);
	TextDrawTextSize(EstG[15], 582.000000, 0.000000);
	TextDrawAlignment(EstG[15], 1);
	TextDrawColor(EstG[15], -16711681);
	TextDrawUseBox(EstG[15], 1);
	TextDrawBoxColor(EstG[15], 80);
	TextDrawSetShadow(EstG[15], 0);
	TextDrawBackgroundColor(EstG[15], 255);
	TextDrawFont(EstG[15], 1);
	TextDrawSetProportional(EstG[15], 1);

	EstG[16] = TextDrawCreate(387.200134, 173.075500, "SEUS_PONTOS_DE_HABILIDADES_CORRESPONDE_A:");
	TextDrawLetterSize(EstG[16], 0.167594, 0.674133);
	TextDrawTextSize(EstG[16], -100.000000, 0.000000);
	TextDrawAlignment(EstG[16], 1);
	TextDrawColor(EstG[16], -1);
	TextDrawSetShadow(EstG[16], 0);
	TextDrawBackgroundColor(EstG[16], 255);
	TextDrawFont(EstG[16], 2);
	TextDrawSetProportional(EstG[16], 1);

	EstG[17] = TextDrawCreate(386.399963, 380.151062, "power");
	TextDrawLetterSize(EstG[17], 0.400000, 1.600000);
	TextDrawAlignment(EstG[17], 1);
	TextDrawColor(EstG[17], -1);
	TextDrawSetShadow(EstG[17], 0);
	TextDrawSetOutline(EstG[17], 1);
	TextDrawBackgroundColor(EstG[17], 255);
	TextDrawFont(EstG[17], 2);
	TextDrawSetProportional(EstG[17], 1);

	// FIM

	// Dacing menu
	dacing[0] = TextDrawCreate(421.000000, 101.000000, "LD_RACE:dacing");
	TextDrawFont(dacing[0], 4);
	TextDrawLetterSize(dacing[0], 0.600000, 2.000000);
	TextDrawTextSize(dacing[0], 152.000000, 257.000000);
	TextDrawSetOutline(dacing[0], 1);
	TextDrawSetShadow(dacing[0], 0);
	TextDrawAlignment(dacing[0], 1);
	TextDrawColor(dacing[0], -1);
	TextDrawBackgroundColor(dacing[0], 255);
	TextDrawBoxColor(dacing[0], 50);
	TextDrawUseBox(dacing[0], 1);
	TextDrawSetProportional(dacing[0], 1);
	TextDrawSetSelectable(dacing[0], 0);
	//
	//text draw horas
	{

		Textdraw1 = TextDrawCreate(542.400268, 21.253326, "00:00:00");
		TextDrawLetterSize(Textdraw1, 0.400000, 1.600000);
		TextDrawAlignment(Textdraw1, 1);
		TextDrawColor(Textdraw1, -1);
		TextDrawSetShadow(Textdraw1, 0);
		TextDrawSetOutline(Textdraw1, -1);
		TextDrawBackgroundColor(Textdraw1, 255);
		TextDrawFont(Textdraw1, 2);
		TextDrawSetProportional(Textdraw1, 1);

		//text draw data
		Textdraw0 = TextDrawCreate(539.600158, 9.306655, "00/00/0000");
		TextDrawLetterSize(Textdraw0, 0.400000, 1.600000);
		TextDrawAlignment(Textdraw0, 1);
		TextDrawColor(Textdraw0, -1);
		TextDrawSetShadow(Textdraw0, 0);
		TextDrawSetOutline(Textdraw0, -1);
		TextDrawBackgroundColor(Textdraw0, 255);
		TextDrawFont(Textdraw0, 2);
		TextDrawSetProportional(Textdraw0, 1);
		SetTimer("Horas", 1000, 1);
	}
	for(new i=0; i<GetMaxPlayers(); i++)
	{

		Aviso[i] = TextDrawCreate(35.000000, 152.000000, " ");
		TextDrawBackgroundColor(Aviso[i], 255);
		TextDrawFont(Aviso[i], 1);
		TextDrawLetterSize(Aviso[i], 0.310000, 1.000000);
		TextDrawColor(Aviso[i], -1);
		TextDrawSetOutline(Aviso[i], 1);
		TextDrawSetProportional(Aviso[i], 1);
	}
	SetTimer("CheckSemParar", 300, true);


	SetTimer("AtualizarText", 1000, true);
 	SetTimer("AtualizarFome", 120000, true); // 2 Minutos
	SetTimer("ChecarCarro", 300, true);
	SetTimer("AtualizarMorto", 30000, true);


	CarregarChaveiros();
	CarregarCarros();


 	//Textos 3d
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, -2040.9733,-2381.2610,30.6250, 5.0, 0, 0); // Pegar Caixa
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, -2052.1597,-2391.0923,30.6250, 5.0, 0, 0); // Inserir Madeira
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, -2074.8806,-2417.7070,30.6250, 5.0, 0, 0); // Dispensando Caixa
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, -2051.3408,-2376.9180,30.6318, 5.0, 0, 0); // Pegar Madeira


 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, 552.8043,909.7172,-42.9609, 5.0, 0, 0); // Minerando 1
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, 557.5746,918.6065,-42.9609, 5.0, 0, 0); // Minerando 2
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, 587.0723,917.7970,-43.0307, 5.0, 0, 0); // Minerando 3
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, 584.5220,924.8887,-42.2134, 5.0, 0, 0); // Minerando 4
 	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, 561.3225,885.1464,-41.6665, 5.0, 0, 0); // Vender minério

	// Sabotagens
	Create3DTextLabel("Pressione 'Y' para interagir", 0xFFFFFFAA, -1660.727783, -1644.042724, 32.332324, 5.0, 0, 0); // Plantar C4 ponte 1
	// • Pontes
	//
	Ponte1[0] = CreateObject(3331, -1623.739990, -1628.410034, 41.875000, 0.000014, -0.000005, 112.749961, 250.00);
	Ponte1[1] = CreateObject(18450, -1627.209960, -1620.910034, 34.914100, 0.000005, 0.000014, 22.750040, 250.00);
	Ponte1[2] = CreateObject(18449, -1700.979980, -1651.839965, 34.914100, 0.000000, 0.000000, -157.249938, 250.00);
	Ponte1[3] = CreateObject(3331, -1697.790039, -1659.459960, 41.875000, 0.000000, 0.000000, 112.750007, 250.00);
	//
	// End
	return 1;

}

public OnGameModeExit()
{
	foreach (new i : Player)
	{
		if (IsPlayerConnected(i)) SalvarConta(i);
	}
	DOF2_Exit();
	return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	if(playertextid == EstP[playerid][0])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}AGILIDADE{FFFFFF}, permite que\nvocê consiga se mover estando ferido.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(1),DIALOG_STYLE_INPUT,"Agilidade",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][1])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}FORÇA{FFFFFF}, permite que\nvocê nocauteie outra pessoa com apenas um soco, possuindo 20 de dano em punhos.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(2),DIALOG_STYLE_INPUT,"Força",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][2])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}CARISMA{FFFFFF}, permite que\nvocê se recupere rapido quando hospitalizado.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(3),DIALOG_STYLE_INPUT,"Carisma",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][3])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}DESTREZA{FFFFFF}, permite que\nvocê não engorde consumindo Fast Foods.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(4),DIALOG_STYLE_INPUT,"Destreza",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][4])
	{
		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}RESISTÊNCIA{FFFFFF}, permite que\nvocê não venha ser nocauteado por outras pessoas e\nvocê não fica ferido ao sentir muita fome ou sede.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(5),DIALOG_STYLE_INPUT,"Resistência",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][5])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}INTELIGÊNCIA{FFFFFF}, permite que\nvocê tome a arma da mão de outra pessoa.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(6),DIALOG_STYLE_INPUT,"Inteligência",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][6])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}DEFESA{FFFFFF}, permite que\nvocê se defenda contra alguem que queira tomar sua arma.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(7),DIALOG_STYLE_INPUT,"Defesa",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][7])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}SABEDORIA{FFFFFF}, permite que\nvocê ative o modo espreita, esquiva mesmo estando em pé e\n derrubar outra pessoa.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(8),DIALOG_STYLE_INPUT,"Sabedoria",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][8])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}SAPIÊNCIA{FFFFFF}, permite que\nvocê invada casas trancadas e fazer ligações diretas em veículos.\n\nPara desbloquear-lá precisará de 50 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(9),DIALOG_STYLE_INPUT,"Sapiência",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][9])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}ENGENHARIA{FFFFFF}, permite que\nvocê invada qualquer frequência de rádio.\n\nPara desbloquear-lá precisará de 100 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(10),DIALOG_STYLE_INPUT,"Engenharia",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][10])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}TALENTO{FFFFFF}, permite que\nvocê efetue disparos mesmo estando com o braço quebrado.\n\nPara desbloquear-lá precisará de 25 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(11),DIALOG_STYLE_INPUT,"Talento",gstring,"Atribuir","Sair");
		return 1;
	}
	if(playertextid == EstP[playerid][11])
	{

		new gstring[256];
		fEst(playerid);
		aEst(playerid);
		format(gstring,sizeof(gstring),"{FFFFFF}A habilidade {FFFF00}POWER{FFFFFF}, permite que\nvocê não caia quando sofrer tiros de Espingardas.\n\nPara desbloquear-lá precisará de 30 pontos atribuidos.\n\nInsira a quantidade de Pontos de Habilidade\nque deseja atribuir:\n");
		ShowPlayerDialog(playerid,Joel(12),DIALOG_STYLE_INPUT,"Power",gstring,"Atribuir","Sair");
		return 1;
	}

	if(playertextid == EstP[playerid][13])
	{

		fEst(playerid);
		return 1;
	}
	// Buttons dacing
	if(playertextid == bdacing[playerid][0])
	{
		SelectTextDraw(playerid, 0xCD0400FF);
		CancelSelectTextDraw(playerid);
		for(new b=0; b < 6; b++){
		PlayerTextDrawHide(playerid, bdacing[playerid][b]); }
		TextDrawHideForPlayer(playerid, dacing[0]);
		ApplyAnimation(playerid, "PED", "dance0", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
	if(playertextid == bdacing[playerid][1])
	{
		SelectTextDraw(playerid, 0xCD0400FF);
		CancelSelectTextDraw(playerid);
		for(new b=0; b < 6; b++){
		PlayerTextDrawHide(playerid, bdacing[playerid][b]); }
		TextDrawHideForPlayer(playerid, dacing[0]);
		ApplyAnimation(playerid, "PED", "dance1", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
	if(playertextid == bdacing[playerid][2])
	{
		SelectTextDraw(playerid, 0xCD0400FF);
		CancelSelectTextDraw(playerid);
		for(new b=0; b < 6; b++){
		PlayerTextDrawHide(playerid, bdacing[playerid][b]); }
		TextDrawHideForPlayer(playerid, dacing[0]);
		ApplyAnimation(playerid, "PED", "dance2", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
	if(playertextid == bdacing[playerid][3])
	{
		SelectTextDraw(playerid, 0xCD0400FF);
		CancelSelectTextDraw(playerid);
		for(new b=0; b < 6; b++){
		PlayerTextDrawHide(playerid, bdacing[playerid][b]); }
		TextDrawHideForPlayer(playerid, dacing[0]);
		ApplyAnimation(playerid, "PED", "dance3", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
	if(playertextid == bdacing[playerid][4])
	{
		SelectTextDraw(playerid, 0xCD0400FF);
		CancelSelectTextDraw(playerid);
		for(new b=0; b < 6; b++){
		PlayerTextDrawHide(playerid, bdacing[playerid][b]); }
		TextDrawHideForPlayer(playerid, dacing[0]);
		ApplyAnimation(playerid, "PED", "dance4", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
	if(playertextid == bdacing[playerid][5])
	{
		SelectTextDraw(playerid, 0xCD0400FF);
		CancelSelectTextDraw(playerid);
		for(new b=0; b < 6; b++){
		PlayerTextDrawHide(playerid, bdacing[playerid][b]); }
		TextDrawHideForPlayer(playerid, dacing[0]);
		ApplyAnimation(playerid, "PED", "dance5", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}

	// End
	// Workbench
    if(playertextid == pag2[playerid][0]){
    if(PaginaWork[playerid] == 1){
    PaginaWork[playerid] = 2;
    TextDrawHideForPlayer(playerid, PublicTD[0]);
    TextDrawShowForPlayer(playerid, PublicTD[1]);
    return 1;
    }
    if(PaginaWork[playerid] == 2){
    PaginaWork[playerid] = 1;
    TextDrawHideForPlayer(playerid, PublicTD[1]);
    TextDrawShowForPlayer(playerid, PublicTD[0]);
    return 1;
    }
    return 1;
    }
	// Taco com Arames (1)
	if(playertextid == Workbench[playerid][0]){
	if(PaginaWork[playerid] == 1){
	TacoOpen(playerid); }
	if(PaginaWork[playerid] == 2){
	GPSOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Bandage (2)
	if(playertextid == Workbench[playerid][4]){
	if(PaginaWork[playerid] == 1){
	BandageOpen(playerid); }
	if(PaginaWork[playerid] == 2){
	FogueiraOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Medkit (3)
	if(playertextid == Workbench[playerid][5]){
	if(PaginaWork[playerid] == 1){
	KitOpen(playerid); }
	if(PaginaWork[playerid] == 2){
	GlockOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Explosivo (3)
	if(playertextid == Workbench[playerid][6]){ // Etapa 1
	if(PaginaWork[playerid] == 1){
	ExplosivoOpen(playerid); }
	if(PaginaWork[playerid] == 2){
	RevolverOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Rádio (4)
	if(playertextid == Workbench[playerid][7]){
	if(PaginaWork[playerid] == 1){
	RadioOpen(playerid); }
	if(PaginaWork[playerid] == 2){
	SilenceOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Capa1 (5)
	if(playertextid == Workbench[playerid][8]){
	if(PaginaWork[playerid] == 1){
	Capa1Open(playerid); }
	if(PaginaWork[playerid] == 2){
	ParabellumOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Capa2 (6)
	if(playertextid == Workbench[playerid][9]){
	if(PaginaWork[playerid] == 1){
	Capa2Open(playerid); }
	if(PaginaWork[playerid] == 2){
	ShotgunOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Capa3 (7)
	if(playertextid == Workbench[playerid][10]){
	if(PaginaWork[playerid] == 1){
	Capa3Open(playerid); }
	if(PaginaWork[playerid] == 2){
	RifleOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Chapeu (8)
	if(playertextid == Workbench[playerid][11]){
	if(PaginaWork[playerid] == 1){
	ChapeuOpen(playerid); }
	if(PaginaWork[playerid] == 2){
	MP5Open(playerid); }
	return 1;
	}
	// x     x     x

	// Mochila1 (9)
	if(playertextid == Workbench[playerid][12]){
	if(PaginaWork[playerid] == 1){
	Mochila1Open(playerid); }
	if(PaginaWork[playerid] == 2){
	AK47Open(playerid); }
	return 1;
	}
	// x     x     x

	// Colete2 (14)
	if(playertextid == Workbench[playerid][13]){
	if(PaginaWork[playerid] == 1){
	Colete2Open(playerid); }
	if(PaginaWork[playerid] == 2){
	SniperOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Colete3 (15)
	if(playertextid == Workbench[playerid][14]){
	if(PaginaWork[playerid] == 1){
	Colete3Open(playerid); }
	if(PaginaWork[playerid] == 2){
	MotoOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Colete0 (12)
	if(playertextid == Workbench[playerid][15]){
	if(PaginaWork[playerid] == 1){
	Colete0Open(playerid); }
	if(PaginaWork[playerid] == 2){
	BobCatOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Colete1 (13)
	if(playertextid == Workbench[playerid][16]){
	if(PaginaWork[playerid] == 1){
	Colete1Open(playerid); }
	if(PaginaWork[playerid] == 2){
	JeepOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Mochila2 (10)
	if(playertextid == Workbench[playerid][17]){
	if(PaginaWork[playerid] == 1){
	Mochila2Open(playerid); }
	if(PaginaWork[playerid] == 2){
	PatriotOpen(playerid); }
	return 1;
	}
	// x     x     x

	// Mochila3 (11)
	if(playertextid == Workbench[playerid][18]){
	if(PaginaWork[playerid] == 1){
	Mochila3Open(playerid); }
	if(PaginaWork[playerid] == 2){
	HeliOpen(playerid); }
	return 1;
	}
	if(playertextid == Workbench[playerid][1]){ // Fechar menu de projetos(workbench)
	SelectTextDraw(playerid, 0xCD0400FF);
	TextDrawHideForPlayer(playerid, PublicTD[0]);
	TextDrawHideForPlayer(playerid, PublicTD[1]);
	for(new m=0; m < 32; m++) {
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	CancelSelectTextDraw(playerid);
	for(new i=0; i < 19; i++){
	PlayerTextDrawHide(playerid, Workbench[playerid][i]); }
	for(new q=0; q < 7; q++){
	PlayerTextDrawHide(playerid, Reqn[playerid][q]); }
	PlayerTextDrawHide(playerid, Desbloq[playerid][0]);
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	PlayerTextDrawHide(playerid, pag2[playerid][0]);
	PaginaWork[playerid] = 0;
	return 1;
	}
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	//
	if(playertextid == Workbench[playerid][2]){
	SelectTextDraw(playerid, 0xCD0400FF);
 	SendClientMessage(playerid, -1, "Button zerar points ok");
	return 1;
	}
	if(playertextid == Workbench[playerid][3]){ // Etapa 2
	SelectTextDraw(playerid, 0xCD0400FF);
	new perso = GetPlayerSkin(playerid);
	SetTimerEx("CloseMsg", 8000, 0, "i", playerid);
	if(tipitem[playerid][0] == 2) // Taco com arames
	{
		for(new i; i<17; i++)
		{
			//
		     if(InventarioInfo[playerid][i][iSlot] == 19793 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 //
			 if(InventarioInfo[playerid][i][iSlot] == 19793 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][0] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][0] += 1;
			 }
			 if(tipitem[playerid][0] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 336;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][0] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][0] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]);
			 }
		}
	}
	if(tipitem[playerid][1] == 2) // Bandage
	{
	    if(perso != 8) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 1509 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1241 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 1509 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][1] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1241 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][1] += 1;
			 }
			 if(tipitem[playerid][1] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 2752;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][1] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][1] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][2] == 2) // Medkit
	{
		if(perso != 8) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 2752 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 2752 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][2] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][2] += 1;
			 }
			 if(tipitem[playerid][2] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 11738;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][2] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][2] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][3] == 2) // Explosivos
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][3] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][3] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][3] += 1;
			 }
			 if(tipitem[playerid][3] == 5) {
			 InventarioInfo[playerid][i][iSlot] = 1654;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][3] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 3; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][3] != 5){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][4] == 2) // Rádio
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 18875 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][4] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 18875 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][4] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][4] += 1;
			 }
			 if(tipitem[playerid][4] == 5) {
			 InventarioInfo[playerid][i][iSlot] = 2966;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][4] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 3; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][4] != 5){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][5] == 2) // capa1
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][5] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][5] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][5] += 1;
			 }
			 if(tipitem[playerid][5] == 5) {
			 InventarioInfo[playerid][i][iSlot] = 19101;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][5] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 3; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][5] != 5){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][6] == 2) // capa2
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][6] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][6] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][6] += 1;
			 }
			 if(tipitem[playerid][6] == 5) {
			 InventarioInfo[playerid][i][iSlot] = 19514; // falta
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][6] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 3; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][6] != 5){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][7] == 2) // capa3
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 6) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 6) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][7] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 6)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][7] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 6)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][7] += 1;
			 }
			 if(tipitem[playerid][7] == 5) {
			 InventarioInfo[playerid][i][iSlot] = 19141;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][7] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 3; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/6", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/6", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][7] != 5){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][8] == 2) // chapeu
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][8] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][8] += 1;
			 }
			 if(tipitem[playerid][8] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 19100;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][8] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
		     return 1;
			 }
			 if(tipitem[playerid][8] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][9] == 2) // mochila1
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19088 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][9] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19088 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][9] += 1;
			 }
			 if(tipitem[playerid][9] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 19559;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][9] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/4", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
		     return 1;
			 }
			 if(tipitem[playerid][9] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][10] == 2) // colete2
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][10] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][10] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][10] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][10] += 1;
			 }
			 if(tipitem[playerid][10] == 6) {
			 InventarioInfo[playerid][i][iSlot] = 373;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][10] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 4; q++){
			 format(string, sizeof (string), "%d/4", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][10] != 6){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][11] == 2) // colete3
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 6) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 6) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 12) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 12) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 6)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][11] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 12)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][11] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 6)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][11] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 12)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][11] += 1;
			 }
			 if(tipitem[playerid][11] == 6) {
			 InventarioInfo[playerid][i][iSlot] = 19142;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][11] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 4; q++){
			 format(string, sizeof (string), "%d/6", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/12", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/6", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/12", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][11] != 6){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][12] == 2) // colete0
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][12] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][12] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][12] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][12] += 1;
			 }
			 if(tipitem[playerid][12] == 6) {
			 InventarioInfo[playerid][i][iSlot] = 19904;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][12] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 4; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][12] != 6){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][13] == 2) // colete1
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][13] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][13] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][13] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][13] += 1;
			 }
			 if(tipitem[playerid][13] == 6) {
			 InventarioInfo[playerid][i][iSlot] = 19515; // falta
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][13] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 4; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][13] != 6){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][14] == 2) // mochila2
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 19088 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 6) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 6)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][14] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19088 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][14] += 1;
			 }
			 if(tipitem[playerid][14] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 3026;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][14] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/6", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][14] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][15] == 2) // mochila1
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] > 12) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 11747 && InventarioInfo[playerid][i][iUnidades] == 12)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][15] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][15] += 1;
			 }
			 if(tipitem[playerid][15] == 4) {
			 InventarioInfo[playerid][i][iSlot] = 19559; // falta
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][15] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 2; q++){
			 format(string, sizeof (string), "%d/12", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][15] != 4){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][16] == 2) // GPS
	{
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 18875 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 18875 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][16] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][16] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][16] += 1;
			 }
			 if(tipitem[playerid][16] == 5) {
			 InventarioInfo[playerid][i][iSlot] = 18868;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][16] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 3; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][16] != 5){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][17] == 2) // Fogueira
	{
		for(new i; i<17; i++)
		{
		     if(InventarioInfo[playerid][i][iSlot] == 19793 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 19793 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][17] += 1;
			 }
			 if(tipitem[playerid][17] == 3) {
			 InventarioInfo[playerid][i][iSlot] = 16932;
			 InventarioInfo[playerid][i][iUnidades] = 1;
			 tipitem[playerid][17] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 1; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][17] != 3){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][18] == 2) // Glock
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][18] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][18] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][18] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][18] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][18] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][18] += 1;
			 }
			 if(tipitem[playerid][18] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 372;
			 InventarioInfo[playerid][i][iUnidades] = 30;
			 tipitem[playerid][18] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][18] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][19] == 2) // Revolver
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 		     if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][19] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][19] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][19] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][19] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][19] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][19] += 1;
			 }
			 if(tipitem[playerid][19] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 348;
			 InventarioInfo[playerid][i][iUnidades] = 16;
			 tipitem[playerid][19] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][19] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][20] == 2) // Silence
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][20] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][20] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][20] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][20] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][20] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][20] += 1;
			 }
			 if(tipitem[playerid][20] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 347;
			 InventarioInfo[playerid][i][iUnidades] = 32;
			 tipitem[playerid][20] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][20] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][21] == 2) // Parabellum
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
		 	 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
		     if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][21] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][21] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][21] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][21] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][21] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][21] += 1;
			 }
			 if(tipitem[playerid][21] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 346;
			 InventarioInfo[playerid][i][iUnidades] = 40;
			 tipitem[playerid][21] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/1", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][21] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][22] == 2) // Shotgun
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 		     if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
		     if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][22] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][22] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][22] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][22] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][22] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][22] += 1;
			 }
			 if(tipitem[playerid][22] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 349;
			 InventarioInfo[playerid][i][iUnidades] = 12;
			 tipitem[playerid][22] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][22] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][23] == 2) // Rifle .30
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 		 	 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
 			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][23] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][23] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][23] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][23] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][23] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][23] += 1;
			 }
			 if(tipitem[playerid][23] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 357;
			 InventarioInfo[playerid][i][iUnidades] = 28;
			 tipitem[playerid][23] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][23] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][24] == 2) // MP5
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 12) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][24] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 12)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][24] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][24] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][24] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][24] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][24] += 1;
			 }
			 if(tipitem[playerid][24] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 353;
			 InventarioInfo[playerid][i][iUnidades] = 60;
			 tipitem[playerid][24] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/12", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][24] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][25] == 2) // AK47
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
   			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 15) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][25] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 15)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][25] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][25] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][25] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][25] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][25] += 1;
			 }
			 if(tipitem[playerid][25] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 355;
			 InventarioInfo[playerid][i][iUnidades] = 80;
			 tipitem[playerid][25] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/15", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][25] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][26] == 2) // Sniper
	{
		if(perso != 7) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 20) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 3082 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][26] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 20)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][26] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][26] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2006 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][26] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][26] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 921 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][26] += 1;
			 }
			 if(tipitem[playerid][26] == 8) {
			 InventarioInfo[playerid][i][iSlot] = 358;
			 InventarioInfo[playerid][i][iUnidades] = 18;
			 tipitem[playerid][26] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/20", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][26] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][27] == 2) //Moto
	{
		if(perso != 305) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 120) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 20) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][27] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 120)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][27] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 20)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][27] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][27] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][27] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][27] += 1;
			 }
			 if(tipitem[playerid][27] == 8) {
			 // CRIAR VEICULO { ... }
			 tipitem[playerid][27] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/2", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/120", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/20", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/8", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][27] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][28] == 2) //BobCat
	{
		if(perso != 305) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 150) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 45) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 12) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][28] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 150)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][28] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 45)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][28] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 12)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][28] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][28] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][28] += 1;
			 }
			 if(tipitem[playerid][28] == 8) {
			 // CRIAR VEICULO { ... }
			 tipitem[playerid][28] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/4", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/150", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/45", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/12", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][28] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][29] == 2) //Jeep
	{
		if(perso != 305) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 120) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 45) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 12) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 4) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][29] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 120)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][29] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 45)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][29] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 12)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][29] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 4)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][29] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][29] += 1;
			 }
			 if(tipitem[playerid][29] == 8) {
			 // CRIAR VEICULO { ... }
			 tipitem[playerid][29] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/4", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/120", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/45", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/12", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/4", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][29] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][30] == 2) //Patriot
	{
		if(perso != 305) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] > 8) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 200) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 60) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 16) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 6) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	 	 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] > 1) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] == 8)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][30] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 200)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][30] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 60)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][30] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 16)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][30] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 6)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][30] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] == 1)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][30] += 1;
			 }
			 if(tipitem[playerid][30] == 8) {
			 // CRIAR VEICULO { ... }
			 tipitem[playerid][30] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/8", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/200", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/60", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/16", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/6", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/1", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][30] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	if(tipitem[playerid][31] == 2) //Heli
	{
		if(perso != 305) { return TextDrawShowForPlayer(playerid, msgw[1]); }
		for(new i; i<17; i++)
		{
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] > 16) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] > 400) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] > 80) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 	     if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] > 25) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] > 15) { return TextDrawShowForPlayer(playerid, msgw[5]);}
	 		 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] > 2) { return TextDrawShowForPlayer(playerid, msgw[5]);}
			 if(InventarioInfo[playerid][i][iSlot] == 915 && InventarioInfo[playerid][i][iUnidades] == 16)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][31] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 1510 && InventarioInfo[playerid][i][iUnidades] == 400)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][31] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19843 && InventarioInfo[playerid][i][iUnidades] == 80)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][31] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 2945 && InventarioInfo[playerid][i][iUnidades] == 25)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][31] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19627 && InventarioInfo[playerid][i][iUnidades] == 15)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][31] += 1;
			 }
			 if(InventarioInfo[playerid][i][iSlot] == 19917 && InventarioInfo[playerid][i][iUnidades] == 2)
			 {
			 	InventarioInfo[playerid][i][iSlot] = 19382;
			 	InventarioInfo[playerid][i][iUnidades] = 0;
			 	tipitem[playerid][31] += 1;
			 }
			 if(tipitem[playerid][31] == 8) {
			 // CRIAR VEICULO { ... }
			 tipitem[playerid][31] = 0;
			 for(new e; e<6; e++) {
		     Cont[playerid][e] = 0; }
		     //att reqs
		     new string[48];
			 for(new s=0; s < 6; s++){
			 PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
			 for(new q=0; q < 6; q++){
			 format(string, sizeof (string), "%d/16", Cont[playerid][0]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
			 format(string, sizeof (string), "%d/400", Cont[playerid][1]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
			 format(string, sizeof (string), "%d/80", Cont[playerid][2]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
			 format(string, sizeof (string), "%d/25", Cont[playerid][3]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
			 format(string, sizeof (string), "%d/15", Cont[playerid][4]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
			 format(string, sizeof (string), "%d/2", Cont[playerid][5]);
			 PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
			 PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
			 TextDrawShowForPlayer(playerid, msgw[3]);
			 return 1;
			 }
			 if(tipitem[playerid][31] != 8){
			 TextDrawShowForPlayer(playerid, msgw[0]); }
		}
	}
	for(new a; a < 32; a++)
	{
		if(tipitem[playerid][a] < 2)
		{
			TextDrawShowForPlayer(playerid, msgw[2]);
	  	}
  	}
	return 1;
	}
	if(playertextid == Desbloq[playerid][0]){ // Etapa 3
	SelectTextDraw(playerid, 0xCD0400FF);
	if(tipitem[playerid][0])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][0] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			TacoOpen(playerid);
			return 1;
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][1])
	{
		if(Dados[playerid][points] >= 2)
		{
			Dados[playerid][Itwork][1] = 1;

			//fechar
			Dados[playerid][points] -= 2;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			BandageOpen(playerid);
		}
		if(Dados[playerid][points] < 2)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][2])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][2] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			KitOpen(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][3])
	{
		if(Dados[playerid][points] >= 6)
		{
			Dados[playerid][Itwork][3] = 1;
			
			//fechar
			Dados[playerid][points] -= 6;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			ExplosivoOpen(playerid);
		}
		if(Dados[playerid][points] < 6)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][4])
	{
		if(Dados[playerid][points] >= 10)
		{
			Dados[playerid][Itwork][4] = 1;

			//fechar
			Dados[playerid][points] -= 10;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			RadioOpen(playerid);
		}
		if(Dados[playerid][points] < 10)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][5])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][5] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Capa1Open(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][6])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][6] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Capa2Open(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][7])
	{
		if(Dados[playerid][points] >= 6)
		{
			Dados[playerid][Itwork][7] = 1;

			//fechar
			Dados[playerid][points] -= 6;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Capa3Open(playerid);
		}
		if(Dados[playerid][points] < 6)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][8])
	{
		if(Dados[playerid][points] >= 2)
		{
			Dados[playerid][Itwork][8] = 1;

			//fechar
			Dados[playerid][points] -= 2;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			ChapeuOpen(playerid);
		}
		if(Dados[playerid][points] < 2)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][9])
	{
		if(Dados[playerid][points] >= 2)
		{
			Dados[playerid][Itwork][6] = 1;

			//fechar
			Dados[playerid][points] -= 2;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Mochila1Open(playerid);
		}
		if(Dados[playerid][points] < 2)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][10])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][10] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Colete2Open(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][11])
	{
		if(Dados[playerid][points] >= 6)
		{
			Dados[playerid][Itwork][11] = 1;

			//fechar
			Dados[playerid][points] -= 6;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Colete3Open(playerid);
		}
		if(Dados[playerid][points] < 6)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][12])
	{
		if(Dados[playerid][points] >= 2)
		{
			Dados[playerid][Itwork][12] = 1;

			//fechar
			Dados[playerid][points] -= 2;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Colete0Open(playerid);
		}
		if(Dados[playerid][points] < 2)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][13])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][13] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Colete1Open(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][14])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][14] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Mochila2Open(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][15])
	{
		if(Dados[playerid][points] >= 6)
		{
			Dados[playerid][Itwork][15] = 1;

			//fechar
			Dados[playerid][points] -= 6;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			Mochila3Open(playerid);
		}
		if(Dados[playerid][points] < 6)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][16])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][16] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			GPSOpen(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][17])
	{
		if(Dados[playerid][points] >= 3)
		{
			Dados[playerid][Itwork][17] = 1;

			//fechar
			Dados[playerid][points] -= 3;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			FogueiraOpen(playerid);
		}
		if(Dados[playerid][points] < 3)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][18])
	{
		if(Dados[playerid][points] >= 5)
		{
			Dados[playerid][Itwork][18] = 1;

			//fechar
			Dados[playerid][points] -= 5;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			GlockOpen(playerid);
		}
		if(Dados[playerid][points] < 5)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][19])
	{
		if(Dados[playerid][points] >= 5)
		{
			Dados[playerid][Itwork][19] = 1;

			//fechar
			Dados[playerid][points] -= 5;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			RevolverOpen(playerid);
		}
		if(Dados[playerid][points] < 5)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][20])
	{
		if(Dados[playerid][points] >= 5)
		{
			Dados[playerid][Itwork][20] = 1;

			//fechar
			Dados[playerid][points] -= 5;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			SilenceOpen(playerid);
		}
		if(Dados[playerid][points] < 5)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][21])
	{
		if(Dados[playerid][points] >= 5)
		{
			Dados[playerid][Itwork][21] = 1;

			//fechar
			Dados[playerid][points] -= 5;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			ParabellumOpen(playerid);
		}
		if(Dados[playerid][points] < 5)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][22])
	{
		if(Dados[playerid][points] >= 7)
		{
			Dados[playerid][Itwork][22] = 1;

			//fechar
			Dados[playerid][points] -= 7;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			ShotgunOpen(playerid);
		}
		if(Dados[playerid][points] < 7)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][23])
	{
		if(Dados[playerid][points] >= 7)
		{
			Dados[playerid][Itwork][23] = 1;

			//fechar
			Dados[playerid][points] -= 7;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			RifleOpen(playerid);
		}
		if(Dados[playerid][points] < 7)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][24])
	{
		if(Dados[playerid][points] >= 7)
		{
			Dados[playerid][Itwork][24] = 1;

			//fechar
			Dados[playerid][points] -= 7;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			MP5Open(playerid);
		}
		if(Dados[playerid][points] < 7)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][25])
	{
		if(Dados[playerid][points] >= 7)
		{
			Dados[playerid][Itwork][25] = 1;

			//fechar
			Dados[playerid][points] -= 7;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			AK47Open(playerid);
		}
		if(Dados[playerid][points] < 7)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][26])
	{
		if(Dados[playerid][points] >= 15)
		{
			Dados[playerid][Itwork][26] = 1;

			//fechar
			Dados[playerid][points] -= 15;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			SniperOpen(playerid);
		}
		if(Dados[playerid][points] < 15)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][27])
	{
		if(Dados[playerid][points] >= 17)
		{
			Dados[playerid][Itwork][27] = 1;

			//fechar
			Dados[playerid][points] -= 17;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			MotoOpen(playerid);
		}
		if(Dados[playerid][points] < 17)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][28])
	{
		if(Dados[playerid][points] >= 20)
		{
			Dados[playerid][Itwork][28] = 1;

			//fechar
			Dados[playerid][points] -= 20;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			BobCatOpen(playerid);
		}
		if(Dados[playerid][points] < 20)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][29])
	{
		if(Dados[playerid][points] >= 20)
		{
			Dados[playerid][Itwork][29] = 1;

			//fechar
			Dados[playerid][points] -= 20;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			JeepOpen(playerid);
		}
		if(Dados[playerid][points] < 20)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][30])
	{
		if(Dados[playerid][points] >= 25)
		{
			Dados[playerid][Itwork][30] = 1;

			//fechar
			Dados[playerid][points] -= 25;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			PatriotOpen(playerid);
		}
		if(Dados[playerid][points] < 25)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	if(tipitem[playerid][31])
	{
		if(Dados[playerid][points] >= 45)
		{
			Dados[playerid][Itwork][31] = 1;

			//fechar
			Dados[playerid][points] -= 45;
			WorkClose(playerid);
			TextDrawHideForPlayer(playerid, oc[0]);
			// abrir:
			WorkOpen(playerid);
			HeliOpen(playerid);
		}
		if(Dados[playerid][points] < 45)
		{
			TextDrawShowForPlayer(playerid, msgw[4]);
		}
	}
	SetTimerEx("CloseMsg", 8000, 0, "i", playerid);
	return 1;
	}
	if(playertextid == InUse[playerid][8] || playertextid == InUse[playerid][9] || playertextid == InUse[playerid][10])
	{
		if(Ut[playerid][7] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 1);
					Ut[playerid][7] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][8]);
					InventarioInfo[playerid][i][iSlot] = MOCHILA1;
					InventarioInfo[playerid][i][iUnidades] = 1;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
			return 1;
		}
		if(Ut[playerid][8] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 1);
					Ut[playerid][8] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][9]);
					InventarioInfo[playerid][i][iSlot] = MOCHILA2;
					InventarioInfo[playerid][i][iUnidades] = 1;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
			return 1;
		}
		if(Ut[playerid][9] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 1);
					Ut[playerid][9] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][10]);
					InventarioInfo[playerid][i][iSlot] = MOCHILA3;
					InventarioInfo[playerid][i][iUnidades] = 1;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
		}
		//
	}
	if(playertextid == InUse[playerid][4] || playertextid == InUse[playerid][5] || playertextid == InUse[playerid][6] || playertextid == InUse[playerid][7])
	{
		if(Ut[playerid][3] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 3);
					Ut[playerid][3] = 0;
					uItem[playerid][3] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][4]);
					InventarioInfo[playerid][i][iSlot] = 19904;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][3];
					Dados[playerid][Armadura] -= VidaItem[playerid][3];
					VidaItem[playerid][3] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
		}
		if(Ut[playerid][4] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 3);
					Ut[playerid][4] = 0;
					uItem[playerid][4] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][5]);
					InventarioInfo[playerid][i][iSlot] = 19515;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][4];
					Dados[playerid][Armadura] -= VidaItem[playerid][4];
					VidaItem[playerid][4] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
		}
		if(Ut[playerid][5] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 3);
					Ut[playerid][5] = 0;
					uItem[playerid][5] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][6]);
					InventarioInfo[playerid][i][iSlot] = 373;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][5];
					Dados[playerid][Armadura] -= VidaItem[playerid][5];
					VidaItem[playerid][5] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
		}
		if(Ut[playerid][6] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 3);
					Ut[playerid][6] = 0;
					uItem[playerid][6] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][7]);
					InventarioInfo[playerid][i][iSlot] = 19142;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][6];
					Dados[playerid][Armadura] -= VidaItem[playerid][6];
					VidaItem[playerid][6] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
		}
		for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
	}
	if(playertextid == InUse[playerid][0] || playertextid == InUse[playerid][1] || playertextid == InUse[playerid][2] || playertextid == InUse[playerid][3])
	{
		if(Ut[playerid][2] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 2);
					Ut[playerid][2] = 0;
					uItem[playerid][2] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][0]);
					InventarioInfo[playerid][i][iSlot] = 19101;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][2];
					Dados[playerid][Armadura] -= VidaItem[playerid][2];
					VidaItem[playerid][2] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
			   	 }
			}
		}
		if(Ut[playerid][1] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 2);
					Ut[playerid][1] = 0;
					uItem[playerid][1] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][1]);
					InventarioInfo[playerid][i][iSlot] = 19514;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][1];
					Dados[playerid][Armadura] -= VidaItem[playerid][1];
					VidaItem[playerid][1] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
			}
		}
		if(Ut[playerid][0] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 2);
					Ut[playerid][0] = 0;
					uItem[playerid][0] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][2]);
					InventarioInfo[playerid][i][iSlot] = 19141;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][0];
					Dados[playerid][Armadura] -= VidaItem[playerid][0];
					VidaItem[playerid][0] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
			}
		}
		if(Ut[playerid][10] == 1)
		{
			for(new i; i<17; i++)
			{
				 if(InventarioInfo[playerid][i][iSlot] == 19382)
				 {
					RemovePlayerAttachedObject(playerid, 2);
					Ut[playerid][10] = 0;
					uItem[playerid][10] = 0;
					PlayerTextDrawHide(playerid, InUse[playerid][3]);
					InventarioInfo[playerid][i][iSlot] = 19100;
					InventarioInfo[playerid][i][iUnidades] = VidaItem[playerid][7];
					Dados[playerid][Armadura] -= VidaItem[playerid][7];
					VidaItem[playerid][7] = 0;
					Atualizar(playerid);
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
			}
		}
		for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
	}
	if(!Ut[playerid][7] || !Ut[playerid][8] || !Ut[playerid][9]) {
	for(new i = 0; i < 4; i++){

			if(playertextid == invPreview[playerid][i]){

				if(MovendoInventario[playerid] == 0 || CombinandoInventario[playerid] == 0){

					new str[256];
					if(PaginaInventario[playerid] == 1){

						for(new j = 0; j < 4; j++){

							if(InventarioInfo[playerid][j][iUnidades] > 0){

								format(str, sizeof str, "%d", InventarioInfo[playerid][j][iUnidades]);
								PlayerTextDrawSetString(playerid, invName[playerid][j], str);
								PlayerTextDrawShow(playerid, invName[playerid][j]);
							}
						}
					}

					if(i >= 0  && i < 4 ){

						showInventarioBox(playerid, i);
					}
					PlayerTextDrawHide(playerid, invName[playerid][i]);
				}
				if(CombinandoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] != InventarioInfo[playerid][i][iSlot]){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
				if(ItemSelecionado[playerid] == i){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; i<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				InventarioInfo[playerid][i][iUnidades] += InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				CombinandoInventario[playerid] = 0;
			}

				if(MovendoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][i][iSlot] != 19382){

					MovendoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível mover este item.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				MovendoInventario[playerid] = 0;
				InventarioInfo[playerid][i][iSlot] = InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot];
				InventarioInfo[playerid][i][iUnidades] = InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				MovendoInventario[playerid] = 0;
			}
				ItemSelecionado[playerid] = i;

				SelectTextDraw(playerid, 0x00FFFFFF);
		}
	}
}
	if(Ut[playerid][7]) {
	for(new i = 0; i < 8; i++){

			if(playertextid == invPreview[playerid][i]){

				if(MovendoInventario[playerid] == 0 || CombinandoInventario[playerid] == 0){

					new str[256];
					if(PaginaInventario[playerid] == 1){

						for(new j = 0; j < 8; j++){

							if(InventarioInfo[playerid][j][iUnidades] > 0){

								format(str, sizeof str, "%d", InventarioInfo[playerid][j][iUnidades]);
								PlayerTextDrawSetString(playerid, invName[playerid][j], str);
								PlayerTextDrawShow(playerid, invName[playerid][j]);
							}
						}
					}

					if(i >= 0  && i < 8 ){

						showInventarioBox(playerid, i);
					}
					PlayerTextDrawHide(playerid, invName[playerid][i]);
				}
				if(CombinandoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] != InventarioInfo[playerid][i][iSlot]){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
				if(ItemSelecionado[playerid] == i){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; i<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				InventarioInfo[playerid][i][iUnidades] += InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				CombinandoInventario[playerid] = 0;
			}

				if(MovendoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][i][iSlot] != 19382){

					MovendoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível mover este item.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				MovendoInventario[playerid] = 0;
				InventarioInfo[playerid][i][iSlot] = InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot];
				InventarioInfo[playerid][i][iUnidades] = InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				MovendoInventario[playerid] = 0;
			}
				ItemSelecionado[playerid] = i;

				SelectTextDraw(playerid, 0x00FFFFFF);
		}
	}
}
	if(Ut[playerid][8]) {
	for(new i = 0; i < 12; i++){

			if(playertextid == invPreview[playerid][i]){

				if(MovendoInventario[playerid] == 0 || CombinandoInventario[playerid] == 0){

					new str[256];
					if(PaginaInventario[playerid] == 1){

						for(new j = 0; j < 12; j++){

							if(InventarioInfo[playerid][j][iUnidades] > 0){

								format(str, sizeof str, "%d", InventarioInfo[playerid][j][iUnidades]);
								PlayerTextDrawSetString(playerid, invName[playerid][j], str);
								PlayerTextDrawShow(playerid, invName[playerid][j]);
							}
						}
					}

					if(i >= 0  && i < 12 ){

						showInventarioBox(playerid, i);
					}
					PlayerTextDrawHide(playerid, invName[playerid][i]);
				}
				if(CombinandoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] != InventarioInfo[playerid][i][iSlot]){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
				if(ItemSelecionado[playerid] == i){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; i<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				InventarioInfo[playerid][i][iUnidades] += InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				CombinandoInventario[playerid] = 0;
			}

				if(MovendoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][i][iSlot] != 19382){

					MovendoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível mover este item.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				MovendoInventario[playerid] = 0;
				InventarioInfo[playerid][i][iSlot] = InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot];
				InventarioInfo[playerid][i][iUnidades] = InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				MovendoInventario[playerid] = 0;
			}
				ItemSelecionado[playerid] = i;

				SelectTextDraw(playerid, 0x00FFFFFF);
		}
	}
}
	if(Ut[playerid][9]) {
	for(new i = 0; i < 16; i++){

			if(playertextid == invPreview[playerid][i]){

				if(MovendoInventario[playerid] == 0 || CombinandoInventario[playerid] == 0){

					new str[256];
					if(PaginaInventario[playerid] == 1){

						for(new j = 0; j < 16; j++){

							if(InventarioInfo[playerid][j][iUnidades] > 0){

								format(str, sizeof str, "%d", InventarioInfo[playerid][j][iUnidades]);
								PlayerTextDrawSetString(playerid, invName[playerid][j], str);
								PlayerTextDrawShow(playerid, invName[playerid][j]);
							}
						}
					}

					if(i >= 0  && i < 16 ){

						showInventarioBox(playerid, i);
					}
					PlayerTextDrawHide(playerid, invName[playerid][i]);
				}
				if(CombinandoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] != InventarioInfo[playerid][i][iSlot]){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
				if(ItemSelecionado[playerid] == i){

					CombinandoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível combinar os dois itens.");

					for(new o = 0; i<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				InventarioInfo[playerid][i][iUnidades] += InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				CombinandoInventario[playerid] = 0;
			}

				if(MovendoInventario[playerid] == 1)
				{

				if(InventarioInfo[playerid][i][iSlot] != 19382){

					MovendoInventario[playerid] = 0;
					SelectTextDraw(playerid, 0x00FFFFFF);
					SendClientMessage(playerid, -1, "Não foi possível mover este item.");

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}

				MovendoInventario[playerid] = 0;
				InventarioInfo[playerid][i][iSlot] = InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot];
				InventarioInfo[playerid][i][iUnidades] = InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades];
				InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
				InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;

				for(new o = 0; o<4; o++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

				FecharInventario(playerid);
				AbrirInventario(playerid);
				SelectTextDraw(playerid, 0x00FFFFFF);
				MovendoInventario[playerid] = 0;
			}
				ItemSelecionado[playerid] = i;

				SelectTextDraw(playerid, 0x00FFFFFF);
		}
	}
}
	if(playertextid == InvSC[playerid][0])
	{
		FecharInventario(playerid);
  		for(new t = 0; t < 11; t++)
  		{
  		PlayerTextDrawHide(playerid, InUse[playerid][t]); }
		CancelSelectTextDraw(playerid);

		for(new i = 0; i<4; i++)     {
			PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
		return 1;
	}
	if( playertextid == invBox[playerid][0] ){

		new item = InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot];
		new slot = ItemSelecionado[playerid];
		new str[1500];
		if(item == 19382)
		return SendClientMessage(playerid, -1, "Não há itens suficientes para ser utilizado.");
		if(item > 10 && item < 312 ){

			new skin = GetPlayerSkin(playerid);
			SetPlayerSkin(playerid, item);
			for(new i = 0; i < 15; i++)
			{

				if(InventarioInfo[playerid][i][iSlot] == 19382)
				{

					format(str, 100, "Você vestiu a roupa %d, a anterior você guardou no inventário.", item);
					SendClientMessage(playerid, -1, str);

					for(new o = 0; o<4; o++)     {
						PlayerTextDrawDestroy(playerid,invBox[playerid][o]);   }

					DiminuirInv(slot, playerid);
					InventarioInfo[playerid][slot][iSlot] = skin;
					InventarioInfo[playerid][slot][iUnidades] = 1;
					FecharInventario(playerid);
					AbrirInventario(playerid);
					return 1;
				}
			}
			SendClientMessage(playerid, 0xFF6347AA, "* Seu inventário está cheio!");
			return 1;
		}
		if(item == ITEM_DINHEIRO) // dinheiro
		{

			format(str,300,"Você pegou $%d do seu inventário.",InventarioInfo[playerid][slot][iUnidades]);
			SendClientMessage(playerid,-1,str);
			GivePlayerMoney(playerid, InventarioInfo[playerid][slot][iUnidades]  );//
			InventarioInfo[playerid][slot][iSlot] = 19382;
			InventarioInfo[playerid][slot][iUnidades] = 0;
			Dados[playerid][Peso] -= 1;
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			return 1;
		}
		if(item == ITEM_CHAVEIRO) // Chaveiro
		{
			FecharInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			CancelSelectTextDraw(playerid);
			VerChaveiro(playerid, InventarioInfo[playerid][slot][iUnidades]);
			return 1;
		}
		if(item == RADIO)
		{
			FecharInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][11] == 0) {
			Iten[playerid] = 1;
			Ut[playerid][11] = 1;
			AnexarItem(playerid);
			return 1; }
			if(Ut[playerid][11] == 1)
			{
				RemovePlayerAttachedObject(playerid, 0);
				Ut[playerid][11] = 0;
				AbrirInventario(playerid);
			}
			return 1;
		}
		if(item == CAPA1)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][1] == 1 || Ut[playerid][0] == 1 || Ut[playerid][10] == 1) { return 1; } // Utilizando outros capacetes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][2] == 0) {
			Iten[playerid] = 6;
   			Ut[playerid][2] = 1;
   			uItem[playerid][2] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][2] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			}
			return 1;
		}
		if(item == CAPA2)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][2] == 1 || Ut[playerid][0] == 1 || Ut[playerid][10] == 1) { return 1; } // Utilizando outros capacetes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][1] == 0) {
			Iten[playerid] = 7;
			Ut[playerid][1] = 1;
			uItem[playerid][1] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][1] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			}
			return 1;
		}
		if(item == CAPA3)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][1] == 1 || Ut[playerid][2] == 1 || Ut[playerid][10] == 1) { return 1; } // Utilizando outros capacetes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][0] == 0) {
			Iten[playerid] = 8;
			Ut[playerid][0] = 1;
			uItem[playerid][0] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][0] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			}
			return 1;
		}
		if(item == COLETE0)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][4] == 1 || Ut[playerid][5] == 1 || Ut[playerid][6] == 1) { return 1; } // Utilizando outros coletes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][3] == 0) {
			Iten[playerid] = 9;
			Ut[playerid][3] = 1;
			uItem[playerid][3] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][3] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			return 1;
			}
		}
		if(item == COLETE1)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][3] == 1 || Ut[playerid][5] == 1 || Ut[playerid][6] == 1) { return 1; } // Utilizando outros coletes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][4] == 0) {
			Iten[playerid] = 10;
			Ut[playerid][4] = 1;
			uItem[playerid][4] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][4] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			return 1;
			}
		}
		if(item == COLETE2)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][4] == 1 || Ut[playerid][3] == 1 || Ut[playerid][6] == 1) { return 1; } // Utilizando outros coletes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][5] == 0) {
			Iten[playerid] = 11;
			Ut[playerid][5] = 1;
			uItem[playerid][5] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][5] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			return 1;
			}
		}
		if(item == COLETE3)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][4] == 1 || Ut[playerid][5] == 1 || Ut[playerid][3] == 1) { return 1; } // Utilizando outros coletes. obs: retornar mensagem em imagem.
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][6] == 0) {
			Iten[playerid] = 12;
			Ut[playerid][6] = 1;
			uItem[playerid][6] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][6] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			return 1;
			}
		}
		if(item == MOCHILA1)
		{
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][7] == 0) {
			Iten[playerid] = 2;
			Ut[playerid][7] = 1;
			AnexarItem(playerid);
			Atualizar(playerid);
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			}
			return 1;
		}
		if(item == MOCHILA2)
		{
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][8] == 0) {
			Iten[playerid] = 3;
			Ut[playerid][8] = 1;
			AnexarItem(playerid);
			Atualizar(playerid);
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			}
			return 1;
		}
		if(item == MOCHILA3)
		{
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][9] == 0) {
			Iten[playerid] = 4;
			Ut[playerid][9] = 1;
			AnexarItem(playerid);
			Atualizar(playerid);
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			}
			return 1;
		}
		if(item == CHAPEU)
		{
			if(!InventarioInfo[playerid][slot][iUnidades]) { return 1; } // Item quebrado. obs: retornar mensagem em imagem.
			if(Ut[playerid][2] == 1 || Ut[playerid][0] == 1|| Ut[playerid][1] == 1) { return 1; } // Utilizando outros capacetes. obs: retornar mensagem em imagem.
			FecharInventario(playerid);
			CancelSelectTextDraw(playerid);
			if(Ut[playerid][10] == 0) {
			Iten[playerid] = 5;
			Ut[playerid][10] = 1;
			uItem[playerid][10] = 1;
			AnexarItem(playerid);
			Dados[playerid][Armadura] += InventarioInfo[playerid][slot][iUnidades];
			VidaItem[playerid][7] += InventarioInfo[playerid][slot][iUnidades];
			Atualizar(playerid);
			//
			InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
			FecharInventario(playerid);
			AbrirInventario(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			}
			return 1;
		}
		if(item == CAVALO) // Cavalo
		{
			FecharInventario(playerid);
			CancelSelectTextDraw(playerid);
			for(new i = 0; i<4; i++) PlayerTextDrawDestroy(playerid,invBox[playerid][i]);
			//
			if(PlayerInHorse[playerid])
			{
				new carid = GetPlayerVehicleID(playerid);
				DestroyVehicle(carid);
				PlayerInHorse[playerid] = 0;
				Dados[HorseForPlayer[playerid]][Cavalo] = 0;
				FCNPC_Destroy(HorseForPlayer[playerid]);
				HorseForPlayer[playerid] = 0;
				Dados[playerid][FollowFour] = 0; // Cavalos
				StopAudioStreamForPlayer(playerid);
				return 1;
			}
			if(!PlayerInHorse[playerid])
			{
				new carid, Float:Pos[3];
				new mot, lu, alar, por, cap, porma, ob;
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				carid = CreateVehicle(471, Pos[0], Pos[1], Pos[2], random(200), random(200), -1, -1);
				GetVehicleParamsEx(carid, mot, lu, alar, por, cap, porma, ob);
				SetVehicleParamsEx(carid, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
				Gas[carid] = 100;
				vehEngine[carid] = 0;
				PutPlayerInVehicle(playerid,carid,0);
				//
				new horse[MAX_PLAYER_NAME + 1];
				format(horse, sizeof(horse), "Horse_%d", cNpcCount);
				new npcid = FCNPC_Create(horse);
				GetVehicleParamsEx(carid, mot, lu, alar, por, cap, porma, ob);
				SetVehicleParamsEx(carid, VEHICLE_PARAMS_ON, lu, alar, por, cap, porma, ob);
				vehEngine[carid] = 1;
				Gas[carid] = 1000;
				Vuln[carid] = 1000;
				new
					Float:player_x,
					Float:player_y,
					Float:player_z,
					Float:player_angle;

				GetPlayerPos(playerid, player_x, player_y, player_z);
				GetPlayerFacingAngle(playerid, player_angle);

				new
					Float:pos_x,
					Float:pos_y;

				GetCoordsInFront(player_x, player_y, player_angle, 2.0, pos_x, pos_y);
				FCNPC_Spawn(npcid,6, pos_x, pos_y, player_z);
				FCNPC_SetVirtualWorld(npcid, GetPlayerVirtualWorld(playerid));
				FCNPC_SetInterior(npcid, GetPlayerInterior(playerid));
				FCNPC_PutInVehicle(npcid, carid, 1);
				Dados[npcid][Cavalo] = 1;
				SetTimerEx("MovimentHorse", 300, true, "i", npcid);
				cNpcCount++;
				PlayerInHorse[playerid] = 1;
				HorseForPlayer[playerid] = npcid;
  			 }
			return 1;
		}
		if(item >= 331 && item < 369) // Armas
		{
            new string[350];
            GivePlayerWeapon(playerid,MudarIdArma(item), InventarioInfo[playerid][slot][iUnidades]);
            format(string, sizeof string, "* Você pegou uma %s com %d bala(s) do seu inventário.", NomeArmaInventario(InventarioInfo[playerid][slot][iSlot]), InventarioInfo[playerid][slot][iUnidades]);
        	SendClientMessage(playerid, -1, string);
            InventarioInfo[playerid][slot][iSlot] = 19382;
            InventarioInfo[playerid][slot][iUnidades] = 0;
		    DiminuirInv(slot, playerid);
		    FecharInventario(playerid);
		    AbrirInventario(playerid);
            for(new i = 0; i<4; i++)     {
            PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
			return 1;
		}
		for(new o; o < 10; o++){

			if(!IsPlayerAttachedObjectSlotUsed(playerid, o))
			{

				new str1[300];
				format(str1,300,"Espinha\nCabeça\nBraço esquerdo\nBraço direito\nMão esquerda\nMão direita\nCoxa esquerda\nCoxa direita\nPé esquerdo\nPé direito\nPanturrilha direita\nPanturrilha esquerda\nAntebraço esquerdo\nAntebraço direito\nOmbro esquerto\nOmbro direito\nPescoço\nMandíbula");
				SetPVarInt(playerid,"slotusar",slot);
				ShowPlayerDialog(playerid, 21215, DIALOG_STYLE_LIST, "Escolher Local", str1, "Escolher", "Cancelar");
				FecharInventario(playerid);
				for(new i = 0; i<4; i++)     {
					PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
				CancelSelectTextDraw(playerid);
				if(!IsPlayerInAnyVehicle(playerid)) ClearAnimations(playerid);
				if(!IsPlayerInAnyVehicle(playerid)) SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(playerid, 9);
				return 1;
			}
		}
		SendClientMessage(playerid,-1,"Você já tem 10 acessorios.");
	}
	if(playertextid == invBox[playerid][2]){

		if(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] == 19382){

			SendClientMessage(playerid, -1, "Não há itens suficientes para ser movido.");

			for(new i = 0; i<4; i++)     {
				PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
			FecharInventario(playerid);
			AbrirInventario(playerid);
			return 1;
		}


		for(new i = 0; i<4; i++)     {
			PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
		FecharInventario(playerid);
		AbrirInventario(playerid);

		SelectTextDraw(playerid, 0xCD0400FF);
		MovendoInventario[playerid] = 1;
		CombinandoInventario[playerid] = 0;
	}
	if(playertextid == invBox[playerid][3]){

		new str[180];

		if(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] == 19382){

			SendClientMessage(playerid, -1, "Não há itens suficientes para ser descartado.");

			for(new i = 0; i<4; i++)     {
				PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
			return 1;
		}
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		format(str, 280, "Você largou um item: %s, com %d unidade(s)", NomeItemInventario(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot]), InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades]);
		SendClientMessage(playerid, -1, str);
		CreateDroppedItem(InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot], InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades], X, Y, Z);
		InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot] = 19382;
		InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] = 0;
		Dados[playerid][Peso] -= 1;
		FecharInventario(playerid);
		AbrirInventario(playerid);
		for(new i = 0; i<4; i++)     {
			PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
	}
	if(playertextid == invBox[playerid][1]){
 		new item = InventarioInfo[playerid][ItemSelecionado[playerid]][iSlot];
		if(item >= 331 && item < 369) return 1;
		if(item == ITEM_CHAVEIRO) return SendClientMessage(playerid,-1,"Este item não pode ser dividido.");
 	    ShowPlayerDialog(playerid, 1099, DIALOG_STYLE_INPUT, "Separar item",
	    "{FFFFFF}Digite a quantidade que você deseja separar:\n\n\
	    {FF6347}OBS:{9C9C9C}O valor deve ser acima de zero!", "Separar", "Cancelar");
		for(new i = 0; i<4; i++)     {
        PlayerTextDrawDestroy(playerid,invBox[playerid][i]);   }
	}
	return 1;
}
public FCNPC_OnGiveDamage(npcid, damagedid, Float:amount, weaponid, bodypart)
{
	if(damagedid != npcid)
	{
		Dados[damagedid][Armadura] -= 10;
		AtualizarItem(damagedid);
		if(Dados[damagedid][Armadura] <= 1.0)
		{
			if (weaponid == 0)
			{
				Dados[damagedid][Saude] -= 10;
			}
			if(Dados[damagedid][Saude] <= 0 && !Dados[damagedid][Chao])
			{
				SetTimerEx("Feridox",4000,false,"i",damagedid); // Ferindo se ele não tiver mais vida.
			}
		}
		Atualizar(damagedid);
	}
	return 1;
}
public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
    if(weaponid == 24) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//DesertEagle
    if(weaponid == 22) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//Colt45
    if(weaponid == 32) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//Tec9
    if(weaponid == 28) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//Uzi
    if(weaponid == 23) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//SilencedColt
    if(weaponid == 31) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//M4
    if(weaponid == 30) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//AK
    if(weaponid == 29) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//MP5
    if(weaponid == 34) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//SniperRifle
    if(weaponid == 33) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//CuntGun
    if(weaponid == 25) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//PumpShotgun
    if(weaponid == 27) FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid)-0);//Spaz12

	if(!IsPlayerConnected(npcid)) return 0;
	if(!IsPlayerConnected(issuerid)) return 0;
	if(issuerid != INVALID_PLAYER_ID && weaponid >= 22 && weaponid <= 38 && bodypart == 9)
	{
		FCNPC_Stop(npcid);
		FCNPC_StopAttack(npcid);
		TogglePlayerControllable(npcid,1);
		FCNPC_SetInvulnerable(npcid, true);
		ApplyAnimation(npcid,"PED","FLOOR_hit_f",4.1,0,1,1,1,1,1);
		Dados[npcid][mZombie] = 1;

		new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(issuerid, name, sizeof(name));

		new msg[144];
	 	format(msg, sizeof(msg), "NPC %d for morto por %d (%s) com a arma %d.", npcid, issuerid, name, weaponid);
	 	SendClientMessage(issuerid,-1, msg);
	 	SetTimerEx("DestroyZo", 57000, 0, "i", npcid); // 1 Minuto para reviver
	}
	return 1;
}
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
	if(Dados[damagedid][Zombie] == 0 && Dados[damagedid][Animal] == 0) // Danos compativeis apenas com pessoas.
	{
		amount = 0;

		if (weaponid == 0)
		{
			if (Dados[damagedid][Resistencia] < 25 && Dados[playerid][Forca] >= 25 && !Dados[damagedid][Chao])
			{
				ApplyAnimation(damagedid,"PED","BIKE_fall_off",4.1,0,1,1,1,1,1);
				Dados[damagedid][Saude] -= 20;
			}
			else
			{
				switch(bodypart)
				{
					case CABECA_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
					case TRONCO_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
					case VIRILHA_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
					case BRACO_ESQUERDO_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
					case BRACO_DIREITO_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
					case PERNA_ESQUERDA_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
					case PERNA_DIREITA_ID: Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
				}
			} // Condicional Vitima sem resistencia, Player com força e vitima não está morto/ferido.
		}
		else
		{
			if (!Dados[damagedid][EmBlindado] && Dados[damagedid][Morto] == 0)
			{
				if(Dados[damagedid][Chao] && Dados[damagedid][Ferido] > 0)
				{
					if (Dados[damagedid][Ferido] >= 1000) Dados[damagedid][Ferido] -= 1000;
					else Dados[damagedid][Ferido] = 0;
				}
				else
				{
					if (bodypart == TRONCO_ID)
					{
						Dados[damagedid][Armadura] -= armaInfo[weaponid][dTronco];
						AtualizarItem(damagedid);
						if (armaInfo[weaponid][isArmaDeFogo])
						{
							if(Dados[damagedid][Armadura] <= 1.0)
							{
								ApplyAnimation(damagedid,"PED","KO_shot_stom",4.1,0,1,1,1,1,1);
								SetTimerEx("Feridox",4000,false,"i",damagedid);
							}
						}
					}
					if (bodypart == VIRILHA_ID)
					{
						Dados[damagedid][Armadura] -= armaInfo[weaponid][dVirilha];
						AtualizarItem(damagedid);
						if (armaInfo[weaponid][isArmaDeFogo])
						{
							if(Dados[damagedid][Armadura] <= 1.0)
							{
								ApplyAnimation(damagedid,"PED","KO_shot_stom",4.1,0,1,1,1,1,1);
								SetTimerEx("Feridox",4000,false,"i",damagedid);
							}
						}
					}
					if (bodypart == BRACO_ESQUERDO_ID || bodypart == BRACO_DIREITO_ID)
					{
						Dados[damagedid][Armadura] -= armaInfo[weaponid][dVirilha];
						AtualizarItem(damagedid);
						if(Dados[damagedid][Armadura] <= 1.0)
						{
							Dados[damagedid][Saude] -= armaInfo[weaponid][dBraco];
							if (armaInfo[weaponid][isArmaDeFogo] && !Dados[damagedid][Braco])
							{
								SendClientMessage(damagedid, -1, "Seu braço foi alvejado e quebrou!");
								Dados[damagedid][Braco] = 1;
							}
						}
					}
					if (bodypart == PERNA_ESQUERDA_ID || bodypart == PERNA_DIREITA_ID)
					{
						Dados[damagedid][Armadura] -= armaInfo[weaponid][dVirilha];
						AtualizarItem(damagedid);
						if(Dados[damagedid][Armadura] <= 1.0)
						{
							Dados[damagedid][Saude] -= armaInfo[weaponid][dPerna];
							if (armaInfo[weaponid][isArmaDeFogo] && !Dados[damagedid][Mancando])
							{
								SendClientMessage(damagedid, -1, "Sua perna foi alvejada e quebrou!");
								Dados[damagedid][Mancando] = 1;
							}
						}
					}
					if (bodypart == CABECA_ID)
					{
						Dados[damagedid][Armadura] -= armaInfo[weaponid][dCabeca];
						AtualizarItem(damagedid);
						if(Dados[damagedid][Armadura] <= 1.0)
						{
							ApplyAnimation(damagedid,"PED","KO_shot_face",4.1,0,1,1,1,1);
							SetTimerEx("Feridox",4000,false,"i",damagedid);
						}
					}
				}
			}
		}
		if(Dados[damagedid][Saude] <= 0 && !Dados[damagedid][Chao])
		{
			SetTimerEx("Feridox",4000,false,"i",damagedid); // Ferindo se ele não tiver mais vida.
		}
		Atualizar(damagedid);

		new string[144];
		new parteCorpo[48];
		if(bodypart == TRONCO_ID) parteCorpo = "Tronco";
		if(bodypart == VIRILHA_ID) parteCorpo = "Virilha";
		if(bodypart == BRACO_ESQUERDO_ID) parteCorpo = "B Esquerdo";
		if(bodypart == BRACO_DIREITO_ID) parteCorpo = "B Direito";
		if(bodypart == PERNA_ESQUERDA_ID) parteCorpo = "P Esquerda";
		if(bodypart == PERNA_DIREITA_ID) parteCorpo = "P Direita";
		if(bodypart == CABECA_ID) parteCorpo = "Cabeça";

		if(Dados[damagedid][Animal] == 0)
	 	{
			format(string, sizeof(string), "%s causou dano em %s, arma: %s, corpo: %s", Nome(playerid),Nome(damagedid), armaInfo[weaponid][nomeArma], parteCorpo);
			EnviarMensagemPainel(string, PAINEL_DANO_ID);
		}
	}
	return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new string[144];
	if(weaponid == QUEDA_ID)
	{
		format(string, sizeof (string), "%s sofreu dano por queda.", GetPlayerNome(playerid));
		EnviarMensagemPainel(string, PAINEL_DANO_ID);

		if(amount >= 10 && amount < 25)
		{
			SendClientMessage(playerid, -1, "Você caiu de um lugar alto e quebrou alguns ossos do seu corpo!");
			if(Dados[playerid][Chao] && !Dados[playerid][Morto])
			{
				Dados[playerid][Ferido] = Dados[playerid][Ferido] <= 200 ? 0 : Dados[playerid][Ferido] - 200;
			}
			else
			{
				new quebrado = random(2);
				if (quebrado == 0) Dados[playerid][Mancando] = 1;
				if (quebrado == 1) Dados[playerid][Braco] = 1;
				Dados[playerid][Saude] -= 10;
			}
		}
		if(amount >= 25 && amount < 40)
		{
			SendClientMessage(playerid, -1, "Você caiu de um lugar muito alto e quebrou vários ossos do seu corpo!");
			if(Dados[playerid][Chao] && !Dados[playerid][Morto])
			{
				Dados[playerid][Ferido] = Dados[playerid][Ferido] <= 500 ? 0 : Dados[playerid][Ferido] - 500;
			}
			else
			{
				Dados[playerid][Mancando] = 1;
				Dados[playerid][Braco] = 1;
				Dados[playerid][Saude] -= 20;
			}
		}
		if(amount >= 40 && amount < 100)
		{
			SendClientMessage(playerid, -1, "Você caiu de um lugar extremamente alto e ficou inconsciente!");
			Dados[playerid][Mancando] = 1;
			Dados[playerid][Braco] = 1;
			if(Dados[playerid][Chao])
			{
				Dados[playerid][Ferido] = 0;
			}
			else Feridox(playerid);
		}
		if(amount >= 100)
		{
			SendClientMessage(playerid, -1, "Você caiu de um lugar extremamente alto e não conseguiu resistir aos ferimentos!");
			if(!Dados[playerid][Chao]) Feridox(playerid);
			Dados[playerid][Ferido] = 0;
		}
	}
	if (weaponid == ATROPELAMENTO_ID){
		format(string, sizeof (string), "%s sofreu dano por atropelamento.", GetPlayerNome(playerid));
		EnviarMensagemPainel(string, PAINEL_DANO_ID);

		SendClientMessage(playerid, -1, "Você foi atropelado e quebrou alguns ossos do seu corpo!");
		new quebrado = random(2);
		if (quebrado == 0) Dados[playerid][Mancando] = 1;
		if (quebrado == 1) Dados[playerid][Braco] = 1;
		Dados[playerid][Saude] -= 8;
		Caiu(playerid);
	}

	if(Dados[playerid][Saude] <= 0 && !Dados[playerid][Chao])
	{
		SetTimerEx("Feridox",4000,false,"i",playerid); // Ferindo se ele não tiver mais vida.
	}
	Atualizar(playerid);
}
public OnPlayerRequestClass(playerid, classid)
{
	TogglePlayerSpectating(playerid, 1);
	new  string[200];
	if(DOF2_FileExists(Contas(playerid)))
	{
		format(string, sizeof(string), "{FFFFFF}Informe a senha da conta:");
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Senha", string , "Entrar", "Voltar");
	}
	else
	{
		format(string, sizeof(string), "{FFFFFF}Informe uma senha para registrar a conta:");
		ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Senha", string , "Registrar", "Voltar");
	}
	return 1;
}
public MovimentHorse(npcid)
{
	new playervehicle;
	if ((playervehicle = GetPlayerVehicleID(npcid)) != INVALID_VEHICLE_ID)
	{
		if(GetVehicleSpeed(playervehicle) < 1) // Horse Stop
		{
			ApplyAnimation(npcid,"PED","horse_idle_1",4.1,0,1,1,1,1,1); // Cavalo parado.
		}
		if(GetVehicleSpeed(playervehicle) >= 1) // Horse Walk
		{
			ApplyAnimation(npcid,"PED","horse_walk",4.1,1,1,1,1,1,1); // Cavalo andando.
		}
		if(GetVehicleSpeed(playervehicle) >= 31 ) // Horse Walk Speed
		{
			ApplyAnimation(npcid,"PED","horse_sprint",4.1,1,1,1,1,1,1); // Cavalo correndo rapido
		}
	}
	return 1;
}
public AtualizarVelo(playerid)
{
	new playervehicle;
	if ( (playervehicle = GetPlayerVehicleID(playerid)) != INVALID_VEHICLE_ID)
	{

		new string_velo[256];
		format(string_velo, sizeof (string_velo), "%d KM", GetVehicleSpeed(playervehicle));
		PlayerTextDrawSetString(playerid, Velo[playerid][0], string_velo);
		if(Vuln[playervehicle] < 1)
		{

			format(string_velo, sizeof (string_velo), "%.0f%", GetVehicleHealthEx(playervehicle));
			PlayerTextDrawSetString(playerid, Velo[playerid][1], string_velo);
		}
		else
		{

			format(string_velo, sizeof (string_velo), "Blindado");
			PlayerTextDrawSetString(playerid, Velo[playerid][1], string_velo);
		}
		format(string_velo, sizeof (string_velo), "%d L", Gas[playervehicle]);
		PlayerTextDrawSetString(playerid, Velo[playerid][2], string_velo);

	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	PaginaInventario[playerid] = 1;
	format(Erquivo, sizeof Erquivo, "Inventario/%s.ini", Nome(playerid));

 	if(!DOF2_FileExists(Erquivo)){

	    CriarInventario(playerid);
	}
	else
	{
		CarregarInventario(playerid);
	}
	//
	PlayerVelocimetro[playerid] = false;
	// • Pontes
	//
	RemoveBuildingForPlayer(playerid, 3331, -1623.739, -1628.410, 41.875, 0.250);
	RemoveBuildingForPlayer(playerid, 3332, -1623.739, -1628.410, 41.875, 0.250);
	RemoveBuildingForPlayer(playerid, 18450, -1627.209, -1620.910, 34.914, 0.250);
	RemoveBuildingForPlayer(playerid, 18538, -1627.209, -1620.910, 34.914, 0.250);
	RemoveBuildingForPlayer(playerid, 18449, -1700.979, -1651.839, 34.914, 0.250);
	RemoveBuildingForPlayer(playerid, 18537, -1700.979, -1651.839, 34.914, 0.250);
	RemoveBuildingForPlayer(playerid, 3331, -1697.790, -1659.459, 41.875, 0.250);
	RemoveBuildingForPlayer(playerid, 3332, -1697.790, -1659.459, 41.875, 0.250);
	//
	//OBJETOS AEROPORTO
	RemoveBuildingForPlayer(playerid, 3672, 1889.6563, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1649.0625, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1889.6563, -2666.0078, 18.8828, 0.25);
	CreateObject(16098, 1887.62842, -2648.11816, 17.43370,   0.00000, 0.00000, 91.00000);
	CreateObject(16098, 1821.55042, -2648.11816, 17.43370,   0.00000, 0.00000, 90.00000);
	CreateObject(16098, 1755.09839, -2648.11816, 17.43370,   0.00000, 0.00000, 90.00000);
	CreateObject(1290, 1788.81494, -2639.88672, 18.47660,   356.85840, 0.00000, -3.12520);
	CreateObject(10814, 1640.06714, -2676.80347, 16.15450,   0.00000, 0.00000, 178.00000);
	CreateObject(1290, 1720.92419, -2639.88672, 18.47656,   356.85840, 0.00000, -3.12515);
	CreateObject(1290, 1630.12244, -2656.98828, 18.47656,   356.85840, 0.00000, -3.12515);
	CreateObject(1290, 1646.11169, -2657.57275, 18.47656,   356.85840, 0.00000, -3.12515);
	//FIM OBJETOS AEROPORTO

	//PEDAGIO ANGEL PINE
	CreateObject(7033, -1119.19543, -2857.91821, 71.06570,   0.00000, 0.00000, 91.00000);
	CreateObject(966, -1120.57800, -2860.29834, 66.66960,   0.00000, 0.00000, 92.30000);
	CreateObject(1237, -1120.27002, -2869.80884, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1120.24792, -2867.89624, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1120.28540, -2868.87402, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(966, -1121.28479, -2855.61279, 66.66960,   0.00000, 0.00000, -87.76000);
	CreateObject(1237, -1120.24792, -2867.89624, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1121.69775, -2848.11035, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1120.27002, -2869.80884, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1121.70935, -2847.03345, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1121.72217, -2845.90430, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(19989, -1160.66919, -2859.07910, 66.65020,   0.00000, 0.00000, 273.00000);
	CreateObject(19989, -1079.16602, -2857.70190, 66.65020,   0.00000, 0.00000, 90.00000);
	//PEDAGIO LS/LV
	CreateObject(9623, 1741.29565, 527.96973, 29.39350,   -3.00000, 0.00000, -18.50000);
	CreateObject(966, 1752.70667, 529.16046, 26.26540,   2.16000, 0.50000, 158.53999);
	CreateObject(966, 1743.73718, 532.58051, 26.26540,   2.16000, 0.50000, 158.53999);
	CreateObject(966, 1738.24561, 523.41498, 26.84540,   -2.50000, 0.00000, -17.96000);
	CreateObject(966, 1729.86572, 526.34528, 26.84540,   -2.50000, 0.00000, -17.96000);
	CreateObject(1237, 1722.46045, 528.80078, 26.96500,   -6.72000, 0.00000, 0.00000);
	CreateObject(1237, 1721.50623, 529.15082, 26.96500,   -6.72000, 0.00000, 0.00000);
	CreateObject(1237, 1759.71533, 526.29120, 26.34500,   0.00000, 0.00000, 0.00000);

	//CANCELA PEDAGIO ANGEL PINE
	CancelaP[playerid][0] = CreatePlayerObject(playerid, 968, -1120.59277, -2860.23462, 67.43290, 0.00000, 90.00000, 272.38000);
	CancelaP[playerid][1] = CreatePlayerObject(playerid, 968, -1121.28052, -2855.66870, 67.43290, 0.00000, 90.00000, 92.18000);
	//CANCELA PEDAGIO LS/LV
	CancelaP[playerid][2] = CreatePlayerObject(playerid, 968, 1752.64233, 529.21753, 27.08570,   0.00000, 90.00000, -21.52000); //Direita meio
	CancelaP[playerid][3] = CreatePlayerObject(playerid, 968, 1743.69641, 532.61810, 27.08570,   0.00000, 90.00000, -21.52000);	//direita
	CancelaP[playerid][4] = CreatePlayerObject(playerid, 968, 1738.31946, 523.43921, 27.62790,   0.00000, 90.00000, 162.17999);	//esquerda
	CancelaP[playerid][5] = CreatePlayerObject(playerid, 968, 1729.92896, 526.36902, 27.62790,   0.00000, 90.00000, 162.17999);	//esuquerda meio
	// TextDraws HUD


	Debug[playerid][0] = CreatePlayerTextDraw(playerid, 653.600036, 182.035537, "");
	PlayerTextDrawLetterSize(playerid, Debug[playerid][0], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, Debug[playerid][0], 1);
	PlayerTextDrawColor(playerid, Debug[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, Debug[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, Debug[playerid][0], 255);
	PlayerTextDrawFont(playerid, Debug[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, Debug[playerid][0], 1);

	HudP[playerid][0] = CreatePlayerTextDraw(playerid, 619.999572, 192.488830, "100"); // Sede
	PlayerTextDrawLetterSize(playerid, HudP[playerid][0], 0.209999, 1.097244);
	PlayerTextDrawAlignment(playerid, HudP[playerid][0], 1);
	PlayerTextDrawColor(playerid, HudP[playerid][0], -285212673);
	PlayerTextDrawSetShadow(playerid, HudP[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, HudP[playerid][0], 255);
	PlayerTextDrawFont(playerid, HudP[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, HudP[playerid][0], 1);

	HudP[playerid][1] = CreatePlayerTextDraw(playerid, 619.999572, 216.382156, "100"); // Vida
	PlayerTextDrawLetterSize(playerid, HudP[playerid][1], 0.209999, 1.097244);
	PlayerTextDrawAlignment(playerid, HudP[playerid][1], 1);
	PlayerTextDrawColor(playerid, HudP[playerid][1], -285212673);
	PlayerTextDrawSetShadow(playerid, HudP[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, HudP[playerid][1], 255);
	PlayerTextDrawFont(playerid, HudP[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, HudP[playerid][1], 1);

	HudP[playerid][2] = CreatePlayerTextDraw(playerid, 619.999633, 248.239898, "100"); // Armadura
	PlayerTextDrawLetterSize(playerid, HudP[playerid][2], 0.209999, 1.097244);
	PlayerTextDrawAlignment(playerid, HudP[playerid][2], 1);
	PlayerTextDrawColor(playerid, HudP[playerid][2], -285212673);
	PlayerTextDrawSetShadow(playerid, HudP[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, HudP[playerid][2], 255);
	PlayerTextDrawFont(playerid, HudP[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, HudP[playerid][2], 1);

	HudP[playerid][3] = CreatePlayerTextDraw(playerid, 619.999633, 167.600036, "100"); // Fome
	PlayerTextDrawLetterSize(playerid, HudP[playerid][3], 0.209999, 1.097244);
	PlayerTextDrawAlignment(playerid, HudP[playerid][3], 1);
	PlayerTextDrawColor(playerid, HudP[playerid][3], -285212673);
	PlayerTextDrawSetShadow(playerid, HudP[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, HudP[playerid][3], 255);
	PlayerTextDrawFont(playerid, HudP[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, HudP[playerid][3], 1);

	// TEXTDRAWS ESTATISTICAS
	EstP[playerid][0] = CreatePlayerTextDraw(playerid, 527.999816, 204.435562, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][0], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][0], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][0], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][0], true);

	EstP[playerid][1] = CreatePlayerTextDraw(playerid, 528.399780, 220.862213, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][1], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][1], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][1], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][1], true);

	EstP[playerid][2] = CreatePlayerTextDraw(playerid, 527.199890, 236.293273, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][2], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][2], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][2], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][2], true);

	EstP[playerid][3] = CreatePlayerTextDraw(playerid, 526.799438, 253.217727, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][3], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][3], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][3], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][3], true);

	EstP[playerid][4] = CreatePlayerTextDraw(playerid, 527.199462, 270.142120, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][4], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][4], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][4], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][4], true);

	EstP[playerid][5] = CreatePlayerTextDraw(playerid, 526.799377, 286.070922, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][5], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][5], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][5], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][5], true);

	EstP[playerid][6] = CreatePlayerTextDraw(playerid, 527.599060, 303.990966, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][6], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][6], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][6], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][6], true);

	EstP[playerid][7] = CreatePlayerTextDraw(playerid, 526.798400, 319.422058, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][7], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][7], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][7], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][7], true);

	EstP[playerid][8] = CreatePlayerTextDraw(playerid, 527.198242, 335.848693, "(0/50)");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][8], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][8], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][8], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][8], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][8], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][8], true);

	EstP[playerid][9] = CreatePlayerTextDraw(playerid, 525.597961, 351.777648, "(0/100)");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][9], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][9], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][9], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][9], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][9], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][9], true);

	EstP[playerid][10] = CreatePlayerTextDraw(playerid, 527.597534, 368.702148, "(0/25)~n~");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][10], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][10], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][10], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][10], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][10], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][10], true);

	EstP[playerid][11] = CreatePlayerTextDraw(playerid, 527.997009, 384.631103, "(0/30)");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][11], 0.272399, 0.903110);
	PlayerTextDrawAlignment(playerid, EstP[playerid][11], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][11], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][11], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][11], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][11], true);

	EstP[playerid][12] = CreatePlayerTextDraw(playerid, 553.999877, 173.573318, "20");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][12], 0.166399, 0.614400);
	PlayerTextDrawAlignment(playerid, EstP[playerid][12], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][12], -16641);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][12], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][12], 2);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][12], 1);

	EstP[playerid][13] = CreatePlayerTextDraw(playerid, 571.599975, 132.257751, "X");
	PlayerTextDrawLetterSize(playerid, EstP[playerid][13], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, EstP[playerid][13], 1);
	PlayerTextDrawColor(playerid, EstP[playerid][13], -16776961);
	PlayerTextDrawSetShadow(playerid, EstP[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, EstP[playerid][13], 1);
	PlayerTextDrawBackgroundColor(playerid, EstP[playerid][13], 255);
	PlayerTextDrawFont(playerid, EstP[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, EstP[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, EstP[playerid][13], true);

	TextFeridoG[playerid][0] = CreatePlayerTextDraw(playerid, 550.399963, 101.893341, "SANGRANDO");
	PlayerTextDrawLetterSize(playerid, TextFeridoG[playerid][0], 0.202400, 0.923022);
	PlayerTextDrawAlignment(playerid, TextFeridoG[playerid][0], 1);
	PlayerTextDrawColor(playerid, TextFeridoG[playerid][0], -16776961);
	PlayerTextDrawSetShadow(playerid, TextFeridoG[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, TextFeridoG[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, TextFeridoG[playerid][0], 255);
	PlayerTextDrawFont(playerid, TextFeridoG[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, TextFeridoG[playerid][0], 1);

	TextFeridoG[playerid][1] = CreatePlayerTextDraw(playerid, 580.799987, 112.346702, "1800");
	PlayerTextDrawLetterSize(playerid, TextFeridoG[playerid][1], 0.238399, 0.768710);
	PlayerTextDrawAlignment(playerid, TextFeridoG[playerid][1], 1);
	PlayerTextDrawColor(playerid, TextFeridoG[playerid][1], 16711935);
	PlayerTextDrawSetShadow(playerid, TextFeridoG[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, TextFeridoG[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, TextFeridoG[playerid][1], 255);
	PlayerTextDrawFont(playerid, TextFeridoG[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, TextFeridoG[playerid][1], 1);

	//
	Inventario(playerid);
	dacingtext(playerid);
	Buttons(playerid);
	// FIM

	LimparChat(playerid, 50);
	//Fim text relogio e data
	Ausente[playerid] = 0;
	NoFuel[playerid] = 0;
	motor[playerid] = 0;
	Feridoo[playerid] = 0;

	// ZERAR VARIAVEIS
	Dados[playerid][RegistroNaoConcluido] = false;
	Dados[playerid][pSenhaInvalida] = 0;
	Dados[playerid][Senha] = 0;
	Dados[playerid][Animal] = 0;
	Dados[playerid][Turret] = 0;
	Dados[playerid][Cavalo] = 0;
	Dados[playerid][Follow] = 0;
	Dados[playerid][FollowTwo] = 0;
	Dados[playerid][FollowThre] = 0;
	Dados[playerid][FollowFour] = 0;
	Dados[playerid][PlayerFire] = 0;
	Dados[playerid][Zombie] = 0;
	Dados[playerid][mZombie] = 0;
	Dados[playerid][Matou] = 0;
	Dados[playerid][Morreu] = 0;
	Dados[playerid][Dinheiro] = 0;
	Dados[playerid][Ferido] = 0;
	Dados[playerid][Chao] = 0;
	Dados[playerid][Morto] = 0;
	Dados[playerid][Braco] = 0;
	Dados[playerid][Peso] = 0;
	Dados[playerid][Mancando] = 0;
	Dados[playerid][IniciouCair] = false;
	Dados[playerid][MancandoKeyPress] = 0;
	Dados[playerid][Tag] = 0;
	Dados[playerid][Saude] = 0;
	Dados[playerid][Fome] = 0;
	Dados[playerid][Sede] = 0;
	Dados[playerid][Celular] = 0;
	Dados[playerid][Creditos] = 0;
	Dados[playerid][Admin] = 0;
	Dados[playerid][UltimoLoginD] = 0;
	Dados[playerid][UltimoLoginA] = 0;
	Dados[playerid][UltimoLoginM] = 0;
	Dados[playerid][Vulneravel] = 0;
	Dados[playerid][EmBlindado] = 0;
	Dados[playerid][Level] = 0;
	Dados[playerid][PH] = 0;
	Dados[playerid][Agilidade] = 0;
	Dados[playerid][Forca] = 0;
	Dados[playerid][Destreza] = 0;
	Dados[playerid][Resistencia] = 0;
	Dados[playerid][Inteligencia] = 0;
	Dados[playerid][Sabedoria] = 0;
	Dados[playerid][Skin] = 0;
	Dados[playerid][Sapiencia] = 0;
	Dados[playerid][Engenharia] = 0;
	Dados[playerid][Talento] = 0;
	Dados[playerid][Power] = 0;
	Dados[playerid][Carisma] = 0;
	Dados[playerid][Defesa] = 0;
	Dados[playerid][Armadura] = 0;
	Dados[playerid][points] = 0;
	Arrastando[playerid] = 0;
	Logado[playerid] = false;
	Caixa[playerid] = 0;
	Caixas[playerid] = 0;
	Minerando[playerid] = 0;
	TurretCarPlayer[playerid] = 0;
	PlayerInHorse[playerid] = 0;
	HorseForPlayer[playerid] = 0;
	Iten[playerid] = 0;
	for(new d; d< 32; d++) {
	Dados[playerid][Itwork][d] = 0; }
	for(new c; c < 7; c++) {
	Ut[playerid][c] = 0; }
	for(new b; b < 7; b++) {
	uItem[playerid][b] = 0; }
	for(new a; a < 7; a++) {
	VidaItem[playerid][a] = 0; }
	PaginaWork[playerid] = 0;
	//
	format(Arquivo, sizeof Arquivo, "Workbench/%s.ini", Nome(playerid));

 	if(!DOF2_FileExists(Arquivo)){

	    CreateWork(playerid);
	}
	else
	{
		LoadWork(playerid);
	}
	//
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
// •••••••••••••••••••••••••••••••••V O i P••••••••••••••••••••••••••••••••• VOIPJOEL
	if (lstream[playerid]) { // Deletando a mixagem de stream para não permacer um vácuo de som.
		SvDeleteStream(lstream[playerid]);
		lstream[playerid] = SV_NULL;
	}
	if (sstream[playerid]) { // Deletando a mixagem de stream para não permacer um vácuo de som.
		SvDeleteStream(sstream[playerid]);
		sstream[playerid] = SV_NULL;
	}
	Ausente[playerid] = 0;
	Dados[playerid][pSenhaInvalida] = 0;
	SalvarConta(playerid);

	if (Dados[playerid][Admin] >= 1) Iter_Remove(Admins, playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//TextDrawShowForPlayer(playerid, Textdraw0); Textdraw data e hora
	//TextDrawShowForPlayer(playerid, Textdraw1);
	GangZoneShowForPlayer(playerid, blackmap, 0x000000FF);
	TogglePlayerSpectating(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	new pos[4];
	pos[0] = DOF2_GetInt(Contas(playerid), "UltimaPosX"); // X
	pos[1] = DOF2_GetInt(Contas(playerid), "UltimaPosY"); // Y
	pos[2] = DOF2_GetInt(Contas(playerid), "UltimaPosZ"); // Z
	pos[3] = DOF2_GetInt(Contas(playerid), "UltimaPosA"); // Angulo de visão.
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerFacingAngle(playerid, pos[3]);
	Dados[playerid][RegistroNaoConcluido] = false;
	Dados[playerid][Saude] = 100;
	SetPlayerColor(playerid, -1);
	//Atualizar(playerid); Textdraw hud
	SetPlayerSkin(playerid, Dados[playerid][Skin]);
	TextDrawShowForPlayer(playerid, Hud);
	for( new b; b != 4; b++) PlayerTextDrawShow(playerid, HudP[playerid][b]);
	Atualizar(playerid);
	SvAddKey(playerid, 0x5A);
	lstream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid, 0xff0000ff, "L"); // Stream em Text3d em r:20.0, modelo red no canto esquerdo.
	// Setar nivel de Skill Arma
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 40);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
	//
	//PlayAudioStreamForPlayer(playerid, "https://cs1.mp3.pm/download/23283913/MnZZaTlqT2EyS2FTSjhzU1RTQ3dhZ3FSZzBOWWtJKys0WjUxWHE2QWsxbzVWQjVDaFJkUUtKVDBUTklUTWU4VFhndG9lRFdjNkRITGhQamEwYnhRbTBYcEpOeEpjdDRrM2tvSlpyVzV6eERGc3YzREp3UEQ0TEFSMkM4cWFLSVQ/Heavy_Rain_Game_Soundtrack_-_Before_the_Storm_(mp3.pm).mp3");
	//SetTimerEx("soundtrack", 180000, 1, "i", playerid);
	//
	return 1;
}
forward soundtrack(playerid);
public soundtrack(playerid)
{
	StopAudioStreamForPlayer(playerid);
  	//PlayAudioStreamForPlayer(playerid, "https://cs1.mp3.pm/download/128087709/MnZZaTlqT2EyS2FTSjhzU1RTQ3dhZ3FSZzBOWWtJKys0WjUxWHE2QWsxb0tGYktBd2FwQUlzV0lvMGZMVjJwdUNxQTNxRVNFN1JqeGFSZEJ1WHp6dHBtd3ZxSkdQZFgybWFmTmFndG8rQ2tsenVZTjNWL2JVb0ZZUW9kU3FxZ0Y/Olafur_Arnalds_-_Near_Light_(mp3.pm).mp3");
  	PlayAudioStreamForPlayer(playerid, "https://cs1.mp3.pm/download/23283913/MnZZaTlqT2EyS2FTSjhzU1RTQ3dhZ3FSZzBOWWtJKys0WjUxWHE2QWsxbzVWQjVDaFJkUUtKVDBUTklUTWU4VFhndG9lRFdjNkRITGhQamEwYnhRbTBYcEpOeEpjdDRrM2tvSlpyVzV6eERGc3YzREp3UEQ0TEFSMkM4cWFLSVQ/Heavy_Rain_Game_Soundtrack_-_Before_the_Storm_(mp3.pm).mp3");
}
public OnPlayerDeath(playerid, killerid, reason)
{

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	new Float: X, Float: Y, Float: Z;
	GetVehiclePos (vehicleid , X , Y , Z );
	DestroyVehicle(vehicleid);
	//if(modelo != 471) {
	//CreateDynamicObject(3594, X, Y, Z, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); }
	if(PlayerInHorse[killerid])
	{
		new carid = GetPlayerVehicleID(killerid);
		DestroyVehicle(carid);
		PlayerInHorse[killerid] = 0;
		Dados[HorseForPlayer[killerid]][Cavalo] = 0;
		FCNPC_Destroy(HorseForPlayer[killerid]);
		HorseForPlayer[killerid] = 0;
		Dados[killerid][FollowFour] = 0; // Cavalos
		StopAudioStreamForPlayer(killerid);
	}
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	if (Vuln[vehicleid] < 0) Vuln[vehicleid] = 0.0;

	if (Vuln[vehicleid])
	{

		Vuln[vehicleid] -= 100 - GetVehicleHealthEx(vehicleid);
		RepairVehicle(vehicleid);

		if (Vuln[vehicleid] <= 0)
		{

			Vuln[vehicleid] = 0.0;
		}
		else
		{

			RepairVehicle(vehicleid);
		}
	}
}

public OnPlayerText(playerid, text[])
{
	new string[144];
	format(string, sizeof(string), "%s: %s", GetPlayerNome(playerid), text);

	new Float:Pos[3], playerWorld;
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	playerWorld = GetPlayerVirtualWorld(playerid);
	foreach(new i : Player)
	{
		if (IsPlayerInRangeOfPoint(i, DISTANCIA_FALA, Pos[0], Pos[1], Pos[2]) && playerWorld == GetPlayerVirtualWorld(i))
		{
			SendClientMessage(i, -1, string);
		}
	}
	return 0;
}

/*public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}*/


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	new car = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(car);
	if(model == 471)
	{
		if(PlayerInHorse[playerid])
		{
			new carid = GetPlayerVehicleID(playerid);
			DestroyVehicle(carid);
			PlayerInHorse[playerid] = 0;
			Dados[HorseForPlayer[playerid]][Cavalo] = 0;
			FCNPC_Destroy(HorseForPlayer[playerid]);
			HorseForPlayer[playerid] = 0;
			Dados[playerid][FollowFour] = 0; // Cavalos
			StopAudioStreamForPlayer(playerid);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{

	if(newstate == PLAYER_STATE_DRIVER) SetPlayerArmedWeapon(playerid, 0);
    new carro = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(carro);
	if(model == 471) { return 1; }
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		MostrarVelocimetro(playerid);
	}
	else
	{

		FecharVelocimetro(playerid) ;
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_NO)) // Torreta BobCat
	{
  		if(Dados[playerid][Turret] == 1)
		{
	  		Dados[playerid][Turret] = 0;
			GivePlayerWeapon(playerid, 31, 0);
			DestroyObject(gunturret[TurretCarPlayer[playerid]]);
			gunturret[TurretCarPlayer[playerid]] = CreateObject(356,0.0,0.0,-1000.0,0.0,0.0,0.0,-1);
			AttachObjectToVehicle(gunturret[TurretCarPlayer[playerid]], TurretCarPlayer[playerid], -0.000, -0.500, 1.269, -2.500, 0.000, 90.799);
			TurretCarPlayer[playerid] = 0;
			for (new i = 0; i <= 12; i++)
			{
   				GivePlayerWeapon(playerid, weapons[i][0], weapons[i][1]);
			}
	 		return 1;
		}
		if(Dados[playerid][Turret] == 0)
		{
			new
		 	Seat = GetPlayerVehicleSeat(playerid);
		 	new
		 	carro = GetPlayerVehicleID(playerid);
		 	new
		 	model = GetVehicleModel(carro);
		 	if(Seat == 1)
		 	{
			    if(model == 422)
			    {
			    	TurretCarPlayer[playerid] = carro;
					for (new i = 0; i <= 12; i++)
					{
					    GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
					    ResetPlayerWeapons(playerid);
					    Dados[playerid][Turret] = 1;
					}
				}
			}
			return 1;
		}
 		return 1;
	}
	if(PRESSED( KEY_NO ))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
		    if(Logado[playerid])
		    {
				SelectTextDraw(playerid, 0x00FFFFFF);
				TextDrawShowForPlayer(playerid, dacing[0]);
				for(new b=0; b < 6; b++){
				PlayerTextDrawShow(playerid, bdacing[playerid][b]); }
			}
		}
 		return 1;
	}
	if (PRESSED( KEY_HANDBRAKE )) // Segurando o botão direito do mouse.
	{
	    if(Dados[playerid][Turret] == 1)
	    {
			DestroyObject(gunturret[TurretCarPlayer[playerid]]);
			GivePlayerWeapon(playerid, 31, 9999);
		}
		return 1;
	}
	if (RELEASED( KEY_HANDBRAKE )) // Soltou o botão direito do mouse.
	{
		if(Dados[playerid][Turret] == 1)
	    {
	    	DestroyObject(gunturret[TurretCarPlayer[playerid]]);
			gunturret[TurretCarPlayer[playerid]] = CreateObject(356,0.0,0.0,-1000.0,0.0,0.0,0.0,-1);
			AttachObjectToVehicle(gunturret[TurretCarPlayer[playerid]], TurretCarPlayer[playerid], -0.000, -0.500, 1.269, -2.500, 0.000, 90.799);
			ResetPlayerWeapons(playerid);
		}
		return 1;
	}
	if (newkeys & KEY_CROUCH) // Agachou na torreta.
	{
		if(Dados[playerid][Turret])
	    {
	    	DestroyObject(gunturret[TurretCarPlayer[playerid]]);
			gunturret[TurretCarPlayer[playerid]] = CreateObject(356,0.0,0.0,-1000.0,0.0,0.0,0.0,-1);
			AttachObjectToVehicle(gunturret[TurretCarPlayer[playerid]], TurretCarPlayer[playerid], -0.000, -0.500, 1.269, -2.500, 0.000, 90.799);
			ResetPlayerWeapons(playerid);
		}
		return 1;
	}
	if(newkeys & KEY_YES)
	{
		if(C4[playerid] == 1)
		{
  			new Float:x, Float:y, Float:z;
  			GetPlayerPos(playerid, x, y, z);
  			new Float: Pos = GetPlayerDistanceFromPoint(playerid, x, y, z);
  			if(Pos <= 1)
  			{
				for(new i; i<17; i++)
				{
					 if(InventarioInfo[playerid][i][iSlot] == 1654 && InventarioInfo[playerid][i][iUnidades] == 1)
					 {
					  	 InventarioInfo[playerid][i][iSlot] = 19382;
						 InventarioInfo[playerid][i][iUnidades] = 0;
					     C4F[0] = CreateObject(1654, -1660.727783, -1644.042724, 32.332324, -92.999977, -0.700000, 22.499990, 250.00);
					     C4[playerid] = 2;
					     GivePlayerWeapon(playerid, 40, 10);
			     	 }
			     }
  			}
		}
	}
	if(newkeys & KEY_FIRE)
	{
	    if(C4[playerid] == 2)
	    {
	   		CreateExplosion(-1660.727783, -1644.042724, 32.332324, 7, 20.0);
		    DetonePonte1();
		    C4[playerid] = 0;
		    GivePlayerWeapon(playerid, 40, 0);
	    }
	}
	if((newkeys & KEY_YES) && GetPlayerState(playerid) == 1)
	{
		for(new z=0; z < MAX_PLAYERS; z++)
		{
			if(Dados[z][Zombie] == 1)
			{
				if(Dados[z][mZombie] == 1)
    			{
			    	new Float: xa, Float:ya, Float:za;
					GetPlayerPos(z, xa, ya, za);
					new Float: Distancia = GetPlayerDistanceFromPoint(playerid, xa, ya, za);
					if(Distancia <= 2)
     				{
         				if(Dados[playerid][Follow] == 1)
						{
							SendClientMessage(playerid, -1, "Você já está Loteando.");
							return 1;
						}
   						ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_in", 4.0, 1, 0, 0, 0, 0);
      					Dados[playerid][Follow] = 1;
        				SetTimerEx("StopLoot", 8000, 0, "i", playerid); // 8 Segundos
					}
				}
			}
		}
	}
	if((newkeys & KEY_YES) && GetPlayerState(playerid) == 1)
	{
	    // Minerador:
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 552.8043,909.7172,-42.9609) || IsPlayerInRangeOfPoint(playerid, 2.0, 557.5746,918.6065,-42.9609) ||
		IsPlayerInRangeOfPoint(playerid, 2.0, 587.0723,917.7970,-43.0307) || IsPlayerInRangeOfPoint(playerid, 2.0, 584.5220,924.8887,-42.2134)) // Minerando
	    {
	        if(Minerando[playerid] == 1)
	        {
	        	SendClientMessage(playerid, -1, "Você já está minerando.");
				return 1;
			}
	    	RemovePlayerAttachedObject(playerid, 0);
			SetPlayerAttachedObject(playerid, 0, 19631, 6, 0.073999, -0.008999, 0.342999, -87.199981, 94.599990, -0.299998, 1.000000, 1.000000, 1.000000);
			TogglePlayerControllable(playerid, 0);
			Minerando[playerid] = 1;
			ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 0, 0, 1);
			SetTimerEx("Minerandoo", 8000, 0, "i", playerid);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 561.3225,885.1464,-41.6665))
		{
		    if(Minerando[playerid] != 2)
		    {
		    	SendClientMessage(playerid, -1, "Você precisa de uma pedra para inspecionar.");
		    	return 1;
		    }
		    Minerando[playerid] = 0;
		    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
			RemovePlayerAttachedObject(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		    new Pedra = random(4);
		    if(Pedra == 0 || Pedra == 2 || Pedra == 4)
		    {
		    	SendClientMessage(playerid, -1, "A pedra não tem minérios.");
		    	Dados[playerid][Dinheiro] += 10;
				Atualizar(playerid);
				new str[128];
				format(str, sizeof(str), "~g~+10 lucrados");
				TextDrawSetString(Aviso[playerid], str);
				TextDrawShowForPlayer(playerid, Aviso[playerid]);
				SetTimerEx("Sumiu", 5000, false, "i", playerid);
		    }
		    if(Pedra == 1)
		    {
		    	SendClientMessage(playerid, -1, "A pedra tem minérios de uránio.");
		    	Dados[playerid][Dinheiro] += 40;
				Atualizar(playerid);
				new str[128];
				format(str, sizeof(str), "~g~+40 lucrados");
				TextDrawSetString(Aviso[playerid], str);
				TextDrawShowForPlayer(playerid, Aviso[playerid]);
				SetTimerEx("Sumiu", 5000, false, "i", playerid);
		    }
		    if(Pedra == 3)
		    {
		    	SendClientMessage(playerid, -1, "A pedra tem minérios de polvora branca.");
		    	Dados[playerid][Dinheiro] += 65;
				Atualizar(playerid);
				new str[128];
				format(str, sizeof(str), "~g~+65 lucrados");
				TextDrawSetString(Aviso[playerid], str);
				TextDrawShowForPlayer(playerid, Aviso[playerid]);
				SetTimerEx("Sumiu", 5000, false, "i", playerid);
		    }
			return 1;
		}
	    // Fabricante de Caixas:
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -2051.4846,-2376.7275,30.6318)) // Pegando madeira.
	    {
			if(Caixa[playerid] == 1)
			{
				SendClientMessage(playerid, -1, "Você já tem um tronco.");
				return 1;
			}
			ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
			SetTimerEx("PegarMadeira", 500, 0, "i", playerid);
			SendClientMessage(playerid, -1, "Insira o tronco na maquina.");
			Caixa[playerid] = 1;
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -2052.1597,-2391.0923,30.6250)) // Inserindo madeira.
	    {
		    if(Caixa[playerid] !=  1)
		    {
		    	SendClientMessage(playerid, -1, "Pegue uma madeira primeiro.");
		    }
			else
			{
				RemovePlayerAttachedObject(playerid, 0);
				Caixa[playerid] = 0;
				Caixas[playerid] += 1;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				Madeira[playerid] = CreatePlayerObject(playerid, 684, -2048.903076, -2388.007812, 30.615015, 0.000000, 0.000000, -47.000022, 300.0);
				SetTimerEx("InserindoMadeira2", 1000, 0, "i", playerid);
			}
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -2040.9733,-2381.2610,30.6250)) // Pegando caixa.
	    {
	        if(Caixa[playerid] == 3)
			{
				SendClientMessage(playerid, -1, "Leve uma caixa de cada vez.");
		    }
		    else
		    {
			    if(Caixas[playerid] == 0)
			    {
			        SendClientMessage(playerid, -1, "Você não tem caixas feitas.");
			    }
				else
				{
					ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
					SetTimerEx("PegarCaixa", 500, 0, "i", playerid);
				}
			}
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -2074.8806,-2417.7070,30.6250)) // Soltando caixa.
	    {
		    if(Caixa[playerid] != 3)
		    {
		        SendClientMessage(playerid, -1, "Pegue uma caixa primeiro.");
		    }
			else
			{
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
				RemovePlayerAttachedObject(playerid, 0);
				Caixa[playerid] = 0;
				Caixas[playerid] -= 1;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				new Pagamento = 10 + random(20);
				Dados[playerid][Dinheiro] += Pagamento;
				Atualizar(playerid);
				new str[128];
				format(str, sizeof(str), "~g~+%d lucrados", Pagamento);
				TextDrawSetString(Aviso[playerid], str);
				TextDrawShowForPlayer(playerid, Aviso[playerid]);
				SetTimerEx("Sumiu", 5000, false, "i", playerid);
			}
			return 1;
		}
		return 1;
	}
	if((newkeys & KEY_YES))
	{

		new mot, lu, alar, por, cap, porma, ob;
		new carro = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(carro);
		if(model == 471) { return 1; }
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(vehEngine[carro] == 0)
			{
				new hasChave = PlayerHasChave(playerid, CHAVE_CARRO, Veiculos[carro][idCar], 0);
				if(hasChave == 1)
				{
					if(fundido[carro] == 1) return SendClientMessage(playerid, -1, "O motor do veiculo aparenta está defeituoso.");
					if(Gas[carro] <= 0) return SendClientMessage(playerid, -1, "O indicador no painel mostra uma falta de gasolina.");
					if(model == 481 || model == 509 || model == 510 || model == 471)
					{

						return 1;
					}
					GetVehicleParamsEx(carro, mot, lu, alar, por, cap, porma, ob);
					SetVehicleParamsEx(carro, VEHICLE_PARAMS_ON, lu, alar, por, cap, porma, ob);
					vehEngine[carro] = 1;
				}
				else if(hasChave == -1) {
					SendClientMessage(playerid, -1, "Parece que a sua chave não é aceita nesta ingnição.");
				}
				else {
					SendClientMessage(playerid, -1, "Você não possui a chave deste veículo.");
				}

			}
			else // Desligando o veiculo.
			{

				GetVehicleParamsEx(carro, mot, lu, alar, por, cap, porma, ob);
				SetVehicleParamsEx(carro, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
				vehEngine[carro] = 0;
			}
		}
	}
	if((oldkeys & KEY_SPRINT) && !(newkeys & KEY_SPRINT))
	{

		Dados[playerid][MancandoKeyPress] = 0;
	}
	if(newkeys & KEY_JUMP && GetPlayerState(playerid)== 1 && Dados[playerid][Mancando] && !Dados[playerid][Chao])
	{

		TogglePlayerControllable(playerid, 0);
		SetTimerEx("Caiu",1000,false,"i",playerid);
	}
	if(newkeys & KEY_SPRINT && GetPlayerState(playerid)== 1 && Dados[playerid][Mancando] && !Dados[playerid][Chao])
	{

		ApplyAnimation(playerid,"PED","FALL_collapse",4.1,0,1,1,1,1,1);
		SetTimerEx("Caiu2",500,false,"i",playerid);
		Dados[playerid][MancandoKeyPress] = 1;
	}
	if(((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) && GetPlayerState(playerid)== 1 && Dados[playerid][Braco] && !Dados[playerid][Chao])
	{

		ApplyAnimation(playerid,"PED","flee_lkaround_01",4.1,0,1,1,1,1);
	}
	if(GetPlayerState(playerid)==1 && GK(playerid,KEY_WALK) && Dados[playerid][Ferido] > 0)
	{

		ArrastarFerido(playerid);
	}

	// new Arm = GetPlayerWeapon(playerid);
	// if(GetPlayerState(playerid)==1 && GK(playerid,KEY_SPRINT) && Arm == 30 || Arm == 31 || Arm == 32 || Arm == 33 || Arm == 34)
	// {
		//     CorrerComArma(playerid);
		// }
	return 1;
}
forward Minerandoo(playerid);
public Minerandoo(playerid)
{
	TogglePlayerControllable(playerid, 1);
	Minerando[playerid] = 2;
	SetPlayerSpecialAction(playerid, 25);
	RemovePlayerAttachedObject(playerid, 0);
	SetPlayerAttachedObject(playerid, 0, 2936, 5, 0.014999, 0.100999, 0.202999, 2.200006, -1.099999, 0.000000, 0.443000, 0.378999, 0.558000);
	SendClientMessage(playerid, -1, "Inspecione a pedra na cabana.");
}
forward PegarMadeira(playerid);
public PegarMadeira(playerid)
{
	SetPlayerSpecialAction(playerid, 25);
	RemovePlayerAttachedObject(playerid, 0);
	SetPlayerAttachedObject(playerid, 0, 684, 5, 0.117999, 0.182999, 0.171000, 163.100036, -115.600006, 66.199989, 0.393000, 0.377000, 0.434000);
}
forward InserindoMadeira2(playerid);
public InserindoMadeira2(playerid)
{
	MovePlayerObject(playerid, Madeira[playerid], -2044.744262, -2384.125732, 30.615015, 3.0);
	SetTimerEx("InserindoMadeira3", 3000, 0, "i", playerid);
	return 1;
}
forward InserindoMadeira3(playerid);
public InserindoMadeira3(playerid)
{
	DestroyPlayerObject(playerid, Madeira[playerid]);
	new string[128];
	format(string, sizeof string, "Você tem %d caixas feitas", Caixas[playerid]);
	SendClientMessage(playerid, -1, string);
	Caixinha[playerid] = CreatePlayerObject(playerid, 2912, -2041.444702, -2380.780273, 30.417156, 0.000000, 0.000000, -48.500019, 300.0);
	return 1;
}
forward PegarCaixa(playerid);
public PegarCaixa(playerid)
{
	SetPlayerSpecialAction(playerid, 25);
	RemovePlayerAttachedObject(playerid, 0);
	SetPlayerAttachedObject(playerid, 0, 2912, 5, 0.250000, 0.046999, 0.049999, 103.200073, -166.199966, -67.300025, 1.000000, 1.000000, 1.000000);
	DestroyPlayerObject(playerid, Caixinha[playerid]);
	Caixa[playerid] = 3;
	return 1;
}
public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}
public OnPlayerUpdate(playerid)
{
	if(IsPlayerConnected(playerid)) // Jogador Conectado condicional
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(PlayerInHorse[playerid])
			{
				new carid = GetPlayerVehicleID(playerid);
				DestroyVehicle(carid);
				PlayerInHorse[playerid] = 0;
				Dados[HorseForPlayer[playerid]][Cavalo] = 0;
				FCNPC_Destroy(HorseForPlayer[playerid]);
				HorseForPlayer[playerid] = 0;
				Dados[playerid][FollowFour] = 0; // Cavalos
				StopAudioStreamForPlayer(playerid);
			}
		}
		// Jogador dentro do blindado:
		new vehicle = GetPlayerVehicleID(playerid);
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(Vuln[vehicle] < 1 || Dados[playerid][Vulneravel] == 1)
			{

				Dados[playerid][EmBlindado] = 0;
			}
		}
		if(IsPlayerInAnyVehicle(playerid))
		{

			if(Vuln[vehicle] >= 1 && Dados[playerid][Vulneravel] < 1)
			{

				Dados[playerid][EmBlindado] = 1;
			}
		}
		if(!IsPlayerInAnyVehicle(playerid))
		{

			Dados[playerid][EmBlindado] = 0;
			Dados[playerid][Vulneravel] = 0;
		}
		// FIM
		if(Dados[playerid][Ferido] > 0 && Feridoo[playerid] == 0 && Dados[playerid][Morto] == 0)
		{

			ApplyAnimation(playerid,"WUZI","CS_Dead_Guy",4.0,1,1,1,1,200,1);
		}

		SetPlayerHealth(playerid, 9999);
	} // --> FIM DA CONDICIONAL JOGADOR CONECTADO

	if (Dados[playerid][Braco] == 1 && Dados[playerid][Talento] < 25) {
		if (GetPlayerWeapon(playerid) != 0 && !IsPlayerInAnyVehicle(playerid)) SetTimerEx("Quebrado", 200, false, "i", playerid);
		SetPlayerArmedWeapon(playerid,0);
	}

	if (Dados[playerid][Braco])
	{

		if (GetPlayerAnimationIndex(playerid))
		{

			new animLib[32], animName[32];

			GetAnimationName(GetPlayerAnimationIndex(playerid), animLib, sizeof animLib, animName, sizeof animName);
			if (IsStringIgual(animLib, "PED"))
			{

				if (IsStringIgual(animName, "CLIMB_JUMP") || IsStringIgual(animName, "CLIMB_IDLE") || IsStringIgual(animName, "CLIMB_PULL") || IsStringIgual(animName, "CLIMB_JUMP_B") || IsStringIgual(animName, "CLIMB_STAND") || IsStringIgual(animName, "CLIMB_STAND_FINISH"))
				{

					if (!Dados[playerid][Mancando] && !Dados[playerid][IniciouCair]){
						Dados[playerid][IniciouCair] = true;
						Caiu(playerid);
					}
				}
			}
		}
	}
	if (GetPlayerVehicleSeat(playerid) == 0) VerificarRadares(playerid, GetPlayerVehicleID(playerid));

 	new ammo = GetPlayerAmmo(playerid);
    new arm = GetPlayerWeapon(playerid);
	if(ammo <= 1)
	{
		if(arm == 22)
		{
	        for(new i=0; i<15; i++)
	        {
	             if(InventarioInfo[playerid][i][iSlot] == 19382)
	             {
	                InventarioInfo[playerid][i][iSlot] = MudarIdArma(GetPlayerWeapon(playerid));
	                InventarioInfo[playerid][i][iUnidades] = 0;
	                SendClientMessage(playerid, -1,"Arma foi ao inventário sem munição.");
	                SetPlayerArmedWeapon(playerid,0);
	                return 1;
	             }
	        }
	    }
    }
	return 1;
}
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    /*new szString[144];
    format(szString, sizeof(szString), "Weapon %i fired. hittype: %i   hitid: %i   pos: %f, %f, %f", weaponid, hittype, hitid, fX, fY, fZ);
    SendClientMessage(playerid, -1, szString);*/
    Dados[playerid][PlayerFire] = 1; // Sincronizar com zombies.
    //SendClientMessage(playerid, -1,"Você deu um disparo.");
    return 1;
}
forward animacaoMorto(playerid);
public animacaoMorto(playerid)
{
	TogglePlayerControllable(playerid,1);
	ApplyAnimation(playerid,"PED","FLOOR_hit_f",4.1,0,1,1,1,1,1);
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == Joel(1))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Agilidade] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Agilidade", Hb);
		Dados[playerid][Agilidade] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		if(Dados[playerid][Agilidade] == 25)
		{

			SendClientMessage(playerid, -1, "Você desbloqueou a habilidade {FFFF00}AGILIDADE{FFFFFF}, aperte LATL para se mover quando ferido.");
		}
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(2))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Forca] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Forca", Hb);
		Dados[playerid][Forca] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(3))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Carisma] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Carisma", Hb);
		Dados[playerid][Carisma] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(4))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Destreza] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Destreza", Hb);
		Dados[playerid][Destreza] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(5))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Resistencia] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Resistencia", Hb);
		Dados[playerid][Resistencia] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(6))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Inteligencia] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Inteligencia", Hb);
		Dados[playerid][Inteligencia] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(7))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Defesa] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Defesa", Hb);
		Dados[playerid][Defesa] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(8))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Sabedoria] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Sabedoria", Hb);
		Dados[playerid][Sabedoria] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(9))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 50.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 50 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 50.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Sapiencia] >= 50)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Sapiencia", Hb);
		Dados[playerid][Sapiencia] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(10))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 100.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 100 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 100.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Engenharia] >= 100)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Engenharia", Hb);
		Dados[playerid][Engenharia] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(11))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 25 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 25.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Talento] >= 25)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Talento", Hb);
		Dados[playerid][Talento] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	if(dialogid == Joel(12))
	{

		if(response == 0)
		{

			SendClientMessage(playerid, -1, "Você saiu do menu da habilidade.");
			return 1;
		}
		if(strlen(inputtext) > 2)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 30.");
		if(strfind(inputtext,"%", true) != -1 || strfind(inputtext,"-", true) != -1 || strfind(inputtext,"+", true) != -1 ||
		strfind(inputtext,"#", true) != -1)return SendClientMessage(playerid, -1, "Caracteres proibidos.");
		new Hb = strval(inputtext);
		if(Hb > 30 || Hb < 1)return SendClientMessage(playerid, -1, "Insira a quantidade de pontos de 1 a 30.");
		if(Dados[playerid][PH] < Hb)return SendClientMessage(playerid, -1, "Pontos de habilidade insuficientes.");
		if(Dados[playerid][Power] >= 30)
		{

			SendClientMessage(playerid, -1, "Essa habilidade já foi desbloqueada.");
			return 1;
		}
		new str[128];
		format(str, sizeof(str), "~g~~h~%d ~w~~h~pontos atribuidos em Power", Hb);
		Dados[playerid][Power] += Hb;
		Dados[playerid][PH] -= Hb;
		fEst(playerid);
		aEst(playerid);
		TextDrawSetString(Aviso[playerid], str);
		TextDrawShowForPlayer(playerid, Aviso[playerid]);
		SetTimerEx("Sumiu", 5000, false, "i", playerid);
		return 1;
	}
	switch(dialogid) {
		case DIALOG_LOGIN: {
			if(response) {
				if(!strval(inputtext)) {
					new string[500];
					SendClientMessage(playerid, -1, "Insira a senha da conta para entrar.");
					format(string, sizeof(string), "{FFFFFF}Informe a senha da conta:");
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Senha", string , "Entrar", "Voltar");
				} else {
					Dados[playerid][Senha] = DOF2_GetInt(Contas(playerid), "Senha");
					if(strval(inputtext) == Dados[playerid][Senha]) {
						new string[128];
						new Joelw[248];
						GivePlayerMoney(playerid, 0);
						LimparChat(playerid, 128);
						Logado[playerid] = true;
						CarregarConta(playerid);
						format(string,sizeof(string),"{FFFFFF} Olá {1E90FF}%s.\n", Nome(playerid));
						strcat(Joelw,string);
						format(string,sizeof(string),"{FFFFFF} Seja bem vindo novamente!\n");
						strcat(Joelw,string);
						format(string,sizeof(string),"{FFFFFF} Seu ultimo login foi: {1E90FF}%02d/%02d/%d{FFFFFF}.\n",Dados[playerid][UltimoLoginD], Dados[playerid][UltimoLoginM], Dados[playerid][UltimoLoginA]);
						strcat(Joelw,string);
						if (SvGetVersion(playerid))
						{
							format(string,sizeof(string),"{FFFFFF} VoIP disponivel.\n");
							strcat(Joelw,string);
						}
						ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "SCRP", Joelw, "Fechar", "");
						SpawnPlayer(playerid);
						return 1;
					} else {
						Dados[playerid][pSenhaInvalida]++;
						if(Dados[playerid][pSenhaInvalida] == 3) return Kick(playerid);
						new string[500];
						format(string, sizeof(string), "A senha informada não corresponde a conta, tentativa: [%d/3].", Dados[playerid][pSenhaInvalida]);
						SendClientMessage(playerid, -1, string);
						format(string, sizeof(string), "{FFFFFF}Informe a senha da conta:");
						ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Senha", string , "Entrar", "Voltar");
					}
				}
			} else {
				//
				return 1;
			}
			return 1;
		}
		// #CRIOU CONTA
		case DIALOG_REGISTRO: {
			if(response) {
				if(!strlen(inputtext)) {
					new string[500];
					SendClientMessage(playerid, -1, "Insira uma senha para registrar a conta.");
					format(string, sizeof(string), "{FFFFFF}Informe uma senha para registrar a conta:");
					ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Senha", string , "Registrar", "Voltar");
				} else {
					new Gerando = 4000 + random(9999);
					Dados[playerid][Tag] = Gerando;
					DOF2_CreateFile(Contas(playerid));
					Dados[playerid][Senha] = strval(inputtext);
					DOF2_SetInt(Contas(playerid), "Level", 0);
					Dados[playerid][Admin] = 0;
					Dados[playerid][Celular] = 0;
					Dados[playerid][Creditos] = 0;
					SetPlayerScore(playerid, 0);
					Logado[playerid] = true;
					SalvarConta(playerid);
					Dados[playerid][RegistroNaoConcluido] = true;
					SpawnPlayer(playerid);
					LimparChat(playerid, 128);
					SendClientMessage(playerid, COR_BRANCO, "Seja Bem Vindo ao Servidor!");
					return 1;
				}
			} else {
				//
			}
			return 1;
		}
	}

	if(dialogid == DIALOG_CONCE) {
		if(response) {
			new Float: X,Float: Y,Float: Z;
			GetPlayerPos(playerid, X,Y,Z);
			switch(listitem) {
				case 0: {
					for(new i = 0; i < sizeof(VeiculosT); i ++)
					{

						if(Dados[playerid][Dinheiro] < VeiculosT[i][Preco]) {
							SendClientMessage(playerid, -1, "Você não tem dinheiro suficiente!");
							return 1;
						}
						CreateVehicle(VeiculosT[i][VeiculosID], X, Y, Z, ANGULO, 1, 2, 0);
						Dados[playerid][Dinheiro] -= VeiculosT[i][Preco];
						SendClientMessage(playerid, -1, "Comprado.");
						Atualizar(playerid);
						break;
					}
					return 1;
				}
				case 1: {
					for(new i = 1; i < sizeof(VeiculosT); i ++)
					{

						CreateVehicle(VeiculosT[i][VeiculosID], X, Y, Z, ANGULO, 1, 2, 0);
						Dados[playerid][Dinheiro] -= VeiculosT[i][Preco];
						SendClientMessage(playerid, -1, "Comprado.");
						Atualizar(playerid);
						break;
					}
					return 1;
				}
				case 2: {
					for(new i = 2; i < sizeof(VeiculosT); i ++)
					{

						CreateVehicle(VeiculosT[i][VeiculosID], X, Y, Z, ANGULO, 1, 2, 0);
						Dados[playerid][Dinheiro] -= VeiculosT[i][Preco];
						SendClientMessage(playerid, -1, "Comprado.");
						Atualizar(playerid);
						break;
					}
					return 1;
				}
				case 3: {
					for(new i = 3; i < sizeof(VeiculosT); i ++)
					{

						CreateVehicle(VeiculosT[i][VeiculosID], X, Y, Z, ANGULO, 1, 2, 0);
						Dados[playerid][Dinheiro] -= VeiculosT[i][Preco];
						SendClientMessage(playerid, -1, "Comprado.");
						Atualizar(playerid);
						break;
					}
					return 1;
				}
				case 4: {
					for(new i = 4; i < sizeof(VeiculosT); i ++)
					{

						CreateVehicle(VeiculosT[i][VeiculosID], X, Y, Z, ANGULO, 1, 2, 0);
						Dados[playerid][Dinheiro] -= VeiculosT[i][Preco];
						SendClientMessage(playerid, -1, "Comprado.");
						Atualizar(playerid);
						break;
					}
					return 1;
				}
				case 5: {
					for(new i = 5; i < sizeof(VeiculosT); i ++)
					{

						CreateVehicle(VeiculosT[i][VeiculosID], X, Y, Z, ANGULO, 1, 2, 0);
						Dados[playerid][Dinheiro] -= VeiculosT[i][Preco];
						SendClientMessage(playerid, -1, "Comprado.");
						Atualizar(playerid);
						break;
					}
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_UTILITARIOS) {
		if(response) {
			switch(listitem) {
				case 0: {
					if(GetPlayerMoney(playerid) < 3000) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$3000.");
						return 1;
					}
					if(Dados[playerid][Celular] == 1) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já tem um celular.");
						return 1;
					}
					SendClientMessage(playerid, -1, "| UTILITARIOS | Você adquiriu um celular. Para mais informações digite /Ajuda.");
					Dados[playerid][Celular] = 1;
					GivePlayerMoney(playerid, -3000);
					return 1;
				}
				case 1: {
					if(GetPlayerMoney(playerid) < 300) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem créditos para mandar mensagem, compre na Loja de Utilitarios!");
						return 1;
					}
					if(Dados[playerid][Creditos] == 200) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Limite de créditos atingido!");
						return 1;
					}
					SendClientMessage(playerid, -1, "| UTILITARIOS | Você adquiriu 50 de créditos, para mais informações /Ajuda.");
					Dados[playerid][Creditos] += 50;
					GivePlayerMoney(playerid, -300);
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_SEMPARAR) {
		if(response) {
			switch(listitem) {
				case 0: {
					if(GetPlayerMoney(playerid) < 900) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$900");
						return 1;
					}
					SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 10 passagens para o SEM PARAR!");
					SemParar[playerid] += 10;
					GivePlayerMoney(playerid, -900);
					return 1;
				}
				case 1: {
					if(GetPlayerMoney(playerid) < 1700) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$1700");
						return 1;
					}
					SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 20 passagens para o SEM PARAR!");
					SemParar[playerid] += 20;
					GivePlayerMoney(playerid, -1700);
					return 1;
				}
				case 2: {
					if(GetPlayerMoney(playerid) < 3200) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$3200");
						return 1;
					}
					SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 30 passagens para o SEM PARAR!");
					SemParar[playerid] += 30;
					GivePlayerMoney(playerid, -3200);
					return 1;
				}
				case 3: {
					if(GetPlayerMoney(playerid) < 6200) {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$6200");
						return 1;
					}
					SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 40 passagens para o SEM PARAR!");
					SemParar[playerid] += 40;
					GivePlayerMoney(playerid, -6200);
					return 1;
				}
			}
		}
	}
	if(dialogid == 25)
	{

		if(response)
		{

			SendClientMessage(playerid,-1, "Edite o Objeto usando os eixos X, Y e Z. Depois click no icone de Salvar.");
			SendClientMessage(playerid,-1, "Caso cancele a edição, seu Item ira para seu Inventario.");
			EditAttachedObject(playerid, GetPVarInt(playerid,"sloteditar"));
		}
		else
		{

			for(new i; i<75; i++)
			{

				if(InventarioInfo[playerid][i][iSlot] == 19382)
				{

					InventarioInfo[playerid][i][iSlot] = AcessorioInfo[playerid][GetPVarInt(playerid,"sloteditar")][aModel];
					InventarioInfo[playerid][i][iUnidades] = 1;

					RemovePlayerAttachedObject(playerid,GetPVarInt(playerid,"sloteditar"));
					SendClientMessage(playerid,-1, "Você removeu este item, ele foi guardado em seu inventario.");
					AcessorioInfo[playerid][GetPVarInt(playerid,"sloteditar")][aModel] = 0;
					AcessorioInfo[playerid][GetPVarInt(playerid,"sloteditar")][aLocal] = 0;
					return 1;
				}
			}
			SendClientMessage(playerid,-1, "{ff0000}>> {ffffff}Seu Intentario esta cheio !");
		}
		return 1;
	}
	if(dialogid == 1099)
	{
		new quantidade = strval(inputtext), slot = ItemSelecionado[playerid], bool:InventarioLotado = true;
		if(quantidade > InventarioInfo[playerid][slot][iUnidades] || quantidade < 0)
		return SendClientMessage(playerid, 0xFF0000FF, "* Quantidade inválida");
		if(strval(inputtext) < InventarioInfo[playerid][ItemSelecionado[playerid]][iUnidades] && strval(inputtext) != 0){
			InventarioInfo[playerid][slot][iUnidades] -= quantidade;
			for(new i; i < 75; i ++)
			{

				if(InventarioInfo[playerid][i][iSlot] == 19382)
				{

					InventarioInfo[playerid][i][iSlot] = InventarioInfo[playerid][slot][iSlot];
					InventarioInfo[playerid][i][iUnidades] = quantidade;
					FecharInventario(playerid);
					AbrirInventario(playerid);
					InventarioLotado = false;
					break;
				}
			}
		}
		else{

			SendClientMessage(playerid, 0xFF6347AA, "* Digite um valor válido!");
		}
		if(InventarioLotado)
		return SendClientMessage(playerid, -1, "Seu inventário está lotado.");
		SendClientMessage(playerid, -1, "Você separou o item com sucesso.");
		return true;
	}
	if(dialogid == 2020)
	{

		if(response)
		{

			new str[400];
			new cu;
			if(GetPlayerMoney(playerid) < ValorCompraInv[playerid])
			{

				//ShowPlayerDialog(playerid, 105, DIALOG_STYLE_MSGBOX, "_", "{ff0000}Erro: {ffffff}Você nao tem dinheiro suficiente !\n\nVenda cancelada.", "Voltar", "");
				SendClientMessage(playerid, -1, "Você não tem dinheiro suficiente para comprar este item.");
				VendendoInv[VendedorInv[playerid]] = 0;
				ItemVender[VendedorInv[playerid]] = -1;
				format(str,400,"* %s não tem $%d para comprar seu item!",Nome(playerid), ValorCompraInv[playerid]);
				SendClientMessage(VendedorInv[playerid], -1, str);
				return 1;
			}

			if(!IsPlayerConnected( VendedorInv[playerid] ))
			{

				VendendoInv[VendedorInv[playerid]] = 0;
				//ShowPlayerDialog(playerid, 105, DIALOG_STYLE_MSGBOX, "_", "{ff0000}Erro: {ffffff}O vendedor saiu do jogo !\n\nVenda cancelada.", "Voltar", "");
				SendClientMessage(playerid, -1, "O vendedor saiu do jogo.");
				ItemVender[VendedorInv[playerid]] = -1;
				return 1;
			}

			for(new i; i<36; i++)
			{

				if(InventarioInfo[playerid][i][iSlot] == 19382)
				{

					InventarioInfo[playerid][i][iSlot] = InventarioInfo[VendedorInv[playerid]][ItemVender[VendedorInv[playerid]]][iSlot];
					InventarioInfo[playerid][i][iUnidades] = InventarioInfo[VendedorInv[playerid]][ItemVender[VendedorInv[playerid]]][iUnidades];
					InventarioInfo[VendedorInv[playerid]][ItemVender[VendedorInv[playerid]]][iSlot] = 19382;
					InventarioInfo[VendedorInv[playerid]][ItemVender[VendedorInv[playerid]]][iUnidades] = 0;
					format(str,400, "* %s aceitou o item que você ofereceu por $%d!",Nome(playerid),ValorCompraInv[playerid]);
					SendClientMessage(VendedorInv[playerid], -1, str);
					format(str,400, "* Você aceitou o item que %s lhe ofereceu por $%d!",Nome(VendedorInv[playerid]),ValorCompraInv[playerid]);
					FecharInventario(playerid);
					SetTimerEx("AbrirInv", 300, false, "i", playerid);
					SendClientMessage(playerid, -1, str);
					GivePlayerMoney(playerid, -ValorCompraInv[playerid]);
					GivePlayerMoney(VendedorInv[playerid], ValorCompraInv[playerid]);
					VendendoInv[VendedorInv[playerid]] = 0;
					ItemVender[VendedorInv[playerid]] = -1;
					cu = 1;
					return 1;
				}
			}
			if(cu == 1) SendClientMessage(playerid, -1, "Seu inventário está cheio.");
			VendendoInv[VendedorInv[playerid]] = 0;
			ItemVender[VendedorInv[playerid]] = -1;
			return 1;
		}
		else
		{

			new str[400];
			format(str,400, "* %s não quis comprar item ofericido por você!",Nome(playerid));
			SendClientMessage(VendedorInv[playerid], -1, str);
			format(str,400, "* Você não aceitou o item que %s lhe ofereceu por R$ %d.",Nome(VendedorInv[playerid]),ValorCompraInv[playerid]);
			SendClientMessage(playerid, -1, str);
			VendendoInv[VendedorInv[playerid]] = 0;
		}
		return 1;
	}
    if(dialogid == 21215)
	{
	    if(response)
	    {
	        for(new i = 0; i<10; i++)
	        {
	            if(!IsPlayerAttachedObjectSlotUsed(playerid,i))
	            {
	                //FecharInv2(playerid);
	                SetPlayerAttachedObject(playerid, i, InventarioInfo[playerid][GetPVarInt(playerid,"slotusar")][iSlot], listitem+1);
	                EditAttachedObject(playerid, i);
	                InventarioInfo[playerid][GetPVarInt(playerid,"slotusar")][iSlot] = 19382;
	                InventarioInfo[playerid][GetPVarInt(playerid,"slotusar")][iUnidades] = 0;
	                SendClientMessage(playerid,-1, "Edite o Objeto usando os eixos X, Y e Z. Depois click no icone de Salvar.");
	        		SendClientMessage(playerid,-1, "Caso cancele a edição, seu Item ira para seu Inventario.");
	                return 1;
	            }

	        }
	    }
	    else
	    {
            SetTimerEx("AbrirInv", 300, false, "i", playerid);
	    }
	    return 1;
	}

	if(dialogid == 900)
    {
        if(response)
        {
            new str[400];
			if( !NumerosInventario(inputtext) || ( strval(inputtext) < 1 || strval(inputtext) > 50000000 )) return SendClientMessage(playerid, -1, "O valor que você digitou é inválido !"), VendendoInv[playerid] = 0;

			format(str,400,"{FFFFFF}* %s quer vender um item para você !\n\n\
			{F5DEB3}Nome do item: {FFFFFF}%s\n\
			{F5DEB3}Quantidade: {FFFFFF}%d unidade(s)\n",Nome(playerid), NomeItemInventarioInventario(ItemVender[playerid],playerid), InventarioInfo[playerid][ItemVender[playerid]][iUnidades]);

			format(str,400,"%s{F5DEB3}Valor: {33AA33}$%d\n\n\
			{FF6347}*OBS: {BFC0C2}Você deseja comprar este item?",str, strval(inputtext));

   			ShowPlayerDialog(TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")],2020, DIALOG_STYLE_MSGBOX, "Comprar Item", str, "Comprar", "Fechar");

			format(str, 400, "{FFFFFF}* Você está preste a negociar um item com %s !\n\n\
			{F5DEB3}Nome do item: {FFFFFF}%s\n\
			{F5DEB3}Quantidade: {FFFFFF}%d unidade(s)\n\
			{F5DEB3}Valor oferecido: {33AA33}$%d\n\n\
			{FF6347}*OBS: {BFC0C2}Você ofereceu o item, aguarde uma resposta...", Nome(TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")]), NomeItemInventarioInventario(ItemVender[playerid],playerid), InventarioInfo[playerid][ItemVender[playerid]][iUnidades], strval(inputtext));

            ShowPlayerDialog(playerid, 2020, DIALOG_STYLE_MSGBOX, "Negociar Item", str, "Fechar", "");

			VendedorInv[ TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")] ] = playerid;
			ValorCompraInv[ TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")] ] = strval(inputtext);

			format(str,400,"* Você ofereceu um(a) %s com %d unidades para %s por $%d, aguarde uma resposta...", NomeItemInventarioInventario(ItemVender[playerid],playerid), InventarioInfo[playerid][ItemVender[playerid]][iUnidades], Nome(TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")]), strval(inputtext));
			SendClientMessage(playerid, -1,str);
			format(str,400,"* %s lhe ofereceu um(a) %s com %d unidades por $%d.",Nome(TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")]), NomeItemInventarioInventario(ItemVender[playerid],playerid), InventarioInfo[playerid][ItemVender[playerid]][iUnidades], strval(inputtext));
			SendClientMessage(TodosPlayers[playerid][GetPVarInt(playerid,"Comprador")],-1,str);

        }
        else
        {
            SendClientMessage(playerid,-1,"Você cancelou a venda !");
            VendendoInv[playerid] = 0;
            ItemVender[playerid] = -1;

		}

        return 1;
    }

    if(dialogid == 9182)
    {
        if(response)
        {
			if(!IsPlayerConnected( TodosPlayers[playerid][listitem] ))
			{
			    SendClientMessage(playerid,-1,"Este jogador não está mais conectado!");
			    VendendoInv[playerid] = 0;
			    ItemVender[playerid] = -1;
		 		return 1;
		 	}
            new str[300];
            format(str,300,"{FFFFFF}* Voce está preste a negociar um item com %s !\n\n\
			{F5DEB3}Nome do item: {FFFFFF}%s\n\
			{F5DEB3}Quantidade: {FFFFFF}%d unidade(s)\n\n\
			{FF6347}*OBS: {BFC0C2}Digite quanto você está pedindo por este item abaixo:", Nome(TodosPlayers[playerid][listitem]), NomeItemInventarioInventario(ItemVender[playerid],playerid) , InventarioInfo[playerid][ItemVender[playerid]][iUnidades]);
            ShowPlayerDialog(playerid,900, DIALOG_STYLE_INPUT, "Vender Item", str, "OK", "Cancelar");
            SetPVarInt(playerid,"comprador",listitem);

        }
        else
        {
            VendendoInv[playerid] = 0;
            ItemVender[playerid] = -1;

        }
        return 1;
    }
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public Sumiu(playerid)
{
	foreach(new i : Player)
	{
		TextDrawHideForPlayer(playerid, Aviso[i]);
	}
	return 1;
}

forward Feridox(playerid);
public Feridox(playerid)
{
	if (!Dados[playerid][Chao] && !Dados[playerid][Morto])
	{
		Dados[playerid][Ferido] = 3000;
		Dados[playerid][Chao] = 1;
		Dados[playerid][Saude] = 0;
		Atualizar(playerid);
	}

	return 1;
}
forward Caiu(playerid);
public Caiu(playerid)
{
	ApplyAnimation(playerid,"PED","BIKE_fall_off",4.1,0,1,1,1,1,1);
	SetTimerEx("Caiu2",2000,false,"i",playerid);
	return 1;
}
forward Caiu2(playerid);
public Caiu2(playerid)
{
	ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0,1);
	if (Dados[playerid][MancandoKeyPress]) SetTimerEx("Caiu2",2000,false,"i",playerid);
	else SetTimerEx("AnimNormal",3000,false,"i",playerid);
}
forward AnimNormal(playerid);
public AnimNormal(playerid)
{
	ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1,1);
	Dados[playerid][IniciouCair] = false;
	TogglePlayerControllable(playerid, 1);
	return 1;
}
forward Quebrado(playerid);
public Quebrado(playerid)
{
	ApplyAnimation(playerid,"PED","flee_lkaround_01",4.1,0,1,1,1,1);
	return 1;
}
forward CheckSemParar();
public CheckSemParar()
{
	for(new i; i != GetMaxPlayers(); i++) {
		if(IsPlayerConnected(i)) {
			/*new Float: Distancia = GetPlayerDistanceFromPoint(i, -1672.1960,-2666.5608,48.6968); // Base para locais fixos.
			if(Distancia <= 100 && Dados[i][FollowTwo] == 0)
			{
				SendClientMessage(i, COR_VERDE, "Arrrg");
				Dados[i][FollowTwo] = 1;
				PlayAudioStreamForPlayer(i, "http://radio.plaza.one/mp3", -1672.1960,-2666.5608,48.6968, 20.0, 1);
                SetTimerEx("StopSound", 30000, false, "i", i);
			}
			if(Distancia >= 100 && Dados[i][FollowTwo] == 1)
			{
				Dados[i][FollowTwo] = 0;
				StopAudioStreamForPlayer(i);
			}*/
			SoundAmbience(i);
			if(IsPlayerInAnyVehicle(i)) {
				if(IsPlayerInRangeOfPoint(i, 6.5, -1125.2976,-2863.8716,67.7188) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][0], -1120.59277, -2860.23462, 67.43290, 0.0001, 0.0000, 0.0000, 272.3800);
						return 1;
					}
					if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela1", 3000, false, "i", i);
							break;
						}
					}
					else {
						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO,"| ERRO | Você não possui R$100 reais para o pedágio!");
						break;
					}
				} else if(IsPlayerInRangeOfPoint(i, 6.5, -1114.5270,-2851.4023,67.7188) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][1], -1121.28052, -2855.66870, 67.43290, 0.0001, 0.0000, 0.0000, 92.1800);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela2", 3000, false, "i", i);
							break;
						}
					}
					else
					{

						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				}
				if(IsPlayerInRangeOfPoint(i, 6.5, 1743.8019, 522.3286, 27.8644) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][3], 1743.69641, 532.61810, 27.08570, 0.0001, 0.0000, 0.0000, -21.5200);
						return 1;
					}
					if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela4", 3000, false, "i", i);
							break;
						}
					}
					else
					{

						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				} else if(IsPlayerInRangeOfPoint(i, 6.5, 1753.6305, 520.3472, 27.7972) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][2], 1752.64233, 529.21753, 27.08570, 0.0001, 0.0000, 0.0000, -21.5200);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela3", 3000, false, "i", i);
							break;
						}
					}
					else
					{

						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				}
				if(IsPlayerInRangeOfPoint(i, 6.5, 1737.3971, 530.7954, 27.5291) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][4], 1738.31946, 523.43921, 27.62790, 0.0001, 0.0000, 0.0000, 162.1799);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela5", 3000, false, "i", i);
							break;
						}
					}
					else
					{

						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				} else if(IsPlayerInRangeOfPoint(i, 6.5, 1729.5702,535.3495,27.4266) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][5], 1729.92896, 526.36902, 27.62790, 0.0001, 0.0000, 0.0000, 162.1799);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela6", 3000, false, "i", i);
							break;
						}
					}
					else
					{

						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				}
			}
		}
	}
	return 1;
}
stock SoundAmbience(playerid)
{
	/*new Float: Distancia = GetPlayerDistanceFromPoint(playerid, -1672.1960,-2666.5608,48.6968); // Base para locais fixos.
	if(Distancia <= 100 && Dados[playerid][FollowTwo] == 0)
	{
		SendClientMessage(playerid, COR_VERDE, "Arrrg");
		Dados[playerid][FollowTwo] = 1;
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, "http://radio.plaza.one/mp3", -1672.1960,-2666.5608,48.6968, 20.0, 1);
 		SetTimerEx("StopSound", 30000, false, "i", playerid);
	}
	if(Distancia >= 100 && Dados[playerid][FollowTwo] == 1)
	{
		Dados[playerid][FollowTwo] = 0;
		StopAudioStreamForPlayer(playerid);
  	}*/
	for(new i; i != GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(Dados[i][Zombie] == 1) // É um zombie
		    {
				if(Dados[i][mZombie] == 0) // Zombie vivo
			    {
					new
						Float:pos_x,
						Float:pos_y,
						Float:pos_z;
					GetPlayerPos(i, pos_x, pos_y, pos_z);
					new Float: DistanceForZombie = GetPlayerDistanceFromPoint(playerid, pos_x, pos_y, pos_z);
					if(DistanceForZombie <= 25)
					{
						if(Dados[playerid][FollowThre] == 0)
						{
						   Dados[playerid][FollowThre] = 1;
						   PlayAudioStreamForPlayer(playerid, "https://www.dropbox.com/s/2r8suk820aa4ot3/Zombies.mp3?dl=1", pos_x, pos_y, pos_z, 60.0, 1);
						   SetTimerEx("StopSound", 30000, false, "i", playerid);
						}
					}
			    }
		    }
			if(Dados[i][Cavalo] == 1)
			{
					new
						Float:pos_x,
						Float:pos_y,
						Float:pos_z;
					GetPlayerPos(i, pos_x, pos_y, pos_z);
					new Float: DistanceForHorse = GetPlayerDistanceFromPoint(playerid, pos_x, pos_y, pos_z);
					if(DistanceForHorse <= 25)
					{
						if(Dados[playerid][FollowFour] == 0)
						{
						   Dados[playerid][FollowFour] = 1;
						   PlayAudioStreamForPlayer(playerid, "https://www.dropbox.com/s/sl7jrbnks1qcif6/Horse.mp3?dl=1");
						   SetTimerEx("StopSound", 30000, false, "i", playerid);
						}
					}
			}
		}
	}
}
forward MoveCancela1(playerid);
public MoveCancela1(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][0], -1120.59277, -2860.23462, 67.43290, 0.0001, 0.0000, 0.0000, 272.3800);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela2(playerid);
public MoveCancela2(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][1], -1121.28052, -2855.66870, 67.43290, 0.0001, 0.0000, 0.0000, 92.1800);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela3(playerid);
public MoveCancela3(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][2], 1752.64233, 529.21753, 27.08570+0.0001, 0.0001, 0.0000, 0.0000, -21.5200);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela4(playerid);
public MoveCancela4(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][3], 1743.69641, 532.61810, 27.08570+0.0001, 0.0001, 0.0000, 0.0000, -21.5200);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela5(playerid);
public MoveCancela5(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][4], 1738.31946, 523.43921, 27.62790+0.0001, 0.0001, 0.0000, 0.0000, 162.1799);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela6(playerid);
public MoveCancela6(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][5], 1729.92896, 526.36902, 27.62790+0.0001, 0.0001, 0.0000, 0.0000, 162.1799);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward PassouPedagioP(playerid);
public PassouPedagioP(playerid)
{
	PassouPedagio[playerid] = false;
	return 1;
}

forward FecharCancelaP(playerid);
public FecharCancelaP(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][0], -1120.59277, -2860.23462, 67.43290, 0.0001, 0.0000, 90.0000, 272.3800);
	MovePlayerObject(playerid, CancelaP[playerid][1], -1121.28052, -2855.66870, 67.43290, 0.0001, 0.0000, 90.0000, 92.1800);
	MovePlayerObject(playerid, CancelaP[playerid][2], 1752.64233, 529.21753, 27.08570, 0.0001, 0.0000, 90.0000, -21.5200);
	MovePlayerObject(playerid, CancelaP[playerid][3], 1743.69641, 532.61810, 27.08570, 0.0001, 0.0000, 90.0000, -21.5200);
	MovePlayerObject(playerid, CancelaP[playerid][4], 1738.31946, 523.43921, 27.62790, 0.0001, 0.0000, 90.0000, 162.1799);
	MovePlayerObject(playerid, CancelaP[playerid][5], 1729.92896, 526.36902, 27.62790, 0.0001, 0.0000, 90.0000, 162.1799);
	return 1;
}

forward AtualizarMorto();
public AtualizarMorto()
{
	foreach(new i : Player)
	{
		if(Dados[i][Chao] && Dados[i][Ferido] <= 0)
		{
			ApplyAnimation(i,"PED","FLOOR_hit_f",4.1,0,1,1,1,1,1);
		}
	}
	return 1;
}
forward StopSound(playerid);
public StopSound(playerid)
{
	Dados[playerid][FollowTwo] = 0;
	Dados[playerid][FollowThre] = 0; // Zombies
	Dados[playerid][FollowFour] = 0; // Cavalos
	StopAudioStreamForPlayer(playerid);
	return 1;
}
forward AtualizarFome();
public AtualizarFome()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(Logado[i] == true)
		    {
			    if(Dados[i][Saude] <= 1 && !Dados[i][Chao] && Dados[i][Resistencia] < 25)
			    {
			    	SetTimerEx("Feridox",4000,false,"i",i);
			    	SendClientMessage(i, -1, "Você sente muita fome ou sede.");
			    }
			    else
			    {
				    if(Dados[i][Fome] <= 1 || Dados[i][Sede] <= 1)
				    {
				    	SendClientMessage(i, -1, "Você precisa se alimentar ou se hidratar urgente.");
				    	SetPlayerDrunkLevel(i , 15000);
				    	Dados[i][Saude] -= 2;
				    	Dados[i][Fome] = 0;
						Dados[i][Sede] = 0;
				    	SetTimerEx("PararDruk", 10000, 0, "i", i);
				    }
				    else
				    {
						Dados[i][Fome] -= 1;
						Dados[i][Sede] -= 1;
					}
				}
				Atualizar(i);
			}
		}
	}
}
forward PararDruk(playerid);
public PararDruk(playerid)
{
	SetPlayerDrunkLevel(playerid , 0);
	return 1;
}
forward AtualizarText();
public AtualizarText()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && Dados[i][Animal] == 0 && Dados[i][Zombie] == 0 && Dados[i][Cavalo] == 0) // Jogador Conectado condicional
		{
			new Joelw[64];
			if(Dados[i][Chao] == 0)
			{
				format(Joelw, sizeof Joelw, "\n\n %d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			if(Dados[i][Ferido] >= 1500)
			{
				format(Joelw, sizeof Joelw, "{F5BC0F}Ferido 'Y' para Interagir\n {FFFFFF}%d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			else if(Dados[i][Ferido] >= 800)
			{
				format(Joelw, sizeof Joelw, "{FA9C05}Ferido 'Y' para Interagir\n {FFFFFF}%d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			else if(Dados[i][Ferido] >= 500)
			{
				format(Joelw, sizeof Joelw, "{E06001}Ferido 'Y' para Interagir\n {FFFFFF}%d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			else if(Dados[i][Ferido] >= 100)
			{
				format(Joelw, sizeof Joelw, "{FA440C}Ferido 'Y' para Interagir\n {FFFFFF}%d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			else if(Dados[i][Ferido] > 0 && Dados[i][Ferido] < 100)
			{
				format(Joelw, sizeof Joelw, "{FA440C}Ferido 'Y' para Interagir\n {FFFFFF}%d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			if(Dados[i][Morto] == 1)
			{
				format(Joelw, sizeof Joelw, "{FA440C}Morto 'Y' para Interagir\n {FFFFFF}%d", Dados[i][Tag]);
				SetPlayerChatBubble(i, Joelw, -1, 10.0, 10000);
			}
			if (Dados[i][Ferido] > 0) Dados[i][Ferido] -= 1;

			new estado[45];
			if(Dados[i][Chao] == 1)
			{
				new gstring[256];
				if(Dados[i][Ferido] >= 2000)estado = "~y~PERDENDO SANGUE";
				else if(Dados[i][Ferido] >= 1500)estado = "~y~VISTA ESCURECENDO";
				else if(Dados[i][Ferido] >= 1000)estado = "~r~~h~DESMAIADO";
				else if(Dados[i][Ferido] >= 500)estado = "~r~~h~CEREBRO SEM AR";
				else if(Dados[i][Ferido] >= 100)estado = "~r~MORTE IMINENTE";
				else if(Dados[i][Ferido] <= 0)estado = "~r~MORTO";
				format(gstring, sizeof gstring, "%s",estado);
				PlayerTextDrawSetString(i, TextFeridoG[i][0], gstring);
				format(gstring, sizeof gstring, "%d",Dados[i][Ferido]);
				PlayerTextDrawSetString(i, TextFeridoG[i][1], gstring);
				for( new t; t != 2; t++) PlayerTextDrawShow(i, TextFeridoG[i][t]);
				TextDrawShowForPlayer(i, TextFerido[0]);

				if (Dados[i][Ferido] <= 0)
				{
					// if(!Dados[i][Morto]) ApplyAnimation(i,"PED","FLOOR_hit_f",4.1,0,1,1,1,1,1);
					Dados[i][Morto] = 1;
					TogglePlayerControllable(i, 0);
				}
			}
			// ANT BUG.
			if(Dados[i][Saude] > 100) Dados[i][Saude] = 100;
			if(Dados[i][Saude] < 0) Dados[i][Saude] = 0;
			if(Dados[i][Fome] > 100) Dados[i][Fome] = 100;
			if(Dados[i][Fome] < 0) Dados[i][Fome] = 0;
			if(Dados[i][Sede] > 100) Dados[i][Sede] = 100;
			if(Dados[i][Sede] < 0) Dados[i][Sede] = 0;

		} // FIM CONDICIONAL DO CARA CONECTADO
	}
}
forward ChecarCarro();
public ChecarCarro()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{

		if(IsPlayerConnected(i))
		{

			if (!IsPlayerInAnyVehicle(i)) continue;
			// Checando lataria:
			new vehicleid;
			vehicleid = GetPlayerVehicleID(i);
			new Float:Vida;
			GetVehicleHealth(vehicleid, Vida);
			if(Vida/10 <= 35)
			{

				SetVehicleHealth(vehicleid , 350.0);
			}
			if(Vida/10 <= 35)
			{

				SetVehicleHealth(vehicleid , 350.0);
				if(fundido[vehicleid] == 0)
				{

					new mot, lu, alar, por, cap, porma, ob;
					GetVehicleParamsEx(vehicleid, mot, lu, alar, por, cap, porma, ob);
					SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
					fundido[vehicleid] = 1;
					SendClientMessage(i, -1, "O motor do veículo parou, aparantemente algo danificou.");
				}
			}
			if(Vida/10 > 35)
			{

				if(fundido[vehicleid] == 1)
				{

					new mot, lu, alar, por, cap, porma, ob;
					GetVehicleParamsEx(vehicleid, mot, lu, alar, por, cap, porma, ob);
					SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lu, alar, por, cap, porma, ob);
					fundido[vehicleid] = 0;
				}
			}
			// Checando gasolina:
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER && !IsPlayerNPC(i))
			{

				new vehicle = GetPlayerVehicleID(i);
				new VehicleModel = GetVehicleModel(vehicle);
				new GasEtempo[MAX_PLAYERS],ResultOwn[MAX_PLAYERS];
				GasEtempo[i] = Gas[vehicle]*18;
				ResultOwn[i] = GasEtempo[i]/60;
				if(VehicleModel == 509 || VehicleModel == 481 || VehicleModel == 510 || VehicleModel == 476 || VehicleModel == 430 || VehicleModel == 462
				|| VehicleModel == 511 || VehicleModel == 512 || VehicleModel == 513 || VehicleModel == 519 || VehicleModel == 520 || VehicleModel == 548 || VehicleModel == 553
				|| VehicleModel == 577 || VehicleModel == 592 || VehicleModel == 593 || VehicleModel == 595 || VehicleModel == 493 || VehicleModel == 472 || VehicleModel == 454 || VehicleModel == 453 || VehicleModel == 452 || VehicleModel == 446)
				{

					return 1;
				}
				if(Gas[vehicle] > 100)
				{

					Gas[vehicle] = 100;
				}
				else if(ResultOwn[i] <= 4)
				{

					//GameTextForPlayer(i, "~r~GASOLINA ACABANDO", 5000, 4);
				}
				GetVehicleVelocity(vehicle, velokm[0], velokm[1], velokm[2]);
				if(floatround(((floatsqroot(((velokm[0] * velokm[0]) + (velokm[1] * velokm[1]) + (velokm[2] * velokm[2]))) * (170.0))) * 1) > 5)
				{

					if(Gas[vehicle] > 0)
					{

						Retirada[i]+=1;
						if(Retirada[i] >= (RETIRAR_KM*13))
						{

							if(Gas[vehicle] <= 1)
							{

								NoFuel[i] = 1;
								PlayerPlaySound(i, 1159, 0.0, 0.0, 0.0);
								SendClientMessage(i, -1, "O motor desligou por falta de combustível, vá até o posto mais próximo e compre um galão.");
								new mot, lu, alar, por, cap, porma, ob;
								GetVehicleParamsEx(vehicle, mot, lu, alar, por, cap, porma, ob);
								SetVehicleParamsEx(vehicle, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
								motor[i] = 0;
								SendClientMessage(i, -1, "Veiculo {E31919}Desligado!");
								return 1;
							}
							Gas[vehicle]--;
							Retirada[i]=0;
						}
					}
					else
					{

						NoFuel[i] = 1;
						new mot, lu, alar, por, cap, porma, ob;
						GetVehicleParamsEx(vehicle, mot, lu, alar, por, cap, porma, ob);
						SetVehicleParamsEx(vehicle, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
						motor[i] = 0;
					}
				}
			}
		}
	}
	return 1;
}
forward MutadoTimer(playerid);
public MutadoTimer(playerid)
{
	SendClientMessage(playerid, 0xFF0000FF, "| INFO | Você foi descalado não quebre as regras novamente!");
	Calado[playerid] = 0;
	return 1;
}

public Horas(playerid) {
	new Str[128], str2[128], ano, mes, dia, horas, minutos, segundos;
	getdate(ano, mes, dia);
	gettime(horas, minutos, segundos);
	new mess[12];
	if(mes == 1) { mess = "1";}
	else if(mes == 2) { mess = "2";}
	else if(mes == 3) { mess = "3";}
	else if(mes == 4) { mess = "4";}
	else if(mes == 5) { mess = "5";}
	else if(mes == 6) { mess = "6";}
	else if(mes == 7) { mess = "7";}
	else if(mes == 8) { mess = "8";}
	else if(mes == 9) { mess = "9";}
	else if(mes == 10) { mess = "10";}
	else if(mes == 11) { mess = "11";}
	else if(mes == 12) { mess = "12";}
	format(Str, sizeof(Str), "%02d/%02d/%02d", dia, mes, ano);
	TextDrawSetString(Text:Textdraw0, Str);
	format(str2, sizeof(str2), "%02d:%02d:%02d", horas, minutos, segundos);
	TextDrawSetString(Text:Textdraw1, str2);
}

// TODAS STOCKS
stock MostrarVelocimetro(playerid) {
	if ( PlayerVelocimetro[playerid] ) {
		return 0;
	}
	for( new text; text != 4; text++) TextDrawShowForPlayer(playerid, Velocimetro[text]);
	for( new text; text != 4; text++) PlayerTextDrawShow(playerid, Velo[playerid][text]);
	PlayerVelocimetro[playerid] = true ;
	PlayerVelocimetroTimer[playerid] = SetTimerEx("AtualizarVelo", 100, true, "i", playerid);
	return 1;
}
stock FecharVelocimetro(playerid) {
	if ( !PlayerVelocimetro[playerid] ) {
		return 0;
	}
	for( new text; text != 4; text++) TextDrawHideForPlayer(playerid, Velocimetro[text]);
	for( new text; text != 4; text++) PlayerTextDrawHide(playerid, Velo[playerid][text]);
	PlayerVelocimetro[playerid] = false ;
	KillTimer(PlayerVelocimetroTimer[playerid]);
	return 1;
}
stock GetVehicleSpeed(vehicleid)
{
	new Float:xPos[3];
	GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
	return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}

stock Contas(playerid) {
	new file[128];
	format(file, sizeof(file), PASTA_CONTAS, GetPlayerNome(playerid));
	return file;
}

stock Carros(carid) {
	new file[128];
	format(file, sizeof(file), PASTA_CARROS, carid);
	return file;
}

stock GetPlayerNome(playerid) {
	new aname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, aname, sizeof(aname));
	return aname;
}

stock SalvarConta(playerid)
{
	if(DOF2_FileExists(Contas(playerid)) && Logado[playerid])
	{
		new car = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(car);
		if(model == 471)
		{
			if(PlayerInHorse[playerid])
			{
				new carid = GetPlayerVehicleID(playerid);
				DestroyVehicle(carid);
				PlayerInHorse[playerid] = 0;
				Dados[HorseForPlayer[playerid]][Cavalo] = 0;
				FCNPC_Destroy(HorseForPlayer[playerid]);
				HorseForPlayer[playerid] = 0;
				Dados[playerid][FollowFour] = 0; // Cavalos
				StopAudioStreamForPlayer(playerid);
			}
		}
	    new Roupa = GetPlayerSkin(playerid);
		SalvarInventario(playerid);
		new Float:Pos[4];
		new ano, mes, dia;
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		GetPlayerFacingAngle(playerid, Pos[3]);
		getdate(ano, mes, dia);
		if(Logado[playerid] == true) // Proteção para não haver bug de "placa".
		{
			DOF2_SetFloat(Contas(playerid), "UltimaPosX", Pos[0]);
			DOF2_SetFloat(Contas(playerid), "UltimaPosY", Pos[1]);
			DOF2_SetFloat(Contas(playerid), "UltimaPosZ", Pos[2]);
			DOF2_SetFloat(Contas(playerid), "UltimaPosA", Pos[3]);
		}
		DOF2_SetInt(Contas(playerid), "Dinheiro", Dados[playerid][Dinheiro]);
		DOF2_SetInt(Contas(playerid), "Ferido", Dados[playerid][Ferido]);
		DOF2_SetInt(Contas(playerid), "Chao", Dados[playerid][Chao]);
		DOF2_SetInt(Contas(playerid), "Braco", Dados[playerid][Braco]);
		DOF2_SetInt(Contas(playerid), "Peso", Dados[playerid][Peso]);
		DOF2_SetInt(Contas(playerid), "Mancando", Dados[playerid][Mancando]);
		DOF2_SetInt(Contas(playerid), "Morto", Dados[playerid][Morto]);
		DOF2_SetInt(Contas(playerid), "UltimoLoginD", dia);
		DOF2_SetInt(Contas(playerid), "UltimoLoginM", mes);
		DOF2_SetInt(Contas(playerid), "UltimoLoginA", ano);
		DOF2_SetInt(Contas(playerid), "Senha", Dados[playerid][Senha]);
		DOF2_SetInt(Contas(playerid), "Tag", Dados[playerid][Tag]);
		DOF2_SetInt(Contas(playerid), "points", Dados[playerid][points]);
		DOF2_SetInt(Contas(playerid), "Saude", Dados[playerid][Saude]);
		DOF2_SetInt(Contas(playerid), "Sede", Dados[playerid][Sede]);
		DOF2_SetInt(Contas(playerid), "Fome", Dados[playerid][Fome]);
		DOF2_SetInt(Contas(playerid), "Matou", Dados[playerid][Matou]);
		DOF2_SetInt(Contas(playerid), "Morreu", Dados[playerid][Morreu]);
		//DOF2_SetInt(Contas(playerid), "Dinheiro", GetPlayerMoney(playerid));
		DOF2_SetInt(Contas(playerid), "Skin", Roupa);
		Dados[playerid][Level] = GetPlayerScore(playerid);
		DOF2_SetInt(Contas(playerid), "Celular", Dados[playerid][Celular]);
		DOF2_SetInt(Contas(playerid), "Creditos", Dados[playerid][Creditos]);
		DOF2_SetInt(Contas(playerid), "Admin", Dados[playerid][Admin]);
		DOF2_SetInt(Contas(playerid), "SemParar", SemParar[playerid]);
		DOF2_SetInt(Contas(playerid), "PH", Dados[playerid][PH]);
		DOF2_SetInt(Contas(playerid), "Agilidade", Dados[playerid][Agilidade]);
		DOF2_SetInt(Contas(playerid), "Forca", Dados[playerid][Forca]);
		DOF2_SetInt(Contas(playerid), "Carisma", Dados[playerid][Carisma]);
		DOF2_SetInt(Contas(playerid), "Destreza", Dados[playerid][Destreza]);
		DOF2_SetInt(Contas(playerid), "Resistencia", Dados[playerid][Resistencia]);
		DOF2_SetInt(Contas(playerid), "Inteligencia", Dados[playerid][Inteligencia]);
		DOF2_SetInt(Contas(playerid), "Defesa", Dados[playerid][Defesa]);
		DOF2_SetInt(Contas(playerid), "Sabedoria", Dados[playerid][Sabedoria]);
		DOF2_SetInt(Contas(playerid), "Sapiencia", Dados[playerid][Sapiencia]);
		DOF2_SetInt(Contas(playerid), "Engenharia", Dados[playerid][Engenharia]);
		DOF2_SetInt(Contas(playerid), "Talento", Dados[playerid][Talento]);
		DOF2_SetInt(Contas(playerid), "Power", Dados[playerid][Power]);
		DOF2_SaveFile();
		SaveWork(playerid);

		for(new i=0; i<15; i++) // Salvar todos os chaveiros
		{
			if(InventarioInfo[playerid][i][iSlot] == ITEM_CHAVEIRO) SalvarChaveiro(InventarioInfo[playerid][i][iUnidades]);
		}
	}
	return 1;
}

stock CarregarConta(playerid)
{
	if (DOF2_FileExists(Contas(playerid)))
	{

		SemParar[playerid] = DOF2_GetInt(Contas(playerid), "SemParar");
		Dados[playerid][Level] = DOF2_GetInt(Contas(playerid), "Level");
		Dados[playerid][Tag] = DOF2_GetInt(Contas(playerid), "Tag");
		Dados[playerid][Saude] = DOF2_GetInt(Contas(playerid), "Saude");
		Dados[playerid][points] = DOF2_GetInt(Contas(playerid), "points");
		Dados[playerid][Sede] = DOF2_GetInt(Contas(playerid), "Sede");
		Dados[playerid][Fome] = DOF2_GetInt(Contas(playerid), "Fome");
		Dados[playerid][Dinheiro] = DOF2_GetInt(Contas(playerid), "Dinheiro");
		Dados[playerid][Ferido] = DOF2_GetInt(Contas(playerid), "Ferido");
		Dados[playerid][Chao] = DOF2_GetInt(Contas(playerid), "Chao");
		Dados[playerid][Braco] = DOF2_GetInt(Contas(playerid), "Braco");
		Dados[playerid][Peso] = DOF2_GetInt(Contas(playerid), "Peso");
		Dados[playerid][Mancando] = DOF2_GetInt(Contas(playerid), "Mancando");
		Dados[playerid][Morto] = DOF2_GetInt(Contas(playerid), "Morto");
		Dados[playerid][Matou] = DOF2_GetInt(Contas(playerid), "Matou");
		Dados[playerid][Morreu] = DOF2_GetInt(Contas(playerid), "Morreu");
		Dados[playerid][Celular] = DOF2_GetInt(Contas(playerid), "Celular");
		Dados[playerid][Creditos] = DOF2_GetInt(Contas(playerid), "Creditos");
		Dados[playerid][Admin] = DOF2_GetInt(Contas(playerid), "Admin");
		Dados[playerid][UltimoLoginA] = DOF2_GetInt(Contas(playerid), "UltimoLoginA");
		Dados[playerid][UltimoLoginM] = DOF2_GetInt(Contas(playerid), "UltimoLoginM");
		Dados[playerid][UltimoLoginD] = DOF2_GetInt(Contas(playerid), "UltimoLoginD");
		Dados[playerid][PH] = DOF2_GetInt(Contas(playerid), "PH");
		Dados[playerid][Agilidade] = DOF2_GetInt(Contas(playerid), "Agilidade");
		Dados[playerid][Forca] = DOF2_GetInt(Contas(playerid), "Forca");
		Dados[playerid][Carisma] = DOF2_GetInt(Contas(playerid), "Carisma");
		Dados[playerid][Destreza] = DOF2_GetInt(Contas(playerid), "Destreza");
		Dados[playerid][Resistencia] = DOF2_GetInt(Contas(playerid), "Resistencia");
		Dados[playerid][Inteligencia] = DOF2_GetInt(Contas(playerid), "Inteligencia");
		Dados[playerid][Defesa] = DOF2_GetInt(Contas(playerid), "Defesa");
		Dados[playerid][Sabedoria] = DOF2_GetInt(Contas(playerid), "Sabedoria");
		Dados[playerid][Sapiencia] = DOF2_GetInt(Contas(playerid), "Sapiencia");
		Dados[playerid][Talento] = DOF2_GetInt(Contas(playerid), "Talento");
		Dados[playerid][Engenharia] = DOF2_GetInt(Contas(playerid), "Engenharia");
		Dados[playerid][Power] = DOF2_GetInt(Contas(playerid), "Power");
		Dados[playerid][Skin] = DOF2_GetInt(Contas(playerid), "Skin");
		SetPlayerScore(playerid, Dados[playerid][Level]);

		if (Dados[playerid][Admin] >=1)
		{
			Iter_Add(Admins, playerid);
			for (new i=0; i<MAX_PAINEL_ID; i++) painelDesativado[playerid][i] = false;
		}
	}
	else
	{

		Kick(playerid);
	}
	//GivePlayerMoney(playerid, Dados[playerid][Dinheiro]);
	return 1;
}

stock LimparChat(playerid, linhas)
{
	for(new i; i < linhas; i++)
	{

		SendClientMessage(playerid, 0xFFFFFFAA, "  ");
	}
	return 1;
}

stock AdminLevel(playerid)
{
	new name[32];
	if(Dados[playerid][Admin] == 0) format(name, sizeof(name), "Jogador");
	else if(Dados[playerid][Admin] == 1) format(name, sizeof(name), "Ajudante");
	else if(Dados[playerid][Admin] == 2) format(name, sizeof(name), "Moderador");
	else if(Dados[playerid][Admin] == 3) format(name, sizeof(name), "Administrador");
	else if(Dados[playerid][Admin] == 4) format(name, sizeof(name), "Sub-Staff");
	else if(Dados[playerid][Admin] == 5) format(name, sizeof(name), "Staff");
	return name;
}

stock ReturnVehicleID(vName[])
{
	for(new x; x != 211; x++) if(strfind(vNames[x], vName, true) != -1) return x + 400;
	return INVALID_VEHICLE_ID;
}

stock IsPlayerInPlace(playerid, Float:XMin, Float:YMin, Float:XMax, Float:YMax)
{
	new
	RetValue = 0,
	Float:aQ,
	Float:aW,
	Float:aE
	;
	GetPlayerPos(playerid, aQ, aW, aE);
	if(aQ >= XMin && aW >= YMin && aQ < XMax && aW < YMax)
	{

		RetValue = 1;
	}
	return RetValue;
}

stock BlindarVeiculo(vehicleid)
{
	Vuln[vehicleid] = 100.0;
	RepairVehicle(vehicleid);
}
stock showInventarioBox(playerid, boxid){
	for(new i; i<4; i++)
	{
		PlayerTextDrawDestroy(playerid,invBox[playerid][i]); }
	if(boxid > 0 || boxid < 16){
		invBox[playerid][0] = CreatePlayerTextDraw(playerid, 146.600006, 353.613342, ""); // Usar
		PlayerTextDrawTextSize(playerid, invBox[playerid][0], 31.000000, 12.000000);
		PlayerTextDrawAlignment(playerid, invBox[playerid][0], 1);
		PlayerTextDrawColor(playerid, invBox[playerid][0], -1);
		PlayerTextDrawSetShadow(playerid, invBox[playerid][0], 0);
		PlayerTextDrawBackgroundColor(playerid, invBox[playerid][0], 5);
		PlayerTextDrawFont(playerid, invBox[playerid][0], 5);
		PlayerTextDrawSetProportional(playerid, invBox[playerid][0], 0);
		PlayerTextDrawSetSelectable(playerid, invBox[playerid][0], true);
		PlayerTextDrawSetPreviewModel(playerid, invBox[playerid][0], 19382);
		PlayerTextDrawSetPreviewRot(playerid, invBox[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

		invBox[playerid][1] = CreatePlayerTextDraw(playerid, 191.000076, 354.111083, ""); // Dividir
		PlayerTextDrawTextSize(playerid, invBox[playerid][1], 44.000000, 12.000000);
		PlayerTextDrawAlignment(playerid, invBox[playerid][1], 1);
		PlayerTextDrawColor(playerid, invBox[playerid][1], -1);
		PlayerTextDrawSetShadow(playerid, invBox[playerid][1], 0);
		PlayerTextDrawBackgroundColor(playerid, invBox[playerid][1], 5);
		PlayerTextDrawFont(playerid, invBox[playerid][1], 5);
		PlayerTextDrawSetProportional(playerid, invBox[playerid][1], 0);
		PlayerTextDrawSetSelectable(playerid, invBox[playerid][1], true);
		PlayerTextDrawSetPreviewModel(playerid, invBox[playerid][1], 19382);
		PlayerTextDrawSetPreviewRot(playerid, invBox[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);

		invBox[playerid][2] = CreatePlayerTextDraw(playerid, 247.800079, 354.111083, ""); // Mover
		PlayerTextDrawTextSize(playerid, invBox[playerid][2], 42.000000, 12.000000);
		PlayerTextDrawAlignment(playerid, invBox[playerid][2], 1);
		PlayerTextDrawColor(playerid, invBox[playerid][2], -1);
		PlayerTextDrawSetShadow(playerid, invBox[playerid][2], 0);
		PlayerTextDrawBackgroundColor(playerid, invBox[playerid][2], 5);
		PlayerTextDrawFont(playerid, invBox[playerid][2], 5);
		PlayerTextDrawSetProportional(playerid, invBox[playerid][2], 0);
		PlayerTextDrawSetSelectable(playerid, invBox[playerid][2], true);
		PlayerTextDrawSetPreviewModel(playerid, invBox[playerid][2], 19382);
		PlayerTextDrawSetPreviewRot(playerid, invBox[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);

		invBox[playerid][3] = CreatePlayerTextDraw(playerid, 310.200103, 352.617767, ""); // Descartar
		PlayerTextDrawTextSize(playerid, invBox[playerid][3], 14.000000, 18.000000);
		PlayerTextDrawAlignment(playerid, invBox[playerid][3], 1);
		PlayerTextDrawColor(playerid, invBox[playerid][3], -1);
		PlayerTextDrawSetShadow(playerid, invBox[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, invBox[playerid][3], 5);
		PlayerTextDrawFont(playerid, invBox[playerid][3], 5);
		PlayerTextDrawSetProportional(playerid, invBox[playerid][3], 0);
		PlayerTextDrawSetSelectable(playerid, invBox[playerid][3], true);
		PlayerTextDrawSetPreviewModel(playerid, invBox[playerid][3], 19382);
		PlayerTextDrawSetPreviewRot(playerid, invBox[playerid][3], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	for(new a; a<4; a++)
	{
	PlayerTextDrawShow(playerid,invBox[playerid][a]); }
}
stock NumerosInventario(const string[])
{
	new length = strlen(string);
	if(!length) return false;
	for(new i = 0; i < length; i++)
	{

		if(string[i] > '9' || string[i] <'0') return false;
	}
	return true;
}
stock DiminuirInv(slot,playerid)
{
	if(InventarioInfo[playerid][slot][iUnidades] > 1) return InventarioInfo[playerid][slot][iUnidades] --;
	if(InventarioInfo[playerid][slot][iUnidades] == 1)
	{

		InventarioInfo[playerid][slot][iUnidades]  = 0;
		InventarioInfo[playerid][slot][iSlot] = 19382;
	}
	return 1;
}
stock ZerarInvi(playerid)
{
	for(new i=0; i<17; i++)
	{

		if(InventarioInfo[playerid][i][iUnidades] >= 1)
		{

			InventarioInfo[playerid][i][iUnidades]  = 0;
			InventarioInfo[playerid][i][iSlot] = 19382;
		}
	}
	return 1;
}
stock CriarInventario(playerid){

	format(Erquivo, sizeof Erquivo, "Inventario/%s.ini", Nome(playerid));

	if(!DOF2_FileExists(Erquivo)){

		DOF2_CreateFile(Erquivo);
	}

	new str[22];
	for(new i = 0; i != 75; ++i){

		format(str, sizeof str, "Slot%d", i);
		DOF2_SetInt(Erquivo, str, 19382);
		format(str, sizeof str, "Unidades%d",i);
		DOF2_SetInt(Erquivo, str, 0);
	}
	DOF2_SaveFile();
	return 1;
}
stock CarregarInventario(playerid){

	format(Erquivo, sizeof Erquivo, "Inventario/%s.ini", Nome(playerid));

	if(DOF2_FileExists(Erquivo)){

		new str[22];
		for(new i = 0; i != 75; ++i){

			format(str, sizeof str, "Slot%d", i);
			InventarioInfo[playerid][i][iSlot] = DOF2_GetInt(Erquivo, str);
			format(str, sizeof str, "Unidades%d", i);
			InventarioInfo[playerid][i][iUnidades] = DOF2_GetInt(Erquivo, str);
		}
	}
	return 1;
}
stock SalvarInventario(playerid){

	format(Erquivo, sizeof Erquivo, "Inventario/%s.ini", Nome(playerid));

	new str[22];
	for(new i = 0; i != 75; i++){

		format(str, sizeof str, "Slot%d", i);
		DOF2_SetInt(Erquivo, str, InventarioInfo[playerid][i][iSlot]);
		format(str, sizeof str, "Unidades%d",i);
		DOF2_SetInt(Erquivo, str, InventarioInfo[playerid][i][iUnidades]);
	}
	DOF2_SaveFile();
	return 1;
}
stock SaveWork(playerid){

	format(Erquivo, sizeof Erquivo, "Workbench/%s.ini", Nome(playerid));

	new str[22];
	for(new i = 0; i != 32; i++){

		format(str, sizeof str, "Item_%d", i);
		DOF2_SetInt(Erquivo, str, Dados[playerid][Itwork][i]);
	}
	DOF2_SaveFile();
	return 1;
}
stock LoadWork(playerid){

	format(Erquivo, sizeof Erquivo, "Workbench/%s.ini", Nome(playerid));

	if(DOF2_FileExists(Erquivo)){

		new str[22];
		for(new i = 0; i != 32; i++){
		format(str, sizeof str, "Item_%d", i);
		Dados[playerid][Itwork][i] = DOF2_GetInt(Erquivo, str);
		}
	}
}
stock CreateWork(playerid){

	format(Erquivo, sizeof Erquivo, "Workbench/%s.ini", Nome(playerid));

	if(!DOF2_FileExists(Erquivo)){

		DOF2_CreateFile(Erquivo);
	}

	new str[22];
	for(new i = 0; i != 32; ++i){

		format(str, sizeof str, "Item_%d", i);
		DOF2_SetInt(Erquivo, str, 0);
	}
	DOF2_SaveFile();
	return 1;
}
stock AlinharUseObject(playerid)
{
	if(Ut[playerid][2]) // Está utilizando capacete 1;
	{
		PlayerTextDrawShow(playerid, InUse[playerid][0]);
	}
	if(Ut[playerid][1]) // Está utilizando capacete 2;
	{
		PlayerTextDrawShow(playerid, InUse[playerid][1]);
	}
	if(Ut[playerid][0]) // Está utilizando capacete 3;
	{
		PlayerTextDrawShow(playerid, InUse[playerid][2]);
	}
	if(Ut[playerid][3]) // Está utilizando colete 0
	{
		PlayerTextDrawShow(playerid, InUse[playerid][4]);
	}
	if(Ut[playerid][4]) // Está utilizando colete 1
	{
		PlayerTextDrawShow(playerid, InUse[playerid][5]);
	}
	if(Ut[playerid][5]) // Está utilizando colete 2
	{
		PlayerTextDrawShow(playerid, InUse[playerid][6]);
	}
	if(Ut[playerid][6]) // Está utilizando colete 3
	{
		PlayerTextDrawShow(playerid, InUse[playerid][7]);
	}
	if(Ut[playerid][10]) // Está utilizando chapeu
	{
		PlayerTextDrawShow(playerid, InUse[playerid][3]);
	}
	if(Ut[playerid][7]) // Está utilizando mochila 1
	{
		PlayerTextDrawShow(playerid, InUse[playerid][8]);
	}
	if(Ut[playerid][8]) // Está utilizando mochila 2
	{
		PlayerTextDrawShow(playerid, InUse[playerid][9]);
	}
	if(Ut[playerid][9]) // Está utilizando mochila 3
	{
		PlayerTextDrawShow(playerid, InUse[playerid][10]);
	}
	return 1;
}
stock AbrirInventario(playerid){ //

	if(!IsPlayerInAnyVehicle(playerid)){
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		SetPlayerAttachedObject(playerid, 9, 19559, 5, 0.073999, 0.111999, 0.091000, -152.600006, -2.80008, 121.500045, 1, 1, 1);
	}
	PlayerTextDrawSetPreviewModel(playerid, InvSC[playerid][1], GetPlayerSkin(playerid));
	for(new i; i <7; i++)
	{
	PlayerTextDrawShow(playerid, InvSC[playerid][i]); }
	SelectTextDraw(playerid, 0x00FFFFFF);
	new str[256];
	InventarioAberto[playerid] = 1;
	AlinharUseObject(playerid);
	Atualizar(playerid);
	if(Ut[playerid][7]){ // Mochila 1
		TextDrawShowForPlayer(playerid, FundoInv[2]);
		if(PaginaInventario[playerid] == 1){

			for(new i=0; i < 8; i++){

				if(InventarioInfo[playerid][i][iUnidades] > 0){

					format(str, sizeof str, "%d", InventarioInfo[playerid][i][iUnidades]);
					PlayerTextDrawSetString(playerid, invName[playerid][i], str);
					PlayerTextDrawShow(playerid, invName[playerid][i]);
				}
				PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], InventarioInfo[playerid][i][iSlot]);
				PlayerTextDrawShow(playerid, invPreview[playerid][i]);

				if(InventarioInfo[playerid][i][iSlot] == 19382){

					PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], 19382);
					PlayerTextDrawShow(playerid, invPreview[playerid][i]);
				}
			}
		}
		return 1;
	} //
	if(Ut[playerid][8]){ // Mochila 2
		TextDrawShowForPlayer(playerid, FundoInv[1]);
		if(PaginaInventario[playerid] == 1){

			for(new i=0; i < 12; i++){

				if(InventarioInfo[playerid][i][iUnidades] > 0){

					format(str, sizeof str, "%d", InventarioInfo[playerid][i][iUnidades]);
					PlayerTextDrawSetString(playerid, invName[playerid][i], str);
					PlayerTextDrawShow(playerid, invName[playerid][i]);
				}
				PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], InventarioInfo[playerid][i][iSlot]);
				PlayerTextDrawShow(playerid, invPreview[playerid][i]);

				if(InventarioInfo[playerid][i][iSlot] == 19382){

					PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], 19382);
					PlayerTextDrawShow(playerid, invPreview[playerid][i]);
				}
			}
		}
		return 1;
	} //
	if(Ut[playerid][9]){ // Mochila 3
		TextDrawShowForPlayer(playerid, FundoInv[0]);
		if(PaginaInventario[playerid] == 1){

			for(new i=0; i < 16; i++){

				if(InventarioInfo[playerid][i][iUnidades] > 0){

					format(str, sizeof str, "%d", InventarioInfo[playerid][i][iUnidades]);
					PlayerTextDrawSetString(playerid, invName[playerid][i], str);
					PlayerTextDrawShow(playerid, invName[playerid][i]);
				}
				PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], InventarioInfo[playerid][i][iSlot]);
				PlayerTextDrawShow(playerid, invPreview[playerid][i]);

				if(InventarioInfo[playerid][i][iSlot] == 19382){

					PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], 19382);
					PlayerTextDrawShow(playerid, invPreview[playerid][i]);
				}
			}
		}
		return 1;
	} //
	if(PaginaInventario[playerid] == 1){
		for(new i=0; i < 4; i++){
			TextDrawShowForPlayer(playerid, FundoInv[3]);
			if(InventarioInfo[playerid][i][iUnidades] > 0)
			{

				format(str, sizeof str, "%d", InventarioInfo[playerid][i][iUnidades]);
				PlayerTextDrawSetString(playerid, invName[playerid][i], str);
				PlayerTextDrawShow(playerid, invName[playerid][i]);
			}
			PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], InventarioInfo[playerid][i][iSlot]);
			PlayerTextDrawShow(playerid, invPreview[playerid][i]);

			if(InventarioInfo[playerid][i][iSlot] == 19382)
			{
				PlayerTextDrawSetPreviewModel(playerid, invPreview[playerid][i], 19382);
				PlayerTextDrawShow(playerid, invPreview[playerid][i]);
			}
		}
	}
	return 1;
}
stock WorkOpen(playerid)
{
	SelectTextDraw(playerid, 0x00FFFFFF);
	for(new i=0; i < 19; i++){
	PlayerTextDrawShow(playerid, Workbench[playerid][i]); }
	PlayerTextDrawHide(playerid, Workbench[playerid][3]); // Production
	new str[48];
	format(str, sizeof str, "%d", Dados[playerid][points]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][6], str);
	PlayerTextDrawShow(playerid, Reqn[playerid][6]); // Points
	TextDrawShowForPlayer(playerid, PublicTD[0]); // Menu projeto fundo
	PlayerTextDrawShow(playerid, pag2[playerid][0]); // Button
	PaginaWork[playerid] = 1;
}
stock WorkClose(playerid)
{
	SelectTextDraw(playerid, 0xCD0400FF);
	TextDrawHideForPlayer(playerid, PublicTD[0]);
	for(new m=0; m < 32; m++) {
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	CancelSelectTextDraw(playerid);
	for(new i=0; i < 19; i++){
	PlayerTextDrawHide(playerid, Workbench[playerid][i]); }
	for(new q=0; q < 7; q++){
	PlayerTextDrawHide(playerid, Reqn[playerid][q]); }
	PlayerTextDrawHide(playerid, Desbloq[playerid][0]);
}
stock TacoOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[0]); // Abrir menu lucile

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][0])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][0] = 1;
	}
	if(Dados[playerid][Itwork][0])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][0] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19793)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock BandageOpen(playerid) // Etapa 4
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0;}
	TextDrawShowForPlayer(playerid, TacTD[1]); // Abrir menu bandage

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][1])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][1] = 1;
	}
	if(Dados[playerid][Itwork][1])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][1] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 1509)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1241)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock KitOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[2]); // Abrir menu kit

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][2])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][3] = 1;
	}
	if(Dados[playerid][Itwork][2])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][2] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 2749)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock ExplosivoOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[3]); // Abrir menu explosivo

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][3])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][3] = 1;
	}
	if(Dados[playerid][Itwork][3])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][3] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 3; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock RadioOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[4]); // Abrir menu radio

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][4])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][4] = 1;
	}
	if(Dados[playerid][Itwork][4])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][4] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 18875)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 3; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Capa1Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[5]); // Abrir menu capa1

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][5])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][5] = 1;
	}
	if(Dados[playerid][Itwork][5])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][5] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 3; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Capa2Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[6]); // Abrir menu capa2

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][6])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][6] = 1;
	}
	if(Dados[playerid][Itwork][6])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][6] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 3; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Capa3Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[7]); // Abrir menu capa3

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][7])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][7] = 1;
	}
	if(Dados[playerid][Itwork][7])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][7] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 3; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/6", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/6", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock ChapeuOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[8]); // Abrir menu chapeu

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][8])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][8] = 1;
	}
	if(Dados[playerid][Itwork][8])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][8] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Mochila1Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[9]); // Abrir menu mochila1

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][9])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][9] = 1;
	}
	if(Dados[playerid][Itwork][9])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][9] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19088)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/4", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Colete2Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[14]); // Coelte2

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][10])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][10] = 1;
	}
	if(Dados[playerid][Itwork][10])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][10] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 4; q++){
	format(string, sizeof (string), "%d/4", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Colete3Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[15]); // Coelte3

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][11])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][11] = 1;
	}
	if(Dados[playerid][Itwork][11])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][11] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 4; q++){
	format(string, sizeof (string), "%d/6", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/12", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/6", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/12", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Colete0Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[12]); // Coelte0

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][12])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][12] = 1;
	}
	if(Dados[playerid][Itwork][12])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][12] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 4; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Colete1Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[13]); // Coelte1

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][13])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][13] = 1;
	}
	if(Dados[playerid][Itwork][13])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][13] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 4; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Mochila2Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[10]); // MOchila2

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][14])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][14] = 1;
	}
	if(Dados[playerid][Itwork][14])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][14] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19088)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/6", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock Mochila3Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[11]); // MOchila3

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][15])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][15] = 1;
	}
	if(Dados[playerid][Itwork][15])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][15] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 11747)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19088)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 2; q++){
	format(string, sizeof (string), "%d/12", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock GPSOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[28]); // GPS

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][16])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][16] = 1;
	}
	if(Dados[playerid][Itwork][16])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][16] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 18875)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 3; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock FogueiraOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[30]); // Fogueira

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][17])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][17] = 1;
	}
	if(Dados[playerid][Itwork][17])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][17] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19793)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 1; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock GlockOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[29]); // Glock

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][18])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][18] = 1;
	}
	if(Dados[playerid][Itwork][18])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][18] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock RevolverOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[21]); // Revolver

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][19])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][19] = 1;
	}
	if(Dados[playerid][Itwork][19])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][19] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock SilenceOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[18]); // Silence

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][20])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][20] = 1;
	}
	if(Dados[playerid][Itwork][20])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][20] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock ParabellumOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[23]); // Parabellum

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][21])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][21] = 1;
	}
	if(Dados[playerid][Itwork][21])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][21] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/1", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock ShotgunOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[19]); // Shotgun

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][22])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][22] = 1;
	}
	if(Dados[playerid][Itwork][22])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][22] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock RifleOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[20]); // Rifle

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][23])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][23] = 1;
	}
	if(Dados[playerid][Itwork][23])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][23] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock MP5Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[17]); // MP5

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][24])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][24] = 1;
	}
	if(Dados[playerid][Itwork][24])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][24] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/12", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock AK47Open(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[31]); // AK47

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][25])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][25] = 1;
	}
	if(Dados[playerid][Itwork][25])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][25] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/15", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock SniperOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[24]); // Sniper

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][26])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][26] = 1;
	}
	if(Dados[playerid][Itwork][26])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][26] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 3082)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2006)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 921)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/20", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock MotoOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[26]); // Moto

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][27])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][27] = 1;
	}
	if(Dados[playerid][Itwork][27])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][27] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 915)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19917)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/2", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/120", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/20", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/8", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock BobCatOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[16]); // BobCat

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][28])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][28] = 1;
	}
	if(Dados[playerid][Itwork][28])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][28] = 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 915)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19917)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/4", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/150", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/45", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/12", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock JeepOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
    TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[25]); // Jeep

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][29])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][29] = 1;
	}
	if(Dados[playerid][Itwork][29])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][29]= 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 915)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19917)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/4", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/120", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/45", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/12", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/4", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock PatriotOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[22]); // Patriot

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][30])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][30] = 1;
	}
	if(Dados[playerid][Itwork][30])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][30]= 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 915)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19917)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/8", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/200", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/60", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/16", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/6", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/1", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock HeliOpen(playerid)
{
	new string[48];
	PlayerTextDrawShow(playerid, Workbench[playerid][3]); // Button produção.
	for(new m=0; m < 32; m++) { // Fechar menus abertos
	TextDrawHideForPlayer(playerid, TacTD[m]); }
	TextDrawHideForPlayer(playerid, oc[0]);
	TextDrawHideForPlayer(playerid, oc[1]);
	for(new e; e<6; e++) {
	Cont[playerid][e] = 0; }
	TextDrawShowForPlayer(playerid, TacTD[27]); // Heli

	// • Button desbloquear •
	if(!Dados[playerid][Itwork][31])
	{
		TextDrawShowForPlayer(playerid, oc[0]); // Closet or Open (Falta IF)
		PlayerTextDrawShow(playerid, Desbloq[playerid][0]); // Button
		tipitem[playerid][31] = 1;
	}
	if(Dados[playerid][Itwork][31])
	{
		TextDrawShowForPlayer(playerid, oc[1]); // Closet or Open (Falta IF)
		tipitem[playerid][31]= 2;
	}
	for(new i; i<17; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 915)
		 {
			Cont[playerid][0] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 1510)
		 {
			Cont[playerid][1] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19843)
		 {
			Cont[playerid][2] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 2945)
		 {
			Cont[playerid][3] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19627)
		 {
			Cont[playerid][4] = InventarioInfo[playerid][i][iUnidades];
		 }
		 if(InventarioInfo[playerid][i][iSlot] == 19917)
		 {
			Cont[playerid][5] = InventarioInfo[playerid][i][iUnidades];
		 }
	}
	// • Requisitos •
	for(new s=0; s < 6; s++){
	PlayerTextDrawHide(playerid, Reqn[playerid][s]); }
	for(new q=0; q < 6; q++){
	format(string, sizeof (string), "%d/16", Cont[playerid][0]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][0], string);
	format(string, sizeof (string), "%d/400", Cont[playerid][1]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][1], string);
	format(string, sizeof (string), "%d/80", Cont[playerid][2]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][2], string);
	format(string, sizeof (string), "%d/25", Cont[playerid][3]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][3], string);
	format(string, sizeof (string), "%d/15", Cont[playerid][4]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][4], string);
	format(string, sizeof (string), "%d/2", Cont[playerid][5]);
	PlayerTextDrawSetString(playerid, Reqn[playerid][5], string);
	PlayerTextDrawShow(playerid, Reqn[playerid][q]); }
}
stock CreateDroppedItem(Item, Amount, Float:gPosX, Float:gPosY, Float:gPosZ)
{
	new f = MAX_OBJ+1;
	for(new a = 0; a < MAX_OBJ; a++)
	{

		if(dItemData[a][ObjtPos][0] == 0.0)
		{

			f = a;
			break;
		}
	}
	if(f > MAX_OBJ) return;

	dItemData[f][droptTimer] = gettime() + (30*60);//30 minutos para o item sumir

	dItemData[f][ObjtData][0] = Item;
	dItemData[f][ObjtData][1] = Amount;
	dItemData[f][ObjtPos][0] = gPosX;
	dItemData[f][ObjtPos][1] = gPosY;
	dItemData[f][ObjtPos][2] = gPosZ;
	dItemData[f][ObjtID] = CreateDynamicObject(Item, dItemData[f][ObjtPos][0], dItemData[f][ObjtPos][1], dItemData[f][ObjtPos][2]-1, 93.7, 120.0, random(360), -1, -1, -1, 80.0);

	new buffer[50];
	/*format(buffer, sizeof buffer, "Item: %s\nUnidade(s): %d", NomeItemInventario(dItemData[f][ObjtData][0]), dItemData[f][ObjtData][1]);
	dItemData[f][textt3d] = CreateDynamic3DTextLabel(buffer, 0xAAAAAAAA, dItemData[f][ObjtPos][0], dItemData[f][ObjtPos][1], dItemData[f][ObjtPos][2]-1, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 80.0);*/
	format(buffer, sizeof buffer, "%s", NomeItemInventario(dItemData[f][ObjtData][0]));
	dItemData[f][textt3d] = CreateDynamic3DTextLabel(buffer, 0xAAAAAAAA, dItemData[f][ObjtPos][0], dItemData[f][ObjtPos][1], dItemData[f][ObjtPos][2]-1, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 80.0);

	return;
}
stock DestroyDroppedItem(dropid)
{
	DestroyDynamicObject(dItemData[dropid][ObjtID]);
	DestroyDynamic3DTextLabel(dItemData[dropid][textt3d]);
	dItemData[dropid][ObjtPos][0] = 0.0;
	dItemData[dropid][ObjtPos][1] = 0.0;
	dItemData[dropid][ObjtPos][2] = 0.0;
	dItemData[dropid][ObjtID] = -1;
	//dGunData[f][ObjData][0] = 0;
	dItemData[dropid][ObjtData][1] = 0;

	return 1;
}
stock FecharInventario(playerid){

	if(!IsPlayerInAnyVehicle(playerid)) ClearAnimations(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
	InventarioAberto[playerid] = 0;
	for(new i = 0; i != 16; i++){

		PlayerTextDrawHide(playerid, invPreview[playerid][i]);
		PlayerTextDrawHide(playerid, invName[playerid][i]);
	}
	
	for(new j = 0; j != 7; j++){
	PlayerTextDrawHide(playerid, InvSC[playerid][j]);
	}
	
	for(new a; a < 4; a ++){
	TextDrawHideForPlayer(playerid, FundoInv[a]);
	}
	Atualizar(playerid);
	return 1;
}
stock NomeItemInventario(idx)
{
	new nomedoitem[100];
	format( nomedoitem, 100, "Desconhecido");
	if(idx == ITEM_DINHEIRO) format(nomedoitem, 50, "Dinheiro");
	if(idx == ITEM_CHAVEIRO) format(nomedoitem, 50, "Chaveiro");
	if(idx == CAVALO) format ( nomedoitem, 50, "Cavalo");
	if(idx == 19142) format( nomedoitem, 50, "Colete III");
	if(idx == 373) format( nomedoitem, 50, "Colete II");
	if(idx == 19515) format( nomedoitem, 50, "Colete I");
	if(idx == 19904) format( nomedoitem, 50, "Colete");
	if(idx == 19141) format( nomedoitem, 50, "Capacete 3");
	if(idx == 19514) format( nomedoitem, 50, "Capacete 2");
	if(idx == 19101) format( nomedoitem, 50, "Capacete 1");
	if(idx == 19100) format( nomedoitem, 50, "Chapeu");
	if(idx == 371) format( nomedoitem, 50, "Mochila 3");
	if(idx == 3026) format( nomedoitem, 50, "Mochila 2");
	if(idx == 19559) format( nomedoitem, 50, "Mochila 1");
	if(idx == 2966) format( nomedoitem, 50, "Radio");
	if(idx == 1654) format( nomedoitem, 50, "C4");
	if(idx == 2752) format( nomedoitem, 50, "Bandage");
	if(idx == 11738) format( nomedoitem, 50, "KitMed");
	if(idx == 18868) format( nomedoitem, 50, "GPS");
	if(idx == 19632) format( nomedoitem, 50, "Fogueira");
	// IDX DE REQUISITOS
	if(idx == 915) format( nomedoitem, 50, "Ventoinhas");
	if(idx == 921) format( nomedoitem, 50, "Arame");
	if(idx == 1083) format( nomedoitem, 50, "Pneu");
	if(idx == 1241) format( nomedoitem, 50, "Comprimidos");
	if(idx == 1509) format( nomedoitem, 50, "Álcool");
	if(idx == 1510) format( nomedoitem, 50, "Porcas");
	if(idx == 2006) format( nomedoitem, 50, "Fita");
	if(idx == 2798) format( nomedoitem, 50, "Manivela");
	if(idx == 2945) format( nomedoitem, 50, "Fios");
	if(idx == 3082) format( nomedoitem, 50, "Pólvora");
	if(idx == 18633) format( nomedoitem, 50, "Chave de Roda");
	if(idx == 18635) format( nomedoitem, 50, "Martelo");
	if(idx == 18875) format( nomedoitem, 50, "Batéria");
	if(idx == 19088) format( nomedoitem, 50, "Cordas");
	if(idx == 19627) format( nomedoitem, 50, "Chave Inglêsa");
	if(idx == 19793) format( nomedoitem, 50, "Madeira");
	if(idx == 19843) format( nomedoitem, 50, "Sucata");
	if(idx == 19917) format( nomedoitem, 50, "Motor");
	if(idx == 11747) format( nomedoitem, 50, "Pano");
	// Modelo adicionar item:
	// 	if(idx == id) format( nomedoitem, 50, "nome");
	if(idx == 19382) format( nomedoitem, 50, "Nenhum Item");
	if(idx > 0 && idx < 312 && idx != 6) format( nomedoitem, 50, "Roupa %d",idx); // se for skin
	if(idx > 399 && idx < 612 ) format( nomedoitem, 50, "%s",vNames[idx - 400]); //  se for veiculo
	if(idx >= 331 && idx < 372) format( nomedoitem, 50, NomeArmaInventario(idx)); // se for arma

	return nomedoitem;
}

stock NomeItemInventarioInventario(id,playerid){

	new str[100];
	new idx = InventarioInfo[playerid][id][iSlot];
	format(str,100,NomeItemInventario(idx));
	return str;
}
stock NomeArmaInventario(weaponid)
{
	new str[30];
	if(weaponid == 0) str = "Soco";
	if(weaponid == 1 || weaponid == 331) str = "Soqueira";
	if(weaponid == 2 || weaponid == 333) str = "Taco de Golf";
	if(weaponid == 3 || weaponid == 334) str = "Cacetete";
	if(weaponid == 4 || weaponid == 335) str = "Knife";
	if(weaponid == 5 || weaponid == 336) str = "Taco com Arames";
	if(weaponid == 6 || weaponid == 337) str = "Pá";
	if(weaponid == 7 || weaponid == 338) str = "Taco de Sinuca";
	if(weaponid == 8 || weaponid == 339) str = "Katana";
	if(weaponid == 9 || weaponid == 341) str = "Motocerra";
	if(weaponid == 10 || weaponid == 321) str = "Dildo Roxo";
	if(weaponid == 11 || weaponid == 322) str = "Dildo Vibrador";
	if(weaponid == 12 || weaponid == 323) str = "Dildo Branco";
	if(weaponid == 13 || weaponid == 324) str = "Dildo Elétrico";
	if(weaponid == 14 || weaponid == 325) str = "Buque de Flores";
	if(weaponid == 15 || weaponid == 326) str = "Bengala";
	if(weaponid == 16 || weaponid == 342) str = "Granada Expansiva";
	if(weaponid == 17 || weaponid == 343) str = "Granada de Gás";
	if(weaponid == 18 || weaponid == 344) str = "Coquetel Molotov";
	if(weaponid == 22 || weaponid == 346) str = "Parabellum";
	if(weaponid == 23 || weaponid == 347) str = "Pistola com Silenciador";
	if(weaponid == 24 || weaponid == 348) str = "Revólver";
	if(weaponid == 25 || weaponid == 349) str = "Shotgun";
	if(weaponid == 26 || weaponid == 350) str = "Sawn-Off 12";
	if(weaponid == 27 || weaponid == 351) str = "12 Automatica";
	if(weaponid == 28 || weaponid == 352) str = "Micro-SMG";
	if(weaponid == 29 || weaponid == 353) str = "SMG";
	if(weaponid == 30 || weaponid == 355) str = "AR15";
	if(weaponid == 31 || weaponid == 356) str = "M4";
	if(weaponid == 32 || weaponid == 372) str = "Glock";
	if(weaponid == 33 || weaponid == 357) str = "Rifle .30";
	if(weaponid == 34 || weaponid == 358) str = "MTR";
	if(weaponid == 35 || weaponid == 359) str = "Bazooka";
	if(weaponid == 36 || weaponid == 360) str = "Bazooka HS";
	if(weaponid == 37 || weaponid == 361) str = "Lança-Chamas";
	if(weaponid == 38 || weaponid == 362) str = "Minigun";
	if(weaponid == 39 || weaponid == 363) str = "Explosivo Remoto";
	if(weaponid == 40 || weaponid == 364) str = "controle Remoto";
	if(weaponid == 41 || weaponid == 365) str = "Lata de Spray";
	if(weaponid == 42 || weaponid == 366) str = "Fire Extinguisher";
	if(weaponid == 43 || weaponid == 367) str = "Camera";
	if(weaponid == 44 || weaponid == 368) str = "Oculos Noturno";
	if(weaponid == 45 || weaponid == 369) str = "Oculos Termico";
	if(weaponid == 46 || weaponid == 371) str = "Paraquedas";
	return str;
}
stock MudarIdArma(weaponid)
{
	new var;

	if(weaponid == 1)  var = 331 ;
	if(weaponid == 2)  var = 333 ;
	if(weaponid == 3)  var = 334 ;
	if(weaponid == 4)  var = 335 ;
	if(weaponid == 5)  var = 336 ;
	if(weaponid == 6)  var = 337 ;
	if(weaponid == 7)  var = 338;
	if(weaponid == 8)  var = 339 ;
	if(weaponid == 9)  var = 341 ;
	if(weaponid == 10)  var = 321 ;
	if(weaponid == 11)  var = 322 ;
	if(weaponid == 12 ) var = 323 ;
	if(weaponid == 13)  var = 324 ;
	if(weaponid == 14 ) var = 325 ;
	if(weaponid == 15)  var = 326 ;
	if(weaponid == 16)  var = 342 ;
	if(weaponid == 17)  var = 343 ;
	if(weaponid == 18)  var = 344 ;
	if(weaponid == 22)  var = 346 ;
	if(weaponid == 23)  var = 347 ;
	if(weaponid == 24 ) var = 348 ;
	if(weaponid == 25)  var = 349 ;
	if(weaponid == 26)  var = 350 ;
	if(weaponid == 27)  var = 351 ;
	if(weaponid == 28)  var = 352 ;
	if(weaponid == 29)  var = 353 ;
	if(weaponid == 30 ) var = 355 ;
	if(weaponid == 31)  var = 356 ;
	if(weaponid == 32)  var = 372 ;
	if(weaponid == 33)  var = 357 ;
	if(weaponid == 34)  var = 358 ;
	if(weaponid == 35)  var = 359 ;
	if(weaponid == 36)  var = 360 ;
	if(weaponid == 37)  var = 361 ;
	if(weaponid == 38)  var = 362 ;
	if(weaponid == 39)  var = 363 ;
	if(weaponid == 40) var = 364 ;
	if(weaponid == 41)  var = 365 ;
	if(weaponid == 42)  var = 366 ;
	if(weaponid == 43)  var = 367 ;
	if(weaponid == 44)  var = 368 ;
	if(weaponid == 45)  var = 369 ;
	if(weaponid == 46)  var = 371 ;
	if(weaponid == 331)  var = 1 ;
	if(weaponid == 333)  var = 2 ;
	if(weaponid == 334)  var = 3 ;
	if(weaponid == 335)  var = 4 ;
	if(weaponid == 336)  var = 5 ;
	if(weaponid == 337)  var = 6 ;
	if(weaponid == 338)  var = 7;
	if(weaponid == 339)  var = 8 ;
	if(weaponid == 341)  var = 9 ;
	if(weaponid == 321)  var = 10 ;
	if(weaponid == 322)  var = 11 ;
	if(weaponid == 323 ) var = 12 ;
	if(weaponid == 324)  var = 13 ;
	if(weaponid == 325 ) var = 14 ;
	if(weaponid == 326)  var = 15 ;
	if(weaponid == 342)  var = 16 ;
	if(weaponid == 343)  var = 17 ;
	if(weaponid == 344)  var = 18 ;
	if(weaponid == 346)  var = 22 ;
	if(weaponid == 347)  var = 23 ;
	if(weaponid == 348 ) var = 24 ;
	if(weaponid == 349)  var = 25 ;
	if(weaponid == 350)  var = 26 ;
	if(weaponid == 351)  var = 27 ;
	if(weaponid == 352)  var = 28 ;
	if(weaponid == 353)  var = 29 ;
	if(weaponid == 355 ) var = 30 ;
	if(weaponid == 356)  var = 31 ;
	if(weaponid == 372)  var = 32 ;
	if(weaponid == 357)  var = 33 ;
	if(weaponid == 358)  var = 34 ;
	if(weaponid == 359)  var = 35 ;
	if(weaponid == 360)  var = 36 ;
	if(weaponid == 361)  var = 37 ;
	if(weaponid == 362)  var = 38 ;
	if(weaponid == 363)  var = 39 ;
	if(weaponid == 364) var = 40;
	if(weaponid == 365)  var = 41 ;
	if(weaponid == 366)  var = 42 ;
	if(weaponid == 367)  var = 43 ;
	if(weaponid == 368)  var = 44 ;
	if(weaponid == 369)  var = 45 ;
	if(weaponid == 371)  var = 46 ;
	return var;
}

stock DiminuirInventario(slot, playerid)
{
	if(InventarioInfo[playerid][slot][iUnidades] > 1) return InventarioInfo[playerid][slot][iUnidades] --;

	if(InventarioInfo[playerid][slot][iUnidades] == 1){

		InventarioInfo[playerid][slot][iUnidades] = 0;
		InventarioInfo[playerid][slot][iSlot] = 19382;
	}
	return 1;
}

stock bool:CriarItem(playerid, item, quantidade)
{
	for(new i=0; i<15; i++)
	{
		if(InventarioInfo[playerid][i][iSlot] == 19382)
		{
			InventarioInfo[playerid][i][iSlot] = item;
			InventarioInfo[playerid][i][iUnidades] = quantidade;
			return true;
		}
	}

	return false;
}

stock VerificarRadares(playerid, vehicleid)
{
	new bool:dentroAlgumRadar = false;

	for(new i=0; i < sizeof(Radares); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, Radares[i][Range], Radares[i][PosX], Radares[i][PosY], Radares[i][PosZ]))
		{
			dentroAlgumRadar = true;
			if(GetVehicleSpeed(vehicleid) > Radares[i][VelMax] && !dentroRadar[playerid])
			{
				SendClientMessage(playerid, COR_ERRO, "Você ultrapassou a velocidade máxima permitida!");
				dentroRadar[playerid] = true;
			}
		}
	}

	if (!dentroAlgumRadar) dentroRadar[playerid] = false;
}

stock VerChaveiro(playerid, chaveiroid)
{
	new string[5000], bool:hasChave=false;
	format(string, sizeof(string), "");
	for(new i=0; i < MAX_CHAVES; i++)
	{
		if(Chaveiros[chaveiroid][i][idC] != SEM_CHAVE)
		{
			hasChave = true;
			format(string, sizeof(string), "%sChave %s [%d] - Modelo %d\n", string, TipoChave[Chaveiros[chaveiroid][i][tipoC]], Chaveiros[chaveiroid][i][idC], Chaveiros[chaveiroid][i][modeloC]);
		}
	}
	if(!hasChave) format(string, sizeof(string), "Chaveiro Vazio");
	ShowPlayerDialog(playerid, DIALOG_VER_CHAVEIRO, DIALOG_STYLE_LIST, "Chaveiro", string, "Fechar", "Teste");
}

stock PlayerHasChave(playerid, tipo, chaveid, modelo)
{
	new hasChave, result;
	for(new i=0; i<15; i++)
	{
		if(InventarioInfo[playerid][i][iSlot] == ITEM_CHAVEIRO)
		{
			result = ChaveiroHasChave(InventarioInfo[playerid][i][iUnidades], tipo, chaveid, modelo);
			if(result)
			{
				hasChave = result;
				if(hasChave == 1) break;
			}
		}
	}

	return hasChave;
}

stock ChaveiroHasChave(chaveiroid, tipo, chaveid, modelo)
{
	/*
		return 0: NÃO TEM CHAVE
		return 1: TEM CHAVE DA MESMA MODELO
		return -1: TEM CHAVE DE MODELO DIFERENTE
	*/
	new hasChave=0;
	for(new i=0; i < MAX_CHAVES; i++)
	{
		if(Chaveiros[chaveiroid][i][idC] != SEM_CHAVE && Chaveiros[chaveiroid][i][tipoC] == tipo)
		{
			if(Chaveiros[chaveiroid][i][idC] == chaveid)
			{
				if(Chaveiros[chaveiroid][i][modeloC] == modelo)
				{
					hasChave = 1;
					break;
				}
				else hasChave = -1;
			}
		}
	}

	return hasChave;
}

stock SalvarChaveiro(chaveiroid)
{
	new stringChaveiro[128], stringChave[128];
	format(stringChaveiro, sizeof(stringChaveiro), PASTA_CHAVEIROS, chaveiroid);

	if(!DOF2_FileExists(stringChaveiro)) DOF2_CreateFile(stringChaveiro);

	for(new i=0; i < MAX_CHAVES; i++)
	{
		format(stringChave, sizeof(stringChave), "chave-%d-tipo", i);
		DOF2_SetInt(stringChaveiro, stringChave, Chaveiros[chaveiroid][i][tipoC]);
		format(stringChave, sizeof(stringChave), "chave-%d-id", i);
		DOF2_SetInt(stringChaveiro, stringChave, Chaveiros[chaveiroid][i][idC]);
		format(stringChave, sizeof(stringChave), "chave-%d-modelo", i);
		DOF2_SetInt(stringChaveiro, stringChave, Chaveiros[chaveiroid][i][modeloC]);
	}

	DOF2_SaveFile();
}

stock CarregarChaveiros()
{
	new stringChaveiro[128], stringChave[128];

	for (new i=0; i < MAX_CHAVEIROS; i++)
	{
		format(stringChaveiro, sizeof(stringChaveiro), PASTA_CHAVEIROS, i);
		for (new j=0; j < MAX_CHAVES; j++)
		{
			if(DOF2_FileExists(stringChaveiro))
			{
				format(stringChave, sizeof(stringChave), "chave-%d-tipo", j);
				Chaveiros[i][j][tipoC] = DOF2_GetInt(stringChaveiro, stringChave);
				format(stringChave, sizeof(stringChave), "chave-%d-id", j);
				Chaveiros[i][j][idC] = DOF2_GetInt(stringChaveiro, stringChave);
				format(stringChave, sizeof(stringChave), "chave-%d-modelo", j);
				Chaveiros[i][j][modeloC] = DOF2_GetInt(stringChaveiro, stringChave);
			}
			else
			{
				Chaveiros[i][j][tipoC] = SEM_CHAVE;
				Chaveiros[i][j][idC] = SEM_CHAVE;
				Chaveiros[i][j][modeloC] = SEM_CHAVE;
			}
		}
	}
}

stock CriarChaveiro(playerid)
{
	if(!DOF2_FileExists(PASTA_CONTADOR_CHAVEIROS)) DOF2_CreateFile(PASTA_CONTADOR_CHAVEIROS);
	if(!DOF2_IsSet(PASTA_CONTADOR_CHAVEIROS, "Quantidade")) DOF2_SetInt(PASTA_CONTADOR_CHAVEIROS, "Quantidade", 1);

	new chaveiroid = DOF2_GetInt(PASTA_CONTADOR_CHAVEIROS, "Quantidade"); // id DOF2

	new bool:criouItem = CriarItem(playerid, ITEM_CHAVEIRO, chaveiroid);

	if(criouItem)
	{
		DOF2_SetInt(PASTA_CONTADOR_CHAVEIROS, "Quantidade", chaveiroid+1);

		new stringChaveiro[128];
		format(stringChaveiro, sizeof(stringChaveiro), PASTA_CHAVEIROS, chaveiroid);

		DOF2_CreateFile(stringChaveiro);
		DOF2_SaveFile();

		return chaveiroid;
	}

	return 0;
}
stock bool:CriarChave(chaveiroid, tipo, chaveid, modelo)
{
	for (new i=0; i < MAX_CHAVES; i++)
	{
		if (Chaveiros[chaveiroid][i][idC] == SEM_CHAVE)
		{
			Chaveiros[chaveiroid][i][tipoC] = tipo;
			Chaveiros[chaveiroid][i][idC] = chaveid;
			Chaveiros[chaveiroid][i][modeloC] = modelo;
			return true;
		}
	}
	return false;
}

stock CarregarCarros()
{
	new stringCarro[128];
	new Lataria;
	new carrosCriados = DOF2_GetInt(PASTA_CONTADOR_CARROS, "Quantidade");

	for (new i=1; i < carrosCriados; i++)
	{
		format(stringCarro, sizeof(stringCarro), PASTA_CARROS, i);
		Veiculos[i][idCar] = i;
		Veiculos[i][modeloCar] = DOF2_GetInt(stringCarro, "Modelo");
		// Veiculos[i][latariaCar] = DOF2_GetInt(stringCarro, "Modelo");
		// Veiculos[i][blindagemCar] = DOF2_GetInt(stringCarro, "Modelo");
		Veiculos[i][corCar][0] = DOF2_GetInt(stringCarro, "Cor1");
		Veiculos[i][corCar][1] = DOF2_GetInt(stringCarro, "Cor2");
		Veiculos[i][posCar][0] = DOF2_GetFloat(stringCarro, "PosX");
		Veiculos[i][posCar][1] = DOF2_GetFloat(stringCarro, "PosY");
		Veiculos[i][posCar][2] = DOF2_GetFloat(stringCarro, "PosZ");
		Veiculos[i][posCar][3] = DOF2_GetFloat(stringCarro, "Rotation");
		Lataria = DOF2_GetInt(stringCarro, "Saude");
		format(Veiculos[i][placaCar], 9, "%s", DOF2_GetString(stringCarro, "Placa"));

		CreateVehicle(Veiculos[i][modeloCar], Veiculos[i][posCar][0], Veiculos[i][posCar][1], Veiculos[i][posCar][2], Veiculos[i][posCar][3], Veiculos[i][corCar][0], Veiculos[i][corCar][1], -1, 0);
		SetVehicleNumberPlate(i, Veiculos[i][placaCar]);
		SetVehicleToRespawn(i);
		SetVehicleHealth(i, Lataria);
	}
}
// ANIMAIS
public CreateNPC()
{
		new name[MAX_PLAYER_NAME + 1];
		format(name, sizeof(name), "Animal_%d", gNpcCount);

		new npcid = FCNPC_Create(name);
		Dados[npcid][Animal] = 1;
		gNpc[npcid][E_MOVE_STAGE] = 0;
		gNpc[npcid][E_VALID] = true;

		new SpawnRandom = random(sizeof(gSpawns));
	    SetTimerEx("PegarProx", 500, 1, "i", npcid); // Ativando medo nos animais.
		FCNPC_Spawn(npcid, 206, gSpawns[SpawnRandom][0], gSpawns[SpawnRandom][1], gSpawns[SpawnRandom][2]);
		FCNPC_SetHealth(npcid, 9999);
		gNpcCount++;
}
public CreateZo()
{
	 	new zombie[MAX_PLAYER_NAME + 1];
		format(zombie, sizeof(zombie), "Zombie_%d", zNpcCount);
		new npcz = FCNPC_Create(zombie);
		gNpc[npcz][E_MOVE_STAGE] = 0;
		gNpc[npcz][E_VALID] = true;
		Dados[npcz][Zombie] = 1;
		Dados[npcz][mZombie] = 0;

        new SpawnRandom = random(sizeof(ZPos));
        new ZSkin = random(11);
        new Meler;
        if(ZSkin == 0) { Meler = 10; }
        if(ZSkin == 1) { Meler = 31; }
        if(ZSkin == 2) { Meler = 39; }
        if(ZSkin == 3) { Meler = 53; }
        if(ZSkin == 4) { Meler = 54; }
        if(ZSkin == 5) { Meler = 129; }
        if(ZSkin == 6) { Meler = 130; }
        if(ZSkin == 7) { Meler = 134; }
        if(ZSkin == 8) { Meler = 160; }
        if(ZSkin == 9) { Meler = 162; }
        if(ZSkin == 10) { Meler = 196; }
        if(ZSkin == 11) { Meler = 197; }
		SetTimerEx("PegarProx", 500, 1, "i", npcz); // Ativando zombies
		FCNPC_Spawn(npcz, Meler, ZPos[SpawnRandom][0], ZPos[SpawnRandom][1], ZPos[SpawnRandom][2]);
		FCNPC_SetHealth(npcz, 9999);
		zNpcCount++;
}
forward StopLoot(playerid);
public StopLoot(playerid)
{
	new Meler[148];
	new Loot = random(3);
	if(Loot == 0) { Meler = "Pano"; }
	if(Loot == 1) { Meler = "Cordas"; }
	if(Loot == 2) { Meler = "Fios"; }
	//
	new msg[144];
	format(msg, sizeof(msg), "Você achou um(a) %s no loot.", Meler);
	SendClientMessage(playerid,-1, msg);
	ApplyAnimation(playerid,"PED","SHOT_partial_B",4.1,0,1,1,1,1);
	Dados[playerid][Follow] = 0;
}
public FCNPC_OnDeath(npcid, killerid, reason)
{
	if (!gNpc[npcid][E_VALID]) {
		return 1;
	}

	new name[MAX_PLAYER_NAME + 1];
	GetPlayerName(killerid, name, sizeof(name));

	new msg[144];
 	format(msg, sizeof(msg), "NPC %d for morto por %d (%s) com a arma %d.", npcid, killerid, name, reason);
 	SendClientMessage(killerid,-1, msg);
 	SetTimerEx("DestroyNPC", 1500, 0, "i", npcid);

 	return 1;
}
public FCNPC_OnUpdate(npcid)
{
    FCNPC_GetPosition(npcid, PosBot[0][npcid], PosBot[1][npcid], PosBot[2][npcid]);
	MapAndreas_FindZ_For2DCoord(PosBot[0][npcid], PosBot[1][npcid], PosBot[2][npcid]);
	//
    FCNPC_SetPosition(npcid, PosBot[0][npcid], PosBot[1][npcid], PosBot[2][npcid]+1);
	return 1;
}
public DestroyNPC(npcid)
{
 	FCNPC_Destroy(npcid);
 	//
	gNpc[npcid][E_VALID] = false;
	SetTimer("CreateNPC", 3000, 0); // Animal morreu, tempo para voltar.
}
public DestroyZo(npcid)
{
 	FCNPC_Destroy(npcid);
 	//
	gNpc[npcid][E_VALID] = false;
	SetTimer("CreateZo", 3000, 0); // Zombie morreu, tempo para voltar.
}
public FCNPC_OnSpawn(npcid)
{
	if (!gNpc[npcid][E_VALID]) {
		return 1;
	}

	// Move the NPC
	MoveNPCc(npcid);
	return 1;
}

public FCNPC_OnReachDestination(npcid) // Chegou no destino.
{
	if (!gNpc[npcid][E_VALID]) {
		return 1;
	}

	gNpc[npcid][E_MOVE_STAGE]++;
	if (gNpc[npcid][E_MOVE_STAGE] >= sizeof(gMovements)) {
		gNpc[npcid][E_MOVE_STAGE] = 0;
	}
	SetTimerEx("MoveNormal", 3000, 0, "i", npcid);
	return 1;
}
forward MoveNormal(npcid);
public MoveNormal(npcid)
{
	MoveNPCc(npcid);
}
stock MoveNPCc(npcid)
{
	new mstage = gNpc[npcid][E_MOVE_STAGE];
	if(Dados[npcid][Animal] == 1)
	{
		FCNPC_GoTo(npcid, gMovements[mstage][0], gMovements[mstage][1], gMovements[mstage][2], FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_AUTO, true, FCNPC_MOVE_PATHFINDING_AUTO, 0.0, true,  0.0,  250);
	}
}
stock MoveNPC(npcid)
{
	new mstage = gNpc[npcid][E_MOVE_STAGE];
	if(Dados[npcid][Animal] == 1)
	{
		FCNPC_GoTo(npcid, gMovements[mstage][0], gMovements[mstage][1], gMovements[mstage][2], FCNPC_MOVE_TYPE_RUN, FCNPC_MOVE_SPEED_AUTO, true, FCNPC_MOVE_PATHFINDING_AUTO, 0.0, true, 0.0, 250);
	}
}
forward PegarProx(npcid);
public PegarProx(npcid)
{
	new
	Float:pos_x,
	Float:pos_y,
	Float:pos_z;
	for(new p=0; p < MAX_PLAYERS; p++)
	{
		if(Dados[p][Zombie] == 0 && Dados[p][Animal] == 0 && Dados[npcid][Animal] == 1)
		{
			GetPlayerPos(p, pos_x, pos_y, pos_z);
			if (IsPlayerInRangeOfPoint(npcid, 30.0, pos_x, pos_y, pos_z))
			{
				MoveNPC(npcid);
			}
		}
		if(Dados[npcid][Zombie] == 1)
		{
  			if(Dados[p][Animal] == 0 && Dados[p][Zombie] == 0 && Dados[p][Cavalo] == 0)
  			{
				GetPlayerPos(p, pos_x, pos_y, pos_z);
				new Float: Distancia = GetPlayerDistanceFromPoint(npcid, pos_x, pos_y, pos_z);
				if(Distancia <= 25 && Dados[npcid][mZombie] == 0)
				{
					FCNPC_GoToPlayer(npcid, p, FCNPC_MOVE_TYPE_WALK);
					FCNPC_MeleeAttack(npcid,2000);
				}
				if(Dados[p][PlayerFire] == 1) // Sendo seguido por ter disparado.
				{
					if(Distancia <= 90  && Dados[npcid][mZombie] == 0)
					{
						FCNPC_GoToPlayer(npcid, p, FCNPC_MOVE_TYPE_WALK);
						FCNPC_MeleeAttack(npcid,2000);
					}
				}
				if(Distancia >= 90)
				{
					FCNPC_Stop(npcid);
					FCNPC_StopAttack(npcid);
					Dados[p][PlayerFire] = 0;
				}
			}
		}
	}
	return 1;
}
// FIM ANIMAIS
// COMANDOS PAWN.CMD //

CMD:sms(playerid, params[])
{
	new id = -1, texto[128];
	sscanf(params, "us[128]", id, texto);
	if(Dados[playerid][Celular] == 0) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem um celular!");
	if(Dados[playerid][Creditos] <= 0) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem créditos!");
	Dados[playerid][Creditos] --;
	if(id != -1)
	{

		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Este jogador(a) não esta conectado(a).");
		if(Dados[id][Celular] == 0) return SendClientMessage(playerid, COR_ERRO, "| ERRO | O(A) jogador(a) que você está tentando mandar mensagem não tem um celular!");
		if(playerid == id) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não pode mandar mensagem para você!");
		if(isnull(texto)) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Digite alguma mensagem!");

		new nome[MAX_PLAYER_NAME], nome2[MAX_PLAYER_NAME], str[128];
		GetPlayerName(playerid, nome, 16);
		GetPlayerName(id, nome2, 16);
		format(str, sizeof(str), "| SMS | O Jogador(a) %s[%d] te enviou uma mensagem: %s", nome, playerid, texto);
		GameTextForPlayer(playerid, "Mensagem recebida!", 4000, 1);
		SendClientMessage(id, COR_SMS, str);
		format(str, sizeof(str), "| SMS | Você enviou uma mensagem para %s[%d]: %s", nome2, id, texto);
		GameTextForPlayer(playerid, "Mensagem enviada!", 4000, 1);
		SendClientMessage(playerid, COR_SMS, str);
	}
	else SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Sms [ID] [Mensagem]");
	return 1;
}

CMD:semparar(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_SEMPARAR, DIALOG_STYLE_TABLIST_HEADERS, "{FF0000}#{FFFFFF}Sem Parar",
	"Quantidade\tPreço(R$)\n\
	10 Passagens{FFFFFF}\t{32CD32}R${FFFFFF}900\n{FFFFFF}20 Passagens{FFFFFF}\t{32CD32}R${FFFFFF}1700\n{FFFFFF}30 Passagens{FFFFFF}\t{32CD32}R${FFFFFF}3200\n{FFFFFF}40 Passagens\t{32CD32}R${FFFFFF}6200", "Comprar", "Sair");
}
CMD:c4(playerid, params[])
{
	Dados[playerid][points] = 3;
	C4[playerid] = 1;
	SendClientMessage(playerid, 1, "Pegou ticks.");
	return ;
}
CMD:testado(playerid, params[])
{
	TextDrawShowForPlayer(playerid, msgw[4]);
	SetTimerEx("CloseMsg", 8000, 0, "i", playerid);
	return ;
}
CMD:ga(playerid, params[])
{
	new str[300];
	if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "Você não possue uma arma em mãos.");
	if(GetPlayerWeapon(playerid) == 34) return SendClientMessage(playerid, -1, "Arma não pode ser guardada.");
	if(GetPlayerWeapon(playerid) == 36) return SendClientMessage(playerid, -1, "Arma não pode ser guardada.");
	if(GetPlayerWeapon(playerid) == 35) return SendClientMessage(playerid, -1, "Arma não pode ser guardada.");
	format(str,300,"Você guardou um(a) %s com %d balas no seu inventário.",NomeArmaInventario(GetPlayerWeapon(playerid)), GetPlayerAmmo(playerid));
	for(new i; i<15; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19382)
		 {
			if(GetPlayerWeapon(playerid) == 1|| GetPlayerWeapon(playerid) == 2|| GetPlayerWeapon(playerid) == 3|| GetPlayerWeapon(playerid) == 4
			|| GetPlayerWeapon(playerid) == 5|| GetPlayerWeapon(playerid) == 6|| GetPlayerWeapon(playerid) == 7|| GetPlayerWeapon(playerid) == 8
			|| GetPlayerWeapon(playerid) == 9|| GetPlayerWeapon(playerid) == 14|| GetPlayerWeapon(playerid) == 15)
			{
				SendClientMessage(playerid, -1,"Essa arma não pode ser guardada.");
				return 1;
			}
			InventarioInfo[playerid][i][iSlot] = MudarIdArma(GetPlayerWeapon(playerid));
			InventarioInfo[playerid][i][iUnidades] = GetPlayerAmmo(playerid);
			GivePlayerWeapon(playerid, GetPlayerWeapon(playerid),-GetPlayerAmmo(playerid));
			return 1;
	   	 }
	}
	SendClientMessage(playerid, -1,"Seu inventário está cheio.");
	return 1;
}
CMD:Horse(playerid, params[])
{
	for(new i; i<15; i++)
	{
		 if(InventarioInfo[playerid][i][iSlot] == 19382)
		 {
			InventarioInfo[playerid][i][iSlot] = 6;
			InventarioInfo[playerid][i][iUnidades] = 1;
			return 1;
	   	 }
	}
	SendClientMessage(playerid, -1,"Seu inventário está cheio.");
	return 1;
}
CMD:est(playerid, params[])
{
	aEst(playerid);
	return 1;
}
CMD:inv(playerid, params[])
{
	AbrirInventario(playerid);
	return 1;
}
CMD:testar(playerid, params[])
{
	CreateNPC();
 	return 1;
}
CMD:pitem(playerid, params[])
{
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new f = MAX_OBJ+1;
		for(new a = 0; a < MAX_OBJ; a++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 1.8, dItemData[a][ObjtPos][0], dItemData[a][ObjtPos][1], dItemData[a][ObjtPos][2]))
		    {
		        f = a;
		        break;
		    }
		}
		if(f > MAX_OBJ) return 1;

		if(gettime() < GetPVarInt(playerid, #VarFlood8))
		    return 1;
		SetPVarInt(playerid, #VarFlood8, gettime()+2);

        for(new i=0; i<75; i++)
		{
		    if(InventarioInfo[playerid][i][iSlot] == 19382)
		    {
		        InventarioInfo[playerid][i][iSlot] = dItemData[f][ObjtData][0];
		        InventarioInfo[playerid][i][iUnidades] = dItemData[f][ObjtData][1];
				break;
		    }
		}

		new str[256];
		format(str, sizeof str, "Você pegou um item: %s, com %d unidade(s)", NomeItemInventario(dItemData[f][ObjtData][0]), dItemData[f][ObjtData][1]);
		SendClientMessage(playerid, -1, str);
		Dados[playerid][Peso] += 1;
        DestroyDroppedItem(f);

        ApplyAnimation(playerid,"BOMBER","BOM_Plant_2Idle",4.1,0,1,1,0,0);


  		return 1;
    }
CMD:concessionaria(playerid, params[])
{
	static string[sizeof(VeiculosT) * 64];
	if (string[0] == EOS) {
		for(new i; i < sizeof(VeiculosT); i ++)
		{

			format(string, sizeof(string), "%s%i\t~w~~h~%s~n~~g~~h~R$%i\n", string, VeiculosT[i][VeiculosID], VeiculosT[i][VeiculoNome], VeiculosT[i][Preco]);
		}
	}
	return ShowPlayerDialog(playerid, DIALOG_CONCE, DIALOG_STYLE_PREVIEW_MODEL, "Concessionaria Terrestre", string, "Comprar", "Sair");
}

CMD:utilitarios(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_UTILITARIOS, DIALOG_STYLE_TABLIST_HEADERS, "Loja de Utilitarios",
	"Itens\tUnidades\tPreço(R$)\n\
	Celular\t1\t{32CD32}R${FFFFFF}3000\n\
	Créditos\t50\t{32CD32}R${FFFFFF}300", "Comprar", "Sair");
	return 1;
}
CMD:admins(playerid, params[])
{
	new ajd, mod, adm, sub, staff;
	new stg2[500], gStr[500], string[128];
	strcat(stg2, "Nome\tCargo\tStatus\n");
	foreach(new i : Admins)
	{

		if(Dados[i][Admin] == 5 && Ausente[i] == 0)
		{

			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}Staff\t{32CD32}Online\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 5 && Ausente[i] == 1)
		{

			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}Staff\t{FF4500}Ausente\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 4 && Ausente[i] == 0)
		{

			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}Sub-Staff\t{32CD32}Online\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 4 && Ausente[i] == 1)
		{

			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}Sub-Staff\t{FF4500}Ausente\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 3 && Ausente[i] == 0)
		{

			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}Administrador(a)\t{32CD32}Online\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 3 && Ausente[i] == 1)
		{

			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}Administrador(a)\t{FF4500}Ausente\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 2 && Ausente[i] == 0)
		{

			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}Moderador(a)\t{32CD32}Online\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 2 && Ausente[i] == 1)
		{

			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}Moderador(a)\t{FF4500}Ausente\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 1 && Ausente[i] == 0)
		{

			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}Ajudante\t{32CD32}Online\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
		if(Dados[i][Admin] == 1 && Ausente[i] == 1)
		{

			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}Ajudante\t{FF4500}Ausente\n", GetPlayerNome(i), i);
			strcat(stg2, gStr);
		}
	}
	new teste = staff + sub + adm + mod + ajd;
	if(teste == 0) return ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admins Offline", "\n{FF0000}Nenhum membro da administração online no momento!\n\n", "Sair", "");
	format(string, sizeof(string), "{FFFFFF}Administradores Onlines [{32CD32}%d{FFFFFF}]", teste);
	ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, string, stg2, "Fechar", "");
	return 1;
}

CMD:ausente(playerid, params[])
{
	if(Dados[playerid][Admin] < 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	if(Ausente[playerid] == 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já está ausente");
		return 1;
	}
	SendClientMessage(playerid, COR_ERRO, "| ADM | Você entrou em modo ausente! Para sair use (/Online)");
	Ausente[playerid] = 1;
	TogglePlayerControllable(playerid, 0);
	return 1;
}

CMD:online(playerid, params[])
{
	if(Dados[playerid][Admin] < 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	if(Ausente[playerid] == 0)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não está ausente");
		return 1;
	}
	SendClientMessage(playerid, COR_ERRO, "| ADM | Você entrou em modo online novamente!");
	Ausente[playerid] = 0;
	TogglePlayerControllable(playerid, 1);
	return 1;
}
CMD:clop(playerid, params[])
{
	if(GetPlayerState(playerid)==2)
	{

		new Float:pX,Float:pY,Float:pZ;
		GetPlayerPos(playerid,pX,pY,pZ);
		new Float:vgX,Float:vgY,Float:vgZ;
		new Found=0;
		new vid=0;
		while((vid<MAX_VEHICLES)&&(!Found))
		{

			vid++;
			GetVehiclePos(vid,vgX,vgY,vgZ);
			if ((floatabs(pX-vgX)<6.0)&&(floatabs(pY-vgY)<6.0)&&(floatabs(pZ-vgZ)<6.0)&&(vid!=GetPlayerVehicleID(playerid)))
			{

				if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
				{

					DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
				}
				else
				{

					AttachTrailerToVehicle(vid,GetPlayerVehicleID(playerid));
				}
			}
		}
	}
	return 1;
}
CMD:vehd(playerid, params[])
{
 	DestroyTorretCar(playerid);
 	TurretCarPlayer[playerid] = 0;
	return 1;
}
CMD:item(playerid, params[])
{
	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new item, quant;
	if(sscanf(params, "id", item, quant))
	{

		SendClientMessage(playerid, -1, "USE: /item [ID do item] [quantidade]");
		return 1;
	}
	for(new i; i<17; i++)
	{
	 if(InventarioInfo[playerid][i][iSlot] == 19382)
	 {
		InventarioInfo[playerid][i][iSlot] = item;
		InventarioInfo[playerid][i][iUnidades] = quant;
		return 1;
	 }
	}
	return 1;
}
CMD:veh(playerid, params[])
{
	if(Dados[playerid][Admin] < 2)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new modelId;
	if(sscanf(params, "d", modelId))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /veh [modelo-carro]");
		return 1;
	}
	if(modelId < 400 || modelId > 611) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Escolha um modelo entre 400 e 611.");
	else {
		new carid, Float:Pos[3];
		new mot, lu, alar, por, cap, porma, ob;
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		carid = CreateVehicle(modelId, Pos[0], Pos[1], Pos[2], random(200), random(200), -1, -1);
		/*GetVehicleParamsEx(carid, mot, lu, alar, por, cap, porma, ob);
		SetVehicleParamsEx(carid, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
		Gas[carid] = 100;
		vehEngine[carid] = 0;*/
		GetVehicleParamsEx(carid, mot, lu, alar, por, cap, porma, ob);
		SetVehicleParamsEx(carid, VEHICLE_PARAMS_ON, lu, alar, por, cap, porma, ob);
		Gas[carid] = 100;
		vehEngine[carid] = 1;
		PutPlayerInVehicle(playerid,carid,0);
		if(modelId == 611)
		{

			new object = CreateObject( 2232,0,0,0,0,0,0,80 );
			AttachObjectToVehicle( object, carid, -0.000000, -0.799999, 1.000000, 0.000000, 0.000000, 0.000000 ); // <iVO>
		}
		if(modelId == 422)
		{
			GetVehicleParamsEx(carid, mot, lu, alar, por, cap, porma, ob);
			SetVehicleParamsEx(carid, VEHICLE_PARAMS_ON, lu, alar, por, cap, porma, ob);

			vehEngine[carid] = 1;
			TorretForCar(carid);
		}
	}
	return 1;
}
CMD:vehtest(playerid, params[]) // Retirar CMD Depois
{
	if(Dados[playerid][Admin] < 2)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new modelId, placa[9];
	if(sscanf(params, "ds[9]", modelId, placa))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /vehtest [modelo-carro] [placa]");
		return 1;
	}
	if(modelId < 400 || modelId > 611) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Escolha um modelo entre 400 e 611.");
	else {
		new carid, Float:Pos[3];
		new Float:Lataria;
		new mot, lu, alar, por, cap, porma, ob;
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		new carcolor[2];
		carcolor[0] = random(200);
		carcolor[1] = random(200);
		new carrotation = random(360);
		carid = CreateVehicle(modelId, Pos[0], Pos[1], Pos[2], carrotation, carcolor[0], carcolor[1], -1, 0);
		GetVehicleParamsEx(carid, mot, lu, alar, por, cap, porma, ob);
		SetVehicleParamsEx(carid, VEHICLE_PARAMS_OFF, lu, alar, por, cap, porma, ob);
		Gas[carid] = 100;
		vehEngine[carid] = 0;
		if(modelId == 611)
		{
			new object = CreateObject( 2232,0,0,0,0,0,0,80 );
			AttachObjectToVehicle( object, carid, -0.000000, -0.799999, 1.000000, 0.000000, 0.000000, 0.000000 ); // <iVO>
		}

		SetVehicleNumberPlate(carid, placa);
		SetVehicleToRespawn(carid);
		PutPlayerInVehicle(playerid,carid,0);
		GetVehicleHealth(carid,Lataria);

		if(!DOF2_FileExists(PASTA_CONTADOR_CARROS)) DOF2_CreateFile(PASTA_CONTADOR_CARROS);
		if(!DOF2_IsSet(PASTA_CONTADOR_CARROS, "Quantidade")) DOF2_SetInt(PASTA_CONTADOR_CARROS, "Quantidade", 1);
		if(!DOF2_FileExists(PASTA_PLACAS_CARROS)) DOF2_CreateFile(PASTA_PLACAS_CARROS);

		new carDOF2id = DOF2_GetInt(PASTA_CONTADOR_CARROS, "Quantidade"); // id DOF2
		DOF2_SetInt(PASTA_CONTADOR_CARROS, "Quantidade", carDOF2id+1);

		DOF2_CreateFile(Carros(carDOF2id));
		DOF2_SetInt(Carros(carDOF2id), "Modelo", modelId);
		DOF2_SetInt(Carros(carDOF2id), "Cor1", carcolor[0]);
		DOF2_SetInt(Carros(carDOF2id), "Cor2", carcolor[1]);
		DOF2_SetFloat(Carros(carDOF2id), "PosX", Pos[0]);
		DOF2_SetFloat(Carros(carDOF2id), "PosY", Pos[1]);
		DOF2_SetFloat(Carros(carDOF2id), "PosZ", Pos[2]);
		DOF2_SetFloat(Carros(carDOF2id), "Rotation", carrotation);
		DOF2_SetString(Carros(carDOF2id), "Placa", placa);
		DOF2_SetFloat(Carros(carDOF2id), "Saude", Lataria);
		DOF2_SetString(Carros(carDOF2id), "Dono", GetPlayerNome(playerid));
		DOF2_SaveFile();

		DOF2_SetInt(PASTA_PLACAS_CARROS, placa, carDOF2id);
		DOF2_SaveFile();

		Veiculos[carid][idCar] = carDOF2id;
		Veiculos[carid][modeloCar] = modelId;
		Veiculos[carid][latariaCar] = 100;
		Veiculos[carid][blindagemCar] = 0;
		Veiculos[carid][corCar][0] = carcolor[0];
		Veiculos[carid][corCar][1] = carcolor[1];
		GetVehiclePos(carid, Veiculos[carid][posCar][0], Veiculos[carid][posCar][1], Veiculos[carid][posCar][2]);
		Veiculos[carid][posCar][3] = carrotation;
		Veiculos[carid][placaCar] = placa;

		new chaveiroid = CriarChaveiro(playerid);
		if(chaveiroid) CriarChave(chaveiroid, CHAVE_CARRO, carDOF2id, 0);
	}
	return 1;
}
CMD:trocarplaca(playerid, params[]) // Retirar cmd depois
{
	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new vehicleid, placa[9];
	if(sscanf(params, "ds[9]", vehicleid, placa))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /trocarplaca [id] [placa]");
		return 1;
	}

	SetVehicleNumberPlate(vehicleid, placa);
	return 1;
}
CMD:respawncar(playerid, params[]) // Retirar cmd depois
{
	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new vehicleid;
	if(sscanf(params, "d", vehicleid))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /respawncar [id]");
		return 1;
	}

	SetVehicleToRespawn(vehicleid);
	return 1;
}
CMD:criarchaveiro(playerid, params[]) // Retirar CMD Depois
{
	if(Dados[playerid][Admin] < 2)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}

	new criouItem = CriarChaveiro(playerid);

	if(!criouItem) SendClientMessage(playerid, -1, "Seu inventário está cheio!");

	return 1;
}
CMD:criarchave(playerid, params[]) // Retirar CMD Depois
{
	if(Dados[playerid][Admin] < 2)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new chaveiroid, tipo, chaveid, modelo;
	if(sscanf(params, "dddd", chaveiroid, tipo, chaveid, modelo))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /criarchave [chaveiro] [tipo] [id-chave] [modelo]");
		return 1;
	}

	new bool:criouChave = CriarChave(chaveiroid, tipo, chaveid, modelo);

	if(!criouChave) SendClientMessage(playerid, -1, "Este chaveiro está cheio!");
	return 1;
}
CMD:verchaveiro(playerid, params[]) // Retirar CMD Depois
{
	for(new i=0; i<15; i++)
	{
		if(InventarioInfo[playerid][i][iSlot] == ITEM_CHAVEIRO)
		{
			VerChaveiro(playerid, InventarioInfo[playerid][i][iUnidades]);
			break;
		}
	}
	return 1;
}
CMD:setskin(playerid, params[])
{

	new para1, level;
	if(sscanf(params, "ud", para1, level))
	{

		SendClientMessage(playerid, -1, "USE: /setskin [playerid] [skin id]");
		return true;
	}
	if(level > 311 || level < 0)
	{

		SendClientMessage(playerid, -1, "ID Desconhecido!");
		return true;
	}
	if (Dados[playerid][Admin] >= 1)
	{

		if(IsPlayerConnected(para1))
		{

			if(para1 != INVALID_PLAYER_ID)
			{

				SetPlayerSkin(para1, level);
			}
		}//not connected
	}
	else
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
	}
	return true;
}

CMD:cnn1(playerid, params[])
{
	new texto[128], str[128];
	if(sscanf(params, "s", texto))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Cnn1 [Texto]");
		return 1;
	}
	else {
		foreach(new i : Player)
		{

			format(str, sizeof(str), "~g~~h~%s~w~~h~: %s", GetPlayerNome(playerid), texto);
			TextDrawSetString(Aviso[i], str);
			TextDrawShowForPlayer(i, Aviso[i]);
			SetTimerEx("Sumiu", 5000, false, "i", i);
		}
		return 1;
	}
}

CMD:calar(playerid, params[])
{
	if(Dados[playerid][Admin] < 2 )
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, tempo, motivo[28], string[300];
	if(sscanf(params, "uis", id, tempo, motivo))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Calar [ID] [Tempo] [Motivo]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido");
		return 1;
	}
	if(Calado[id] == 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) já está mutado");
		return 1;
	}
	if(tempo < 1 || tempo > 20)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Tempo de 1 á 20 minutos!");
		return 1;
	}
	Calado[id] = 1;

	format(string, sizeof(string), "| ADM | O(A) %s %s calou o jogador(a) %s por %i minutos. (Motivo: %s)", AdminLevel(playerid), GetPlayerNome(playerid), GetPlayerNome(id), tempo, motivo);
	SendClientMessageToAll(COR_VERMELHO, string);

	format(string, sizeof(string), "| ADM | O(A) %s %s calou você por %i minutos. (Motivo: %s)", AdminLevel(playerid), GetPlayerNome(playerid), tempo, motivo);
	SendClientMessage(id, COR_VERMELHO, string);

	format(string, sizeof(string), "| INFO | Você calou o jogador(a) %s por %i minutos. (Motivo: %s)", GetPlayerNome(id), tempo, motivo);
	SendClientMessage(playerid, COR_ADM, string);

	TimerCalado[id] = SetTimerEx("MutadoTimer", tempo *1000 *60, false, "i", id);
	return 1;
}
CMD:abcar(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{

		new string[246];
		if(Dados[playerid][Admin] < 1)
		{

			SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
			return 1;
		}
		new counter = 0;
		new result;
		new plyName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, plyName, MAX_PLAYER_NAME);
		for(new i; i != MAX_VEHICLES; i++)
		{

			new dist = ChecarVeiculo(5, playerid, i);
			if(dist)
			{

				result = i;
				counter++;
			}
		}
		switch(counter)
		{

			case 0:
			{

				SendClientMessage(playerid, -1, " Não há nenhum carro nesse raio.");
			}
			case 1:
			{

				new name[MAX_PLAYER_NAME];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Você abasteceu o carro ID:[%d]", result);
				SendClientMessage(playerid, -1, string);
				Gas[result] = 4;
			}
			default:
			{

				SendClientMessage(playerid, -1, "Muitos veiculos próximo.");
			}
		}
	}
	return 1;
}
CMD:bcar(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{

		if(Dados[playerid][Admin] < 1)
		{

			SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
			return 1;
		}
		new counter = 0;
		new result;
		new plyName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, plyName, MAX_PLAYER_NAME);
		for(new i; i != MAX_VEHICLES; i++)
		{

			new dist = ChecarVeiculo(5, playerid, i);
			if(dist)
			{

				result = i;
				counter++;
			}
		}
		switch(counter)
		{

			case 0:
			{

				SendClientMessage(playerid, -1, "Não há nenhum carro nesse raio.");
			}
			case 1:
			{

				BlindarVeiculo(result);
				SendClientFormat(playerid, -1, "Você blindou o carro ID:[%d]", result);
			}
			default:
			{

				SendClientMessage(playerid, -1, "Muitos veiculos próximo.");
			}
		}
	}
	return 1;
}
CMD:montar(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{

		if(Dados[playerid][Admin] < 1)
		{

			SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
			return 1;
		}
		new counter = 0;
		new result;
		new plyName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, plyName, MAX_PLAYER_NAME);
		for(new i; i != MAX_VEHICLES; i++)
		{

			new dist = ChecarVeiculo(5, playerid, i);
			if(dist)
			{

				result = i;
				counter++;
			}
		}
		switch(counter)
		{

			case 0:
			{

				SendClientMessage(playerid, -1, "Não há nenhum carro nesse raio.");
			}
			case 1: // resultado positivo
			{
				PutPlayerInVehicle(playerid, result, 0);
			}
			default:
			{

				SendClientMessage(playerid, -1, "Muitos veiculos próximo.");
			}
		}
	}
	return 1;
}
CMD:descalar(playerid, params[])
{
	if(Dados[playerid][Admin] < 2)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Descalar [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido");
		return 1;
	}
	if(Calado[id] == 0)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) não esta calado!");
		return 1;
	}
	Calado[id] = 0;

	format(string, sizeof(string), "| ADM | O(A) %s %s descalou você.", AdminLevel(playerid), GetPlayerNome(playerid));
	SendClientMessage(id, COR_ADM, string);

	format(string, sizeof(string), "| INFO | Você descalou o jogador(a) %s", GetPlayerNome(id));
	SendClientMessage(playerid, COR_ADM, string);

	KillTimer(TimerCalado[id]);
	return 1;
}

CMD:daradmin(playerid, params[])
{

	if(IsPlayerConnected(playerid))
	{

		if(Dados[playerid][Admin] < 4)
		{

			SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
			return 1;
		}
		new novoadmin, nivel;
		if(sscanf(params, "ud", novoadmin, nivel))
		{

			SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Daradmin [ID] [NivelAdm] ou use /AdminsLevel");
			return 1;
		}
		if(nivel < 0 || nivel > 5) {
			SendClientMessage(playerid, -1, "| ERRO | Level de admin de 0 á 5 {FF0000}Obs: Level 0 = Jogador{FFFFFF}!");
			return 1;
		}
		if(novoadmin == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
		Dados[novoadmin][Admin] = nivel;
		if(Iter_Contains(Admins, novoadmin))
		{
			if(nivel == 0) Iter_Remove(Admins, novoadmin);
		}
		else if(nivel != 0) Iter_Add(Admins, novoadmin);
		new string[128], nome[MAX_PLAYER_NAME+1];
		GetPlayerName(playerid, nome, MAX_PLAYER_NAME);
		format(string, sizeof(string), "| INFO | Você foi promovido para %s - Por %s", AdminLevel(novoadmin), GetPlayerNome(playerid));
		SendClientMessage(novoadmin, COR_ADM, string);
		GetPlayerName(novoadmin, nome, MAX_PLAYER_NAME);
		format(string, sizeof(string), "| INFO | Você promoveu %s para o level %d de Admin. Para mais informaçães /AdminsLevel", GetPlayerNome(novoadmin), nivel);
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:ir(playerid, params[])
{
	if(Dados[playerid][Admin] < 2)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /ir [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		new Float:Pos[3];
		GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(playerid, Pos[0], Pos[1]+1, Pos[2]);

		format(string, sizeof(string), "| ADM | O(A) %s %s veio até você.", AdminLevel(playerid), GetPlayerNome(playerid));
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| ADM | Você foi até o jogador(a) %s.", GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}
CMD:armar(playerid, params[])
{

	new playa;
	new gun;
	new ammo;
	if(sscanf(params, "udd", playa, gun, ammo))
	{

		SendClientMessage(playerid, -1, "USE: /dararma [ID do Player] [arma id(ex. 24 = Eagle)] [munição]");
		SendClientMessage(playerid, -1, "3(Cassetete) 4(Faca) 5(Taco de Baseball) 6(Pá) 7(Espada) 8(Katana) 10-13(Vibrador) 14(Flores) 16(Granadas) 17(Granada Gás) 18(Molotovs) 22(Pistola)");
		SendClientMessage(playerid, -1, "23(Pistola com Silenciador) 24(Eagle) 25(Escopeta) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Lança Chamas) 41(spray) 42(extintor) 43(Camera) 46(Paraquedas)");
		return true;
	}
	if(ammo < 1 || ammo > 999)
	{

		SendClientMessage(playerid, -1, "O minimo de munição é 1 e o máximo é 999!");
		return true;
	}
	if (Dados[playerid][Admin] >= 4)
	{

		if(IsPlayerConnected(playa))
		{

			GivePlayerWeapon(playa, gun, ammo);
		}
	}
	else
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
	}
	return true;
}
CMD:ferir(playerid, params[])
{

	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}

	new para1;
	new level;
	if(sscanf(params, "ud", para1, level))
	{

		SendClientMessage(playerid, -1, "USE: /ferir [ID do Player] [tempo de ferido]");
		return 1;
	}
	if(IsPlayerConnected(para1))
	{

		if(para1 != INVALID_PLAYER_ID)
		{

			new string[128];
			format(string, sizeof string, "Você feriu por %d o jogador %s.", level, Nome(para1));
			SendClientMessage(playerid, -1, string);
			format(string, sizeof string, "O Administrador %s te feriu por %d.", Nome(playerid), level);
			SendClientMessage(para1, -1, string);
			Dados[para1][Ferido] = level;
			Dados[para1][Chao] = 1;
		}
	}
	return 1;
}
CMD:grana(playerid, params[])
{

	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}

	new para1;
	new level;
	if(sscanf(params, "ud", para1, level))
	{

		SendClientMessage(playerid, -1, "USE: /grana [ID do Player] [quantia]");
		return 1;
	}
	if(IsPlayerConnected(para1))
	{

		if(para1 != INVALID_PLAYER_ID)
		{

			new string[128];
			format(string, sizeof string, "Você deu R$%d,00 para o jogador %s.", level, Nome(para1));
			SendClientMessage(playerid, -1, string);
			format(string, sizeof string, "O Administrador %s te deu R$%d,00.", Nome(playerid), level);
			SendClientMessage(para1, -1, string);
			Dados[para1][Dinheiro] += level;
			Atualizar(para1);
		}
	}
	return 1;
}
CMD:setpos(playerid, params[])
{

	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}

	new Float:Pos[3];
	if(sscanf(params, "fff", Pos[0], Pos[1], Pos[2]))
	{
		SendClientMessage(playerid, -1, "USE: /setpos [x] [y] [z]");
		return 1;
	}
	else SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

	return 1;
}
CMD:test(playerid, params[])
{

	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}

	new para1;
	new level;
	if(sscanf(params, "ud", para1, level))
	{

		SendClientMessage(playerid, -1, "USE: /test [ID do Player] [quantia]");
		return 1;
	}
	if(IsPlayerConnected(para1))
	{

		if(para1 != INVALID_PLAYER_ID)
		{

			Dados[para1][PH] += level;
		}
	}
	return 1;
}
CMD:reviver(playerid, params[])
{

	Dados[playerid][Ferido] = 0;
	Dados[playerid][Chao] = 0;
	Dados[playerid][Mancando] = 0;
	Dados[playerid][Braco] = 0;
	Dados[playerid][Saude] = 100;
	Dados[playerid][Sede] = 100;
	Dados[playerid][Fome] = 100;
	Dados[playerid][Morto] = 0;
	TogglePlayerControllable(playerid, 1);
	Atualizar(playerid);
	return 1;
}
CMD:tgrana(playerid, params[])
{

	if(Dados[playerid][Admin] < 5)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}

	new para1;
	new level;
	if(sscanf(params, "ud", para1, level))
	{

		SendClientMessage(playerid, -1, "USE: /tgrana [ID do Player] [quantia]");
		return 1;
	}
	if(IsPlayerConnected(para1))
	{

		if(para1 != INVALID_PLAYER_ID)
		{

			new string[128];
			format(string, sizeof string, "Você tirou R$%d,00 do jogador %s.", level, Nome(para1));
			SendClientMessage(playerid, 0xff6347FF, string);
			format(string, sizeof string, "O Administrador %s tirou R$%d,00 de seu dinheiro.", Nome(playerid), level);
			SendClientMessage(para1, 0xff6347FF, string);
			Dados[para1][Dinheiro] -= level;
			Atualizar(para1);
		}
	}
	return 1;
}
CMD:trazer(playerid, params[])
{
	if(Dados[playerid][Admin] < 3)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /trazer [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(id, Pos[0], Pos[1]+1, Pos[2]);

		format(string, sizeof(string), "| ADM | O(A) %s %s trouxe você.", AdminLevel(playerid), GetPlayerNome(playerid));
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| ADM | Você trouxe o jogador(a) %s.", GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:dargrana(playerid, params[])
{
	if(Dados[playerid][Admin] < 3)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, grana;
	if(sscanf(params, "ui", id, grana))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /DarGrana [ID] [Quantidade]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		GivePlayerMoney(playerid, grana);
		new string[128];
		format(string, sizeof(string), "| INFO | O %s %s te deu R$%d", AdminLevel(playerid), GetPlayerNome(playerid), grana);
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| INFO | Você deu R$%d para{FFFFFF} %s", grana, GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}
CMD:darlevel(playerid, params[])
{
	if(Dados[playerid][Admin] < 3)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, qlevel;
	if(sscanf(params, "ui", id, qlevel))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /DarLevel [ID] [Score]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		SetPlayerScore(id, qlevel);
		new string[128];
		format(string, sizeof(string), "| INFO | O %s %s te deu %d scores", AdminLevel(playerid), GetPlayerNome(playerid), qlevel);
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| INFO | Você deu %d scores para %s", qlevel, GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:tapa(playerid, params[])
{
	if(Dados[playerid][Admin] < 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id;
	if(sscanf(params, "u", id))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Tapa [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		new Float:Pos[3], string[128];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]+15);
		format(string, sizeof(string), "| ADM | O(A) %s %s deu um tapa no jogador(a) %s.", AdminLevel(playerid), GetPlayerNome(playerid), GetPlayerNome(id));
		SendClientMessageToAll(0xFF0000FF, string);

		format(string, sizeof(string), "| ADM | O(A) %s %s te deu um tapa.", AdminLevel(playerid), GetPlayerNome(playerid));
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| INFO | Você deu um tapa no jogador %s.", GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:identidade(playerid, params[])
{
	new stg[1500], gstring[1500], oi[128];
	format(gstring, sizeof(gstring), "{32CD32}~~~~~~~~~~~~~~~~ Identidade ~~~~~~~~~~~~~~~~\n\n");
	strcat(stg, gstring);
	format(gstring, sizeof(gstring), "{FFFFFF}» Level: {32CD32}%d", GetPlayerScore(playerid));
	strcat(stg, gstring);
	if(Dados[playerid][Celular] == 1)
	{

		format(gstring, sizeof(gstring), "\n{FFFFFF}» Celular: {32CD32}Possui");
		strcat(stg, gstring);
	}
	if(Dados[playerid][Celular] == 0)
	{

		format(gstring, sizeof(gstring), "\n{FFFFFF}» Celular: {FF0000}Não Possui");
		strcat(stg, gstring);
	}
	if(SemParar[playerid])
	{

		format(gstring, sizeof(gstring), "\n{FFFFFF}» SemParar: {32CD32}Possui");
		strcat(stg, gstring);
	}
	if(!SemParar[playerid])
	{

		format(gstring, sizeof(gstring), "\n{FFFFFF}» SemParar: {FF0000}Não Possui");
		strcat(stg, gstring);
	}
	format(gstring, sizeof(gstring), "\n{FFFFFF}» Creditos: {32CD32}%d", Dados[playerid][Creditos]);
	strcat(stg, gstring);
	format(gstring, sizeof(gstring), "\n\n{32CD32}~~~~~~~~~~~~~~~~ Identidade ~~~~~~~~~~~~~~~~");
	strcat(stg, gstring);
	format(gstring, sizeof(gstring), "{FFA500}Identidade de{FFFFFF}: %s", GetPlayerNome(playerid));
	strcat(oi, gstring);

	ShowPlayerDialog(playerid, DIALOG_IDENTIDADE, DIALOG_STYLE_MSGBOX, oi, stg, "Fechar", "");
}

// COMANDOS ADMINS //

CMD:adminslevel(playerid, params[])
{
	if(Dados[playerid][Admin] < 4) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando invalido");
		return 1;
	}
	ShowPlayerDialog(playerid, DIALOG_ADMIN_LEVEL, DIALOG_STYLE_TABLIST, "Leveis Admin", "Level 1\tAjudante\nLevel 2\tModerador\nLevel 3\tAdministrador\nLevel 4\tSub-Staff", "Sair", "");
	return 1;
}

CMD:cnn(playerid, params[])
{
	if(Dados[playerid][Admin] < 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new texto[128], str[128];
	if(sscanf(params, "s[24]", texto))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Cnn [Texto]");
		return 1;
	}
	else {
		format(str, sizeof(str), "~p~] ~w~%s ~p~]", texto);
		GameTextForPlayer(playerid, str, 5000, 3);
		return 1;
	}
}

CMD:ircarro(playerid, params[])
{
	new vehicleid, Float:vehiclePosX, Float:vehiclePosY, Float:vehiclePosZ;
	if(Dados[playerid][Admin] < 1)
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	else
	{

		if (sscanf(params, "%d", vehicleid)) SendClientMessage(playerid, COR_ERRO, "| ERRO | Utilize: /ircarro [id]" );
		else
		{

			GetVehiclePos(vehicleid, vehiclePosX, vehiclePosY, vehiclePosZ);
			SetPlayerPos(playerid, vehiclePosX, vehiclePosY, vehiclePosZ);
		}
	}

	return 1;
}
CMD:clima(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		new id;
		if(sscanf(params, "u", id))
		{
			SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /clima [ID]");
			return 1;
		}
		if(Dados[playerid][Admin] >= 1)
		{
			SetWorldTime(id);
		}
		else
		{
			SendClientMessage(playerid, COR_ERRO, "Você não está autorizado a usar o comando!");
		}
	}
	return 1;
}
// FIM COMANDOS ADMINS //
CMD:somsom(playerid, params[]) // Botão para executar a flexao.
{
	soundtrack(playerid);
	return 1;
}
CMD:flexao(playerid, params[]) // Botão para executar a flexao. 
{
	ApplyAnimation(playerid,"PED","flexao",4.0,0,1,1,1,1,1);
	return 1;
}
CMD:continencia(playerid, params[])
{
	ApplyAnimation(playerid,"PED","continencia",4.0,0,1,1,1,1,1);
	return 1;
}
CMD:barra(playerid, params[])
{
	ApplyAnimation(playerid,"PED","barra",4.0,0,1,1,1,1,1); // Botão para executar a barra.
	return 1;
}
CMD:rendido(playerid, params[])
{
	ApplyAnimation(playerid,"PED","rendido",4.0,1,1,1,1,1,1);
	return 1;
}
CMD:abdominal(playerid, params[]) // Botão para executar o abdominal
{
	ApplyAnimation(playerid,"PED","abdominal",4.0,0,1,1,1,1,1);
	return 1;
}
CMD:go(playerid, params[]) //
{
	ApplyAnimation(playerid,"PED","maoscima",4.1,0,1,1,1,1,1);
	return 1;
}
CMD:sentido(playerid, params[]) //
{
	ApplyAnimation(playerid,"PED","Sentido",4.1,0,1,1,1,1,1);
	return 1;
}
CMD:menu(playerid, params[]) //
{
	WorkOpen(playerid);
	return 1;
}
CMD:duvida(playerid, params[])
{
	new duvida, string[128];
	if(sscanf(params, "s[64]", duvida))
	{

		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Duvida [Texto]" );
		return 1;
	}
	foreach(new i : Admins)
	{
		format(string, sizeof(string), "| ADM | Dúvida recebida de %s[%d]: %s", GetPlayerNome(playerid), playerid, duvida);
		SendClientMessage(i, COR_DUVIDA, string);
		GameTextForPlayer(i, "~b~~h~DUVIDA", 5000, 4);
	}
	return 1;
}
