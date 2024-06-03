//NÃO RETIRE O NICK DA INCLUDE, JUSTIN
/*
Criado por JUSTIN
NÃO REMOVER OS CRÉDITOS
ISSO É ANTI ÉTICO
OBRIGADO POR TODOS QUE COLABORARAM E ME DERAM APOIO PARA CODAR


*/
#include <a_samp>
#include <a_npc>


#if defined _dutils_included
  #endinput
#endif

#define _dutils_included
#pragma library dutils

#define MAX_STRING 255

new PRIVATE_Last_Money[MAX_PLAYERS];

/*
 * First version released by mike, this one created by DracoBlue
 * Has also a fix to use "-" and "+" in the beginning of the number.
 */
stock isNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
		|| (string[i]=='-' && i!=0)                                             // A '-' but not at first.
		|| (string[i]=='+' && i!=0)                                             // A '+' but not at first.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

/*
 * Originally created by mabako, tuned by DracoBlue
 */
stock mktime(hour,minute,second,day,month,year) {
	new timestamp2;

	timestamp2 = second + (minute * 60) + (hour * 3600);

	new days_of_month[12];

	if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) {
			days_of_month = {31,29,31,30,31,30,31,31,30,31,30,31}; // Schaltjahr
		} else {
			days_of_month = {31,28,31,30,31,30,31,31,30,31,30,31}; // keins
		}
	new days_this_year = 0;
	days_this_year = day;
	if(month > 1) { // No January Calculation, because its always the 0 past months
		for(new i=0; i<month-1;i++) {
			days_this_year += days_of_month[i];
		}
	}
	timestamp2 += days_this_year * 86400;

	for(new j=1970;j<year;j++) {
		timestamp2 += 31536000;
		if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )  timestamp2 += 86400; // Schaltjahr + 1 Tag
	}

	return timestamp2;
}


/**
 *  Return if a Email is valid or not
 *  @param   value
 */
stock ValidEmail(email[]) {
  new len=strlen(email);
  new cstate=0;
  new i;
  for(i=0;i<len;i++) {
    if ((cstate==0 || cstate==1) && (email[i]>='A' && email[i]<='Z') || (email[i]>='a' && email[i]<='z')  || (email[i]=='.')  || (email[i]=='-')  || (email[i]=='_'))
    {
    } else {
       // Ok no A..Z,a..z,_,.,-
       if ((cstate==0) &&(email[i]=='@')) {
          // its an @ after the name, ok state=1;
          cstate=1;
       } else {
          // Its stuff which is not allowed
          return false;
       }
    }
  }
  if (cstate<1) return false;
  if (len<6) return false;
  // A toplevel domain has only 3 to 4 signs :-)
  if ((email[len-3]=='.') || (email[len-4]=='.') || (email[len-5]=='.')) return true;
  return false;
}

/**
 *  Return a timestamp
 */
stock Time() {
  new hour,minute,second;
  new year, month,day;
  gettime(hour, minute, second);
  getdate(year, month, day);
  return mktime(hour,minute,second,day,month,year);
}


/**
 *  Return a timestamp
 */
stock Now() {
  new hour,minute,second;
  new year, month,day;
  gettime(hour, minute, second);
  getdate(year, month, day);
  return mktime(hour,minute,second,day,month,year);
}


/**
 *  Return the value of an hex-string
 *  @param string
 */
stock HexToInt(string[]) {
  if (string[0]==0) return 0;
  new i;
  new cur=1;
  new res=0;
  for (i=strlen(string);i>0;i--) {
    if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
    cur=cur*16;
  }
  return res;
}

/**
 *  Return the int as string
 *  @param   number
 */
stock IntToHex(number)
{
	new m=1;
	new depth=0;
	while (number>=m) {
		m = m*16;
		depth++;
	}
	depth--;
	new str[MAX_STRING];
	for (new i = depth; i >= 0; i--)
	{
		str[i] = ( number & 0x0F) + 0x30; // + (tmp > 9 ? 0x07 : 0x00)
		str[i] += (str[i] > '9') ? 0x07 : 0x00;
		number >>= 4;
	}
	str[8] = '\0';
	return str;
}

/**
 *  Return the string as int
 *  @param   string
 */
stock StrToInt(string[]) {
  return strval(string);
}

/**
 *  Return the value as string
 *  @param   value
 */
stock IntToStr(value) {
  new tmp[MAX_STRING];
  valstr(tmp, value);
  return tmp;
}

/**
 *  Return the truncated value
 *  @param   Float:value
 */
stock trunc(Float:value) {
	return floatround(value,floatround_floor);
}

/**
 *  Sets money for player
 *  @param   playerid
 *           howmuch
 */
stock SetPlayerMoney(playerid,howmuch) {
  PRIVATE_Last_Money[playerid]=howmuch;
  GivePlayerMoney(playerid,howmuch-GetPlayerMoney(playerid));
}

/**
 *  Copies a file (Source file won't be deleted!)
 *  @param   oldname
 *           newname
 *  @requires WINDOWS
 */
stock fcopy(oldname[],newname[]) {
	new File:ohnd,File:nhnd;
	if (!fexist(oldname)) return false;
	ohnd=fopen(oldname,io_read);
	nhnd=fopen(newname,io_write);
	new buf2[1];
	new i;
	for (i=flength(ohnd);i>0;i--) {
		fputchar(nhnd, fgetchar(ohnd, buf2[0],false),false);
	}
	fclose(ohnd);
	fclose(nhnd);
	return true;
}


/**
 *  Copies a textfile (Source file won't be deleted!)
 *  @param   oldname
 *           newname
 */
stock fcopytextfile(oldname[],newname[]) {
	new File:ohnd,File:nhnd;
	if (!fexist(oldname)) return false;
	ohnd=fopen(oldname,io_read);
	nhnd=fopen(newname,io_write);
	new tmpres[MAX_STRING];
	while (fread(ohnd,tmpres)) {
		StripNewLine(tmpres);
		format(tmpres,sizeof(tmpres),"%s\r\n",tmpres);
		fwrite(nhnd,tmpres);
	}
	fclose(ohnd);
	fclose(nhnd);
	return true;
}


/**
 *  Renames a file (Source file will be deleted!)
 *  @param   oldname
 *           newname
 *  @requires WINDOWS (because fcopy does)
 */
stock frename(oldname[],newname[]) {
    if (!fexist(oldname)) return false;
    fremove(newname);
    if (!fcopy(oldname,newname)) return false;
    fremove(oldname);
    return true;
}

/**
 *  Strips Newline from the end of a string.
 *  Idea: Y_Less, Bugfixing (when length=1) by DracoBlue
 *  @param   string
 */
stock StripNewLine(string[])
{
	new len = strlen(string);
	if (string[0]==0) return ;
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) {
		string[len - 1] = 0;
		if (string[0]==0) return ;
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
	}
}

/**
 *  Copies items from one array/string into return.
 *  @param   source
 *           index (where to start, 0 is first)
 *           numbytes (how much)
 */
stock copy(dest[],source[],count) {
	dest[0]=0;
	if (count<0) return false;
	if (count>strlen(source)) count=strlen(source);
	new i=0;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
		if (source[i]==0) return true;
	}
	dest[count]=0;
	return true;
}


/**
 *  Deletes the first 'count' items of a array/string
 *  @param   string[]
 *           count
 */
stock delete(string[],count) {
	new tmp[MAX_STRING];
	tmp[0]=0;
	if (count<=0) {
		format(tmp,sizeof(tmp),"%s",string);
		return tmp;
	}
	tmp=ret_memcpy(string,count,strlen(string));
	return tmp;
}

/**
 *  Sets a string's value to source.
 *  @param   dest
 *           source
 *           count
 */
stock set(dest[],source[]) {
	new count = strlen(source);
	new i=0;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
	}
	dest[count]=0;
}

/**
 *  Checks wether two strings are equal (case insensetive)
 *  @param   str1
 *           str2
 */
stock equal(str1[],str2[],bool:ignorecase) {
    if (strlen(str1)!=strlen(str2)) return false;
    if (strcmp(str1,str2,ignorecase)==0) return true;
    return false;
}

/**
 *  Returns an element of a string splitted by ' ', default index is 0.
 *  @param   string
 *           index
 */

stock mod(up,down) {
  return up-(floatround((up/down),floatround_floor))*down;
}

stock div(up,down) {
  return (floatround((up/down),floatround_floor));
}

/**
 *  Returns a hashed value in adler32 as int
 *  @param   buf
 */
stock num_hash(buf[])
 {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++) {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
 }

/**
 *  Returns a hashed value in adler32 as string
 *  @param   buf
 */
stock hash(str2[]) {
   new tmpdasdsa[MAX_STRING];
   tmpdasdsa[0]=0;
   valstr(tmpdasdsa,num_hash(str2));
   return tmpdasdsa;
}

/**
 *  Returns a string which has 'newstr' where 'trg' was before
 *  @param   trg
 *           newstr
 *           src
 */
stock strreplace(trg[],newstr[],src[]) {
    new f=0;
    new s1[MAX_STRING];
    new tmp[MAX_STRING];
    format(s1,sizeof(s1),"%s",src);
    f = strfind(s1,trg);
    tmp[0]=0;
    while (f>=0) {
        strcat(tmp,ret_memcpy(s1, 0, f));
        strcat(tmp,newstr);
        format(s1,sizeof(s1),"%s",ret_memcpy(s1, f+strlen(trg), strlen(s1)-f));
        f = strfind(s1,trg);
    }
    strcat(tmp,s1);
    return tmp;
}

/**
 *  Returns the string with lowercase
 *  @param   txt
 */
stock strlower(txt[]) {
	new tmp[MAX_STRING];
	tmp[0]=0;
	if (txt[0]==0) return tmp;
	new i=0;
	for (i=0;i<strlen(txt);i++) {
		tmp[i]=tolower(txt[i]);
	}
	tmp[strlen(txt)]=0;
	return tmp;
}

/**
 *  Returns the string with uppercase
 *  @param   txt
 */
stock strupper(txt[]) {
	new tmp[MAX_STRING];
	tmp[0]=0;
	if (txt[0]==0) return tmp;
	new i=0;
	for (i=0;i<strlen(txt);i++) {
		tmp[i]=toupper(txt[i]);
	}
	tmp[strlen(txt)]=0;
	return tmp;
}
new HouseEntered[MAX_PLAYERS];
new BizzEntered[MAX_PLAYERS];
/*new vehName[][] = {
"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster",
"Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto",
"Taxi","Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee",
"Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo",
"RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer",
"Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer",
"PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale","Oceanic","Sanchez","Sparrow","Patriot",
"Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina","Comet","BMX",
"Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo",
"Greenwood","Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa",
"RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT","Elegant",
"Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain","Nebula","Majestic",
"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona",
"FBI Truck","Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight",
"Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob",
"Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A","Monster B","Uranus",
"Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight",
"Trailer","Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford",
"BF-400","Newsvan","Tug","Trailer A","Emperor","Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C",
"Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)","Police Car (LVPD)","Police Ranger",
"Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
"Stair Trailer","Boxville","Farm Plow","Utility Trailer" };*/
new Music[MAX_PLAYERS];
new Songs[7][1] = {
{1187}, {1185}, {1183}, {1097}, {1076}, {1068}, {1062}
};
enum justen_Info
{
	pMotivo[126],
	pAdmBan[MAX_PLAYER_NAME],
	pData[20],
	pHora[20],
	pNick[64],
    banIP[128]
};
new BanInfo[MAX_PLAYERS][justen_Info];


enum pSpec {
	Float:Coords[3],
	Float:sPx,
	Float:sPy,
	Float:sPz,
	sPint,
	sLocal,
	sCam,
};

new Unspec[MAX_PLAYERS][pSpec];
enum pInfo {
    pWTFreq,
    pKey,
	pLevel,
	pSpawn,
	pAdmin,
	pRegularRank,
	gPupgrade,
	pConnectSeconds,
	pReg,
	pSex,
	pAge,
	pOrigem,
    pHaveWalkie,
    pHotel,
    pOculos,
    pAnabU,  
    pSkin1,
    pSkin2,
    Float:pComida,
    pEtnia,
	pCK,
	pMuted,
	pFrozen,
	pExp,
	pCash,
	pAccount,
	pCrimes,
	pWanted,
	pCrimeReason[128],
	pWantedLevel,
	pKills,
	pDeaths,
	pWhyLeft[24],
	pArrested,
	pWantedDeaths,
	pSCT, 
	pLottoNr,
	pGasQuantia,
    pCaminhoneiroT,//caminhoneiro
    pJob,
	pPayCheck,
	pTanabolisante,
	pJailed,
	pJailTime,
    pMats,
	pDrugs,//Não usada
	pLeader,
	pMember,
	pFMember,
	pRank,
	pChar,
	pContractTime,
	Float:pHealth,
	Float:pSHealth,
	Float:pArmour,
	pInt,
	pInteriorNr,
	pLocal,
	pTeam,
	pModel,
	pPnumber,
	pPhousekey,
	pPcarkey,
	pPcarkey2,
	pPbiskey,
	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	pCarLic,
	pFlyLic,
	pBoatLic,
	pTruckLic,
	pGunLic,
	pPayDay,
	pPayDayHad,
	pWatch,
	pCrashed,
	pAlcoholPerk,
	pDrugPerk,
	pTraderPerk,
    pTut,
	pWarns,
	pVirWorld,
	pFuel,
	pMarried,
	pUseAccent,
    pVoz[128],
    pAccent[128],
    pMarriedTo[128],
	pFishTool,
	pApp[128],
    pTato[128],
    pPeso,
	pAltura,
    pBandana,
    //
    pTelNote1[128],
	pTelNote1s,
	pTelNote2[128],
	pTelNote2s,
	pTelNote3[128],
    pTelNote3s,
	//
    pNote1[128],
	pNote1s,
	pNote2[128],
	pNote2s,
	pNote3[128],
	pNote3s,
	pNote4[128],
	pNote4s,
	pNote5[128],
	pNote5s,
	pInvWeapon,
	pInvAmmo,
    pInvWeapon2,
	pInvAmmo2,
	pInvWeapon3,
	pInvAmmo3,
	pInvWeapon4,
	pInvAmmo4,
	pInvWeapon5,
	pInvAmmo5,
	pInvWeapon6,
	pInvAmmo6,
	pLighter,
	pCigarettes,
	pRequestingBackup,
	pRoadblock,
	pMaskNumber,
    pPoliceScanner,
    pPoliceScannerOn,
    pInvestimento,
	pInvestimentoTipo,
    //pInvestimentoNome[128],
    pMask,
	pMaskuse,
	pAdminDuty,
	pHelper,
	pBlind,
	pSpeedo,
	pWarned,
	pHideNumber,
	pSpeaker,
	pSwat,
	pAnabolisante,
	pDuty,
	pGPS,
	pCabelo,
    pFS,
	pBoxiSkill,
	pKneeSkill,
	pKungSkill,
	pGrabSkill,
	pElbowSkill,
	pViciado,
    pCD,
	pViewPms,
	pAppearList,
	pAndro,
	pJet,
	pAmmuTrainTime,
 	pPistSkill,
	pSilenSkill,
	pDesertSkill,
	pShotgSkill,
	pSawnSkill,
	pCombSkill,
	pUziSkill,
	pSmgSkill,
	pAkSkill,
	pM4Skill,
	pSnipSkill,
	pShiftName,
	pWeapon,
	pWeapon2,
	pWeapon3,
	pWeapon4,
	pWeapon5,
	pWeapon6,
	pWeapon7,
	pWeapon8,
	pWeapon9,
	pWeapon10,
	pWeapon11,
	pWeapon12,
	pAmmo,
	pAmmo2,
	pAmmo3,
	pAmmo4,
	pAmmo5,
	pAmmo6,
	pAmmo7,
	pAmmo8,
	pAmmo9,
	pAmmo10,
	pAmmo11,
 	pAmmo12,
 	pChatMode,
 	pPunishment1[128],
	pPunishment2[128],
	pPunishment3[128],
	pPunishment4[128],
	pPunishment5[128],
	pPunishment6[128],
	pPunishment7[128],
	pPunishment8[128],
	pIP[24],
	pLastSeen[24],
	pRegistredDate[24],
	pNextPunishment,
	pPunished,
	pTazerBullets,
	jTColete,   //by rick
	pDecoder,
	pLSP,
    pASOS,
    pForca,
    pATrab,
    pRusso,
    pJapones,
    pEspanhol,
    pItaliano,
    pFacul,
    pMotoboy,
    pVipPoints,
    pPDPoints,
    pPDPoints2,
    pAutoNivel,
    pTOnota,
    p2Level,
    pG3000,
    pG5000,
    pSDEmprego,
    pTEstilos,
    pG7000,
    //Anti WH by Ricardo brasil
    j_9mm,
    j_9mmB,
    j_pSilenced,
    j_pSilencedB,
    j_pDesert,
    j_pDesertB,
    j_pShotgun,
    j_pShotgunB,
    j_pMicroUzi,
    j_pMicroUziB,
    j_pMp5,
    j_pMp5B,
    j_pAK47,
    j_pAK47B,
    j_pM4,
    j_pM4B,
    j_pTec9,
    j_pTec9B,
    j_pCountry,
    j_pCountryB,
    j_pSniper,
    j_pSniperB,
    //                         fim do AWH
    pPescou,
	pTratorou,
    pCarteirou,
    pMultado,//Não usado
    pMaconha,
    pMaconhaM,
    pLSD,
    pLSDM,
    pCocaina,
    pCocainaM,
    pCrack,
    pCrackM,
    pNovaDroga,
    pNovaDrogaNome,
    pNovaDroga2,
    pNovaDrogaNome2,
    pDrogaSkill,
    pMistura1,
    pMistura2,
    pMistura3,
    pMistura4,
    pMistura5,
    pMaconhaVicio,
    pCrackVicio,
    pLSDVicio,
    pCocainaVicio,
    pChapeuID,
    pCaminhaoInCity,
    pGuardaVidas, 
    pHaval,
    pAdmNome[MAX_PLAYER_NAME],
    pOlhos,
    pHelperData[128],
    pLenhador,
    pLogado,
    pHistoria,
    pNoticia[0x80],
    pTestamento,
    pAKVP,
    pDEVP,
};
new PlayerInfo[MAX_PLAYERS][pInfo];//by j____st___en!

new pmodelid[MAX_PLAYERS] = 0;
new j_Emprego6, portaoaero = 0, portaoficina, portaoficina2, lspdChat = 1;
new j_QuadBike[MAX_PLAYERS] = 0x0, j_Injected[MAX_PLAYERS] = 0x0, j_JustinBote[MAX_PLAYERS] = 0x0;
new cargailegal, carga[9], j_cargando[MAX_PLAYERS] = 0x0, facingangletimer;
new lenhador[4], Lenhando[MAX_PLAYERS], VagaEscolhida, j_UsouDrogas[MAX_PLAYERS] = 0x0;
new contrabandocar[4];
new NoRadar[MAX_PLAYERS];

new Text:j_ADLogo0;                        //LOGO DO AD_RP
new Text:j_ADLogo1;                        //LOGO DO AD_RP
new Text:j_ADPersonalise;                  //TUTORIAL
new Text:GN_Draw1[MAX_PLAYERS], Text:GN_Draw2[MAX_PLAYERS], Text:GN_Draw3[MAX_PLAYERS];
new Text:GN_Draw4[MAX_PLAYERS], Text:GN_Draw5[MAX_PLAYERS], Text:GN_Draw6[MAX_PLAYERS], Text:GN_Draw7[MAX_PLAYERS];
new Radares = 0;
new Text:j_TD0[MAX_PLAYERS], Text:j_TD1[MAX_PLAYERS], Text:j_TD2[MAX_PLAYERS], Text:j_TD3[MAX_PLAYERS], Text:j_TD4[MAX_PLAYERS];//GASOLINA


new FaixaIP[] = { 142 };

/* ----------------------------- [DIALOGS] ----------------------------- */
//

#define                 DIALOG_LSPD                                (1750)  
#define                 DIALOGID                                (1700)  
#define                 DIALOG_MENU3                            (1602)
#define                 DIALOG_ENCDROGA                         (1579)
#define                 DIALOG_MENU2                            (1601)
#define                 DIALOG_INVENTARIO                       (1577)
#define                 DIALOG_INFOLSPD                         (1576)
#define                 DIALOG_AVALIE                           (1575)
#define                 DIALOG_FAMILIAS                         (1574)
#define                 DIALOG_MENU                             (1600)
#define                 DIALOG_PLICENCAS4                       (1572)
#define                 DIALOG_PLICENCAS3                       (1571)
#define                 DIALOG_PLICENCAS2                       (1570)
#define                 DIALOG_PLICENCAS                        (1569)
#define                 DIALOG_LICENCAS3                        (1569)
#define                 DIALOG_LICENCAS2                        (1568)
#define                 DIALOG_LICENCAS                         (1567)
#define                 DIALOG_MEDICOS                  	(1566)
#define                 DIALOG_MEDICOS2                 	(1565)
#define                 DIALOG_MEDICOS3                 	(1564)
#define                 DIALOG_MEDICOS4                 	(1563)
#define                 DIALOG_MEDICOS5                 	(1562)
#define                 DIALOG_ANUNCIO                          (1561)
#define                 DIALOG_ANUNCIO2                         (1560)
#define                 DIALOG_ANUNCIO3                         (1559)
#define                 DIALOG_ANUNCIO4                         (1558)
#define                 DIALOG_ANUNCIO5                         (1557)
#define                 VPBYRICK                                (1556)
#define                 DIALOG_NADA                             (24024)
#define                 DIALOGFACULDADE                         (1551)
#define                 DIALOGESTUDORUSSO                       (1552)
#define                 DIALOGESTUDOJAPONES                     (1553)
#define                 DIALOGESTUDOESPANHOL                    (1554)
#define                 DIALOGESTUDOITALIANO                    (1555)
#define                 DIALOG_MALETA                           (1032)
#define                 DIALOG_CELULAR                          (1030)
#define                 DIALOG_CELULAR2                         (1029)
#define                 DIALOG_CELULAR3                         (1028)
#define                 DIALOG_CELULAR4                         (1027)
#define                 DIALOG_CELULAR5                         (1031)
#define                 DIALOG_ARMAMAFIA                        (1026)
#define                 Investimento0                           (1022)
#define                 Investimento1                           (1023)
#define                 Investimento2                           (1024)
#define                 TUTO                                    (990)
#define                 HOSPEDAGEM                              (991)
#define                 HOSPEDAGEM2                             (992)
#define                 DIALOGSAVE                              (19990)
#define                 DIALOGSAVE1                             (19991)
#define                 DIALOGSAVE2                             (19992)
#define                 DIALOGSAVE3                             (19993)
#define                 DIALOGSAVE4                             (19994)
#define                 DIALOGSAVE5                             (19995)
#define                 DIALOGACE                               (200)   //Acessórios
#define                 DIALOGACE1                              (201)
#define                 DIALOGACE2                              (202)
#define                 DIALOGACE3                              (203)
#define                 DIALOGACE4                              (204)
#define                 DIALOGACE5                              (205)
#define                 DIALOGACE6                              (206)
#define                 DIALOGACE7                              (207)
#define                 DIALOGACE8                              (208)
#define                 DIALOGACE9                              (209)
#define                 DIALOGACE10                             (210)
#define                 DIALOGACE11                             (211)
#define                 DIALOGMAFIA                             (800)  //Menu de informação p/deposito
#define                 DIALOGMAFIA1                            (811) //Menu do depósito
#define                 DIALOGMAFIA2                            (801)  //Menu Sacar
#define                 DIALOGMAFIA3                            (802) //Sacar Grana
#define                 DIALOGMAFIA4                            (803) //Sacar Mats
#define                 DIALOGMAFIA5                            (804) //SACAR ARMA
#define                 DIALOGMAFIA7                            (806) //Depositar Armas
#define                 DIALOGMAFIA8                            (807) //Depositar mats
#define                 DIALOGMAFIA9                            (808)   //Depositar Grana
#define                 DIALOGMAFIAINFO                         (812) //Info
#define                 COFREORG                                (813) // Menu
#define                 COFREORG2                               (814) // Saldo
#define                 COFREORG3                               (815) // Depósito feito
#define                 COFREORG4                               (816) // Sacar
#define                 DIALOG_MDC                              (820)
#define                 DIALOG_MDC1                             (824)
#define                 DIALOG_MDCPLACA                         (821)
#define                 DIALOG_MDC3                             (822)
#define                 DIALOG_MDCNOME                          (823)
#define                 DIALOG_MDCNOME2                         (824)
#define                 DIALOG_MDCNOME3                         (825)

#define PD                                                                      ProxDetector
#define SCM 						                                            SendClientMessage
#define SetPlayerHoldingObject(%1,%2,%3,%4,%5,%6,%7,%8,%9) SetPlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1,%2,%3,%4,%5,%6,%7,%8,%9)
#define StopPlayerHoldingObject(%1) RemovePlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)
#define IsPlayerHoldingObject(%1) IsPlayerAttachedObjectSlotUsed(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)
//#define MAX_PLAYER_ATTACHED_OBJECTS 5 // Número de Objetos presos no jogador na qual o máximo é 5 = 0-4..      By JUSTIN
#define MAX_STRING 255



#define DEF                                                                     0x96C184AA
#define COLOR_ASKQ                                                              0xFF0000FF
#define COLOR_WALKIE                                                            0x00C6C6AA
#define COLOR_GRAD1                                                             0xB4B5B7FF
#define COLOR_GRAD2                                                             0xBFC0C2FF
#define COLOR_GRAD3                                                             0xCBCCCEFF
#define COLOR_GRAD4                                                             0xD8D8D8FF
#define COLOR_GRAD5                                                             0xE3E3E3FF
#define COLOR_GRAD6                                                             0xF0F0F0FF
#define COLOR_GREY                                                              0xAFAFAFAA
#define COLOR_GREEN                                                             0x9EC73DAA
#define COLOR_GROVE                                                             0x00FF00FF
#define COLOR_RED                                                               0xEC0000AA
#define COLOR_COOLRED                                                           0xB35959AA
#define COLOR_ORANGE                                                            0xFF9900AA
#define COLOR_PINK                                                              0xFF66FFAA
#define COLOR_DARKRED                                                           0x660000AA
#define COLOR_BRIGHTRED                                                         0xFF0000AA
#define COLOR_INDIGO                                                            0x4B00B0AA
#define COLOR_VIOLET                                                            0x9955DEEE
#define CAZUL                                                                   0xADC7E7AA
#define COLOR_GRAYWHITE                                                         0xEEEEFFC4
#define COLOR_LIGHTNEUTRALBLUE                                                  0xabcdef66
#define COLOR_GREENISHGOLD                                                      0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN                                                    0x0FFDD349
#define COLOR_NEUTRALBLUE                                                       0xABCDEF01
#define COLOR_LIGHTCYAN                                                         0xAAFFCC33
#define COLOR_LEMON                                                             0xDDDD2357
#define COLOR_LIGHTRED                                                          COLOR_RED //0xFF6347AA
#define COLOR_LIGHTBLUE                                                         0x33CCFFAA
#define COLOR_LIGHTGREEN                                                        0x9ACD32AA
#define COLOR_YELLOW                                                            0xDABB3EAA
#define COLOR_YELLOW2                                                           0xF5DEB3AA
#define COLOR_WHITE                                                             0xEEEEEEAA
#define COLOR_FADE1                                                             0xE6E6E6E6
#define COLOR_FADE2                                                             0xC8C8C8C8
#define COLOR_FADE3                                                             0xAAAAAAAA
#define COLOR_FADE4                                                             0x8C8C8C8C
#define COLOR_FADE5                                                             0x6E6E6E6E
#define COLOR_PURPLE                                                            0xC2A2DAAA
#define COLOR_CHAT1                                                             0xF9B7FFAA
#define COLOR_CHAT2                                                             0xE6A9ECAA
#define COLOR_CHAT3                                                             0xC38EC7AA
#define COLOR_CHAT4                                                             0xD2B9D3AA
#define COLOR_CHAT5                                                             0xC6AEC7AA
#define COLOR_ALLDEPT                                                           0xFF8282AA
#define COLOR_NEWS                                                              0x458E1DAA
#define COLOR_OOC                                                               0xE0FFFFAA
#define OBJECTIVE_COLOR                                                         0x64000064
#define TEAM_GREEN_COLOR                                                        0xFFFFFFAA
#define TEAM_JOB_COLOR                                                          0xFFB6C1AA
#define TEAM_HIT_COLOR                                                          0xFFFFFF00
#define TEAM_BLUE_COLOR                                                         0x8D8DFF00
#define TEAM_RADIO_COLOR                                                        0xF2D068FF
#define COLOR_ADD                                                               0x63FF60AA
#define TEAM_GROVE_COLOR                                                        0x00D900C8
#define TEAM_VAGOS_COLOR                                                        0xFFC801C8
#define TEAM_BALLAS_COLOR                                                       0xD900D3C8
#define TEAM_AZTECAS_COLOR                                                      0x01FCFFC8
#define TEAM_CYAN_COLOR                                                         0xFF8282AA
#define COLOR_CREAM                                                             0xFF8282AA
#define TEAM_ORANGE_COLOR                                                       0xFF830000
#define TEAM_COR_COLOR                                                          0x39393900
#define TEAM_BAR_COLOR                                                          0x00D90000
#define TEAM_TAT_COLOR                                                          0xBDCB9200
#define TEAM_CUN_COLOR                                                          0xD900D300
#define TEAM_STR_COLOR                                                          0x01FCFF00
#define TEAM_ADMIN_COLOR                                                        0x00808000
#define COLOR_SIMPSONS                                                          0xFFD90FAA
#define COLOR_SEA                                                               0x00808000
#define COLOR_INVIS                                                             0xAFAFAF00
#define COLOR_SPEC                                                              0xBFC0C200
#define COLOR_BLUE                                                              0x2641FEAA
#define COLOR_DBLUE                                                             0x3333CCAA
#define COLOR_DARKNICERED                                                       0x9D000096
#define COLOR_LIGHT_BLUE                                                        0xa9c4e4FF
//BY JUSTIN


#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1


#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#if defined _zones_included
	#endinput
#endif
#define _zones_included

#define MAX_ZONE_NAME 38

#define GREEN 0x21DD00FF
#define RED 0xE60000FF
#define YELLOW 0xFFFF00FF
#define ORANGE 0xF97804FF
#define GRAY 0xCECECEFF
#define COLOR_TRUE                                                              0x33AA33AA
#define COR_AMAR 																0xDEEB63AA
#define COLOR_WOW 																0xF0F8FFAA
#define LIGHTBLUE 0x00C2ECFF
#define DrivingTestCash 5000 // Edit this if needed. 5000 = the cash that you'll pay to take the driving test
#define TooSlow 120 // 120 = if the time is 120 or more, you are driving too slow. You may edit this if needed.
#define TooFast 105 // 105 = if the time is less than 105, you are driving too fast. You may edit this if needed.
#define MINVEHHP 600 // 600 = the minimum vehicle health the vehicle can have to pass the test. You may edit this if needed.
#define COP_COLOR 0x6363C0AA
#define cop_color 0xC2A2DAFF
#define COLOR_BLACK 0x000000FF
#define COLOR_NICERED 0xFF0000FF

forward GetDigits(number);
//forward Vida();
forward NameTimer1();
forward ParaJustinsz(playerid);
forward RefreshMenuHeader(playerid,Menu:menu,text[]);
forward MinutesToSeconds(minutes);
//forward ResetRoadblockTimer();
forward RemoveRoadblock(playerid);
forward BackupClear(playerid, calledbytimer);
forward IsAGangCar(carid);
forward IsAGangCar2(carid);
forward IsAGangCar3(carid);
forward IsAGangCar4(carid);
new Aeroportando[MAX_PLAYERS];
forward IsAGangCar5(carid);
forward IsAGangCar6(carid);
forward IsAGangCar7(carid);
forward IsABike(carid);
//forward IsAOBike(carid);
forward IsATank(carid);
forward DrankWine(playerid);
forward SmokedCig(playerid);
forward DrankBeer(playerid);
forward DrankSprunk(playerid);
forward GateClose(playerid);
forward GateClose2();
forward GateClose3();
forward GateClose4();
forward GateClose5();
forward GateClose6();
forward AmmuTrain();
forward RegularCount();
forward elevator1(playerid);
forward elevator2(playerid);
forward elevator3(playerid);
forward elevator4(playerid);
forward LoadProperty();
forward LoadCar();
forward LoadSecurity();
forward SaveSecurity();
forward LoadBizz();
forward LoadSBizz();
forward LoadStuff();
forward SaveStuff();
forward SaveAnticheat();
forward LoadAnticheat();
forward SaveMotd();
forward LoadMotd();
//forward SaveEvents();
//forward LoadEvents();
forward SalvarMafia();
forward CarregarMafia();
forward LoadFamilies();
forward SaveFamilies();
forward LoadPapers();
forward SavePapers();
forward SetPlayerSkills(playerid);
forward LoadBoxer();
forward SaveBoxer();
forward OnPropUpdate(update,idx);
forward OnPropTextdrawUpdate(update, id);
forward OnHousePickupUpdate(houseid);
forward ExtortionBiz(bizid, money);
forward ExtortionSBiz(bizid, money);
forward IsAtClothShop(playerid);
forward IsAtGasStation(playerid);
forward IsAtBar(playerid);
forward SearchingHit(playerid);
forward DollahScoreUpdate();
forward SetPlayerSpawn(playerid);
forward SetupPlayerForClassSelection(playerid);
forward SetPlayerTeamFromClass(playerid,classid);
forward CrimInRange(Float:radi, playerid,copid);
forward SendEnemyMessage(color, string[]);
forward SendTeamBeepMessage(team, color, string[]);
forward SendSOSMessage(color,const string[],level);
forward ABroadCast(color,const string[],level);
forward SendGMMessage(color,const string[],level);
forward GetClosestPlayer(p1);
forward PrintBizInfo(playerid,targetid);
forward PrintSBizInfo(playerid,targetid);
forward SetPlayerUnjail();
forward OtherTimer();
forward GpsCheck();
forward HideSpeedo(playerid);
forward RingTonerRev();
forward RingToner();
forward HireCost(carid);
forward BanLog(string[]);
forward AdminLog(string[]);
forward ReportLog(string[]);
forward EntregarArmaLog(string[]);
forward DivulguerLog(string[]);
//portamalas log
forward PortamalasColocarArmaLog(string[]);
forward PortamalasRetirarArmaLog(string[]);
//
forward RetirarArmaLog(string[]);
forward ColocarArmaLog(string[]);
forward CasaColocarLog(string[]);
forward CasaRetirarLog(string[]);
forward EmpresaRetirar(string[]);
forward CommandLog(string[]);
forward AllCommandLog(string[]);
forward ExplodeLog(string[]);
forward ChiterLog(string[]);
forward VendaLog(string[]);
forward MovesLog(string[]);
forward PlaceLog(string[]);
forward TelesLog(string[]);
forward WTLog(string[]);
forward CelularLog(string[]);
forward ChatLog(string[]);
//forward SenhasLog(string[]);
forward BugsLog(string[]);
forward AdminChatLog(string[]);
forward GiveLog(string[]);
forward FamilyChatLog(string[]);
forward LocalChatLog(string[]);
forward PublicLog(string[]);
forward AnnounceLog(string[]);
forward CofreOrgLog(string[]);
forward SlapLog(string[]);
forward LoginLog(string[]);
forward MuteLog(string[]);
forward FreezeLog(string[]);
forward JailLog(string[]);
forward RadioChatLog(string[]);
forward PMLog(string[]);
forward APMLog(string[]);
forward DepartmentChatLog(string[]);
forward VenderArmaLog(string[]);
forward KickLog(string[]);
forward WarnLog(string[]);
forward ActionLog(string[]);
forward PayLog(string[]);
forward CKLog(string[]);
forward IsATruck(carid);
forward IsAPizzabike(carid);
forward IsANewsCar(carid);
forward IsATaxicar(carid);
forward IsABus(carid);
forward IsATowcar(carid);
forward IsAnAmbulance(carid);
forward IsAnFiretruck(carid);
forward IsACopCar(carid);
forward IsAnFbiCar(carid);
forward IsNgCar(carid);
forward IsASwatCar(carid);
forward IsATacticalCar(carid);
forward EmpresaBike(carid);
forward EmpresaCarro(carid);
forward IsASpecialFCar(carid);
forward IsAGovernmentCar(carid);
forward IsAnOwnableCar(carid);
forward IsACreatedCar(carid);
forward IsARentableCar(carid);
//forward IsARentableBike(carid);
forward IsASalesVehicle(vehicleid);
forward GetVehiclePrice(vehicleid);
forward IsAtDealership(playerid);
forward IsAtCarrental(playerid);
forward IsAPlane(carid);
forward IsABoat(carid);
forward IsAHarvest(carid);
forward IsADrugHarvest(carid);
forward IsASmuggleCar(carid);
forward IsASweeper(carid);
forward IsATrator(carid);
forward IsACop(playerid);
forward IsAFiremen(playerid);
forward IsAMedic(playerid);
forward IsAnFbi(playerid);
forward IsAnNg(playerid);
forward IsASwat(playerid);
forward IsPlayerOnSpecialAction(playerid);
forward IsAPDMember(playerid);
forward IsAMember(playerid);
forward IsANorteno(playerid);
forward Spectator();
forward ConvertTicks(ticks);
forward Encrypt(string[]);
forward GameModeExitFunc(playerid);
forward SetAllPlayerCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi, num);
forward SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi);
forward SetPlayerCriminal(playerid,declare,reason[]);
forward SetPlayerCriminalEx(playerid,declare,reason[]);
forward SetPlayerFree(playerid,declare,reason[]);
forward SetPlayerWeapons(playerid);
forward ShowStats(playerid,targetid);
forward SetPlayerToTeamColor(playerid);
forward GameModeInitExitFunc();
forward split(const strsrc[], strdest[][], delimiter);
forward OnPlayerLogin(playerid,password[]);
forward OnPlayerUpdateEx(playerid);
forward OnPlayerRegister(playerid, password[]);
forward BroadCast(color,const string[]);
forward OOCOff(color,const string[]);
forward OOCNews(color,const string[]);
forward SendPSMessage(color, string[]);
forward SendLSPMessage(color, string[]);
forward SendJobMessage(job, color, string[]);
forward SendFamilyMessage(family, color, string[]);
forward SendNewFamilyMessage(family, color, string[]);
forward SendTeamMessage(team, color, string[]);
forward SendRadioMessage(member, color, string[]);
forward SendAdminMessage(color, string[]);
forward SendTesterMessage(color, string[]);
forward AddCar(carcoords);
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward ProxDetectorB(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward ProxDetectorS(Float:radi, playerid, targetid);
forward ClearFamily(family);
forward ClearPaper(paper);
forward ClearCrime(playerid);
forward Lotto(number);
forward CarCheck();
forward CarInit();
forward CarTow(carid);
forward CarRespawn(carid);
forward LockCar(carid);
forward UnLockCar(carid);
forward InitLockDoors(playerid);
forward CheckGas();
forward Fillup();
forward ResetJump1(playerid);
forward StoppedVehicle();
forward SyncTime();
forward SyncUp();
forward SaveAccounts();
forward ResetDildo(playerid);
forward Production();
new aOnline = 0;
new helperOnline = 0;
new empresastring[256];
new productiontimer;
forward PayDay();
forward ini_GetKey( line[] );
forward ini_GetValue( line[] );
forward PlayerPlayMusic(playerid);
forward StopMusic();
forward PlayerFixRadio(playerid);
forward PlayerFixRadio2();
forward HouseLevel(playerid);
forward CHouseLevel(houseid);
forward CustomPickups();
forward IdleKick();
forward SetCamBack(playerid);
forward AddsOn();
forward IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy);
forward AdvertiseToPlayersAtBusStop(Float:stopX, Float:stopY, Float:stopZ, eastorwest);
forward SendBusRoute(playerid, eastorwest);
forward IsInBusrouteZone(playerid);
forward BusrouteEnd(playerid, vehicleid);
forward CreateFoodMenus();
forward OnPlayerEnterFood(playerid, foodid);
forward OnPlayerExitFood(playerid);
forward ClearChatBox(playerid, lines);
forward CreateGuideMenus();
//forward CreateLegalJobsMenus();
//forward CreateLicensesMenus();
forward Startup(playerid, vehicleid);
forward engine2(playerid);
forward CarregamentoGas(playerid);
forward DescarregamentoGas(playerid);
forward busroutestoptimer(playerid);
forward CheckCarHealth();
forward StartingTheVehicle(playerid);
forward FarmerExit(playerid);
forward DrugFarmerExit(playerid);
forward LoadDrugSystem();
forward SaveDrugSystem();
forward LoadMatsSystem();
forward SaveMatsSystem();
forward ChangeWeather();
forward LoadingDrugsForSmugglers(playerid);
forward SmugglerExit(playerid);
forward SafeSetPlayerPos(playerid, Float:x, Float:y, Float:z);
forward SafeSetPlayerArmour(playerid, Float:armour);
forward SafeGivePlayerMoney(plyid, amounttogive);
forward SafeSetPlayerInterior(plyid, interiorid);
forward SafeGivePlayerWeapon(playerid, weaponid, ammo);
forward SafeResetPlayerMoney(plyid);
forward SafeResetPlayerWeapons(playerid);
forward UnsetFirstSpawn(playerid);
forward LoadHQLocks();
forward SaveHQLocks();
forward ClearKnock(playerid);
forward DrugEffectGone(playerid);
forward PodeUsarAjuda(playerid);
forward UsingDrugsUnset(playerid);
forward UpdatePlayerPosition(playerid);
forward UpdateAllPlayersPosition();
forward SaveAllGuns();
forward SaveGuns(playerid);
forward CrashPlayer(playerid);
forward AfterSpray1(playerid);
forward AfterSpray2(playerid);
forward AfterSpray3(playerid);
forward AfterSpray4(playerid);
forward UnsetCrash(playerid);
forward backtoclothes(playerid);
forward RemovePlayerWeapon(playerid, weaponid);
forward PeterAC();
forward UpdateBurgerPositions();
forward ShowMenuBurger(i);
forward UpdateChickenPositions();
forward ShowMenuChicken(i);
forward CanDriveThruAgain(playerid);
forward Float:GetDistance(playerid, Float:x, Float:y);
forward UsarBan(playerid);
forward UsarB(playerid);
forward PodeSOS(playerid);
forward ReportReset(playerid);
forward ReduceTimer(playerid);
forward ChangeName(playerid);
forward HideTD2();
forward HideTD3();
forward HideTD4();
forward HideTD5();
forward HideTD6();
forward HideWarnTextdraw(playerid);
forward BoxTrain(playerid);
forward KungTrain(playerid);
forward GrabTrain(playerid);
forward KneeTrain(playerid);
forward prisonls(playerid);
forward lvls(playerid);
forward lvslv(playerid);
forward lvsf(playerid);
forward lvap(playerid);
forward lvsmc(playerid);
forward lvsrc(playerid);
forward lvsls(playerid);
forward lvssf(playerid);
forward lvstr(playerid);
forward lvsbc(playerid);
forward lslv(playerid);
forward lsslv(playerid);
forward lssf(playerid);
forward lsap(playerid);
forward lssmc(playerid);
forward lssrc(playerid);
forward lssls(playerid);
forward lsssf(playerid);
forward lsstr(playerid);
forward lssbc(playerid);
forward sflv(playerid);
forward sfslv(playerid);
forward sfls(playerid);
forward sfap(playerid);
forward sfsmc(playerid);
forward sfsrc(playerid);
forward sfsls(playerid);
forward sfssf(playerid);
forward sfstr(playerid);
forward sfsbc(playerid);
forward aplv(playerid);
forward SendMSG(playerid);
forward HideSpeedGun(playerid);
forward ShowSpeedGun(playerid);
forward StartLotto();
forward TrainPistol(playerid);
forward SafeRemovePlayerFromVehicle(playerid);
forward TrainSilenced(playerid);
forward UnsetSuspect(playerid);
forward TrainDeagle(playerid);
forward TrainShotgun(playerid);
forward TrainSawn(playerid);
forward TrainCombat(playerid);
forward TrainUzi(playerid);
forward TrainSmg(playerid);
forward TrainAk47(playerid);
forward TrainM4(playerid);
forward TrainSniper(playerid);
forward ChangeYourName(playerid);
forward ResetAcWarn(playerid);
forward ResetArea(playerid);
forward SetRealMoney(playerid, money);
forward IsAtCandySprunk(playerid);
forward SetHP(playerid);
forward IsAtPaySpray(playerid);
forward IsAtTransfender(playerid);
forward PaySprayTrans();
forward IsModelAPlane(carid);
forward IsModelABike(carid);
forward IsModelABycicle(carid);
forward IsModelAHeli(carid);
forward IsModelABoat(carid);
forward IsModelASpecial(carid);
forward RestartCars();
forward IsAnEnterableModel(carid);
forward IsAnEnterableCar(carid);
forward IsAnEnterableHeli(carid);
forward IsAnEnterablePlane(carid);
forward IsAnEnterableBoat(carid);
forward GreenMoney(playerid);
forward RedMoney(playerid);
forward SaveVehicleComponents(car);
forward ClearVehicleComponents(car);
forward SetVehicleModifications(carid);
forward AddPunishment(playerid, string[]);
forward TogglePlayerControllable2(playerid);
forward Unfreezeply(playerid);
forward ResetUpgradeUse(playerid);
forward ClockSeconds();
forward EvaluateHouse(houseid);
forward AttachWeaponCorrectly(playerid, gun);
forward AttachObjectCorrectly(playerid, object);
forward ResetText(playerid);
forward ResetCommands(playerid);
forward CheckDist(playerid,playerid2);
new do_Texto[MAX_PLAYERS][128];
new TotalConectados, MaxLogados, MaxRegistrados, MaxVisitas, PlayersOn, UltimoRegistrado[255];
//new Radio[MAX_PLAYERS], Radio1[MAX_PLAYERS], Radio2[MAX_PLAYERS], Radio3[MAX_PLAYERS], Radio4[MAX_PLAYERS], Radio5[MAX_PLAYERS];
//new Radio6[MAX_PLAYERS], Radio7[MAX_PLAYERS], Radio8[MAX_PLAYERS], Radio9[MAX_PLAYERS], Radio10[MAX_PLAYERS];
//new Radio11[MAX_PLAYERS], Radio12[MAX_PLAYERS], Radio13[MAX_PLAYERS], Radio14[MAX_PLAYERS];
new qualcarro[MAX_PLAYERS] = 0;
new FornecendoCigarro[MAX_PLAYERS] = 0;    //empresa de id 35
new FornecendoPerfume[MAX_PLAYERS] = 0;    //empresa de id 36
new Motoboy33[MAX_PLAYERS] = 0;
new Motoboy34[MAX_PLAYERS] = 0;
new Pursiot[42];
//
new Carteirando[MAX_PLAYERS];
new Tratorando[MAX_PLAYERS];
new PescaCP[MAX_PLAYERS];
new EnviarSMSPID[MAX_PLAYERS] = 0;
new AntiNomeBot[][] = {
	"con.",
    "com1",
	"com2",
	"com3",
	"com4",
	"com5",
	"com6",
	"com7",
	"com8",
	"com9",
	"lpt1",
	"lpt2",
	"lpt3",
	"lpt4",
	"lpt5",
	"lpt6",
	"lpt7",
	"lpt8",
	"lpt9",
	"nul",
	"clock$",
	"aux",
	"prn",
	"con",
	"Carl",
	"Rocky",
	"Pepe",
	"Arnoldo",
	"SgtPepper",
	"Pepsi",
	"Pepno",
	"Azucar",
	"Vino_Toro",
	"Zoquete",
	"Pacman",
	"Batman",
	"AquilesBrinco",
	"Manfrey",
	"Sopapeala",
	"Papirola",
	"Sony",
	"[ViP]Labrik",
	"Justin_Bieber",
	"Poderoso_Chefao",
	"[MT]Lavis",
    "Gil_Henrique",
    "Server_Lixo",
    "Justin_Biba",
    "Justin_Viadinho",
    "Advanced_Lixo",
    "Chefao_Fusion",
    "Fusion_Games",
    "Advanced_Derrubado"
};  //Advanced_Derrubado
//  Não modifique as linhas abaixo.
new FUMARNAMES[4][128] =
{
    "de fumar uma pedrinha.",
    "de dar uma cheiradinha em uma cocaina.",
    "de usar umas drogas misturadas.",
    "de dar uma brisada."
};
/*new DOEUNAMES[4][128] =
{
    "da forte pancada que recebeu na cabeça.",
    "da sua úcera que estava alta.",
    "do ataque cardiaco.",
    "de um tiro que você levou, porém esqueceu de quem."
};*/
forward RandomServerNames();
new SVNAMES[4][128] =
{
    " Advanced Roleplay || por Ricop522 ",
    "Servidor somente para testes || by Ricop522",
    " Advanced Roleplay || por Ricop522",
    "Servidor somente para testes || by Ricop522"
};
new MenuFaculdade; //Gil noob.
new FaculdadeEntrar;//não sabe codar
new FaculdadeSair; //Bostão ;D.
new lang[0x3C*2];//Fiz em hex... by Ricar_do
new otext[0x3C*2];
new stext[0x3C*2];
//new ownvehkey;
new trailer1;
new trailer2;
new trailer3;
new trailer4;
new trailer5;
new trailer6;
/*new PVC[212] =
{
    30000,	25000,	150000,	22000,	14000,	50000,             //Tem o meu nome xD \/
	0,
	0,	0,	400000,	20000,	350000,	60000,	8000,	7000, 350000,
	0,	0,	9000,	15000,	0,	20000,	7500,	0,
	25000,	0,	20000,	0,	0,	75000,	0,	0,	0,	0,	15000,	0,	15000,	0,	0,	25000,	12000,	0,	0,	0,	35000,	35000,
	0,	0,	0,	0,	0,	500000,	0,	0,	0,	0,	60000,	0,
	25000,	8000,	0,	80000,	25000,	50000,	0,	0,	18000,	18000,	35000,	0,	0,	25000,
	0,	0, 	12000,	30000,	0,	44000,	7000,	11000,	65000,	0,	8000,	0,	0,	0,	0,	0,
	0,	14000,	0,	25000,	30000,	0,	0,	0,	17000, 	0,	14000,	12000,	13000, 	0,	0,	0,	0,	30000,	390000,	50000,	0,	0,	0,	0,	0,	0,
    70000,	65000,	22000,	23000,
	18000,	0,
	0,	90000,	85000,	0,	0,	0,	12000,	14000,	0,	23000,	0,	0,	0,	41000,	40000,	17000,	75000,	0,
	0,	0,	15000,	450000,	12000,	12000,	0,	38000,	30000,	19000,	0,	12000,	45000,	43000,	0,
	0,	12000,	35000,	0,	0,	250000,	150000,	22000,	85000,	0,	0,	16000,	31000,	75000,
	0,	0,	0,	0,	0,	0,	0,	35000,	31000,	0,	0, 12000,	56000,	82000,	0,	0,	0,	35000,	8000, 36000, 0, 29000,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12000, 0, 45000, 55000, 5000, 4000, 0,0, 0, 15000, 	0, 	0
}; */
new Text:CVolta, Text:TextDraw11, Text:Textdraw2, Text:Textdraw3, Text:Textdraw4, Text:TextDraw55,
    Text:Textdraw6, Text:Textdraw7, Text:OPMENU[MAX_PLAYERS], Text:BCelular2;   //Celular fim.
new BenchAvail[10] = 0;
new BenchPresses[MAX_PLAYERS];
new BenchPressID[MAX_PLAYERS];
new BenchPressTime[MAX_PLAYERS];
new Float:BenchPress[2][4] = {
{1754.0804,-1532.7604,9.4408,7.0076},
{772.8803,1.4384,1000.7209,269.3404}
};
new Text:nDraw[MAX_PLAYERS];

new CamSet[MAX_PLAYERS][2]; //câmera mudando de posição
//new Radio[MAX_PLAYERS];
//Skins
new Float:SkinOffSet[300][7] = {
{0.098771, 0.030772, -0.000335, 85.342658, 84.122947, 4.236968 }, // - 0
{0.100766, 0.028630, -0.003521, 87.936676, 82.110870, 4.236968 }, // - 1
{0.083712, 0.033132, -0.003521, 87.936676, 82.110870, 4.236968 }, // - 2
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // - 3
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // - 4
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // - 5
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // - 6
{0.090066, 0.043458, -0.006523, 87.936676, 82.110870, 4.236968 }, // - 7
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // - 8
{0.070977, 0.028663, 0.000147, 81.164970, 92.128402, 4.236968 },  // - 9
{0.072317, 0.032179, -0.002934, 86.843269, 84.196006, 4.236968 }, // - 10
{0.072317, 0.035465, -0.002201, 86.843269, 84.196006, 4.236968 }, // - 11
{0.072317, 0.028100, -0.002201, 86.843269, 84.196006, 4.236968 }, // - 12
{0.076569, 0.028100, -0.002201, 86.843269, 84.196006, 4.236968 }, // - 13
{0.091310, 0.049169, -0.002201, 86.843269, 84.196006, 4.236968 }, // - 14
{0.073734, 0.006292, -0.002755, 86.843269, 84.196006, 4.236968 }, // - 15
{0.092845, 0.040331, 0.000183, 86.843269, 82.864280, 4.236968 },  // - 16
{0.088241, 0.030184, -0.000157, 86.843269, 82.864280, 4.236968 }, // - 17
{0.061677, 0.029596, -0.007398, 86.843269, 82.864280, 4.236968 }, // - 18
{0.079911, 0.029596, -0.002934, 86.843269, 82.864280, 4.236968 }, // - 19
{0.095079, 0.029596, -0.001718, 85.261871, 86.296562, 4.236968 }, // - 20
{0.093728, 0.042083, -0.005781, 85.261871, 81.636192, 4.236968 }, // - 21
{0.079585, 0.042083, -0.005781, 85.261871, 81.636192, 4.236968 }, // - 22
{0.090786, 0.041737, -0.005263, 85.261871, 81.636192, 4.236968 }, // - 23
{0.085247, 0.026941, -0.000317, 85.261871, 81.636192, 4.236968 }, // - 24
{0.081646, 0.031448, -0.001113, 89.393653, 81.665985, 4.236968 }, // - 25
{0.083700, 0.033814, -0.001960, 86.436462, 81.665985, 4.236968 }, // - 26
{0.092498, 0.037321, -0.001960, 86.436462, 85.568023, 4.236968 }, // - 27
{0.097068, 0.041360, -0.007881, 86.771400, 85.568023, 4.236968 }, // - 28
{0.083456, 0.050595, 0.001011, 86.771400, 77.201461, 4.236968 },  // - 29
{0.076983, 0.047168, -0.006161, 86.771400, 74.329719, 4.236968 }, // - 30
{0.083798, 0.042184, -0.001869, 86.771400, 83.181861, 4.236968 }, // - 31
{0.053021, -0.000587, -0.001869, 86.771400, 66.859710, 4.236968 },// - 32
{0.034386, 0.013324, -0.001869, 86.771400, 80.314460, 4.236968 }, // - 33
{0.104669, 0.037365, -0.001403, 86.771400, 87.178382, 4.236968 }, // - 34
{0.102659, 0.037465, -0.000829, 86.771400, 93.020492, 4.236968 }, // - 35
{0.107638, 0.037465, -0.000829, 86.771400, 93.020492, 4.236968 }, // - 36
{0.107638, 0.035879, -0.000829, 86.771400, 93.020492, 4.236968 }, // - 37
{0.107638, 0.041106, -0.000829, 86.771400, 93.020492, 4.236968 }, // - 38
{0.080326, 0.035634, -0.000829, 86.771400, 93.020492, 4.236968 }, // - 39
{0.080326, 0.027371, -0.000829, 86.771400, 93.020492, 4.236968 }, // - 40
{0.084617, 0.039613, -0.001620, 86.771400, 93.020492, 4.236968 }, // - 41
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // - 42
{0.040075, 0.025445, -0.000974, 86.771400, 92.964149, 4.236968 }, // - 43
{0.077369, 0.028469, -0.000974, 86.771400, 78.435791, 4.236968 }, // - 44
{0.064145, 0.028684, -0.000974, 86.771400, 84.762802, 4.236968 }, // - 45
{0.091993, 0.056559, -0.000974, 86.771400, 84.762802, 4.236968 }, // - 46
{0.084582, 0.051277, -0.005034, 86.771400, 84.762802, 4.236968 }, // - 47
{0.092182, 0.042095, -0.003533, 86.771400, 84.762802, 4.236968 }, // - 48
{0.086866, 0.032203, -0.001021, 86.771400, 84.762802, 4.236968 }, // - 49
{0.099350, 0.009422, -0.005899, 86.771400, 84.762802, 4.236968 }, // -=50
{0.099350, 0.030598, -0.005899, 86.771400, 84.762802, 4.236968 }, // -=51
{0.099350, 0.030598, -0.003575, 86.771400, 84.762802, 4.236968 }, // -=52
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=53
{0.079123, 0.030598, -0.003575, 86.771400, 84.762802, 4.236968 }, // -=54
{0.063159, 0.029641, -0.003575, 86.771400, 84.762802, 4.236968 }, // -=55
{0.070293, 0.029641, -0.000570, 86.771400, 84.762802, 4.236968 }, // -=56
{0.111305, 0.045368, -0.000570, 86.771400, 84.458084, 4.236968 }, // -=57
{0.084901, 0.020965, -0.000570, 86.771400, 79.542411, 4.236968 }, // -=58
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=59
{0.090164, 0.044163, -0.004754, 86.771400, 79.542411, 4.236968 }, // -=60
{0.087151, 0.041447, -0.000885, 90.928329, 89.598678, 0.000000 }, // -=61
{0.094350, 0.041447, 0.005717, 90.928329, 89.598678, 0.000000 },  // -=62
{0.075534, 0.041447, -0.001751, 90.928329, 89.598678, 0.000000 }, // -=63
{0.075534, 0.041447, -0.001751, 90.928329, 89.598678, 0.000000 }, // -=64
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=65
{0.104148, 0.034787, 0.001341, 90.928329, 89.598678, 0.000000 },  // -=66
{0.104148, 0.034787, 0.001341, 90.928329, 89.598678, 0.000000 },  // -=67
{0.087317, 0.039646, -0.004032, 90.928329, 89.598678, 0.000000 }, // -=68
{0.074873, 0.039646, -0.003072, 90.928329, 89.598678, 0.000000 }, // -=69
{0.090391, 0.042364, 0.005494, 90.928329, 89.598678, 0.000000 },  // -=70
{0.090391, 0.022298, -0.001170, 90.928329, 89.598678, 0.000000 }, // -=71
{0.090391, 0.039580, -0.001170, 90.928329, 89.598678, 0.000000 }, // -=72
{0.090391, 0.038224, -0.001170, 90.928329, 89.598678, 0.000000 }, // -=73
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=74
{0.083113, 0.038224, -0.001170, 90.928329, 89.598678, 0.000000 }, // -=75
{0.072957, 0.028956, -0.001170, 90.928329, 89.598678, 0.000000 }, // -=76
{0.069398, 0.039981, -0.001170, 90.928329, 89.598678, 0.000000 }, // -=77
{0.105738, 0.010001, 0.004508, 90.928329, 79.030494, 0.000000 },  // -=78
{0.078264, 0.019668, 0.004508, 90.928329, 79.030494, 0.000000 },  // -=79
{0.087377, 0.022096, -0.001993, 90.928329, 79.030494, 0.000000 }, // -=80
{0.087377, 0.022096, -0.001635, 90.928329, 79.030494, 0.000000 }, // -=81
{0.100623, 0.043063, -0.001635, 90.928329, 87.672645, 0.000000 }, // -=82
{0.092528, 0.027493, -0.001635, 90.928329, 87.672645, 0.000000 }, // -=83
{0.102086, 0.027493, -0.001635, 90.928329, 87.672645, 0.000000 }, // -=84
{0.081954, 0.041672, -0.001635, 90.928329, 87.672645, 0.000000 }, // -=85
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=86
{0.077010, 0.046925, -0.003438, 90.928329, 91.590301, 0.000000 }, // -=87
{0.069952, 0.042635, -0.003438, 90.928329, 86.722587, 0.000000 }, // -=88
{0.093827, 0.019258, -0.003438, 90.928329, 86.722587, 0.000000 }, // -=89
{0.066464, 0.035685, -0.000843, 90.928329, 86.722587, 0.000000 }, // -=90
{0.066464, 0.035685, -0.000843, 90.928329, 86.722587, 0.000000 }, // -=91
{0.066464, 0.038135, -0.000843, 90.928329, 86.722587, 0.000000 }, // -=92
{0.066464, 0.038135, -0.001690, 90.928329, 86.722587, 0.000000 }, // -=93
{0.048124, 0.010598, -0.001690, 90.928329, 86.722587, 0.000000 }, // -=94
{0.084997, 0.006773, -0.001690, 90.928329, 86.722587, 0.000000 }, // -=95
{0.100076, 0.026633, -0.001690, 90.928329, 80.020179, 0.000000 }, // -=96
{0.061686, 0.027537, -0.001690, 90.928329, 80.020179, 0.000000 }, // -=97
{0.098318, 0.053993, -0.001690, 90.928329, 89.237678, 0.000000 }, // -=98
{0.098318, 0.033702, -0.001690, 90.928329, 89.237678, 0.000000 }, // -=99
{0.086149, 0.042526, -0.001690, 90.928329, 77.587478, 0.000000 }, // -=100
{0.081864, 0.030555, -0.001690, 90.928329, 78.145759, 0.000000 }, // -=101
{0.081864, 0.047914, -0.005079, 90.928329, 78.145759, 0.000000 }, // -=102
{0.089607, 0.036717, -0.005079, 90.928329, 78.145759, 0.000000 }, // -=103
{0.079655, 0.042021, -0.005079, 90.928329, 78.145759, 0.000000 }, // -=104
{0.091779, 0.037620, -0.005079, 90.928329, 78.145759, 0.000000 }, // -=105
{0.084179, 0.035251, -0.005079, 90.928329, 78.145759, 0.000000 }, // -=106
{0.089387, 0.040297, -0.006006, 90.928329, 78.145759, 0.000000 }, // -=107
{0.081930, 0.030756, 0.001523, 90.928329, 78.145759, 0.000000 },  // -=108
{0.092857, 0.043070, -0.006084, 90.928329, 85.326652, 0.000000 }, // -=109
{0.092857, 0.043070, -0.006084, 90.928329, 85.326652, 0.000000 }, // -=110
{0.106601, 0.028021, -0.003537, 90.928329, 90.217376, 0.000000 }, // -=111
{0.096335, 0.015873, -0.003537, 90.928329, 90.217376, 0.000000 }, // -=112
{0.105827, 0.046620, -0.001395, 90.928329, 90.217376, 0.000000 }, // -=113
{0.097520, 0.044296, -0.007286, 90.928329, 90.217376, 0.000000 }, // -=114
{0.097408, 0.043470, -0.007286, 90.928329, 90.217376, 0.000000 }, // -=115
{0.092588, 0.049832, -0.007286, 90.928329, 90.217376, 0.000000 }, // -=116
{0.081444, 0.037602, -0.003125, 90.928329, 90.217376, 0.000000 }, // -=117
{0.078678, 0.037602, -0.001816, 90.928329, 90.217376, 0.000000 }, // -=118
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=119
{0.089214, 0.029291, -0.000784, 90.928329, 84.624763, 0.000000 }, // -=120
{0.086825, 0.033424, -0.000784, 90.928329, 77.233818, 0.000000 }, // -=121
{0.082869, 0.030783, -0.000950, 90.928329, 77.233818, 0.000000 }, // -=122
{0.096117, 0.048957, -0.006245, 90.928329, 87.579650, 0.000000 }, // -=123
{0.103663, 0.040022, 0.000449, 90.928329, 87.579650, 0.000000 },  // -=124
{0.099326, 0.031202, -0.001180, 90.928329, 87.579650, 0.000000 }, // -=125
{0.099326, 0.031132, -0.001180, 90.928329, 87.579650, 0.000000 }, // -=126
{0.099326, 0.039279, -0.001180, 90.928329, 87.579650, 0.000000 }, // -=127
{0.099326, 0.047422, -0.001180, 90.928329, 87.579650, 0.000000 }, // -=128
{0.088817, 0.021210, 0.000730, 90.928329, 87.579650, 0.000000 },  // -=129
{0.025784, 0.028323, 0.000730, 90.928329, 59.394767, 0.000000 },  // -=130
{0.068455, 0.031841, -0.004470, 90.928329, 79.979003, 0.000000 }, // -=131
{0.012930, 0.008392, -0.004470, 90.928329, 72.129173, 0.000000 }, // -=132
{0.102457, 0.032260, -0.003338, 90.928329, 84.534217, 0.000000 }, // -=133
{0.085976, 0.014956, -0.003338, 90.928329, 80.308830, 0.000000 }, // -=134
{0.071574, 0.028186, -0.001588, 90.928329, 80.308830, 0.000000 }, // -=135
{0.085219, 0.016666, -0.000738, 90.928329, 80.308830, 0.000000 }, // -=136
{0.065114, 0.009318, -0.000738, 90.928329, 80.308830, 0.000000 }, // -=137
{0.066890, 0.040024, -0.000738, 90.928329, 87.341934, 0.000000 }, // -=138
{0.072037, 0.036141, -0.000702, 90.928329, 87.341934, 0.000000 }, // -=139
{0.069108, 0.042194, -0.000436, 90.928329, 87.341934, 0.000000 }, // -=140
{0.058717, 0.043547, -0.000436, 90.928329, 87.209770, 0.000000 }, // -=141
{0.104196, 0.039601, -0.005481, 90.928329, 87.209770, 0.000000 }, // -=142
{0.090929, 0.045881, -0.012780, 90.928329, 87.209770, 0.000000 }, // -=143
{0.098291, 0.042464, -0.006952, 90.928329, 83.081665, 0.000000 }, // -=144
{0.080087, 0.030122, 0.000606, 90.928329, 83.081665, 0.000000 },  // -=145
{0.093500, 0.030690, -0.001545, 90.928329, 83.081665, 0.000000 }, // -=146
{0.079566, 0.020138, 0.004838, 90.928329, 73.715591, 0.000000 },  // -=147
{0.073564, 0.028430, -0.000527, 90.928329, 88.295433, 0.000000 }, // -=148
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=149
{0.073564, 0.028430, -0.000527, 90.928329, 88.295433, 0.000000 }, // -=150
{0.083426, 0.032359, -0.005717, 90.928329, 88.295433, 0.000000 }, // -=151
{0.072349, 0.019623, -0.000747, 90.928329, 82.624351, 0.000000 }, // -=152
{0.075065, 0.015351, 0.006545, 90.928329, 71.041442, 0.000000 },  // -=153
{0.062227, 0.029731, -0.004938, 90.928329, 84.602760, 0.000000 }, // -=154
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=155
{0.079936, 0.049000, -0.000304, 90.928329, 82.926010, 0.000000 }, // -=156
{0.067550, 0.035686, -0.000017, 90.928329, 82.926010, 0.000000 }, // -=157
{0.090676, 0.039383, -0.001726, 90.928329, 88.667900, 0.000000 }, // -=158
{0.090676, 0.039383, -0.003532, 90.928329, 88.667900, 0.000000 }, // -=159
{0.098662, 0.017441, -0.001589, 90.928329, 88.667900, 0.000000 }, // -=160
{0.105388, 0.038409, 0.003155, 90.928329, 88.667900, 0.000000 },  // -=161
{0.097415, 0.036904, -0.000525, 90.928329, 88.667900, 0.000000 }, // -=162
{0.088934, 0.023302, -0.004153, 90.928329, 80.393875, 0.000000 }, // -=163
{0.088934, 0.023302, -0.004153, 90.928329, 80.393875, 0.000000 }, // -=164
{0.087018, 0.051364, 0.000484, 90.928329, 94.584838, 0.000000 },  // -=165
{0.087018, 0.051364, 0.000484, 90.928329, 94.584838, 0.000000 },  // -=166
{0.095996, 0.038787, 0.000484, 90.928329, 84.315711, 0.000000 },  // -=167
{0.089094, 0.034001, -0.006451, 90.928329, 84.315711, 0.000000 }, // -=168
{0.075700, 0.028082, -0.006451, 90.928329, 84.315711, 0.000000 }, // -=169
{0.093751, 0.041968, -0.005545, 90.928329, 84.315711, 0.000000 }, // -=170
{0.090124, 0.031055, -0.000505, 90.928329, 84.315711, 0.000000 }, // -=171
{0.066033, 0.032915, -0.002713, 90.928329, 84.315711, 0.000000 }, // -=172
{0.088287, 0.045350, -0.005384, 90.928329, 84.315711, 0.000000 }, // -=173
{0.087750, 0.042129, -0.005384, 90.928329, 84.315711, 0.000000 }, // -=174
{0.092384, 0.039294, -0.005384, 90.928329, 84.315711, 0.000000 }, // -=175
{0.097661, 0.039065, -0.006344, 90.928329, 80.736480, 0.000000 }, // -=176
{0.097114, 0.039641, -0.006692, 90.928329, 80.736480, 0.000000 }, // -=177
{0.069354, 0.039641, -0.000474, 90.928329, 80.736480, 0.000000 }, // -=178
{0.091414, 0.039641, -0.005617, 90.928329, 80.736480, 0.000000 }, // -=179
{0.094914, 0.039641, -0.005617, 90.928329, 80.736480, 0.000000 }, // -=180
{0.117232, 0.033217, -0.001099, 90.928329, 82.396362, 0.000000 }, // -=181
{0.082569, 0.032748, -0.003248, 90.928329, 87.394371, 0.000000 }, // -=182
{0.095527, 0.027237, -0.001960, 90.928329, 86.443649, 0.000000 }, // -=183
{0.095527, 0.040994, -0.006878, 90.928329, 86.443649, 0.000000 }, // -=184
{0.085663, 0.030601, -0.002345, 90.928329, 81.496513, 0.000000 }, // -=185
{0.085663, 0.030601, -0.001015, 90.928329, 81.496513, 0.000000 }, // -=186
{0.076527, 0.027211, 0.008500, 90.928329, 74.401092, 0.000000 },  // -=187
{0.096669, 0.032578, 0.001662, 90.928329, 83.502502, 0.000000 },  // -=188
{0.098753, 0.032129, -0.001659, 90.928329, 90.153724, 0.000000 }, // -=189
{0.092821, 0.035572, -0.001659, 90.928329, 90.153724, 0.000000 }, // -=190
{0.092821, 0.035572, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=191
{0.092821, 0.035572, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=192
{0.092821, 0.035572, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=193
{0.092821, 0.035572, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=194
{0.092821, 0.035572, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=195
{0.092821, 0.035572, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=196
{0.100630, 0.020568, -0.001132, 90.928329, 90.153724, 0.000000 }, // -=197
{0.077905, 0.028523, 0.000000, 89.675476, 89.270309, 0.000000 },  // -=198
{0.099095, 0.022463, 0.000000, 89.675476, 89.270309, 0.000000 },  // -=199
{0.103182, 0.031106, 0.000000, 89.675476, 89.270309, 0.000000 },  // -=200
{0.078426, 0.038546, 0.000000, 89.675476, 89.270309, 0.000000 },  // -=201
{0.101092, 0.035797, -0.002997, 89.675476, 82.081153, 0.000000 }, // -=202
{0.092009, 0.042780, -0.005841, 89.675476, 84.463294, 0.000000 }, // -=203
{0.092009, 0.042780, -0.005841, 89.675476, 84.463294, 0.000000 }, // -=204
{0.092969, 0.027782, -0.002959, 89.675476, 84.463294, 0.000000 }, // -=205
{0.105109, 0.036128, -0.000471, 89.675476, 84.463294, 0.000000 }, // -=206
{0.066892, 0.024410, -0.002792, 89.675476, 84.463294, 0.000000 }, // -=207
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=208
{0.084046, 0.013608, -0.002792, 89.675476, 81.667831, 0.000000 }, // -=209
{0.084046, 0.013608, -0.001034, 89.675476, 81.667831, 0.000000 }, // -=210
{0.067610, 0.033777, -0.001034, 89.675476, 85.214485, 0.000000 }, // -=211
{0.094159, 0.020717, 0.000715, 89.675476, 85.214485, 0.000000 },  // -=212
{0.098744, 0.036786, -0.001770, 89.675476, 85.214485, 0.000000 }, // -=213
{0.068755, 0.036786, -0.001770, 89.675476, 85.214485, 0.000000 }, // -=214
{0.068755, 0.026863, -0.001770, 89.675476, 85.214485, 0.000000 }, // -=215
{0.068755, 0.026863, -0.001770, 89.675476, 85.214485, 0.000000 }, // -=216
{0.095765, 0.030034, -0.001770, 89.675476, 85.214485, 0.000000 }, // -=217
{0.085486, 0.039427, -0.003311, 89.675476, 85.214485, 0.000000 }, // -=218
{0.068874, 0.027850, -0.001021, 89.675476, 85.214485, 0.000000 }, // -=219
{0.052931, 0.050390, -0.002062, 89.675476, 88.113647, 0.000000 }, // -=220
{0.094479, 0.034432, 0.000875, 89.675476, 83.572830, 0.000000 },  // -=221
{0.094479, 0.034432, -0.000596, 89.675476, 83.572830, 0.000000 }, // -=222
{0.094479, 0.062073, -0.003098, 89.675476, 83.572830, 0.000000 }, // -=223
{0.064458, 0.029760, -0.001460, 89.675476, 83.572830, 0.000000 }, // -=224
{0.064458, 0.029760, -0.001460, 89.675476, 83.572830, 0.000000 }, // -=225
{0.072095, 0.029760, -0.001460, 89.675476, 83.572830, 0.000000 }, // -=226
{0.110619, 0.043037, -0.001466, 89.675476, 86.927627, 0.000000 }, // -=227
{0.099446, 0.050772, -0.001466, 89.675476, 85.103805, 0.000000 }, // -=228
{0.078635, 0.023680, -0.000275, 89.675476, 73.445220, 0.000000 }, // -=229
{0.043357, 0.028726, -0.000275, 89.675476, 73.445220, 0.000000 }, // -=230
{0.092488, 0.049972, -0.000275, 89.675476, 88.981941, 0.000000 }, // -=231
{0.092488, 0.016739, -0.000275, 89.675476, 88.981941, 0.000000 }, // -=232
{0.071677, 0.037055, -0.002878, 89.675476, 88.981941, 0.000000 }, // -=233
{0.082745, 0.004209, -0.002878, 89.675476, 88.981941, 0.000000 }, // -=234
{0.057909, 0.021331, -0.002878, 89.675476, 88.981941, 0.000000 }, // -=235
{0.079016, 0.021331, -0.000419, 89.675476, 77.678733, 0.000000 }, // -=236
{0.074572, 0.021331, -0.000419, 89.675476, 84.527442, 0.000000 }, // -=237
{0.074572, 0.038346, -0.001500, 89.675476, 84.527442, 0.000000 }, // -=238
{0.111645, 0.011549, 0.006237, 89.675476, 84.527442, 0.000000 },  // -=239
{0.090766, 0.044221, -0.000423, 89.675476, 89.461883, 0.000000 }, // -=240
{0.069491, 0.049021, -0.000423, 89.675476, 89.461883, 0.000000 }, // -=241
{0.059706, 0.031911, -0.000423, 89.675476, 89.461883, 0.000000 }, // -=242
{0.065242, 0.031911, -0.000423, 89.675476, 89.461883, 0.000000 }, // -=243
{0.065242, 0.051077, -0.001103, 89.675476, 89.461883, 0.000000 }, // -=244
{0.082393, 0.038233, 0.000410, 89.675476, 89.461883, 0.000000 },  // -=245
{0.079338, 0.044859, -0.002535, 89.675476, 89.461883, 0.000000 }, // -=246
{0.101566, 0.037019, 0.000750, 89.675476, 83.514060, 0.000000 },  // -=247
{0.091887, 0.047776, -0.000040, 89.675476, 83.514060, 0.000000 }, // -=248
{0.089745, 0.044044, 0.004071, 89.675476, 83.514060, 0.000000 },  // -=249
{0.094214, 0.044044, -0.007274, 89.675476, 83.514060, 0.000000 }, // -=250
{0.072282, 0.044044, -0.001468, 89.675476, 90.444763, 0.000000 }, // -=251
{0.095764, 0.034224, -0.000264, 89.675476, 82.959915, 0.000000 }, // -=252
{0.087454, 0.026208, -0.000264, 89.675476, 82.959915, 0.000000 }, // -=253
{0.099198, 0.037362, -0.000264, 89.675476, 82.959915, 0.000000 }, // -=254
{0.070845, 0.019943, 0.003505, 89.675476, 73.529716, 0.000000 },  // -=255
{0.065373, 0.033656, -0.001141, 89.675476, 83.002151, 0.000000 }, // -=256
{0.070077, 0.033656, -0.001141, 89.675476, 83.002151, 0.000000 }, // -=257
{0.089536, 0.041904, 0.000715, 89.675476, 83.002151, 0.000000 },  // -=258
{0.084822, 0.041904, 0.000715, 89.675476, 83.002151, 0.000000 },  // -=259
{0.093009, 0.031491, -0.001568, 89.675476, 83.002151, 0.000000 }, // -=260
{0.093009, 0.015023, -0.001477, 89.675476, 83.002151, 0.000000 }, // -=261
{0.076580, 0.039782, -0.001477, 89.675476, 88.620780, 0.000000 }, // -=262
{0.076580, 0.028967, -0.001477, 89.675476, 88.620780, 0.000000 }, // -=263
{0.075424, 0.043059, -0.001477, 89.675476, 88.620780, 0.000000 }, // -=264
{0.089655, 0.021726, -0.001477, 89.675476, 88.620780, 0.000000 }, // -=265
{0.096792, 0.014114, -0.003062, 89.675476, 85.166038, 0.000000 }, // -=266
{0.094886, 0.024989, -0.003184, 89.675476, 85.166038, 0.000000 }, // -=267
{0.094886, 0.024989, -0.003184, 89.675476, 85.166038, 0.000000 }, // -=268
{0.102252, 0.024989, -0.003184, 89.675476, 85.166038, 0.000000 }, // -=269
{0.102252, 0.024989, 0.000529, 89.675476, 85.166038, 0.000000 },  // -=270
{0.096134, 0.025462, 0.000529, 89.675476, 79.225112, 0.000000 },  // -=271
{0.099226, 0.032663, 0.000529, 89.675476, 79.225112, 0.000000 },  // -=272
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=273
{0.089833, 0.022466, -0.001590, 89.675476, 88.636062, 0.000000 }, // -=274
{0.089833, 0.022466, -0.001590, 89.675476, 88.636062, 0.000000 }, // -=275
{0.089833, 0.022466, -0.001590, 89.675476, 88.636062, 0.000000 }, // -=276
{0.082718, 0.062596, -0.000201, 89.675476, 88.636062, 0.000000 }, // -=277
{0.082718, 0.062596, -0.000201, 89.675476, 88.636062, 0.000000 }, // -=278
{0.087652, 0.059379, -0.000201, 89.675476, 88.636062, 0.000000 }, // -=279
{0.087652, 0.023702, -0.003091, 89.675476, 88.636062, 0.000000 }, // -=280
{0.087652, 0.023702, -0.003091, 89.675476, 88.636062, 0.000000 }, // -=281
{0.090877, 0.026643, -0.003091, 89.675476, 88.636062, 0.000000 }, // -=282
{0.090877, 0.026643, -0.003091, 89.675476, 88.636062, 0.000000 }, // -=283
{0.090877, 0.053674, 0.009879, 89.675476, 88.636062, 0.000000 },  // -=284
{0.104320, 0.041487, 0.008021, 89.675476, 88.636062, 0.000000 },  // -=285
{0.087062, 0.021779, -0.003307, 89.675476, 88.636062, 0.000000 }, // -=286
{0.073173, 0.048856, 0.005337, 89.675476, 92.561180, 0.000000 },  // -=287
{0.090294, 0.027592, -0.003497, 89.675476, 92.561180, 0.000000 }, // -=288
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   // -=289
{0.086562, 0.042698, -0.000612, 89.675476, 92.561180, 0.000000 }, // -=290
{0.096768, 0.039233, -0.000612, 89.675476, 83.550270, 0.000000 }, // -=291
{0.079939, 0.020731, -0.005162, 89.675476, 83.550270, 0.000000 }, // -=292
{0.097107, 0.027826, -0.005162, 89.675476, 88.505996, 0.000000 }, // -=293
{0.097107, 0.037636, 0.000618, 89.675476, 88.505996, 0.000000 },  // -=294
{0.079985, 0.035006, -0.000826, 89.675476, 87.533462, 0.000000 }, // -=295
{0.088445, 0.024209, -0.002076, 89.675476, 73.285072, 0.000000 }, // -=296
{0.094039, 0.035411, 0.000490, 89.675476, 84.277572, 0.000000 },  // -=297
{0.099553, 0.024683, -0.002919, 89.675476, 84.277572, 0.000000 }, // -=298
{0.099553, 0.044356, -0.000285, 89.675476, 84.277572, 0.000000 }  // -=299
};  //Fim das skins

new AntiDivulgador[12][256] = {
        "189.1",
        ".172.227",
        "200.255",
        "189.1",
        "172.230",
        "172.230",
        "172.62",
        "172.62",
        "172.229",
        "55.231",
        ":7777",
        ":7778"
};
//new Erva[MAX_PLAYERS];
new WtFreq[MAX_PLAYERS];
//new levotiro[MAX_PLAYERS];
new Caido[MAX_PLAYERS];
new JustDied[MAX_PLAYERS];
new pmid;
new UsingTattoo                     [MAX_PLAYERS];
//new Float:MortoPosX					[MAX_PLAYERS];
//new Float:MortoPosY					[MAX_PLAYERS];
//new Float:MortoPosZ					[MAX_PLAYERS];
//new TaMorto							[MAX_PLAYERS];
//new mint[MAX_PLAYERS];
//new mvw[MAX_PLAYERS];
//new pixup;
//new pixtext[64];
//new PIXEON = 0;
//new Caido[MAX_PLAYERS];
forward AeroGate();
forward AeroGate2();
forward AeroGate3();
new cela1, cela2, cela3, cela4, celavisita, patio, PortaoByRicardo; //Sistema de prisão por : Ricardo
new Fogo1, Fogo2, Fogo3, Fogo4, Fogo5, Fogo6, Fogo7, Fogo8, Fogo9, Fogo10; //byrick
new entradapresos, servircomida;            //byrick
new refeitorio, visitas;
new PMAberto = 1;
//new Text3D:Placa[MAX_VEHICLES];
new Text3D:Bandana[MAX_PLAYERS];
new Text3D:Description[MAX_PLAYERS];
new Text3D:VENDACARRO[MAX_VEHICLES];
//new Text3D:DescricaoCarro[MAX_VEHICLES];
//new Text3D:DescricaoCarro[MAX_VEHICLES];
new First = 0;
new canimon[MAX_PLAYERS];
//
new PodMudarN[MAX_PLAYERS] = 0;
new PodMudarS[MAX_PLAYERS] = 0;
new PodMudarI[MAX_PLAYERS] = 0;
new PodMudarET[MAX_PLAYERS] = 0;
//new Menu:UsingTatM;
new Menu:burgermenu, Menu:chickenmenu, Menu:pizzamenu, Menu:donutshop;
new Menu:Guide, Menu:JobLocations, Menu:JobLocations2, Menu:JobLocations3;
//new Menu:LegalJobs, Menu:LegalJobs2;
//new Menu:Licenses;
new CommandsTimer[MAX_PLAYERS];
new TextTimer[MAX_PLAYERS];
new Commands[MAX_PLAYERS];
new Text[MAX_PLAYERS];
new CanTurnEngine[MAX_PLAYERS];
new Attached[MAX_PLAYERS];
new nextapartment;
new nexthouse;
new nextmedium;
new cDebug;
new nextbig;
new Motd[32];new MinutesTD;
new SecondsTD;
new HoursTD;
new LogingAttempts[MAX_PLAYERS];
new PreTazerAmmo[MAX_PLAYERS];
new Tazer[MAX_PLAYERS];
//new OfficerCourseStep[MAX_PLAYERS];
new CanUseUpgrade[MAX_PLAYERS];
new CanChangeName[MAX_PLAYERS];
new CanSellHouse[MAX_PLAYERS];
new CanSellBizz[MAX_PLAYERS];
new CanLeaveFaction[MAX_PLAYERS];
new SpawnWorld[MAX_PLAYERS];
new SpawnInterior[MAX_PLAYERS];
new AFK[MAX_PLAYERS];
new admin[MAX_PLAYERS];
new cage[MAX_PLAYERS][4];
new caged[MAX_PLAYERS];
new Text3D:DutyLabel[MAX_PLAYERS];
new Gps[MAX_PLAYERS];
new IsPlayerInEVehicle[MAX_PLAYERS];
new Seats[MAX_VEHICLES];
new DebtMoney[MAX_PLAYERS];
new Searching[MAX_PLAYERS];
new GaveUp[MAX_PLAYERS];
new TookSprunk[MAX_PLAYERS];
new UsedAreaRecently[MAX_PLAYERS];
new ChangeNameTimer;
new GangCar[MAX_PLAYERS];
new do_Timer[MAX_PLAYERS];
new TrainTimer[MAX_PLAYERS];
new MoneyTimer[MAX_PLAYERS];
new ReceivedMoney[MAX_PLAYERS];
new cufftimer[MAX_PLAYERS];
new Text:TD1;
new Text:TD2;
new Text:TD3;
new Text:TD4;
new Text:TD0;
new Text:Textdraw1[MAX_PLAYERS];
new Text:Textdraw5;
new Text:Textdraw39[MAX_PLAYERS];
new Text:Textdraw41[MAX_PLAYERS];
new Text:Textdraw42[MAX_PLAYERS];
new Text:Textdraw43;
new Text:Textdraw49[MAX_PLAYERS];
new Text:Textdraw52[MAX_PLAYERS];
new Text:Textdraw53[MAX_PLAYERS];
new Text:Textdraw54[MAX_PLAYERS];
new Text:Textdraw56;
new Text:Textdraw57;
new Text:Textdraw58;
new TD1D;
new TD2D;
new TD3D;
new TD4D;
new TD0D;
new pdgate1;
new pdgate2;
new pdgate3;
new pdgate4;
new armydoor1, armydoor2, armydoor3, lspddoor1, lspddoor2;
new lspdwindows;
new fbidoor1;
new fbidoor2;
new fbidoor3;
new armygate1;
new armygate2;
new armygate3;
new armywindows1;
new armywindows2;
new fbigate;
new fbigate2;
//new iorgate;
new Para1;
new Para2;
new Para3;
new Para4;
new Tax = 0;
new TaxValue = 0;
new Jackpot = 0;	
new Medics = 0;
new MedicCall = 999;
new MedicCallTime[MAX_PLAYERS];
new Mechanics = 0;
new MechanicCall = 999;
new MechanicCallTime[MAX_PLAYERS];
new TaxiDrivers = 0;
new TaxiCall = 999;
new TaxiCallTime[MAX_PLAYERS];
new TaxiAccepted[MAX_PLAYERS];
new BusDrivers = 0;
new BusCall = 999;
new ScriptMoney[MAX_PLAYERS];
new ScriptWeapons[MAX_PLAYERS][13];
new OtherWeapons[MAX_PLAYERS][13];
new OtherAmmo[MAX_PLAYERS][13];
new ScriptMoneyUpdated[MAX_PLAYERS];
new ScriptWeaponsUpdated[MAX_PLAYERS];
new ConsumingMoney[MAX_PLAYERS];
new BusCallTime[MAX_PLAYERS];
new BusAccepted[MAX_PLAYERS];
new TransportDuty[MAX_PLAYERS];
new TransportValue[MAX_PLAYERS];
new TransportMoney[MAX_PLAYERS];
new TransportTime[MAX_PLAYERS];
new TransportCost[MAX_PLAYERS];
new TransportDriver[MAX_PLAYERS];
new JobDuty[MAX_PLAYERS];
new RegistrationStep[MAX_PLAYERS];
new OnCK[MAX_PLAYERS];
new GettingCK[MAX_PLAYERS];
new TakingLesson[MAX_PLAYERS];
new PlayersChannel[MAX_PLAYERS];
new CDC[MAX_PLAYERS];
new ReporterTV[MAX_PLAYERS];
new AssistindoTV[MAX_PLAYERS];
new NoFuel[MAX_PLAYERS];
new MatsHolding[MAX_PLAYERS];
new ShakeOffer[MAX_PLAYERS];
new TicketOffer[MAX_PLAYERS];
new TicketMoney[MAX_PLAYERS];
new gPlayerUsingLoopingAnim[MAX_PLAYERS];
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];
new animation[200];
new Text:txtAnimHelper;
new PlayerStoned[MAX_PLAYERS];
//new ConsumingMoney[MAX_PLAYERS];
new FishCount[MAX_PLAYERS];
new TutTime[MAX_PLAYERS];
new PlayerDrunk[MAX_PLAYERS];
new PlayerDrunkTime[MAX_PLAYERS];
new PlayerTazeTime[MAX_PLAYERS];
new BoxWaitTime[MAX_PLAYERS];
new PaperOffer[MAX_PLAYERS];
new BoxOffer[MAX_PLAYERS];
new CarOffer[MAX_PLAYERS];
new CarPrice[MAX_PLAYERS];
new CarID[MAX_PLAYERS];
new CarCalls[MAX_PLAYERS];
new MedicTime[MAX_PLAYERS];
new NeedMedicTime[MAX_PLAYERS];
new MedicBill[MAX_PLAYERS];
new PlayerTied[MAX_PLAYERS];
new PlayerCuffed[MAX_PLAYERS];
new LiveOffer[MAX_PLAYERS];
new TalkingLive[MAX_PLAYERS];
new PlacedNews[MAX_PLAYERS];
new SelectChar[MAX_PLAYERS];
new SelectCharID[MAX_PLAYERS];
new SelectCharPlace[MAX_PLAYERS];
new ChosenSkin[MAX_PLAYERS];
new GettingJob[MAX_PLAYERS];
new GuardOffer[MAX_PLAYERS];
new GuardPrice[MAX_PLAYERS];
new ApprovedLawyer[MAX_PLAYERS];
new CallLawyer[MAX_PLAYERS];
new WantLawyer[MAX_PLAYERS];
new KickPlayer[MAX_PLAYERS];
new Robbed[MAX_PLAYERS];
new RobbedTime[MAX_PLAYERS];
new CP[MAX_PLAYERS];
new MoneyMessage[MAX_PLAYERS];
new Condom[MAX_PLAYERS];
new Rope[MAX_PLAYERS];
new SexOffer[MAX_PLAYERS];
new SexPrice[MAX_PLAYERS];
new RepairOffer[MAX_PLAYERS];
new RepairPrice[MAX_PLAYERS];
new RefillOffer[MAX_PLAYERS];
new RefillPrice[MAX_PLAYERS];
new RepairCar[MAX_PLAYERS];
new DrugOffer[MAX_PLAYERS];
new DrugID[MAX_PLAYERS];
new DrugPrice[MAX_PLAYERS];
new DrugGram[MAX_PLAYERS];
new JailPrice[MAX_PLAYERS];
new BunnyJump[MAX_PLAYERS];
new WantedPoints[MAX_PLAYERS];
new WantedLevel[MAX_PLAYERS];
//new swat[MAX_PLAYERS];
new OnDuty[MAX_PLAYERS];
new gPlayerCheckpointStatus[MAX_PLAYERS];
//new pLogado[MAX_PLAYERS];
new gPlayerLogTries[MAX_PLAYERS];
new gPlayerSpawned[MAX_PLAYERS];
new gActivePlayers[MAX_PLAYERS];
new gLastCar[301];
new gOoc[MAX_PLAYERS];
new gNews[MAX_PLAYERS];
new ChatAdmin[MAX_PLAYERS];
new togsos[MAX_PLAYERS];
new gFam[MAX_PLAYERS];
new BigEar[MAX_PLAYERS];
new CellTime[MAX_PLAYERS];
new StartTime[MAX_PLAYERS];
new HireCar[MAX_PLAYERS];
new SafeTime[MAX_PLAYERS];
new HidePM[MAX_PLAYERS];
new PhoneOnline[MAX_PLAYERS];
new gDice[MAX_PLAYERS];
new gSpentCash[MAX_PLAYERS];
new FirstSpawn[MAX_PLAYERS];
new SwitchKey[MAX_PLAYERS];
new Fixr[MAX_PLAYERS];
new Locator[MAX_PLAYERS];
new Mobile[MAX_PLAYERS];
new RingTone[MAX_PLAYERS];
new CallCost[MAX_PLAYERS];
new gPlayerAccount[MAX_PLAYERS];
new BusrouteEast[MAX_PLAYERS][2];
new BusrouteWest[MAX_PLAYERS][2];
new Float:BusShowLocation[MAX_PLAYERS][4];
new BusShowLocationC[MAX_PLAYERS];
new InAFoodPlace[MAX_PLAYERS];
new PlayerDrankWine[MAX_PLAYERS];
new PlayerDrankBeer[MAX_PLAYERS];
new PlayerSmokedCig[MAX_PLAYERS];
new PlayerDrankSprunk[MAX_PLAYERS];
new gLastDriver[302];
new gCarLock[265];
new noooc = 0;
new adds = 1;
new addtimer = 60000;
new Float:rx, Float:ry, Float:rz;
//new carselect[15];
new objstore[128];
new cbjstore[128];
new textmotd[128];
//new RStart;
new ghour = 0;
new gminute = 0;
new gsecond = 0;
new numplayers = 0;
new realtime = 1;
new wtime = 16;
new ammutraintimer;
new regularcounttimer;
//new levelcost = 5000;
new deathcost = 250;
new callcost = 2; //20 seconds
new othtimer;
new hackchecktimer;
new synctimer;
new unjailtimer;
new pickuptimer;
new spectatetimer;
new idletimer;
new HideSpeed;
new SetWorld;
new accountstimer;
new checkgastimer;
new stoppedvehtimer;
new checkcarhealthtimer;
new cartimer;
new levelexp = 4;
new cchargetime = 60;
new txtcost = 1;
new pickups;
/*new authorizeswat;*/
new PizzaBoys = 0;
new PizzaCall = 999;
new PizzaCallTime[MAX_PLAYERS];
new bPizza[MAX_PLAYERS];
new bolaa[MAX_PLAYERS];
new sPizza[MAX_PLAYERS];
new CIV[] = {7,19,20,23,73,101,122};
new Float:ChangePos[MAX_PLAYERS][3];
new ChangePos2[MAX_PLAYERS][2];
new ChangePos3[MAX_PLAYERS];
new Float:AdminPos[MAX_PLAYERS][3];
new Float:TeleportDest[MAX_PLAYERS][3];
new Float:TelePos[MAX_PLAYERS][6];
new Typed[MAX_PLAYERS][64];
new Untouchable[MAX_PLAYERS];
new Training[MAX_PLAYERS];
new ViewingSpeed[MAX_PLAYERS];
new ViewAdmin[MAX_PLAYERS];
new ViewGrana[MAX_PLAYERS];
new UsingBelt[MAX_PLAYERS];
new HelpMessages[MAX_PLAYERS];
//new roadblocktimer = 0;
new engineOn[MAX_VEHICLES];
new vehicleEntered[MAX_PLAYERS][MAX_VEHICLES];
new gEngine[MAX_PLAYERS];
new FarmerVar[MAX_PLAYERS];
new FarmerPickup[MAX_PLAYERS][2];
new DrugFarmerVar[MAX_PLAYERS];
new DrugFarmerPickup[MAX_PLAYERS][2];
new JustStarted[MAX_PLAYERS];
new SmugglerWork[MAX_PLAYERS];
new SmuggledDrugs[MAX_PLAYERS];
new PayDaySecure[MAX_PLAYERS];
new KnockedDown[MAX_PLAYERS];
new UnidentifedCall[MAX_PLAYERS];
new LicenseOffer[MAX_PLAYERS];
new LicensePrice[MAX_PLAYERS];
new escutahave;
new Float:escx, Float:escy, Float:escz;
new escutacar;
new LicenseType[MAX_PLAYERS];
new DefaultWeather = 10;
new GetWorldTime = 0;
new OnSwatDuty[MAX_PLAYERS];
new UsingDrugs[MAX_PLAYERS];
new AfterTutorial[MAX_PLAYERS];
new OwnableCarOffer[MAX_PLAYERS];
new OwnableCarID[MAX_PLAYERS];
new OwnableCarPrice[MAX_PLAYERS];
new BlindFold[MAX_PLAYERS];
new UcAdmin[MAX_PLAYERS];
new PlayerIsSweeping[MAX_PLAYERS];
// ------------
new VehicleWindows[MAX_VEHICLES] = 0;
new BurgerPickUp[9];
new ChickenPickUp[9];
new Menu:BurgerShot;
new Menu:CluckinBell;
new IsMenuShowed[MAX_PLAYERS] = 0;
new burgertimer;
new	chickentimer;
new pdtrace = 0;
new Float:pdtrace_x;
new Float:pdtrace_y;
new Float:pdtrace_z;
new emdtrace = 0;
new Float:emdtrace_x;
new Float:emdtrace_y;
new Float:emdtrace_z;
new tracetimer;
new UsoB[MAX_PLAYERS];
new UsoBan[MAX_PLAYERS];
new UsouSOS[MAX_PLAYERS];
new JustReported[MAX_PLAYERS];
new PlayerNeedsHelp[MAX_PLAYERS];
new AdminSpec[MAX_PLAYERS];
new IsSmoking[MAX_PLAYERS];
new UsingSmokeAnim[MAX_PLAYERS];
new ReduceTime[MAX_PLAYERS];
new CreatingGun[MAX_PLAYERS];
new CreatingGunAmmo[MAX_PLAYERS];
new CreatingGunPrice[MAX_PLAYERS];
#define                 MAX_REPORTS                             (9)
new Reports[MAX_REPORTS][128];
new PlayerSuspicious[MAX_PLAYERS];
new PlayerSuspiciousMoney[MAX_PLAYERS];
new PlayerSuspiciousInterior[MAX_PLAYERS];
new PlayerGotSpottedRecently[MAX_PLAYERS];
new PlayerBunnyJumping[MAX_PLAYERS];
new PlayerMoneyHacking[MAX_PLAYERS];
new PlayerInteriorHacking[MAX_PLAYERS];
new PlayerWeaponHacking[MAX_PLAYERS];
new PlayerSpeedHacking[MAX_PLAYERS];
new PlayerOnCashInbalance[MAX_PLAYERS];
new PlayerFailedToLogin[MAX_PLAYERS];
new PlayerSuspiciousSpeed[MAX_PLAYERS];
new Checked[MAX_PLAYERS];
new weather2;
new lspd1, lspd2;
new PORTAOTEU;
new lspd3;
new fbi1, fbi2, fbi3;
new army1, army2, army3;
new lspdw;
new armyw1;
new armyw2;
new lspdg;
new lspdg2;
new armyg;
new armyg2;
new fbig;
new fbig2;
new HideTD2Timer;
new HideTD3Timer;
new HideTD4Timer;
new HideTD5Timer;
new HideTD6Timer;
new Text3D:VehicleLabel[MAX_VEHICLES];
new ChangedName[MAX_PLAYERS];
new ServerRestarted = 0;
new MaxPing = 9999;
new idletime = 300000;
new HouseReload[MAX_PLAYERS];
new TempoDoDialog[MAX_PLAYERS];
new pdistance = 1;
forward NameTimer();
new UsouCTRL[MAX_PLAYERS];
new aulateorica[MAX_PLAYERS];
new IDAula[MAX_PLAYERS];
//Strings_Globais_Para_menor_ultilização da memória :D by Ricarrrrdo0bRRRaaasssil>
new SkillBase[1024];
new basegostosa[1024];
new string1[200], string2[200], string3[200], string4[200], string5[200];
new string6[200], string7[200], string8[200], string9[200], string10[200];
new string12[200], string11[200], string13[200];
//
new DOUSADO[MAX_PLAYERS];
new MaconhaNames[1][128] = {
    "/do Começa a ficar inquieto e mal humorado pela falta do uso da Maconha."
};
new CocainaNames[3][128] = {
    "/me Começa a coçar o nariz intensamente enquanto pensa em usar Cocaína.",
    "/do Mostra-se agressivo e mal humorado.",
    "/do Inquieto e agressivo pela falta do uso de Cocaína."
};
new LSDNames[2][128] = {
    "/me Lembra-se do uso de LSD e sente uma certa falta.",
    "/me Lambe seus lábios enquanto se lembra do uso da LSD."
};
new CrackNames[2][128] = {
    "/do Mãos tremulas e suando frio pela falta do uso de Crack.",
    "/do Paranóico devido a falta do Crack."
};
#define GasMax 100
#define RunOutTime 40000
#define RefuelWait 5000
new FumandoDorgas[MAX_PLAYERS];
new Gas[MAX_VEHICLES];
stock mostrarInventario(playerid, jogador)//by J_u_sten
{
    if(PlayerInfo[playerid][pLogado] == 0 || !IsPlayerConnected(playerid)) return SendClientMessage(playerid, COLOR_GREY, "<!> Logue-se primeiro. ");
    if(PlayerInfo[jogador][pLogado] == 0 || !IsPlayerConnected(jogador)) return SendClientMessage(playerid, COLOR_GREY, "<!> Jogador não logado. ");
    new gunname[MAX_PLAYER_NAME]; GetWeaponName(PlayerInfo[jogador][pInvWeapon], gunname, sizeof(gunname));
    new gunname2[MAX_PLAYER_NAME]; GetWeaponName(PlayerInfo[jogador][pInvWeapon2], gunname2, sizeof(gunname2));
    new gunname3[MAX_PLAYER_NAME]; GetWeaponName(PlayerInfo[jogador][pInvWeapon3], gunname3, sizeof(gunname3));
    new gunname4[MAX_PLAYER_NAME]; GetWeaponName(PlayerInfo[jogador][pInvWeapon4], gunname4, sizeof(gunname4));
    new gunname5[MAX_PLAYER_NAME]; GetWeaponName(PlayerInfo[jogador][pInvWeapon5], gunname5, sizeof(gunname5));
    new gunname6[MAX_PLAYER_NAME]; GetWeaponName(PlayerInfo[jogador][pInvWeapon6], gunname6, sizeof(gunname6));
    if(PlayerInfo[jogador][pInvWeapon] != 0 && PlayerInfo[jogador][pInvAmmo] != 0)
    {
        format(string1, sizeof(string1), "[SLOT 1]: %s, Munição: %d\n", gunname, PlayerInfo[jogador][pInvAmmo]);
    }
	else { format(string1, sizeof(string1), "[SLOT 1]: N/A\n"); }
    if(PlayerInfo[jogador][pInvWeapon2] != 0 && PlayerInfo[jogador][pInvAmmo2] != 0)
    {
        format(string2, sizeof(string2), "[SLOT 2]: %s, Munição: %d\n", gunname2, PlayerInfo[jogador][pInvAmmo2]);
    }
	else { format(string2, sizeof(string2), "[SLOT 2]: N/A\n"); }
    if(PlayerInfo[jogador][pInvWeapon3] != 0 && PlayerInfo[jogador][pInvAmmo3] != 0)
    {
        format(string3, sizeof(string3), "[SLOT 3]: %s, Munição: %d\n", gunname3, PlayerInfo[jogador][pInvAmmo3]);
    }
	else { format(string3, sizeof(string3), "[SLOT 3]: N/A\n"); }
    if(PlayerInfo[jogador][pInvWeapon4] != 0 && PlayerInfo[jogador][pInvAmmo4] != 0)
    {
        format(string4, sizeof(string4), "[SLOT 4]: %s, Munição: %d\n", gunname4, PlayerInfo[jogador][pInvAmmo4]);
    }
	else { format(string4, sizeof(string4), "[SLOT 4]: N/A\n"); }
    if(PlayerInfo[jogador][pInvWeapon5] != 0 && PlayerInfo[jogador][pInvAmmo5] != 0)
    {
        format(string5, sizeof(string5), "[SLOT 5]: %s, Munição: %d\n", gunname5, PlayerInfo[jogador][pInvAmmo5]);
    }
	else { format(string5, sizeof(string5), "[SLOT 5]: N/A\n"); }
    if(PlayerInfo[jogador][pInvWeapon6] != 0 && PlayerInfo[jogador][pInvAmmo6] != 0)
    {
        format(string6, sizeof(string6), "[SLOT 6]: %s, Munição: %d\n", gunname6, PlayerInfo[jogador][pInvAmmo6]);
    }
	else { format(string6, sizeof(string6), "[SLOT 6]: N/A\n"); }
    format(empresastring, sizeof(empresastring), "[Inventário de %s]", GetPlayerNameEx(jogador));
    format(SkillBase, sizeof(SkillBase), "%s%s%s%s%s%s", string1, string2, string3, string4, string5, string6);
    ShowPlayerDialog(playerid,DIALOG_NADA,DIALOG_STYLE_MSGBOX,empresastring,SkillBase,"OK","");
    return 0x01;
}

stock GetSkinName(skinid)
{
	new returnt[64];
	switch(skinid)
	{
		case 0	: { format(returnt,sizeof(returnt),  "Carl CJ Johnson"); }
		case 1	: { format(returnt,sizeof(returnt),  "The Truth"); }
		case 2	: { format(returnt,sizeof(returnt),  "Maccer"); }
		case 3	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 4	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 5	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 6	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 7	: { format(returnt,sizeof(returnt),  "Taxi Driver/Train Driver"); }
		case 8	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 9	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 10	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 11	: { format(returnt,sizeof(returnt),  "Casino Worker"); }
		case 12	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 13	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 14	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 15	: { format(returnt,sizeof(returnt),  "RS Haul Owner"); }
		case 16	: { format(returnt,sizeof(returnt),  "Airport Ground Worker"); }
		case 17	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 18	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 19	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 20	: { format(returnt,sizeof(returnt),  "Madd Dogg's Manager"); }
		case 21	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 22	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 23	: { format(returnt,sizeof(returnt),  "BMXer"); }
		case 24	: { format(returnt,sizeof(returnt),  "Madd Dogg Bodyguard"); }
		case 25	: { format(returnt,sizeof(returnt),  "Madd Dogg Bodyguard"); }
		case 26	: { format(returnt,sizeof(returnt),  "Mountain Climber"); }
		case 27	: { format(returnt,sizeof(returnt),  "Builder"); }
		case 28	: { format(returnt,sizeof(returnt),  "Encapuzado"); }
		case 29	: { format(returnt,sizeof(returnt),  "Encapuzado"); }
		case 30	: { format(returnt,sizeof(returnt),  "Emcapuzado"); }
		case 31	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 32	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 33	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 34	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 35	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 36	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 37	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 38	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 39	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 40	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 41	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 42	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 43	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 44	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 45	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 46	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 47	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 48	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 49	: { format(returnt,sizeof(returnt),  "Snakehead (Da Nang)"); }
		case 50	: { format(returnt,sizeof(returnt),  "Mechanic"); }
		case 51	: { format(returnt,sizeof(returnt),  "Mountain Aventureiro"); }
		case 52	: { format(returnt,sizeof(returnt),  "Mountain Aventureiro"); }
		case 53	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 54	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 55	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 56	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 57	: { format(returnt,sizeof(returnt),  "Feds"); }
		case 58	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 59	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 60	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 61	: { format(returnt,sizeof(returnt),  "Pilot"); }
		case 62	: { format(returnt,sizeof(returnt),  "Colonel Fuhrberger"); }
		case 63	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 64	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 65	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 66	: { format(returnt,sizeof(returnt),  "Pool Player"); }
		case 67	: { format(returnt,sizeof(returnt),  "Pool Player"); }
		case 68	: { format(returnt,sizeof(returnt),  "Priest"); }
		case 69	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 70	: { format(returnt,sizeof(returnt),  "Scientist"); }
		case 71	: { format(returnt,sizeof(returnt),  "Security Guard"); }
		case 72	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 73	: { format(returnt,sizeof(returnt),  "Jethro"); }
		case 74	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 75	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 76	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 77	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 78	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 79	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 80	: { format(returnt,sizeof(returnt),  "Boxer"); }
		case 81	: { format(returnt,sizeof(returnt),  "Boxer"); }
		case 82	: { format(returnt,sizeof(returnt),  "Elvis Wannabe"); }
		case 83	: { format(returnt,sizeof(returnt),  "Elvis Wannabe"); }
		case 84	: { format(returnt,sizeof(returnt),  "Elvis Wannabe"); }
		case 85	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 86	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 87	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 88	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 89	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 90	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 91	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 92	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 93	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 94	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 95	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 96	: { format(returnt,sizeof(returnt),  "Jogger"); }
		case 97	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 98	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 99	: { format(returnt,sizeof(returnt),  "Skeelering"); }
		case 100	: { format(returnt,sizeof(returnt),  "Aventureiro"); }
		case 101	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 102	: { format(returnt,sizeof(returnt),  "Balla"); }
		case 103	: { format(returnt,sizeof(returnt),  "Balla"); }
		case 104	: { format(returnt,sizeof(returnt),  "Balla"); }
		case 105	: { format(returnt,sizeof(returnt),  "Grove Street Families"); }
		case 106	: { format(returnt,sizeof(returnt),  "Grove Street Families"); }
		case 107	: { format(returnt,sizeof(returnt),  "Grove Street Families"); }
		case 108	: { format(returnt,sizeof(returnt),  "Los Santos Vagos"); }
		case 109	: { format(returnt,sizeof(returnt),  "Los Santos Vagos"); }
		case 110	: { format(returnt,sizeof(returnt),  "Los Santos Vagos"); }
		case 111	: { format(returnt,sizeof(returnt),  "The Russian Mafia"); }
		case 112	: { format(returnt,sizeof(returnt),  "The Russian Mafia"); }
		case 113	: { format(returnt,sizeof(returnt),  "The Russian Mafia"); }
		case 114	: { format(returnt,sizeof(returnt),  "Varios Los Aztecas"); }
		case 115	: { format(returnt,sizeof(returnt),  "Varios Los Aztecas"); }
		case 116	: { format(returnt,sizeof(returnt),  "Varios Los Aztecas"); }
		case 117	: { format(returnt,sizeof(returnt),  "Traid"); }
		case 118	: { format(returnt,sizeof(returnt),  "Traid"); }
		case 119	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 120	: { format(returnt,sizeof(returnt),  "Traid"); }
		case 121	: { format(returnt,sizeof(returnt),  "Da Nang Boy"); }
		case 122	: { format(returnt,sizeof(returnt),  "Da Nang Boy"); }
		case 123	: { format(returnt,sizeof(returnt),  "Da Nang Boy"); }
		case 124	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 125	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 126	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 127	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 128	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 129	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 130	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 131	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 132	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 133	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 134	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 135	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 136	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 137	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 138	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 139	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 140	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 141	: { format(returnt,sizeof(returnt),  "Office Worker"); }
		case 142	: { format(returnt,sizeof(returnt),  "Taxi Driver"); }
		case 143	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 144	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 145	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 146	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 147	: { format(returnt,sizeof(returnt),  "Director"); }
		case 148	: { format(returnt,sizeof(returnt),  "Secretary"); }
		case 149	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 150	: { format(returnt,sizeof(returnt),  "Secretary"); }
		case 151	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 152	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 153	: { format(returnt,sizeof(returnt),  "Coffee mam'"); }
		case 154	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 155	: { format(returnt,sizeof(returnt),  "Well Stacked Pizza"); }
		case 156	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 157	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 158	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 159	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 160	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 161	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 162	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 163	: { format(returnt,sizeof(returnt),  "Bouncer"); }
		case 164	: { format(returnt,sizeof(returnt),  "Bouncer"); }
		case 165	: { format(returnt,sizeof(returnt),  "MIB Agent"); }
		case 166	: { format(returnt,sizeof(returnt),  "MIB Agent"); }
		case 167	: { format(returnt,sizeof(returnt),  "Cluckin' Bell"); }
		case 168	: { format(returnt,sizeof(returnt),  "Food Vendor"); }
		case 169	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 170	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 171	: { format(returnt,sizeof(returnt),  "Casino Worker"); }
		case 172	: { format(returnt,sizeof(returnt),  "Hotel Services"); }
		case 173	: { format(returnt,sizeof(returnt),  "San Fierro Rifa"); }
		case 174	: { format(returnt,sizeof(returnt),  "San Fierro Rifa"); }
		case 175	: { format(returnt,sizeof(returnt),  "San Fierro Rifa"); }
		case 176	: { format(returnt,sizeof(returnt),  "Tatoo Shop"); }
		case 177	: { format(returnt,sizeof(returnt),  "Tatoo Shop"); }
		case 178	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 179	: { format(returnt,sizeof(returnt),  "Ammu-Nation Salesmen"); }
		case 180	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 181	: { format(returnt,sizeof(returnt),  "Punker"); }
		case 182	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 183	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 184	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 185	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 186	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 187	: { format(returnt,sizeof(returnt),  "Buisnessman"); }
		case 188	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 189	: { format(returnt,sizeof(returnt),  "Valet"); }
		case 190	: { format(returnt,sizeof(returnt),  "Barbara Schternvart"); }
		case 191	: { format(returnt,sizeof(returnt),  "Helena Wankstein"); }
		case 192	: { format(returnt,sizeof(returnt),  "Michelle Cannes"); }
		case 193	: { format(returnt,sizeof(returnt),  "Katie Zhan"); }
		case 194	: { format(returnt,sizeof(returnt),  "Millie Perkins"); }
		case 195	: { format(returnt,sizeof(returnt),  "Denise Robinson"); }
		case 196	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 197	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 198	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 199	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 200	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 201	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 202	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 203	: { format(returnt,sizeof(returnt),  "Karate Teacher"); }
		case 204	: { format(returnt,sizeof(returnt),  "Karate Teacher"); }
		case 205	: { format(returnt,sizeof(returnt),  "Burger Shot Cashier"); }
		case 206	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 207	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 208	: { format(returnt,sizeof(returnt),  "Well Stacked Pizza"); }
		case 209	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 210	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 211	: { format(returnt,sizeof(returnt),  "Shop Staff"); }
		case 212	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 213	: { format(returnt,sizeof(returnt),  "Weird old man"); }
		case 214	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 215	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 216	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 217	: { format(returnt,sizeof(returnt),  "Shop Staff"); }
		case 218	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 219	: { format(returnt,sizeof(returnt),  "Secretary"); }
		case 220	: { format(returnt,sizeof(returnt),  "Taxi Driver"); }
		case 221	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 222	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 223	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 224	: { format(returnt,sizeof(returnt),  "Sofori"); }
		case 225	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 226	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 227	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 228	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 229	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 230	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 231	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 232	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 233	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 234	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 235	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 236	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 237	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 238	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 239	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 240	: { format(returnt,sizeof(returnt),  "The D.A"); }
		case 241	: { format(returnt,sizeof(returnt),  "Afro-American"); }
		case 242	: { format(returnt,sizeof(returnt),  "Mexican"); }
		case 243	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 244	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 245	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 246	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 247	: { format(returnt,sizeof(returnt),  "Aventureiro"); }
		case 248	: { format(returnt,sizeof(returnt),  "Aventureiro"); }
		case 249	: { format(returnt,sizeof(returnt),  "Pimp"); }
		case 250	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 251	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 252	: { format(returnt,sizeof(returnt),  "Naked Valet"); }
		case 253	: { format(returnt,sizeof(returnt),  "Velho"); }
		case 254	: { format(returnt,sizeof(returnt),  "Emcapuzado"); }
		case 255	: { format(returnt,sizeof(returnt),  "Limo Driver"); }
		case 256	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 257	: { format(returnt,sizeof(returnt),  "Prostituta"); }
		case 258	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 259	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 260	: { format(returnt,sizeof(returnt),  "Construction Site"); }
		case 261	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 262	: { format(returnt,sizeof(returnt),  "Taxi Driver"); }
		case 263	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 264	: { format(returnt,sizeof(returnt),  "Clown"); }
		case 265	: { format(returnt,sizeof(returnt),  "Tenpenny"); }
		case 266	: { format(returnt,sizeof(returnt),  "Pulaski"); }
		case 267	: { format(returnt,sizeof(returnt),  "Officer Frank Tenpenny (Crooked Cop)"); }
		case 268	: { format(returnt,sizeof(returnt),  "Dwaine"); }
		case 269	: { format(returnt,sizeof(returnt),  "Melvin Big Smoke Harris"); }
		case 270	: { format(returnt,sizeof(returnt),  "Sweet "); }
		case 271	: { format(returnt,sizeof(returnt),  "Lance Ryder Wilson"); }
		case 272	: { format(returnt,sizeof(returnt),  "Mafia Boss"); }
		case 273	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 274	: { format(returnt,sizeof(returnt),  "Paramedico"); }
		case 275	: { format(returnt,sizeof(returnt),  "Paramedico"); }
		case 276	: { format(returnt,sizeof(returnt),  "Paramedico"); }
		case 277	: { format(returnt,sizeof(returnt),  "Bombeiro"); }
		case 278	: { format(returnt,sizeof(returnt),  "Bombeiro"); }
		case 279	: { format(returnt,sizeof(returnt),  "Bombeiro"); }
		case 280	: { format(returnt,sizeof(returnt),  "Los Santos Police"); }
		case 281	: { format(returnt,sizeof(returnt),  "San Fierro Police"); }
		case 282	: { format(returnt,sizeof(returnt),  "Las Venturas Police"); }
		case 283	: { format(returnt,sizeof(returnt),  "Country Sheriff"); }
		case 284	: { format(returnt,sizeof(returnt),  "San Andreas Police Dept."); }
		case 285	: { format(returnt,sizeof(returnt),  "S.W.A.T Special Forces"); }
		case 286	: { format(returnt,sizeof(returnt),  "Federal Agents"); }
		case 287	: { format(returnt,sizeof(returnt),  "San Andreas Army"); }
		case 288	: { format(returnt,sizeof(returnt),  "Desert Sheriff"); }
		case 289	: { format(returnt,sizeof(returnt),  "Civil"); }
		case 290	: { format(returnt,sizeof(returnt),  "Ken Rosenberg"); }
		case 291	: { format(returnt,sizeof(returnt),  "Desert Sheriff"); }
		case 292	: { format(returnt,sizeof(returnt),  "Cesar Vialpando"); }
		case 293	: { format(returnt,sizeof(returnt),  "Jeffrey OG Loc Cross"); }
		case 294	: { format(returnt,sizeof(returnt),  "Wu Zi Mu (Woozie)"); }
		case 295	: { format(returnt,sizeof(returnt),  "Michael Toreno"); }
		case 296	: { format(returnt,sizeof(returnt),  "Jizzy B."); }
		case 297	: { format(returnt,sizeof(returnt),  "Madd Dogg"); }
		case 298	: { format(returnt,sizeof(returnt),  "Catalina"); }
		case 299	: { format(returnt,sizeof(returnt),  "Claude"); }
		default: { format(returnt,sizeof(returnt),  "Civil"); }
	}
	return returnt;
}
stock colocarChapeu(playerid, chapeuid) //by Justi#n , peguei as coordenadas TODAS.
{ //by Ricardo
    if(chapeuid == 18976) SetPlayerAttachedObject(playerid, 1, 18976, 2, 0.09, 0.03, 0, 88, 75, 0);
    if(chapeuid == 18645) SetPlayerAttachedObject(playerid, 1, 18645, 2, 0.07, 0, 0, 88, 75, 0);
    if(chapeuid == 18977) SetPlayerAttachedObject(playerid, 1, 18977, 2, 0.07, 0, 0, 88, 75, 0);
    if(chapeuid == 18978) SetPlayerAttachedObject(playerid, 1, 18978, 2, 0.07, 0, 0, 88, 75, 0);
    if(chapeuid == 18979) SetPlayerAttachedObject(playerid, 1, 18979, 2, 0.07, 0, 0, 88, 75, 0);
    if(chapeuid == 18944) SetPlayerAttachedObject(playerid, 1, 18944, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18945) SetPlayerAttachedObject(playerid, 1, 18945, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18946) SetPlayerAttachedObject(playerid, 1, 18946, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18947) SetPlayerAttachedObject(playerid, 1, 18947, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18948) SetPlayerAttachedObject(playerid, 1, 18948, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18949) SetPlayerAttachedObject(playerid, 1, 18949, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18950) SetPlayerAttachedObject(playerid, 1, 18950, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18951) SetPlayerAttachedObject(playerid, 1, 18951, 2, 0.15, 0.0, 0, 180, 0, 10);
    if(chapeuid == 18921) SetPlayerAttachedObject(playerid, 1, 18921, 2, 0.15, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18922) SetPlayerAttachedObject(playerid, 1, 18922, 2, 0.15, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18923) SetPlayerAttachedObject(playerid, 1, 18923, 2, 0.15, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18924) SetPlayerAttachedObject(playerid, 1, 18924, 2, 0.15, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18925) SetPlayerAttachedObject(playerid, 1, 18925, 2, 0.15, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18939) SetPlayerAttachedObject(playerid, 1, 18939, 2, 0.17, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18940) SetPlayerAttachedObject(playerid, 1, 18940, 2, 0.17, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18941) SetPlayerAttachedObject(playerid, 1, 18941, 2, 0.17, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18942) SetPlayerAttachedObject(playerid, 1, 18942, 2, 0.17, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18943) SetPlayerAttachedObject(playerid, 1, 18943, 2, 0.17, -0.03, 0.01, 180, 0, 30);
    if(chapeuid == 18953) SetPlayerAttachedObject(playerid, 1, 18953, 2, 0.13, -0.03, 0.00, 180, 0, 30);
    if(chapeuid == 18954) SetPlayerAttachedObject(playerid, 1, 18954, 2, 0.13, -0.03, 0.00, 180, 0, 30);
    if(chapeuid == 18960) SetPlayerAttachedObject(playerid, 1, 18960, 2, 0.13, 0, 0, 88, 75, 0);
    if(chapeuid == 18961) SetPlayerAttachedObject(playerid, 1, 18961, 2, 0.14, 0, 0, 88, 75, 0);
    if(chapeuid == 18962) SetPlayerAttachedObject(playerid, 1, 18962, 2, 0.14, 0, 0, 88, 75, 0);
    if(chapeuid == 18964) SetPlayerAttachedObject(playerid, 1, 18964, 2, 0.125, 0.015, 0, 90, 100, 0);
    if(chapeuid == 18965) SetPlayerAttachedObject(playerid, 1, 18965, 2, 0.125, 0.015, 0, 90, 100, 0);
    if(chapeuid == 18966) SetPlayerAttachedObject(playerid, 1, 18966, 2, 0.125, 0.015, 0, 90, 100, 0);
    if(chapeuid == 18967) SetPlayerAttachedObject(playerid, 1, 18967, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18968) SetPlayerAttachedObject(playerid, 1, 18968, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18969) SetPlayerAttachedObject(playerid, 1, 18969, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18970) SetPlayerAttachedObject(playerid, 1, 18970, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18971) SetPlayerAttachedObject(playerid, 1, 18971, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18972) SetPlayerAttachedObject(playerid, 1, 18972, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18973) SetPlayerAttachedObject(playerid, 1, 18973, 2, 0.125, 0.015, 0, 90, 80, 0);
    if(chapeuid == 18955) SetPlayerAttachedObject(playerid, 1, 18955, 2, 0.11, 0.02, 0, 88, 75, 0);
    if(chapeuid == 18956) SetPlayerAttachedObject(playerid, 1, 18956, 2, 0.11, 0.02, 0, 88, 75, 0);
    if(chapeuid == 18957) SetPlayerAttachedObject(playerid, 1, 18957, 2, 0.11, 0.02, 0, 88, 75, 0);
    if(chapeuid == 18958) SetPlayerAttachedObject(playerid, 1, 18958, 2, 0.11, 0.02, 0, 88, 75, 0);
    if(chapeuid == 18959) SetPlayerAttachedObject(playerid, 1, 18959, 2, 0.11, 0.02, 0, 88, 75, 0);
    if(chapeuid == 18936) SetPlayerAttachedObject(playerid, 1, 18936, 2, 0.105, 0.02, 0, 0, 0, 0);
    if(chapeuid == 18937) SetPlayerAttachedObject(playerid, 1, 18937, 2, 0.105, 0.02, 0, 0, 0, 0);
    if(chapeuid == 18938) SetPlayerAttachedObject(playerid, 1, 18938, 2, 0.105, 0.02, 0, 0, 0, 0);
    if(chapeuid == 18926) SetPlayerAttachedObject(playerid, 1, 18926, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18927) SetPlayerAttachedObject(playerid, 1, 18927, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18928) SetPlayerAttachedObject(playerid, 1, 18928, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18929) SetPlayerAttachedObject(playerid, 1, 18929, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18930) SetPlayerAttachedObject(playerid, 1, 18930, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18931) SetPlayerAttachedObject(playerid, 1, 18931, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18932) SetPlayerAttachedObject(playerid, 1, 18932, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18933) SetPlayerAttachedObject(playerid, 1, 18933, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18934) SetPlayerAttachedObject(playerid, 1, 18934, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18935) SetPlayerAttachedObject(playerid, 1, 18935, 2, 0.17, 0, -0.01, 0, 0, 0);
    if(chapeuid == 18891) SetPlayerAttachedObject(playerid, 1, 18891, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18892) SetPlayerAttachedObject(playerid, 1, 18892, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18893) SetPlayerAttachedObject(playerid, 1, 18893, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18894) SetPlayerAttachedObject(playerid, 1, 18894, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18895) SetPlayerAttachedObject(playerid, 1, 18895, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18896) SetPlayerAttachedObject(playerid, 1, 18896, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18897) SetPlayerAttachedObject(playerid, 1, 18897, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18898) SetPlayerAttachedObject(playerid, 1, 18898, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18899) SetPlayerAttachedObject(playerid, 1, 18899, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18900) SetPlayerAttachedObject(playerid, 1, 18900, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18901) SetPlayerAttachedObject(playerid, 1, 18901, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18902) SetPlayerAttachedObject(playerid, 1, 18902, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18903) SetPlayerAttachedObject(playerid, 1, 18903, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18904) SetPlayerAttachedObject(playerid, 1, 18904, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18905) SetPlayerAttachedObject(playerid, 1, 18905, 2, 0.15, -0.013, 0.001, 90, -30, -90);
    if(chapeuid == 18906) SetPlayerAttachedObject(playerid, 1, 18906, 2, 0.12, -0.02, 0.001, 90, -60, -90);
    if(chapeuid == 18907) SetPlayerAttachedObject(playerid, 1, 18907, 2, 0.12, -0.02, 0.001, 90, -60, -90);
    if(chapeuid == 18908) SetPlayerAttachedObject(playerid, 1, 18908, 2, 0.12, -0.02, 0.001, 90, -60, -90);
    if(chapeuid == 18909) SetPlayerAttachedObject(playerid, 1, 18909, 2, 0.12, -0.02, 0.001, 90, -60, -90);
    if(chapeuid == 18910) SetPlayerAttachedObject(playerid, 1, 18910, 2, 0.12, -0.02, 0.001, 90, -60, -90);
    return 1;
}













/*


JUSTIN CRIOU ESSA INCLUDE
NÃO REMOVA OS CRÉDITOS ¬¬
*/

