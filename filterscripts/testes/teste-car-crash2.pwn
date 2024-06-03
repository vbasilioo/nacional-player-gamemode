#include <a_samp>
#include <crashdetect>
#include <new-callbacks>
#define COLOR_GREY              0xAFAFAFAA
// =-=-=-=-=-=-=-=

#define COEFICIENTE_DRUNK_LEVEL 200.0
#define REDUCAO_DANO_CINTO 2.0

new bool:hasSeatBelt[MAX_PLAYERS];

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	hasSeatBelt[playerid] = false;
}

forward animation(playerid, animid);
public animation(playerid, animid)
{
	switch(animid)
	{
		case 1: ApplyAnimation(playerid,"PED","abseil",4.1,0,1,1,1,1);
		case 2: ApplyAnimation(playerid,"PED","ARRESTgun",4.1,0,1,1,1,1);
		case 3: ApplyAnimation(playerid,"PED","ATM",4.1,0,1,1,1,1);
		case 4: ApplyAnimation(playerid,"PED","BIKE_elbowL",4.1,0,1,1,1,1);
		case 5: ApplyAnimation(playerid,"PED","BIKE_elbowR",4.1,0,1,1,1,1);
		case 6: ApplyAnimation(playerid,"PED","BIKE_fallR",4.1,0,1,1,1,1);
		case 7: ApplyAnimation(playerid,"PED","BIKE_fall_off",4.1,0,1,1,1,1);
		case 8: ApplyAnimation(playerid,"PED","BIKE_pickupL",4.1,0,1,1,1,1);
		case 9: ApplyAnimation(playerid,"PED","BIKE_pickupR",4.1,0,1,1,1,1);
		case 10: ApplyAnimation(playerid,"PED","BIKE_pullupL",4.1,0,1,1,1,1);
		case 11: ApplyAnimation(playerid,"PED","BIKE_pullupR",4.1,0,1,1,1,1);
		case 12: ApplyAnimation(playerid,"PED","bomber",4.1,0,1,1,1,1);
		case 13: ApplyAnimation(playerid,"PED","CAR_alignHI_LHS",4.1,0,1,1,1,1);
		case 14: ApplyAnimation(playerid,"PED","CAR_alignHI_RHS",4.1,0,1,1,1,1);
		case 15: ApplyAnimation(playerid,"PED","CAR_align_LHS",4.1,0,1,1,1,1);
		case 16: ApplyAnimation(playerid,"PED","CAR_align_RHS",4.1,0,1,1,1,1);
		case 17: ApplyAnimation(playerid,"PED","CAR_closedoorL_LHS",4.1,0,1,1,1,1);
		case 18: ApplyAnimation(playerid,"PED","CAR_closedoorL_RHS",4.1,0,1,1,1,1);
		case 19: ApplyAnimation(playerid,"PED","CAR_closedoor_LHS",4.1,0,1,1,1,1);
		case 20: ApplyAnimation(playerid,"PED","CAR_closedoor_RHS",4.1,0,1,1,1,1);
		case 21: ApplyAnimation(playerid,"PED","CAR_close_LHS",4.1,0,1,1,1,1);
		case 22: ApplyAnimation(playerid,"PED","CAR_close_RHS",4.1,0,1,1,1,1);
		case 23: ApplyAnimation(playerid,"PED","CAR_crawloutRHS",4.1,0,1,1,1,1);
		case 24: ApplyAnimation(playerid,"PED","CAR_dead_LHS",4.1,0,1,1,1,1);
		case 25: ApplyAnimation(playerid,"PED","CAR_dead_RHS",4.1,0,1,1,1,1);
		case 26: ApplyAnimation(playerid,"PED","CAR_doorlocked_LHS",4.1,0,1,1,1,1);
		case 27: ApplyAnimation(playerid,"PED","CAR_doorlocked_RHS",4.1,0,1,1,1,1);
		case 28: ApplyAnimation(playerid,"PED","CAR_fallout_LHS",4.1,0,1,1,1,1);
		case 29: ApplyAnimation(playerid,"PED","CAR_fallout_RHS",4.1,0,1,1,1,1);
		case 30: ApplyAnimation(playerid,"PED","CAR_getinL_LHS",4.1,0,1,1,1,1);
		case 31: ApplyAnimation(playerid,"PED","CAR_getinL_RHS",4.1,0,1,1,1,1);
		case 32: ApplyAnimation(playerid,"PED","CAR_getin_LHS",4.1,0,1,1,1,1);
		case 33: ApplyAnimation(playerid,"PED","CAR_getin_RHS",4.1,0,1,1,1,1);
		case 34: ApplyAnimation(playerid,"PED","CAR_getoutL_LHS",4.1,0,1,1,1,1);
		case 35: ApplyAnimation(playerid,"PED","CAR_getoutL_RHS",4.1,0,1,1,1,1);
		case 36: ApplyAnimation(playerid,"PED","CAR_getout_LHS",4.1,0,1,1,1,1);
		case 37: ApplyAnimation(playerid,"PED","CAR_getout_RHS",4.1,0,1,1,1,1);
		case 38: ApplyAnimation(playerid,"PED","car_hookertalk",4.1,0,1,1,1,1);
		case 39: ApplyAnimation(playerid,"PED","CAR_jackedLHS",4.1,0,1,1,1,1);
		case 40: ApplyAnimation(playerid,"PED","CAR_jackedRHS",4.1,0,1,1,1,1);
		case 41: ApplyAnimation(playerid,"PED","CAR_jumpin_LHS",4.1,0,1,1,1,1);
		case 42: ApplyAnimation(playerid,"PED","CAR_LB",4.1,0,1,1,1,1);
		case 43: ApplyAnimation(playerid,"PED","CAR_LB_pro",4.1,0,1,1,1,1);
		case 44: ApplyAnimation(playerid,"PED","CAR_LB_weak",4.1,0,1,1,1,1);
		case 45: ApplyAnimation(playerid,"PED","CAR_LjackedLHS",4.1,0,1,1,1,1);
		case 46: ApplyAnimation(playerid,"PED","CAR_LjackedRHS",4.1,0,1,1,1,1);
		case 47: ApplyAnimation(playerid,"PED","CAR_Lshuffle_RHS",4.1,0,1,1,1,1);
		case 48: ApplyAnimation(playerid,"PED","CAR_Lsit",4.1,0,1,1,1,1);
		case 49: ApplyAnimation(playerid,"PED","CAR_open_LHS",4.1,0,1,1,1,1);
		case 50: ApplyAnimation(playerid,"PED","CAR_open_RHS",4.1,0,1,1,1,1);
		case 51: ApplyAnimation(playerid,"PED","CAR_pulloutL_LHS",4.1,0,1,1,1,1);
		case 52: ApplyAnimation(playerid,"PED","CAR_pulloutL_RHS",4.1,0,1,1,1,1);
		case 53: ApplyAnimation(playerid,"PED","CAR_pullout_LHS",4.1,0,1,1,1,1);
		case 54: ApplyAnimation(playerid,"PED","CAR_pullout_RHS",4.1,0,1,1,1,1);
		case 55: ApplyAnimation(playerid,"PED","CAR_Qjacked",4.1,0,1,1,1,1);
		case 56: ApplyAnimation(playerid,"PED","CAR_rolldoor",4.1,0,1,1,1,1);
		case 57: ApplyAnimation(playerid,"PED","CAR_rolldoorLO",4.1,0,1,1,1,1);
		case 58: ApplyAnimation(playerid,"PED","CAR_rollout_LHS",4.1,0,1,1,1,1);
		case 59: ApplyAnimation(playerid,"PED","CAR_rollout_RHS",4.1,0,1,1,1,1);
		case 60: ApplyAnimation(playerid,"PED","CAR_shuffle_RHS",4.1,0,1,1,1,1);
		case 61: ApplyAnimation(playerid,"PED","CAR_sit",4.1,0,1,1,1,1);
		case 62: ApplyAnimation(playerid,"PED","CAR_sitp",4.1,0,1,1,1,1);
		case 63: ApplyAnimation(playerid,"PED","CAR_sitpLO",4.1,0,1,1,1,1);
		case 64: ApplyAnimation(playerid,"PED","CAR_sit_pro",4.1,0,1,1,1,1);
		case 65: ApplyAnimation(playerid,"PED","CAR_sit_weak",4.1,0,1,1,1,1);
		case 66: ApplyAnimation(playerid,"PED","CAR_tune_radio",4.1,0,1,1,1,1);
		case 67: ApplyAnimation(playerid,"PED","CLIMB_idle",4.1,0,1,1,1,1);
		case 68: ApplyAnimation(playerid,"PED","CLIMB_jump",4.1,0,1,1,1,1);
		case 69: ApplyAnimation(playerid,"PED","CLIMB_jump2fall",4.1,0,1,1,1,1);
		case 70: ApplyAnimation(playerid,"PED","CLIMB_jump_B",4.1,0,1,1,1,1);
		case 71: ApplyAnimation(playerid,"PED","CLIMB_Pull",4.1,0,1,1,1,1);
		case 72: ApplyAnimation(playerid,"PED","CLIMB_Stand",4.1,0,1,1,1,1);
		case 73: ApplyAnimation(playerid,"PED","CLIMB_Stand_finish",4.1,0,1,1,1,1);
		case 74: ApplyAnimation(playerid,"PED","cower",4.1,0,1,1,1,1);
		case 75: ApplyAnimation(playerid,"PED","Crouch_Roll_L",4.1,0,1,1,1,1);
		case 76: ApplyAnimation(playerid,"PED","Crouch_Roll_R",4.1,0,1,1,1,1);
		case 77: ApplyAnimation(playerid,"PED","DAM_armL_frmBK",4.1,0,1,1,1,1);
		case 78: ApplyAnimation(playerid,"PED","DAM_armL_frmFT",4.1,0,1,1,1,1);
		case 79: ApplyAnimation(playerid,"PED","DAM_armL_frmLT",4.1,0,1,1,1,1);
		case 80: ApplyAnimation(playerid,"PED","DAM_armR_frmBK",4.1,0,1,1,1,1);
		case 81: ApplyAnimation(playerid,"PED","DAM_armR_frmFT",4.1,0,1,1,1,1);
		case 82: ApplyAnimation(playerid,"PED","DAM_armR_frmRT",4.1,0,1,1,1,1);
		case 83: ApplyAnimation(playerid,"PED","DAM_LegL_frmBK",4.1,0,1,1,1,1);
		case 84: ApplyAnimation(playerid,"PED","DAM_LegL_frmFT",4.1,0,1,1,1,1);
		case 85: ApplyAnimation(playerid,"PED","DAM_LegL_frmLT",4.1,0,1,1,1,1);
		case 86: ApplyAnimation(playerid,"PED","DAM_LegR_frmBK",4.1,0,1,1,1,1);
		case 87: ApplyAnimation(playerid,"PED","DAM_LegR_frmFT",4.1,0,1,1,1,1);
		case 88: ApplyAnimation(playerid,"PED","DAM_LegR_frmRT",4.1,0,1,1,1,1);
		case 89: ApplyAnimation(playerid,"PED","DAM_stomach_frmBK",4.1,0,1,1,1,1);
		case 90: ApplyAnimation(playerid,"PED","DAM_stomach_frmFT",4.1,0,1,1,1,1);
		case 91: ApplyAnimation(playerid,"PED","DAM_stomach_frmLT",4.1,0,1,1,1,1);
		case 92: ApplyAnimation(playerid,"PED","DAM_stomach_frmRT",4.1,0,1,1,1,1);
		case 93: ApplyAnimation(playerid,"PED","DOOR_LHinge_O",4.1,0,1,1,1,1);
		case 94: ApplyAnimation(playerid,"PED","DOOR_RHinge_O",4.1,0,1,1,1,1);
		case 95: ApplyAnimation(playerid,"PED","DrivebyL_L",4.1,0,1,1,1,1);
		case 96: ApplyAnimation(playerid,"PED","DrivebyL_R",4.1,0,1,1,1,1);
		case 97: ApplyAnimation(playerid,"PED","Driveby_L",4.1,0,1,1,1,1);
		case 98: ApplyAnimation(playerid,"PED","Driveby_R",4.1,0,1,1,1,1);
		case 99: ApplyAnimation(playerid,"PED","DRIVE_BOAT",4.1,0,1,1,1,1);
		case 100: ApplyAnimation(playerid,"PED","DRIVE_BOAT_back",4.1,0,1,1,1,1);
		case 101: ApplyAnimation(playerid,"PED","DRIVE_BOAT_L",4.1,0,1,1,1,1);
		case 102: ApplyAnimation(playerid,"PED","DRIVE_BOAT_R",4.1,0,1,1,1,1);
		case 103: ApplyAnimation(playerid,"PED","Drive_L",4.1,0,1,1,1,1);
		case 104: ApplyAnimation(playerid,"PED","Drive_LO_l",4.1,0,1,1,1,1);
		case 105: ApplyAnimation(playerid,"PED","Drive_LO_R",4.1,0,1,1,1,1);
		case 106: ApplyAnimation(playerid,"PED","Drive_L_pro",4.1,0,1,1,1,1);
		case 107: ApplyAnimation(playerid,"PED","Drive_L_pro_slow",4.1,0,1,1,1,1);
		case 108: ApplyAnimation(playerid,"PED","Drive_L_slow",4.1,0,1,1,1,1);
		case 109: ApplyAnimation(playerid,"PED","Drive_L_weak",4.1,0,1,1,1,1);
		case 110: ApplyAnimation(playerid,"PED","Drive_L_weak_slow",4.1,0,1,1,1,1);
		case 111: ApplyAnimation(playerid,"PED","Drive_R",4.1,0,1,1,1,1);
		case 112: ApplyAnimation(playerid,"PED","Drive_R_pro",4.1,0,1,1,1,1);
		case 113: ApplyAnimation(playerid,"PED","Drive_R_pro_slow",4.1,0,1,1,1,1);
		case 114: ApplyAnimation(playerid,"PED","Drive_R_slow",4.1,0,1,1,1,1);
		case 115: ApplyAnimation(playerid,"PED","Drive_R_weak",4.1,0,1,1,1,1);
		case 116: ApplyAnimation(playerid,"PED","Drive_R_weak_slow",4.1,0,1,1,1,1);
		case 117: ApplyAnimation(playerid,"PED","Drive_truck",4.1,0,1,1,1,1);
		case 118: ApplyAnimation(playerid,"PED","DRIVE_truck_back",4.1,0,1,1,1,1);
		case 119: ApplyAnimation(playerid,"PED","DRIVE_truck_L",4.1,0,1,1,1,1);
		case 120: ApplyAnimation(playerid,"PED","DRIVE_truck_R",4.1,0,1,1,1,1);
		case 121: ApplyAnimation(playerid,"PED","Drown",4.1,0,1,1,1,1);
		case 122: ApplyAnimation(playerid,"PED","DUCK_cower",4.1,0,1,1,1,1);
		case 123: ApplyAnimation(playerid,"PED","endchat_01",4.1,0,1,1,1,1);
		case 124: ApplyAnimation(playerid,"PED","endchat_02",4.1,0,1,1,1,1);
		case 125: ApplyAnimation(playerid,"PED","endchat_03",4.1,0,1,1,1,1);
		case 126: ApplyAnimation(playerid,"PED","EV_dive",4.1,0,1,1,1,1);
		case 127: ApplyAnimation(playerid,"PED","EV_step",4.1,0,1,1,1,1);
		case 128: ApplyAnimation(playerid,"PED","facanger",4.1,0,1,1,1,1);
		case 129: ApplyAnimation(playerid,"PED","facanger",4.1,0,1,1,1,1);
		case 130: ApplyAnimation(playerid,"PED","facgum",4.1,0,1,1,1,1);
		case 131: ApplyAnimation(playerid,"PED","facsurp",4.1,0,1,1,1,1);
		case 132: ApplyAnimation(playerid,"PED","facsurpm",4.1,0,1,1,1,1);
		case 133: ApplyAnimation(playerid,"PED","factalk",4.1,0,1,1,1,1);
		case 134: ApplyAnimation(playerid,"PED","facurios",4.1,0,1,1,1,1);
		case 135: ApplyAnimation(playerid,"PED","FALL_back",4.1,0,1,1,1,1);
		case 136: ApplyAnimation(playerid,"PED","FALL_collapse",4.1,0,1,1,1,1);
		case 137: ApplyAnimation(playerid,"PED","FALL_fall",4.1,0,1,1,1,1);
		case 138: ApplyAnimation(playerid,"PED","FALL_front",4.1,0,1,1,1,1);
		case 139: ApplyAnimation(playerid,"PED","FALL_glide",4.1,0,1,1,1,1);
		case 140: ApplyAnimation(playerid,"PED","FALL_land",4.1,0,1,1,1,1);
		case 141: ApplyAnimation(playerid,"PED","FALL_skyDive",4.1,0,1,1,1,1);
		case 142: ApplyAnimation(playerid,"PED","Fight2Idle",4.1,0,1,1,1,1);
		case 143: ApplyAnimation(playerid,"PED","FightA_1",4.1,0,1,1,1,1);
		case 144: ApplyAnimation(playerid,"PED","FightA_2",4.1,0,1,1,1,1);
		case 145: ApplyAnimation(playerid,"PED","FightA_3",4.1,0,1,1,1,1);
		case 146: ApplyAnimation(playerid,"PED","FightA_block",4.1,0,1,1,1,1);
		case 147: ApplyAnimation(playerid,"PED","FightA_G",4.1,0,1,1,1,1);
		case 148: ApplyAnimation(playerid,"PED","FightA_M",4.1,0,1,1,1,1);
		case 149: ApplyAnimation(playerid,"PED","FIGHTIDLE",4.1,0,1,1,1,1);
		case 150: ApplyAnimation(playerid,"PED","FightShB",4.1,0,1,1,1,1);
		case 151: ApplyAnimation(playerid,"PED","FightShF",4.1,0,1,1,1,1);
		case 152: ApplyAnimation(playerid,"PED","FightSh_BWD",4.1,0,1,1,1,1);
		case 153: ApplyAnimation(playerid,"PED","FightSh_FWD",4.1,0,1,1,1,1);
		case 154: ApplyAnimation(playerid,"PED","FightSh_Left",4.1,0,1,1,1,1);
		case 155: ApplyAnimation(playerid,"PED","FightSh_Right",4.1,0,1,1,1,1);
		case 156: ApplyAnimation(playerid,"PED","flee_lkaround_01",4.1,0,1,1,1,1);
		case 157: ApplyAnimation(playerid,"PED","FLOOR_hit",4.1,0,1,1,1,1);
		case 158: ApplyAnimation(playerid,"PED","FLOOR_hit_f",4.1,0,1,1,1,1);
		case 159: ApplyAnimation(playerid,"PED","fucku",4.1,0,1,1,1,1);
		case 160: ApplyAnimation(playerid,"PED","gang_gunstand",4.1,0,1,1,1,1);
		case 161: ApplyAnimation(playerid,"PED","gas_cwr",4.1,0,1,1,1,1);
		case 162: ApplyAnimation(playerid,"PED","getup",4.1,0,1,1,1,1);
		case 163: ApplyAnimation(playerid,"PED","getup_front",4.1,0,1,1,1,1);
		case 164: ApplyAnimation(playerid,"PED","gum_eat",4.1,0,1,1,1,1);
		case 165: ApplyAnimation(playerid,"PED","GunCrouchBwd",4.1,0,1,1,1,1);
		case 166: ApplyAnimation(playerid,"PED","GunCrouchFwd",4.1,0,1,1,1,1);
		case 167: ApplyAnimation(playerid,"PED","GunMove_BWD",4.1,0,1,1,1,1);
		case 168: ApplyAnimation(playerid,"PED","GunMove_FWD",4.1,0,1,1,1,1);
		case 169: ApplyAnimation(playerid,"PED","GunMove_L",4.1,0,1,1,1,1);
		case 170: ApplyAnimation(playerid,"PED","GunMove_R",4.1,0,1,1,1,1);
		case 171: ApplyAnimation(playerid,"PED","Gun_2_IDLE",4.1,0,1,1,1,1);
		case 172: ApplyAnimation(playerid,"PED","GUN_BUTT",4.1,0,1,1,1,1);
		case 173: ApplyAnimation(playerid,"PED","GUN_BUTT_crouch",4.1,0,1,1,1,1);
		case 174: ApplyAnimation(playerid,"PED","Gun_stand",4.1,0,1,1,1,1);
		case 175: ApplyAnimation(playerid,"PED","handscower",4.1,0,1,1,1,1);
		case 176: ApplyAnimation(playerid,"PED","handsup",4.1,0,1,1,1,1);
		case 177: ApplyAnimation(playerid,"PED","HitA_1",4.1,0,1,1,1,1);
		case 178: ApplyAnimation(playerid,"PED","HitA_2",4.1,0,1,1,1,1);
		case 179: ApplyAnimation(playerid,"PED","HitA_3",4.1,0,1,1,1,1);
		case 180: ApplyAnimation(playerid,"PED","HIT_back",4.1,0,1,1,1,1);
		case 181: ApplyAnimation(playerid,"PED","HIT_behind",4.1,0,1,1,1,1);
		case 182: ApplyAnimation(playerid,"PED","HIT_front",4.1,0,1,1,1,1);
		case 183: ApplyAnimation(playerid,"PED","HIT_GUN_BUTT",4.1,0,1,1,1,1);
		case 184: ApplyAnimation(playerid,"PED","HIT_L",4.1,0,1,1,1,1);
		case 185: ApplyAnimation(playerid,"PED","HIT_R",4.1,0,1,1,1,1);
		case 186: ApplyAnimation(playerid,"PED","HIT_walk",4.1,0,1,1,1,1);
		case 187: ApplyAnimation(playerid,"PED","HIT_wall",4.1,0,1,1,1,1);
		case 188: ApplyAnimation(playerid,"PED","Idlestance_fat",4.1,0,1,1,1,1);
		case 189: ApplyAnimation(playerid,"PED","idlestance_old",4.1,0,1,1,1,1);
		case 190: ApplyAnimation(playerid,"PED","IDLE_armed",4.1,0,1,1,1,1);
		case 191: ApplyAnimation(playerid,"PED","IDLE_chat",4.1,0,1,1,1,1);
		case 192: ApplyAnimation(playerid,"PED","IDLE_csaw",4.1,0,1,1,1,1);
		case 193: ApplyAnimation(playerid,"PED","Idle_Gang1",4.1,0,1,1,1,1);
		case 194: ApplyAnimation(playerid,"PED","IDLE_HBHB",4.1,0,1,1,1,1);
		case 195: ApplyAnimation(playerid,"PED","IDLE_ROCKET",4.1,0,1,1,1,1);
		case 196: ApplyAnimation(playerid,"PED","IDLE_stance",4.1,0,1,1,1,1);
		case 197: ApplyAnimation(playerid,"PED","IDLE_taxi",4.1,0,1,1,1,1);
		case 198: ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,1,1);
		case 199: ApplyAnimation(playerid,"PED","Jetpack_Idle",4.1,0,1,1,1,1);
		case 200: ApplyAnimation(playerid,"PED","JOG_femaleA",4.1,0,1,1,1,1);
		case 201: ApplyAnimation(playerid,"PED","JOG_maleA",4.1,0,1,1,1,1);
		case 202: ApplyAnimation(playerid,"PED","JUMP_glide",4.1,0,1,1,1,1);
		case 203: ApplyAnimation(playerid,"PED","JUMP_land",4.1,0,1,1,1,1);
		case 204: ApplyAnimation(playerid,"PED","JUMP_launch",4.1,0,1,1,1,1);
		case 205: ApplyAnimation(playerid,"PED","JUMP_launch_R",4.1,0,1,1,1,1);
		case 206: ApplyAnimation(playerid,"PED","KART_drive",4.1,0,1,1,1,1);
		case 207: ApplyAnimation(playerid,"PED","KART_L",4.1,0,1,1,1,1);
		case 208: ApplyAnimation(playerid,"PED","KART_LB",4.1,0,1,1,1,1);
		case 209: ApplyAnimation(playerid,"PED","KART_R",4.1,0,1,1,1,1);
		case 210: ApplyAnimation(playerid,"PED","KD_left",4.1,0,1,1,1,1);
		case 211: ApplyAnimation(playerid,"PED","KD_right",4.1,0,1,1,1,1);
		case 212: ApplyAnimation(playerid,"PED","KO_shot_face",4.1,0,1,1,1,1);
		case 213: ApplyAnimation(playerid,"PED","KO_shot_front",4.1,0,1,1,1,1);
		case 214: ApplyAnimation(playerid,"PED","KO_shot_stom",4.1,0,1,1,1,1);
		case 215: ApplyAnimation(playerid,"PED","KO_skid_back",4.1,0,1,1,1,1);
		case 216: ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,1,1,1,1);
		case 217: ApplyAnimation(playerid,"PED","KO_spin_L",4.1,0,1,1,1,1);
		case 218: ApplyAnimation(playerid,"PED","KO_spin_R",4.1,0,1,1,1,1);
		case 219: ApplyAnimation(playerid,"PED","pass_Smoke_in_car",4.1,0,1,1,1,1);
		case 220: ApplyAnimation(playerid,"PED","phone_in",4.1,0,1,1,1,1);
		case 221: ApplyAnimation(playerid,"PED","phone_out",4.1,0,1,1,1,1);
		case 222: ApplyAnimation(playerid,"PED","phone_talk",4.1,0,1,1,1,1);
		case 223: ApplyAnimation(playerid,"PED","Player_Sneak",4.1,0,1,1,1,1);
		case 224: ApplyAnimation(playerid,"PED","Player_Sneak_walkstart",4.1,0,1,1,1,1);
		case 225: ApplyAnimation(playerid,"PED","roadcross",4.1,0,1,1,1,1);
		case 226: ApplyAnimation(playerid,"PED","roadcross_female",4.1,0,1,1,1,1);
		case 227: ApplyAnimation(playerid,"PED","roadcross_gang",4.1,0,1,1,1,1);
		case 228: ApplyAnimation(playerid,"PED","roadcross_old",4.1,0,1,1,1,1);
		case 229: ApplyAnimation(playerid,"PED","run_1armed",4.1,0,1,1,1,1);
		case 230: ApplyAnimation(playerid,"PED","run_armed",4.1,0,1,1,1,1);
		case 231: ApplyAnimation(playerid,"PED","run_civi",4.1,0,1,1,1,1);
		case 232: ApplyAnimation(playerid,"PED","run_csaw",4.1,0,1,1,1,1);
		case 233: ApplyAnimation(playerid,"PED","run_fat",4.1,0,1,1,1,1);
		case 234: ApplyAnimation(playerid,"PED","run_fatold",4.1,0,1,1,1,1);
		case 235: ApplyAnimation(playerid,"PED","run_gang1",4.1,0,1,1,1,1);
		case 236: ApplyAnimation(playerid,"PED","run_left",4.1,0,1,1,1,1);
		case 237: ApplyAnimation(playerid,"PED","run_old",4.1,0,1,1,1,1);
		case 238: ApplyAnimation(playerid,"PED","run_player",4.1,0,1,1,1,1);
		case 239: ApplyAnimation(playerid,"PED","run_right",4.1,0,1,1,1,1);
		case 240: ApplyAnimation(playerid,"PED","run_rocket",4.1,0,1,1,1,1);
		case 241: ApplyAnimation(playerid,"PED","Run_stop",4.1,0,1,1,1,1);
		case 242: ApplyAnimation(playerid,"PED","Run_stopR",4.1,0,1,1,1,1);
		case 243: ApplyAnimation(playerid,"PED","Run_Wuzi",4.1,0,1,1,1,1);
		case 244: ApplyAnimation(playerid,"PED","SEAT_down",4.1,0,1,1,1,1);
		case 245: ApplyAnimation(playerid,"PED","SEAT_idle",4.1,0,1,1,1,1);
		case 246: ApplyAnimation(playerid,"PED","SEAT_up",4.1,0,1,1,1,1);
		case 247: ApplyAnimation(playerid,"PED","SHOT_leftP",4.1,0,1,1,1,1);
		case 248: ApplyAnimation(playerid,"PED","SHOT_partial",4.1,0,1,1,1,1);
		case 249: ApplyAnimation(playerid,"PED","SHOT_partial_B",4.1,0,1,1,1,1);
		case 250: ApplyAnimation(playerid,"PED","SHOT_rightP",4.1,0,1,1,1,1);
		case 251: ApplyAnimation(playerid,"PED","Shove_Partial",4.1,0,1,1,1,1);
		case 252: ApplyAnimation(playerid,"PED","Smoke_in_car",4.1,0,1,1,1,1);
		case 253: ApplyAnimation(playerid,"PED","sprint_civi",4.1,0,1,1,1,1);
		case 254: ApplyAnimation(playerid,"PED","sprint_panic",4.1,0,1,1,1,1);
		case 255: ApplyAnimation(playerid,"PED","Sprint_Wuzi",4.1,0,1,1,1,1);
		case 256: ApplyAnimation(playerid,"PED","swat_run",4.1,0,1,1,1,1);
		case 257: ApplyAnimation(playerid,"PED","Swim_Tread",4.1,0,1,1,1,1);
		case 258: ApplyAnimation(playerid,"PED","Tap_hand",4.1,0,1,1,1,1);
		case 259: ApplyAnimation(playerid,"PED","Tap_handP",4.1,0,1,1,1,1);
		case 260: ApplyAnimation(playerid,"PED","turn_180",4.1,0,1,1,1,1);
		case 261: ApplyAnimation(playerid,"PED","Turn_L",4.1,0,1,1,1,1);
		case 262: ApplyAnimation(playerid,"PED","Turn_R",4.1,0,1,1,1,1);
		case 263: ApplyAnimation(playerid,"PED","WALK_armed",4.1,0,1,1,1,1);
		case 264: ApplyAnimation(playerid,"PED","WALK_civi",4.1,0,1,1,1,1);
		case 265: ApplyAnimation(playerid,"PED","WALK_csaw",4.1,0,1,1,1,1);
		case 266: ApplyAnimation(playerid,"PED","Walk_DoorPartial",4.1,0,1,1,1,1);
		case 267: ApplyAnimation(playerid,"PED","WALK_drunk",4.1,0,1,1,1,1);
		case 268: ApplyAnimation(playerid,"PED","WALK_fat",4.1,0,1,1,1,1);
		case 269: ApplyAnimation(playerid,"PED","WALK_fatold",4.1,0,1,1,1,1);
		case 270: ApplyAnimation(playerid,"PED","WALK_gang1",4.1,0,1,1,1,1);
		case 271: ApplyAnimation(playerid,"PED","WALK_gang2",4.1,0,1,1,1,1);
		case 272: ApplyAnimation(playerid,"PED","WALK_old",4.1,0,1,1,1,1);
		case 273: ApplyAnimation(playerid,"PED","WALK_player",4.1,0,1,1,1,1);
		case 274: ApplyAnimation(playerid,"PED","WALK_rocket",4.1,0,1,1,1,1);
		case 275: ApplyAnimation(playerid,"PED","WALK_shuffle",4.1,0,1,1,1,1);
		case 276: ApplyAnimation(playerid,"PED","WALK_start",4.1,0,1,1,1,1);
		case 277: ApplyAnimation(playerid,"PED","WALK_start_armed",4.1,0,1,1,1,1);
		case 278: ApplyAnimation(playerid,"PED","WALK_start_csaw",4.1,0,1,1,1,1);
		case 279: ApplyAnimation(playerid,"PED","WALK_start_rocket",4.1,0,1,1,1,1);
		case 280: ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,0,1,1,1,1);
		case 281: ApplyAnimation(playerid,"PED","WEAPON_crouch",4.1,0,1,1,1,1);
		case 282: ApplyAnimation(playerid,"PED","woman_idlestance",4.1,0,1,1,1,1);
		case 283: ApplyAnimation(playerid,"PED","woman_run",4.1,0,1,1,1,1);
		case 284: ApplyAnimation(playerid,"PED","WOMAN_runbusy",4.1,0,1,1,1,1);
		case 285: ApplyAnimation(playerid,"PED","WOMAN_runfatold",4.1,0,1,1,1,1);
		case 286: ApplyAnimation(playerid,"PED","woman_runpanic",4.1,0,1,1,1,1);
		case 287: ApplyAnimation(playerid,"PED","WOMAN_runsexy",4.1,0,1,1,1,1);
		case 288: ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,0,1,1,1,1);
		case 289: ApplyAnimation(playerid,"PED","WOMAN_walkfatold",4.1,0,1,1,1,1);
		case 290: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,0,1,1,1,1);
		case 291: ApplyAnimation(playerid,"PED","WOMAN_walkold",4.1,0,1,1,1,1);
		case 292: ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,0,1,1,1,1);
		case 293: ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,0,1,1,1,1);
		case 294: ApplyAnimation(playerid,"PED","WOMAN_walkshop",4.1,0,1,1,1,1);
		case 295: ApplyAnimation(playerid,"PED","XPRESSscratch",4.1,0,1,1,1,1);
	}
	return;
}

public OnPlayerCrashVehicle(playerid, vehicleid, Float:damage)
{
	new string[256];
	format(string, sizeof(string), "Você bateu o veículo %d e teve %f de dano", vehicleid, damage);
	SendClientMessage(playerid, -1, string);

	new Float:playerDamage = damage * 3.0 / 10.0;
	new playerDrunkLevel = GetPlayerDrunkLevel(playerid);
	
	if(hasSeatBelt[playerid])
	{
		playerDamage /= REDUCAO_DANO_CINTO;
	}
	else
	{
		// if(damage > 230.0)
		if(damage > 50.0)
		{
			// new vehicleModel = GetVehicleModel(vehicleid);
			new 
				Float:vehicleVelocityX,
				Float:vehicleVelocityY,
				Float:vehicleVelocityZ,
				Float:vehiclePosX,
				Float:vehiclePosY,
				Float:vehiclePosZ,
				Float:vehicleAngle;
				// Float:vehicleSizeX,
				// Float:vehicleSizeY,
				// Float:vehicleSizeZ;

			GetVehiclePos(vehicleid, vehiclePosX, vehiclePosY, vehiclePosZ);
			GetVehicleVelocity(vehicleid, vehicleVelocityX, vehicleVelocityY, vehicleVelocityZ);
			GetVehicleZAngle(vehicleid, vehicleAngle);
			vehicleAngle = 360.0 - vehicleAngle;

			new Float:plusX = floatsin(vehicleAngle, degrees);
			new Float:plusY = floatcos(vehicleAngle, degrees);

			SetPlayerPos(playerid, vehiclePosX + plusX, vehiclePosY + plusY, vehiclePosZ + 1.5);
			SetPlayerVelocity(playerid, (vehicleVelocityX+1.0) * plusX, (vehicleVelocityY+1.0) * plusY, (vehicleVelocityZ+0.2) * 0.5);
			SetTimerEx("animation", 200, false, "ii", playerid, 6);
			SetTimerEx("animation", 250, false, "ii", playerid, 6);
			SetTimerEx("animation", 300, false, "ii", playerid, 6);
			SetTimerEx("animation", 575, false, "ii", playerid, 215);

			// GetVehiclePos(vehicleid, vehiclePosX, vehiclePosY, vehiclePosZ);
			// GetVehicleModelInfo(vehicleModel, VEHICLE_MODEL_INFO_SIZE, vehicleSizeX, vehicleSizeY, vehicleSizeZ);

			// SetPlayerPos(playerid, vehiclePosX + vehicleSizeX/2.0, vehiclePosY + vehicleSizeY/2.0, vehiclePosZ + vehicleSizeZ/2.0);
			// // RemovePlayerFromVehicle(playerid);
			// SetPlayerVelocity(playerid, vehicleVelocityX, vehicleVelocityY, vehicleVelocityZ);
		}
	}

	playerDrunkLevel += floatround(playerDamage * COEFICIENTE_DRUNK_LEVEL, floatround_ceil);
	SetPlayerDrunkLevel(playerid, playerDrunkLevel);

	format(string, sizeof(string), "Possível dano: %f", playerDamage);
	SendClientMessage(playerid, -1, string);
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	new idx;
	new cmd[256];
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/cinto", true) == 0) {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Este comando só pode ser utilizado dentro de um veículo.");
		
		if(hasSeatBelt[playerid])
		{
			GameTextForPlayer(playerid, "~y~CINTO DE SEGURANCA~n~~r~RETIRADO", 5000, 3);
			hasSeatBelt[playerid] = false;
		}
		else
		{
			GameTextForPlayer(playerid, "~y~CINTO DE SEGURANCA~n~~g~COLOCADO", 5000, 3);
			hasSeatBelt[playerid] = true;
		}
		return 1;
	}

	if(strcmp(cmd, "/teste", true) == 0) {
		SetPlayerDrunkLevel(playerid, 2000);
		TogglePlayerControllable(playerid, 1);

		return 1;
	}

	if(strcmp(cmd, "/testes", true) == 0) {
		SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
		return 1;
	}

    // if(strcmp(cmd, "/comando", true) == 0) {
	// 	tmp = strtok(cmdtext, idx);
    //     if(!strlen(tmp))
    //     {
    //         SendClientMessage(playerid, -1, "Use: /comando [id]");
    //         return 1;
    //     }
    //     new id = strval(tmp);
	// 	return 1;
	// }

    return 0;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// IsNumeric(const string[])
// {
// 	for (new i = 0, j = strlen(string); i < j; i++)
// 	{
// 		if (string[i] > '9' || string[i] < '0') return 0;
// 	}
// 	return 1;
// }

// ReturnUser(text[], playerid = INVALID_PLAYER_ID)
// {
// 	new pos = 0;
// 	while (text[pos] < 0x21) // Strip out leading spaces
// 	{
// 		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
// 		pos++;
// 	}
// 	new userid = INVALID_PLAYER_ID;
// 	if (IsNumeric(text[pos])) // Check whole passed string
// 	{
// 		// If they have a numeric name you have a problem (although names are checked on id failure)
// 		userid = strval(text[pos]);
// 		if (userid >=0 && userid < MAX_PLAYERS)
// 		{
// 			if(!IsPlayerConnected(userid))
// 			{
// 				/*if (playerid != INVALID_PLAYER_ID)
// 				{
// 					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
// 				}*/
// 				userid = INVALID_PLAYER_ID;
// 			}
// 			else
// 			{
// 				return userid; // A player was found
// 			}
// 		}
// 		/*else
// 		{
// 			if (playerid != INVALID_PLAYER_ID)
// 			{
// 				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
// 			}
// 			userid = INVALID_PLAYER_ID;
// 		}
// 		return userid;*/
// 		// Removed for fallthrough code
// 	}
// 	// They entered [part of] a name or the id search failed (check names just incase)
// 	new len = strlen(text[pos]);
// 	new count = 0;
// 	new name[MAX_PLAYER_NAME];
// 	for (new i = 0; i < MAX_PLAYERS; i++)
// 	{
// 		if (IsPlayerConnected(i))
// 		{
// 			GetPlayerName(i, name, sizeof (name));
// 			if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
// 			{
// 				if (len == strlen(name)) // Exact match
// 				{
// 					return i; // Return the exact player on an exact match
// 					// Otherwise if there are two players:
// 					// Me and MeYou any time you entered Me it would find both
// 					// And never be able to return just Me's id
// 				}
// 				else // Partial match
// 				{
// 					count++;
// 					userid = i;
// 				}
// 			}
// 		}
// 	}
// 	if (count != 1)
// 	{
// 		if (playerid != INVALID_PLAYER_ID)
// 		{
// 			if (count)
// 			{
// 				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
// 			}
// 			else
// 			{
// 				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
// 			}
// 		}
// 		userid = INVALID_PLAYER_ID;
// 	}
// 	return userid; // INVALID_USER_ID for bad return
// }