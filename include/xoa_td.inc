//Global Textdraws:

new Text:ao_Text[25];
new PlayerText:ao_pText[MAX_PLAYERS][11];

stock TD_Yukle()
{
ao_Text[0] = TextDrawCreate(515.882202, 137.999923, "usebox");
TextDrawLetterSize(ao_Text[0], 0.000000, 30.501363);
TextDrawTextSize(ao_Text[0], 117.999984, 0.000000);
TextDrawAlignment(ao_Text[0], 1);
TextDrawColor(ao_Text[0], 0);
TextDrawUseBox(ao_Text[0], true);
TextDrawBoxColor(ao_Text[0], 102);
TextDrawSetShadow(ao_Text[0], 0);
TextDrawSetOutline(ao_Text[0], 0);
TextDrawFont(ao_Text[0], 0);

ao_Text[1] = TextDrawCreate(322.823425, 122.499954, "~y~XpDeviL~w~'s Object Attacher");
TextDrawLetterSize(ao_Text[1], 0.561999, 2.189167);
TextDrawAlignment(ao_Text[1], 2);
TextDrawColor(ao_Text[1], -1);
TextDrawSetShadow(ao_Text[1], 0);
TextDrawSetOutline(ao_Text[1], 1);
TextDrawBackgroundColor(ao_Text[1], 51);
TextDrawFont(ao_Text[1], 0);
TextDrawSetProportional(ao_Text[1], 1);

ao_Text[2] = TextDrawCreate(130.823638, 151.083358, "Object Information:");
TextDrawLetterSize(ao_Text[2], 0.272117, 1.273329);
TextDrawAlignment(ao_Text[2], 1);
TextDrawColor(ao_Text[2], -1378294017);
TextDrawSetShadow(ao_Text[2], 0);
TextDrawSetOutline(ao_Text[2], 1);
TextDrawBackgroundColor(ao_Text[2], 51);
TextDrawFont(ao_Text[2], 3);
TextDrawSetProportional(ao_Text[2], 1);

ao_Text[3] = TextDrawCreate(183.058853, 242.083297, ".");
TextDrawLetterSize(ao_Text[3], 24.927700, 0.404166);
TextDrawAlignment(ao_Text[3], 1);
TextDrawColor(ao_Text[3], -1);
TextDrawSetShadow(ao_Text[3], 0);
TextDrawSetOutline(ao_Text[3], 1);
TextDrawBackgroundColor(ao_Text[3], 51);
TextDrawFont(ao_Text[3], 1);
TextDrawSetProportional(ao_Text[3], 1);

ao_Text[4] = TextDrawCreate(188.764709, 260.000091, "Object Options");
TextDrawLetterSize(ao_Text[4], 0.272117, 1.273329);
TextDrawAlignment(ao_Text[4], 2);
TextDrawColor(ao_Text[4], -1378294017);
TextDrawSetShadow(ao_Text[4], 0);
TextDrawSetOutline(ao_Text[4], 1);
TextDrawBackgroundColor(ao_Text[4], 51);
TextDrawFont(ao_Text[4], 3);
TextDrawSetProportional(ao_Text[4], 1);

ao_Text[5] = TextDrawCreate(191.529418, 286.416625, "Change Object ID");
TextDrawLetterSize(ao_Text[5], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[5], 10.941032, 110.833343);
TextDrawAlignment(ao_Text[5], 2);
TextDrawColor(ao_Text[5], -1);
TextDrawUseBox(ao_Text[5], true);
TextDrawBoxColor(ao_Text[5], 255);
TextDrawSetShadow(ao_Text[5], 0);
TextDrawSetOutline(ao_Text[5], 1);
TextDrawBackgroundColor(ao_Text[5], 51);
TextDrawFont(ao_Text[5], 2);
TextDrawSetProportional(ao_Text[5], 1);
TextDrawSetSelectable(ao_Text[5], true);

ao_Text[6] = TextDrawCreate(191.588302, 304.916717, "Change Bone");
TextDrawLetterSize(ao_Text[6], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[6], 10.941032, 110.833374);
TextDrawAlignment(ao_Text[6], 2);
TextDrawColor(ao_Text[6], -1);
TextDrawUseBox(ao_Text[6], true);
TextDrawBoxColor(ao_Text[6], 255);
TextDrawSetShadow(ao_Text[6], 0);
TextDrawSetOutline(ao_Text[6], 1);
TextDrawBackgroundColor(ao_Text[6], 51);
TextDrawFont(ao_Text[6], 2);
TextDrawSetProportional(ao_Text[6], 1);
TextDrawSetSelectable(ao_Text[6], true);

ao_Text[7] = TextDrawCreate(191.647125, 322.833282, "Change Position");
TextDrawLetterSize(ao_Text[7], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[7], 10.941032, 110.833374);
TextDrawAlignment(ao_Text[7], 2);
TextDrawColor(ao_Text[7], -1);
TextDrawUseBox(ao_Text[7], true);
TextDrawBoxColor(ao_Text[7], 255);
TextDrawSetShadow(ao_Text[7], 0);
TextDrawSetOutline(ao_Text[7], 1);
TextDrawBackgroundColor(ao_Text[7], 51);
TextDrawFont(ao_Text[7], 2);
TextDrawSetProportional(ao_Text[7], 1);
TextDrawSetSelectable(ao_Text[7], true);

ao_Text[8] = TextDrawCreate(191.705963, 340.750152, "Remove Object");
TextDrawLetterSize(ao_Text[8], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[8], 10.941032, 110.833374);
TextDrawAlignment(ao_Text[8], 2);
TextDrawColor(ao_Text[8], -16776961);
TextDrawUseBox(ao_Text[8], true);
TextDrawBoxColor(ao_Text[8], 255);
TextDrawSetShadow(ao_Text[8], 0);
TextDrawSetOutline(ao_Text[8], 1);
TextDrawBackgroundColor(ao_Text[8], 51);
TextDrawFont(ao_Text[8], 2);
TextDrawSetProportional(ao_Text[8], 1);
TextDrawSetSelectable(ao_Text[8], true);

ao_Text[9] = TextDrawCreate(191.764770, 359.250091, "Add Another Object");
TextDrawLetterSize(ao_Text[9], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[9], 10.941032, 110.833374);
TextDrawAlignment(ao_Text[9], 2);
TextDrawColor(ao_Text[9], 8388863);
TextDrawUseBox(ao_Text[9], true);
TextDrawBoxColor(ao_Text[9], 255);
TextDrawSetShadow(ao_Text[9], 0);
TextDrawSetOutline(ao_Text[9], 1);
TextDrawBackgroundColor(ao_Text[9], 51);
TextDrawFont(ao_Text[9], 2);
TextDrawSetProportional(ao_Text[9], 1);
TextDrawSetSelectable(ao_Text[9], true);

ao_Text[10] = TextDrawCreate(268.235351, 94.499847, ".");
TextDrawLetterSize(ao_Text[10], 0.108352, 34.517486);
TextDrawAlignment(ao_Text[10], 1);
TextDrawColor(ao_Text[10], -1);
TextDrawSetShadow(ao_Text[10], 0);
TextDrawSetOutline(ao_Text[10], 1);
TextDrawBackgroundColor(ao_Text[10], 51);
TextDrawFont(ao_Text[10], 1);
TextDrawSetProportional(ao_Text[10], 1);

ao_Text[11] = TextDrawCreate(318.704986, 259.833404, "Current Objects");
TextDrawLetterSize(ao_Text[11], 0.272117, 1.273329);
TextDrawAlignment(ao_Text[11], 2);
TextDrawColor(ao_Text[11], -1378294017);
TextDrawSetShadow(ao_Text[11], 0);
TextDrawSetOutline(ao_Text[11], 1);
TextDrawBackgroundColor(ao_Text[11], 51);
TextDrawFont(ao_Text[11], 3);
TextDrawSetProportional(ao_Text[11], 1);

ao_Text[12] = TextDrawCreate(318.646636, 286.249938, "Object 1");
TextDrawLetterSize(ao_Text[12], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[12], 10.941032, 50.166690);
TextDrawAlignment(ao_Text[12], 2);
TextDrawColor(ao_Text[12], -1);
TextDrawUseBox(ao_Text[12], true);
TextDrawBoxColor(ao_Text[12], 255);
TextDrawSetShadow(ao_Text[12], 0);
TextDrawSetOutline(ao_Text[12], 1);
TextDrawBackgroundColor(ao_Text[12], 51);
TextDrawFont(ao_Text[12], 2);
TextDrawSetProportional(ao_Text[12], 1);
TextDrawSetSelectable(ao_Text[12], true);

ao_Text[13] = TextDrawCreate(318.705474, 304.166717, "Object 2");
TextDrawLetterSize(ao_Text[13], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[13], 10.941032, 50.166690);
TextDrawAlignment(ao_Text[13], 2);
TextDrawColor(ao_Text[13], -1);
TextDrawUseBox(ao_Text[13], true);
TextDrawBoxColor(ao_Text[13], 255);
TextDrawSetShadow(ao_Text[13], 0);
TextDrawSetOutline(ao_Text[13], 1);
TextDrawBackgroundColor(ao_Text[13], 51);
TextDrawFont(ao_Text[13], 2);
TextDrawSetProportional(ao_Text[13], 1);
TextDrawSetSelectable(ao_Text[13], true);

ao_Text[14] = TextDrawCreate(318.293731, 322.083465, "Object 3");
TextDrawLetterSize(ao_Text[14], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[14], 10.941032, 50.166690);
TextDrawAlignment(ao_Text[14], 2);
TextDrawColor(ao_Text[14], -1);
TextDrawUseBox(ao_Text[14], true);
TextDrawBoxColor(ao_Text[14], 255);
TextDrawSetShadow(ao_Text[14], 0);
TextDrawSetOutline(ao_Text[14], 1);
TextDrawBackgroundColor(ao_Text[14], 51);
TextDrawFont(ao_Text[14], 2);
TextDrawSetProportional(ao_Text[14], 1);
TextDrawSetSelectable(ao_Text[14], true);

ao_Text[15] = TextDrawCreate(318.352569, 340.583496, "Object 4");
TextDrawLetterSize(ao_Text[15], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[15], 10.941032, 50.166690);
TextDrawAlignment(ao_Text[15], 2);
TextDrawColor(ao_Text[15], -1);
TextDrawUseBox(ao_Text[15], true);
TextDrawBoxColor(ao_Text[15], 255);
TextDrawSetShadow(ao_Text[15], 0);
TextDrawSetOutline(ao_Text[15], 1);
TextDrawBackgroundColor(ao_Text[15], 51);
TextDrawFont(ao_Text[15], 2);
TextDrawSetProportional(ao_Text[15], 1);
TextDrawSetSelectable(ao_Text[15], true);

ao_Text[16] = TextDrawCreate(318.411407, 359.083557, "Object 5");
TextDrawLetterSize(ao_Text[16], 0.190705, 1.372499);
TextDrawTextSize(ao_Text[16], 10.941032, 50.166690);
TextDrawAlignment(ao_Text[16], 2);
TextDrawColor(ao_Text[16], -1);
TextDrawUseBox(ao_Text[16], true);
TextDrawBoxColor(ao_Text[16], 255);
TextDrawSetShadow(ao_Text[16], 0);
TextDrawSetOutline(ao_Text[16], 1);
TextDrawBackgroundColor(ao_Text[16], 51);
TextDrawFont(ao_Text[16], 2);
TextDrawSetProportional(ao_Text[16], 1);
TextDrawSetSelectable(ao_Text[16], true);

ao_Text[17] = TextDrawCreate(371.352783, 95.499839, ".");
TextDrawLetterSize(ao_Text[17], 0.108352, 34.517486);
TextDrawAlignment(ao_Text[17], 1);
TextDrawColor(ao_Text[17], -1);
TextDrawSetShadow(ao_Text[17], 0);
TextDrawSetOutline(ao_Text[17], 1);
TextDrawBackgroundColor(ao_Text[17], 51);
TextDrawFont(ao_Text[17], 1);
TextDrawSetProportional(ao_Text[17], 1);

ao_Text[18] = TextDrawCreate(443.939422, 262.583404, "Options");
TextDrawLetterSize(ao_Text[18], 0.272117, 1.273329);
TextDrawAlignment(ao_Text[18], 2);
TextDrawColor(ao_Text[18], -1378294017);
TextDrawSetShadow(ao_Text[18], 0);
TextDrawSetOutline(ao_Text[18], 1);
TextDrawBackgroundColor(ao_Text[18], 51);
TextDrawFont(ao_Text[18], 3);
TextDrawSetProportional(ao_Text[18], 1);

ao_Text[19] = TextDrawCreate(395.294097, 294.583404, "LD_SPAC:white");
TextDrawLetterSize(ao_Text[19], 0.000000, 0.000000);
TextDrawTextSize(ao_Text[19], 36.705902, 43.166687);
TextDrawAlignment(ao_Text[19], 1);
TextDrawColor(ao_Text[19], -1);
TextDrawSetShadow(ao_Text[19], 0);
TextDrawSetOutline(ao_Text[19], 0);
TextDrawSetPreviewModel(ao_Text[19], 1277);
TextDrawFont(ao_Text[19], TEXT_DRAW_FONT_MODEL_PREVIEW);
TextDrawSetSelectable(ao_Text[19], true);

ao_Text[20] = TextDrawCreate(462.175628, 294.416687, "LD_SPAC:white");
TextDrawLetterSize(ao_Text[20], 0.000000, 0.000000);
TextDrawTextSize(ao_Text[20], 36.705902, 43.166687);
TextDrawAlignment(ao_Text[20], 1);
TextDrawColor(ao_Text[20], -1);
TextDrawSetShadow(ao_Text[20], 0);
TextDrawSetOutline(ao_Text[20], 0);
TextDrawSetPreviewModel(ao_Text[20], 1343);
TextDrawFont(ao_Text[20], TEXT_DRAW_FONT_MODEL_PREVIEW);
TextDrawSetSelectable(ao_Text[20], true);

ao_Text[21] = TextDrawCreate(415.058654, 341.250000, "Save All To .pwn~n~File");
TextDrawLetterSize(ao_Text[21], 0.211411, 0.899999);
TextDrawAlignment(ao_Text[21], 2);
TextDrawColor(ao_Text[21], -1);
TextDrawSetShadow(ao_Text[21], 0);
TextDrawSetOutline(ao_Text[21], 1);
TextDrawBackgroundColor(ao_Text[21], 51);
TextDrawFont(ao_Text[21], 1);
TextDrawSetProportional(ao_Text[21], 1);

ao_Text[22] = TextDrawCreate(481.940948, 342.833374, "Remove All");
TextDrawLetterSize(ao_Text[22], 0.211411, 0.899999);
TextDrawAlignment(ao_Text[22], 2);
TextDrawColor(ao_Text[22], -1);
TextDrawSetShadow(ao_Text[22], 0);
TextDrawSetOutline(ao_Text[22], 1);
TextDrawBackgroundColor(ao_Text[22], 51);
TextDrawFont(ao_Text[22], 1);
TextDrawSetProportional(ao_Text[22], 1);

ao_Text[23] = TextDrawCreate(180.294158, 383.083221, ".");
TextDrawLetterSize(ao_Text[23], 24.927700, 0.404166);
TextDrawAlignment(ao_Text[23], 1);
TextDrawColor(ao_Text[23], -1);
TextDrawSetShadow(ao_Text[23], 0);
TextDrawSetOutline(ao_Text[23], 1);
TextDrawBackgroundColor(ao_Text[23], 51);
TextDrawFont(ao_Text[23], 1);
TextDrawSetProportional(ao_Text[23], 1);

ao_Text[24] = TextDrawCreate(320.941375, 391.416412, "Close");
TextDrawLetterSize(ao_Text[24], 0.363882, 1.669999);
TextDrawTextSize(ao_Text[24], 10.941032, 45.166690);
TextDrawAlignment(ao_Text[24], 2);
TextDrawColor(ao_Text[24], -1);
TextDrawSetShadow(ao_Text[24], 0);
TextDrawSetOutline(ao_Text[24], 1);
TextDrawBackgroundColor(ao_Text[24], 51);
TextDrawFont(ao_Text[24], 1);
TextDrawSetProportional(ao_Text[24], 1);
TextDrawSetSelectable(ao_Text[24], true);
}


stock pTD_Yukle(playerid)
{
ao_pText[playerid][0] = CreatePlayerTextDraw(playerid, 136.000030, 173.833343, "_");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][0], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, ao_pText[playerid][0], 48.000000, 57.750000);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][0], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][0], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][0], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][0], 0);
PlayerTextDrawFont(playerid, ao_pText[playerid][0], TEXT_DRAW_FONT_MODEL_PREVIEW);

ao_pText[playerid][1] = CreatePlayerTextDraw(playerid, 192.941223, 175.583389, "Object ID: ~g~1274");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][1], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][1], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][1], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][1], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][1], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][1], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][1], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][1], 1);

ao_pText[playerid][2] = CreatePlayerTextDraw(playerid, 193.000061, 188.250045, "Object Offset X: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][2], 0.181764, 1.197499);
PlayerTextDrawTextSize(playerid, ao_pText[playerid][2], 296.000091, -28.583333);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][2], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][2], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][2], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][2], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][2], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][2], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][2], 1);

ao_pText[playerid][3] = CreatePlayerTextDraw(playerid, 193.058883, 201.499984, "Object Offset X: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][3], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][3], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][3], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][3], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][3], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][3], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][3], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][3], 1);

ao_pText[playerid][4] = CreatePlayerTextDraw(playerid, 192.647140, 215.333282, "Object Offset X: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][4], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][4], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][4], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][4], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][4], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][4], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][4], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][4], 1);

ao_pText[playerid][5] = CreatePlayerTextDraw(playerid, 307.528991, 187.750000, "Object Rot X: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][5], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][5], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][5], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][5], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][5], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][5], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][5], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][5], 1);

ao_pText[playerid][6] = CreatePlayerTextDraw(playerid, 307.117218, 201.583312, "Object Rot Y: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][6], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][6], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][6], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][6], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][6], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][6], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][6], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][6], 1);

ao_pText[playerid][7] = CreatePlayerTextDraw(playerid, 307.176208, 215.416641, "Object Rot Z: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][7], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][7], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][7], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][7], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][7], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][7], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][7], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][7], 1);

ao_pText[playerid][8] = CreatePlayerTextDraw(playerid, 411.116424, 187.583343, "Object Scale X: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][8], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][8], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][8], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][8], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][8], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][8], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][8], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][8], 1);

ao_pText[playerid][9] = CreatePlayerTextDraw(playerid, 410.704681, 201.416625, "Object Scale Y: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][9], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][9], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][9], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][9], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][9], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][9], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][9], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][9], 1);

ao_pText[playerid][10] = CreatePlayerTextDraw(playerid, 410.763519, 214.083297, "Object Scale Z: ~g~123.12345");
PlayerTextDrawLetterSize(playerid, ao_pText[playerid][10], 0.181764, 1.197499);
PlayerTextDrawAlignment(playerid, ao_pText[playerid][10], 1);
PlayerTextDrawColor(playerid, ao_pText[playerid][10], -1);
PlayerTextDrawSetShadow(playerid, ao_pText[playerid][10], 0);
PlayerTextDrawSetOutline(playerid, ao_pText[playerid][10], 1);
PlayerTextDrawBackgroundColor(playerid, ao_pText[playerid][10], 51);
PlayerTextDrawFont(playerid, ao_pText[playerid][10], 2);
PlayerTextDrawSetProportional(playerid, ao_pText[playerid][10], 1);
}