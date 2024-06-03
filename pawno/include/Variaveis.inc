#include <a_samp>
#include <DOF2>
#include <sscanf2>
#include <zcmd>
#include <dudb>
#include <progress>
#include <streamer>
#include <zone>
#include <a_http>
#define MAILER_URL      "www.sannews.org/mailer/enviar.php"
#include <mailer>


#define DLogar 			0
#define DRegistrar		1
#define DPainel			7
#define DSkill 			10
#define DEdicao			11
#define DCodigos        23// dialog == 26
#define DEmail          26
#define DAtivar         27
#define Nulo 			999999
#define NServer 		"Revolution RPG"
#define EMAIL_SERVIDOR  ("projetosamp@umaboaimagem.com.br")
#define Senha 			3
#define Lista 			2
#define Texto 			1
#define Box 			0
#define Players 		50
#define Player_Veiculo  3
#define Max_Veiculos 	250
#define MAX_CASAS 		150
#define PRATA           1
#define OURO    		2

#define DESEMPREGADO    0
#define PM              1
#define PF              2
#define PR              3
#define GATE            4
#define TAXISTA         5
#define REPORTER        6
#define GROVE           7
#define MARA            8
#define VAGOS           9
#define AZTECAS         10
#define BALLAS          11
#define GN              12
#define ALQAEDA         13
#define FARC            14
#define TRIADS          15
#define SINDACCO        16

new Cores[][] = {
	"00BFFF",
	"00FFFF",
	"7FFFD4",
	"00FF7F",
	"7CFC00",
	"00FF00",
	"00FA9A",
	"ADFF2F",
	"FFFF00",
	"FFD700",
	"7FFFD4",
	"FF82AB",
	"FF3E96",
	"FF00FF",
	"E066FF",
	"FF4500",
	"FF3030",
	"FF8247",
	"FF6EB4",
	"FFA07A",
	"FF6347",
	"1E90FF"
};
new Clima[14] = {
	0,//sol
	1,//sol
	2,//sol
	3,//sol
	4,//nublado
	7,//nublado
	8,//chuva
	9,//nevoa
	10,//sol
	11,//sol
	13,//sol
	15,//nublado
	16,//chuva
	17,//tempestade de area
};
new Float:PosConc[40][4] = {

	{-2693.1589,-22.6700,4.0415,179.0120}, // 1
	{-2689.7388,-22.7290,4.0414,179.0120}, // 2
	{-2686.4348,-22.7860,4.0414,179.0120}, // 3
	{-2683.1755,-22.8422,4.0414,179.0120}, //4
	{-2679.7827,-22.9007,4.0414,179.0120}, //5
	{-2676.2942,-21.6804,4.0442,179.0120}, //6
	{-2672.7942,-34.1308,4.0409,179.7195}, //7
	{-2669.7415,-34.1457,4.0409,179.7195}, //8
	{-2666.4893,-34.1616,4.0409,179.7195}, //9
	{-2663.4497,-34.1765,4.0409,179.7195}, //10
	{-2633.4424,-34.9055,4.0412,179.2762}, //11
	{-2630.4429,-34.7263,4.0412,179.7362}, //12
	{-2627.5325,-34.7397,4.0412,179.7362}, //13
	{-2624.4038,-34.7542,4.0412,179.7362}, //14
	{-2621.0940,-22.7647,4.0317,179.7340}, //15
	{-2617.5586,-22.7811,4.0317,179.7340}, //16
	{-2616.8511,-55.0508,4.0413,0.4373}, //17
	{-2620.1421,-55.0759,4.0413,0.4373}, //18
	{-2623.4658,-55.1013,4.0413,0.4373}, //19
	{-2626.8813,-55.1274,4.0413,0.4373}, //20
	{-2630.1011,-55.1519,4.0413,0.4373}, //21
	{-2633.5142,-55.1780,4.0413,0.4373}, //22
	{-2636.7803,-55.2029,4.0413,0.4373}, //23
	{-2640.1477,-55.2286,4.0413,0.4373}, //24
	{-2643.4824,-55.2540,4.0413,0.4373}, //25
	{-2646.8120,-55.2795,4.0413,0.4373}, //26
	{-2650.0989,-55.3045,4.0413,0.4373}, //27
	{-2653.3770,-55.3296,4.0413,0.4373}, //28
	{-2656.7209,-55.3551,4.0413,0.4373}, //29
	{-2660.0430,-55.3804,4.0413,0.4373}, //30
	{-2663.4111,-55.4061,4.0413,0.4373}, //31
	{-2666.5535,-55.4301,4.0412,0.4373}, //32
	{-2669.8982,-55.4556,4.0412,0.4373}, //33
	{-2673.3308,-55.4818,4.0412,0.4373}, //34
	{-2676.6243,-55.5070,4.0412,0.4373}, //35
	{-2679.9578,-55.5324,4.0412,0.4373}, //36
	{-2683.2041,-55.5572,4.0412,0.4373}, //37
	{-2686.6582,-55.5835,4.0412,0.4373}, //38
	{-2689.9651,-55.6088,4.0412,0.4373}, //39
	{-2693.3987,-55.6350,4.0412,0.4373} //40
};
new Camionetes[] = {
	400,422,489,495,543,554,579
};
new ValorCamionetes[] = {
	45000,30000,65000,90000,25000,50000,75000
};
new VeiculosNome[][] =
{
    "Landstalker","Bravura","Buffalo","Linerunner","Perrenial","Sentinel","Dumper","Firetruck","Trashmaster",
    "Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam",
    "Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer",
    "Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer 1","Previon","Coach",
    "Cabbie","Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow",
    "Pizzaboy","Tram","Trailer 2","Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair",
    "Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale","Oceanic",
    "Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR-350","Walton",
    "Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher",
    "FBI Rancher","Virgo","Greenwood","Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville",
    "Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT",
    "Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","Roadtrain","Nebula",
    "Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune",
    "Cadrona","FBI Truck","Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade",
    "Freight","Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck LA","Hustler","Intruder",
    "Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A","Monster B",
    "Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito",
    "Freight Flat","Streak Carriage","Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30",
    "Huntley","Stafford","BF-400","Newsvan","Tug","Trailer 3","Emperor","Wayfarer","Euros","Hotdog","Club",
    "Freight Carriage","Trailer 3","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
    "Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler",
    "Luggage Trailer A","Luggage Trailer B","Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};
new NomeArmas[][] = {
	"Nenhum","Soqueira","Taco de Golf","Cacetete","Faca","Baseball","Pá","Taco de Sinuca","Katana","Motoserra",
	"Dildo Roxo","Dildo Branco I","Dildo Branco II","Dildo Prata","Buquê de Flor","Bengala","Granada","Bomba de Gás",
	"Molotov","Nenhum","Nenhum","Nenhum","9mm","SD Pistola","Eagle","Shotgun","Sawn Shotgun","Combat Shotgun","Uzi",
	"MP5","Ak 47","M4","Tec9","Country Rifle","Sniper Rifle","Lança Míssil","Bazuka","Lança Chamas","Minigun","Mochilinha",
	"Detonador","Spray","Extintor","Câmera Fotográfica","Visão Noturna","Óculos Raio X","Paraquedas"
};
new Text:TextoLogo[ 5 ][ Players ];
new Text:Textodraw[ Players ];
new bool:Selecionando[Players];
new EditarCasa[ Players ];
new Text:TCor[13][Players];
new CorTipo[2][Players];
new bool:chatOff = false;
new Text:TModelo[Players];
new Text:TSetaE[Players];
new Text:TSetaD[Players];
new Text:TNomeV[Players];
new Text:TValorV[Players];
new Text:TClasseV[Players];
new Text:TMenuV[Players];
new Text:TComprarV[Players];
new _r[Players];
new _c[Players];
new Text:VNome[Players];
new Text:VLata[Players];
new Text:VVelo[Players];
new Text:VGas[Players];
new Text:VFundo[Players];
new Text:VPlaca[Players];
new Text:Login[Players];
new Fome[Players],Stamina[Players],Vicio[Players];
new ContadorSono[Players];
new Text:Fundo[Players];
new Text:Tutorial[Players];
new Text:Credito[Players];
new Text:Saindo[Players];
new bool:Logou[Players];
new id;
new Respeito[Players];
new TipoCarro[Players];
new bool:Reg[Players][4];
new Bar:BFome[Players],/*Bar:BVicio[Players],*/Bar:BEnergia[Players];
new TAtualizar[Players];
new SErrou[Players];
new bool:Espiando[Players];
new Contador[3][Players];
new Text:TInfo[Players][21];
new Float:MarcaX[Players],Float:MarcaY[Players],Float:MarcaZ[Players];
new MarcaInt[Players],MarcaVw[Players];
new Text:Relogio[Players];//Text:TRelogio[Players];
new Text:TFome[Players];
new Text:TEnergia[Players];
new Text:TVicio[Players];
new TVelocimetro[Players];
new Text:TGrana[ Players ];
new Text:TStatus[ 2 ][ Players ];
new TGas[Players];
new Gas[MAX_VEHICLES];
new VeiculoConc[Max_Veiculos];
new CP[Players];
new bool:Oficina;
new bool:VeiculoOficina[Max_Veiculos];
new Tempo;
new TContando;
enum vinfo{
	vdono[128],
	vmodelo,
	vcor,
	vcor2,
	Float:vx,
	Float:vy,
	Float:vz,
	Float:va,
	vvalor,
}
new VI[Max_Veiculos][vinfo];
enum pInfo{//isso
	pSenha,
	pLevel,
	pDolar,
	pAdmin,
	pFome,
	pVicio,
	pEnergia,
	pViciado,
	bool:pDormiu,
	bool:pRegistrado,
	pSkin,
	pAvisos,
	pChaveCarro[5],
	pXp,
	pHConectado,
	pCLevel,
	pUpgrade,
	pGp,
	pOrg,
}
new PI[Players][pInfo];
enum codigoInfo{
	codigoVip[ 30 ],
	codigoValor,
	codigoEmail[ 128 ],
}
new SistemaCodigo[ Players ][ codigoInfo ];
enum vipInfo{
	vipLevel,
	vipTempo,
}
new SistemaVip[ Players ][ vipInfo ];
enum cInfo{

        Float:C_entradax,
        Float:C_entraday,
        Float:C_entradaz,
        Float:C_saidax,
        Float:C_saiday,
        Float:C_saidaz,
        C_valor,
        C_level,
        C_interior,
        C_virtual,
        C_dono[26],
        C_descricao[128],
        C_aluguel,
        bool:C_alugavel,
        C_modelocarro,
        Float:C_carrox,
        Float:C_carroy,
        Float:C_carroz,
        C_cor1,
        C_cor2,
        bool:C_comprada,
		bool:C_trancada,
		C_cofre,
		bool:C_vip,
}
new CI[MAX_CASAS][cInfo];
new PCasa[MAX_CASAS];
new Text3D:TCasa[MAX_CASAS];
enum sInfo{
	sFome,
	sVicio,
	sEnergia,
}
new SkillInfo[Players][sInfo];