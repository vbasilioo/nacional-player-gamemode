new Text:Radinho;
new Text:ManualOct;
new Text:RCNH;
new Text:RSAMU;
new Text:RPORTE;
new Text:RRG;
new Text:pcivil[11];
new Text:PFF[8];
new Text:PMDET[5];
new Text:FMAR[3];
new Text:FABIN;
new Text:FABINN;
new PlayerText:ButtonRad[MAX_PLAYERS][2];
new PlayerText:FCNH[MAX_PLAYERS][6];
new PlayerText:FPORTE[MAX_PLAYERS][6];
new PlayerText:FRG[MAX_PLAYERS][8];
new PlayerText:FSAMU[MAX_PLAYERS][3];
new PlayerText:PMDETI[MAX_PLAYERS][4];
new PlayerText:EMAR[MAX_PLAYERS][5];
stock Module_Joel()
{
	FABINN = TextDrawCreate(386.000000, 173.000000, "LD_RACE:ABIN");
	TextDrawFont(FABINN, 4);
	TextDrawLetterSize(FABINN, 0.600000, 2.000000);
	TextDrawTextSize(FABINN, 63.500000, 73.500000);
	TextDrawSetOutline(FABINN, 1);
	TextDrawSetShadow(FABINN, 0);
	TextDrawAlignment(FABINN, 1);
	TextDrawColor(FABINN, -1);
	TextDrawBackgroundColor(FABINN, 255);
	TextDrawBoxColor(FABINN, 50);
	TextDrawUseBox(FABINN, 1);
	TextDrawSetProportional(FABINN, 1);
	TextDrawSetSelectable(FABINN, 0);

	FABIN = TextDrawCreate(386.000000, 173.000000, "LD_RACE:ABIN");
	TextDrawFont(FABIN, 4);
	TextDrawLetterSize(FABIN, 0.600000, 2.000000);
	TextDrawTextSize(FABIN, 63.500000, 73.500000);
	TextDrawSetOutline(FABIN, 1);
	TextDrawSetShadow(FABIN, 0);
	TextDrawAlignment(FABIN, 1);
	TextDrawColor(FABIN, -1);
	TextDrawBackgroundColor(FABIN, 255);
	TextDrawBoxColor(FABIN, 50);
	TextDrawUseBox(FABIN, 1);
	TextDrawSetProportional(FABIN, 1);
	TextDrawSetSelectable(FABIN, 0);

	Radinho = TextDrawCreate(-14.000000, 134.000000, "LD_RACE:octoc");
	TextDrawFont(Radinho, 4);
	TextDrawLetterSize(Radinho, 0.600000, 2.000000);
	TextDrawTextSize(Radinho, 202.500000, 213.500000);
	TextDrawSetOutline(Radinho, 1);
	TextDrawSetShadow(Radinho, 0);
	TextDrawAlignment(Radinho, 1);
	TextDrawColor(Radinho, -1);
	TextDrawBackgroundColor(Radinho, 255);
	TextDrawBoxColor(Radinho, 50);
	TextDrawUseBox(Radinho, 1);
	TextDrawSetProportional(Radinho, 1);
	TextDrawSetSelectable(Radinho, 0);

	ManualOct = TextDrawCreate(367.000000, 124.000000, "LD_RACE:ManualOc");
	TextDrawFont(ManualOct, 4);
	TextDrawLetterSize(ManualOct, 0.600000, 2.000000);
	TextDrawTextSize(ManualOct, 257.500000, 233.500000);
	TextDrawSetOutline(ManualOct, 1);
	TextDrawSetShadow(ManualOct, 0);
	TextDrawAlignment(ManualOct, 1);
	TextDrawColor(ManualOct, -1);
	TextDrawBackgroundColor(ManualOct, 255);
	TextDrawBoxColor(ManualOct, 50);
	TextDrawUseBox(ManualOct, 1);
	TextDrawSetProportional(ManualOct, 1);
	TextDrawSetSelectable(ManualOct, 0);

	RCNH = TextDrawCreate(377.000000, 164.000000, "LD_RACE:cnh");
	TextDrawFont(RCNH, 4);
	TextDrawLetterSize(RCNH, 0.600000, 2.000000);
	TextDrawTextSize(RCNH, 188.500000, 143.500000);
	TextDrawSetOutline(RCNH, 1);
	TextDrawSetShadow(RCNH, 0);
	TextDrawAlignment(RCNH, 1);
	TextDrawColor(RCNH, -1);
	TextDrawBackgroundColor(RCNH, 255);
	TextDrawBoxColor(RCNH, 50);
	TextDrawUseBox(RCNH, 1);
	TextDrawSetProportional(RCNH, 1);
	TextDrawSetSelectable(RCNH, 0);

	RSAMU = TextDrawCreate(377.000000, 164.000000, "LD_RACE:fsamu");
	TextDrawFont(RSAMU, 4);
	TextDrawLetterSize(RSAMU, 0.600000, 2.000000);
	TextDrawTextSize(RSAMU, 188.500000, 143.500000);
	TextDrawSetOutline(RSAMU, 1);
	TextDrawSetShadow(RSAMU, 0);
	TextDrawAlignment(RSAMU, 1);
	TextDrawColor(RSAMU, -1);
	TextDrawBackgroundColor(RSAMU, 255);
	TextDrawBoxColor(RSAMU, 50);
	TextDrawUseBox(RSAMU, 1);
	TextDrawSetProportional(RSAMU, 1);
	TextDrawSetSelectable(RSAMU, 0);

	RPORTE = TextDrawCreate(377.000000, 164.000000, "LD_RACE:porte");
	TextDrawFont(RPORTE, 4);
	TextDrawLetterSize(RPORTE, 0.600000, 2.000000);
	TextDrawTextSize(RPORTE, 188.500000, 143.500000);
	TextDrawSetOutline(RPORTE, 1);
	TextDrawSetShadow(RPORTE, 0);
	TextDrawAlignment(RPORTE, 1);
	TextDrawColor(RPORTE, -1);
	TextDrawBackgroundColor(RPORTE, 255);
	TextDrawBoxColor(RPORTE, 50);
	TextDrawUseBox(RPORTE, 1);
	TextDrawSetProportional(RPORTE, 1);
	TextDrawSetSelectable(RPORTE, 0);

	RRG = TextDrawCreate(377.000000, 164.000000, "LD_RACE:rg");
	TextDrawFont(RRG, 4);
	TextDrawLetterSize(RRG, 0.600000, 2.000000);
	TextDrawTextSize(RRG, 188.500000, 143.500000);
	TextDrawSetOutline(RRG, 1);
	TextDrawSetShadow(RRG, 0);
	TextDrawAlignment(RRG, 1);
	TextDrawColor(RRG, -1);
	TextDrawBackgroundColor(RRG, 255);
	TextDrawBoxColor(RRG, 50);
	TextDrawUseBox(RRG, 1);
	TextDrawSetProportional(RRG, 1);
	TextDrawSetSelectable(RRG, 0);

	pcivil[0] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc1");
	TextDrawFont(pcivil[0], 4);
	TextDrawLetterSize(pcivil[0], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[0], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[0], 1);
	TextDrawSetShadow(pcivil[0], 0);
	TextDrawAlignment(pcivil[0], 1);
	TextDrawColor(pcivil[0], -1);
	TextDrawBackgroundColor(pcivil[0], 255);
	TextDrawBoxColor(pcivil[0], 50);
	TextDrawUseBox(pcivil[0], 1);
	TextDrawSetProportional(pcivil[0], 1);
	TextDrawSetSelectable(pcivil[0], 0);
	
	pcivil[1] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc2");
	TextDrawFont(pcivil[1], 4);
	TextDrawLetterSize(pcivil[1], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[1], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[1], 1);
	TextDrawSetShadow(pcivil[1], 0);
	TextDrawAlignment(pcivil[1], 1);
	TextDrawColor(pcivil[1], -1);
	TextDrawBackgroundColor(pcivil[1], 255);
	TextDrawBoxColor(pcivil[1], 50);
	TextDrawUseBox(pcivil[1], 1);
	TextDrawSetProportional(pcivil[1], 1);
	TextDrawSetSelectable(pcivil[1], 0);
	
	pcivil[2] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc3");
	TextDrawFont(pcivil[2], 4);
	TextDrawLetterSize(pcivil[2], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[2], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[2], 1);
	TextDrawSetShadow(pcivil[2], 0);
	TextDrawAlignment(pcivil[2], 1);
	TextDrawColor(pcivil[2], -1);
	TextDrawBackgroundColor(pcivil[2], 255);
	TextDrawBoxColor(pcivil[2], 50);
	TextDrawUseBox(pcivil[2], 1);
	TextDrawSetProportional(pcivil[2], 1);
	TextDrawSetSelectable(pcivil[2], 0);

	pcivil[3] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc4");
	TextDrawFont(pcivil[3], 4);
	TextDrawLetterSize(pcivil[3], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[3], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[3], 1);
	TextDrawSetShadow(pcivil[3], 0);
	TextDrawAlignment(pcivil[3], 1);
	TextDrawColor(pcivil[3], -1);
	TextDrawBackgroundColor(pcivil[3], 255);
	TextDrawBoxColor(pcivil[3], 50);
	TextDrawUseBox(pcivil[3], 1);
	TextDrawSetProportional(pcivil[3], 1);
	TextDrawSetSelectable(pcivil[3], 0);

	pcivil[4] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc5");
	TextDrawFont(pcivil[4], 4);
	TextDrawLetterSize(pcivil[4], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[4], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[4], 1);
	TextDrawSetShadow(pcivil[4], 0);
	TextDrawAlignment(pcivil[4], 1);
	TextDrawColor(pcivil[4], -1);
	TextDrawBackgroundColor(pcivil[4], 255);
	TextDrawBoxColor(pcivil[4], 50);
	TextDrawUseBox(pcivil[4], 1);
	TextDrawSetProportional(pcivil[4], 1);
	TextDrawSetSelectable(pcivil[4], 0);

	pcivil[5] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc6");
	TextDrawFont(pcivil[5], 4);
	TextDrawLetterSize(pcivil[5], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[5], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[5], 1);
	TextDrawSetShadow(pcivil[5], 0);
	TextDrawAlignment(pcivil[5], 1);
	TextDrawColor(pcivil[5], -1);
	TextDrawBackgroundColor(pcivil[5], 255);
	TextDrawBoxColor(pcivil[5], 50);
	TextDrawUseBox(pcivil[5], 1);
	TextDrawSetProportional(pcivil[5], 1);
	TextDrawSetSelectable(pcivil[5], 0);

	pcivil[6] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc7");
	TextDrawFont(pcivil[6], 4);
	TextDrawLetterSize(pcivil[6], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[6], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[6], 1);
	TextDrawSetShadow(pcivil[6], 0);
	TextDrawAlignment(pcivil[6], 1);
	TextDrawColor(pcivil[6], -1);
	TextDrawBackgroundColor(pcivil[6], 255);
	TextDrawBoxColor(pcivil[6], 50);
	TextDrawUseBox(pcivil[6], 1);
	TextDrawSetProportional(pcivil[6], 1);
	TextDrawSetSelectable(pcivil[6], 0);

	pcivil[7] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc8");
	TextDrawFont(pcivil[7], 4);
	TextDrawLetterSize(pcivil[7], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[7], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[7], 1);
	TextDrawSetShadow(pcivil[7], 0);
	TextDrawAlignment(pcivil[7], 1);
	TextDrawColor(pcivil[7], -1);
	TextDrawBackgroundColor(pcivil[7], 255);
	TextDrawBoxColor(pcivil[7], 50);
	TextDrawUseBox(pcivil[7], 1);
	TextDrawSetProportional(pcivil[7], 1);
	TextDrawSetSelectable(pcivil[7], 0);

	pcivil[8] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc9");
	TextDrawFont(pcivil[8], 4);
	TextDrawLetterSize(pcivil[8], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[8], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[8], 1);
	TextDrawSetShadow(pcivil[8], 0);
	TextDrawAlignment(pcivil[8], 1);
	TextDrawColor(pcivil[8], -1);
	TextDrawBackgroundColor(pcivil[8], 255);
	TextDrawBoxColor(pcivil[8], 50);
	TextDrawUseBox(pcivil[8], 1);
	TextDrawSetProportional(pcivil[8], 1);
	TextDrawSetSelectable(pcivil[8], 0);

	pcivil[9] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc10");
	TextDrawFont(pcivil[9], 4);
	TextDrawLetterSize(pcivil[9], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[9], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[9], 1);
	TextDrawSetShadow(pcivil[9], 0);
	TextDrawAlignment(pcivil[9], 1);
	TextDrawColor(pcivil[9], -1);
	TextDrawBackgroundColor(pcivil[9], 255);
	TextDrawBoxColor(pcivil[9], 50);
	TextDrawUseBox(pcivil[9], 1);
	TextDrawSetProportional(pcivil[9], 1);
	TextDrawSetSelectable(pcivil[9], 0);

	pcivil[10] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pc11");
	TextDrawFont(pcivil[10], 4);
	TextDrawLetterSize(pcivil[10], 0.600000, 2.000000);
	TextDrawTextSize(pcivil[10], 62.500000, 82.500000);
	TextDrawSetOutline(pcivil[10], 1);
	TextDrawSetShadow(pcivil[10], 0);
	TextDrawAlignment(pcivil[10], 1);
	TextDrawColor(pcivil[10], -1);
	TextDrawBackgroundColor(pcivil[10], 255);
	TextDrawBoxColor(pcivil[10], 50);
	TextDrawUseBox(pcivil[10], 1);
	TextDrawSetProportional(pcivil[10], 1);
	TextDrawSetSelectable(pcivil[10], 0);

	PFF[0] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf1");
	TextDrawFont(PFF[0], 4);
	TextDrawLetterSize(PFF[0], 0.600000, 2.000000);
	TextDrawTextSize(PFF[0], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[0], 1);
	TextDrawSetShadow(PFF[0], 0);
	TextDrawAlignment(PFF[0], 1);
	TextDrawColor(PFF[0], -1);
	TextDrawBackgroundColor(PFF[0], 255);
	TextDrawBoxColor(PFF[0], 50);
	TextDrawUseBox(PFF[0], 1);
	TextDrawSetProportional(PFF[0], 1);
	TextDrawSetSelectable(PFF[0], 0);
	
	PFF[1] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf2");
	TextDrawFont(PFF[1], 4);
	TextDrawLetterSize(PFF[1], 0.600000, 2.000000);
	TextDrawTextSize(PFF[1], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[1], 1);
	TextDrawSetShadow(PFF[1], 0);
	TextDrawAlignment(PFF[1], 1);
	TextDrawColor(PFF[1], -1);
	TextDrawBackgroundColor(PFF[1], 255);
	TextDrawBoxColor(PFF[1], 50);
	TextDrawUseBox(PFF[1], 1);
	TextDrawSetProportional(PFF[1], 1);
	TextDrawSetSelectable(PFF[1], 0);

	PFF[2] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf3");
	TextDrawFont(PFF[2], 4);
	TextDrawLetterSize(PFF[2], 0.600000, 2.000000);
	TextDrawTextSize(PFF[2], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[2], 1);
	TextDrawSetShadow(PFF[2], 0);
	TextDrawAlignment(PFF[2], 1);
	TextDrawColor(PFF[2], -1);
	TextDrawBackgroundColor(PFF[2], 255);
	TextDrawBoxColor(PFF[2], 50);
	TextDrawUseBox(PFF[2], 1);
	TextDrawSetProportional(PFF[2], 1);
	TextDrawSetSelectable(PFF[2], 0);

	PFF[3] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf4");
	TextDrawFont(PFF[3], 4);
	TextDrawLetterSize(PFF[3], 0.600000, 2.000000);
	TextDrawTextSize(PFF[3], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[3], 1);
	TextDrawSetShadow(PFF[3], 0);
	TextDrawAlignment(PFF[3], 1);
	TextDrawColor(PFF[3], -1);
	TextDrawBackgroundColor(PFF[3], 255);
	TextDrawBoxColor(PFF[3], 50);
	TextDrawUseBox(PFF[3], 1);
	TextDrawSetProportional(PFF[3], 1);
	TextDrawSetSelectable(PFF[3], 0);

	PFF[4] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf5");
	TextDrawFont(PFF[4], 4);
	TextDrawLetterSize(PFF[4], 0.600000, 2.000000);
	TextDrawTextSize(PFF[4], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[4], 1);
	TextDrawSetShadow(PFF[4], 0);
	TextDrawAlignment(PFF[4], 1);
	TextDrawColor(PFF[4], -1);
	TextDrawBackgroundColor(PFF[4], 255);
	TextDrawBoxColor(PFF[4], 50);
	TextDrawUseBox(PFF[4], 1);
	TextDrawSetProportional(PFF[4], 1);
	TextDrawSetSelectable(PFF[4], 0);

	PFF[5] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf6");
	TextDrawFont(PFF[5], 4);
	TextDrawLetterSize(PFF[5], 0.600000, 2.000000);
	TextDrawTextSize(PFF[5], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[5], 1);
	TextDrawSetShadow(PFF[5], 0);
	TextDrawAlignment(PFF[5], 1);
	TextDrawColor(PFF[5], -1);
	TextDrawBackgroundColor(PFF[5], 255);
	TextDrawBoxColor(PFF[5], 50);
	TextDrawUseBox(PFF[5], 1);
	TextDrawSetProportional(PFF[5], 1);
	TextDrawSetSelectable(PFF[5], 0);

	PFF[6] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf7");
	TextDrawFont(PFF[6], 4);
	TextDrawLetterSize(PFF[6], 0.600000, 2.000000);
	TextDrawTextSize(PFF[6], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[6], 1);
	TextDrawSetShadow(PFF[6], 0);
	TextDrawAlignment(PFF[6], 1);
	TextDrawColor(PFF[6], -1);
	TextDrawBackgroundColor(PFF[6], 255);
	TextDrawBoxColor(PFF[6], 50);
	TextDrawUseBox(PFF[6], 1);
	TextDrawSetProportional(PFF[6], 1);
	TextDrawSetSelectable(PFF[6], 0);

	PFF[7] = TextDrawCreate(383.000000, 194.000000, "LD_RACE:pf8");
	TextDrawFont(PFF[7], 4);
	TextDrawLetterSize(PFF[7], 0.600000, 2.000000);
	TextDrawTextSize(PFF[7], 62.500000, 82.500000);
	TextDrawSetOutline(PFF[7], 1);
	TextDrawSetShadow(PFF[7], 0);
	TextDrawAlignment(PFF[7], 1);
	TextDrawColor(PFF[7], -1);
	TextDrawBackgroundColor(PFF[7], 255);
	TextDrawBoxColor(PFF[7], 50);
	TextDrawUseBox(PFF[7], 1);
	TextDrawSetProportional(PFF[7], 1);
	TextDrawSetSelectable(PFF[7], 0);

	PMDET[0] = TextDrawCreate(387.000000, 134.000000, "LD_RACE:PMESP");
	TextDrawFont(PMDET[0], 4);
	TextDrawLetterSize(PMDET[0], 0.600000, 2.000000);
	TextDrawTextSize(PMDET[0], 110.500000, 188.500000);
	TextDrawSetOutline(PMDET[0], 1);
	TextDrawSetShadow(PMDET[0], 0);
	TextDrawAlignment(PMDET[0], 1);
	TextDrawColor(PMDET[0], -1);
	TextDrawBackgroundColor(PMDET[0], 255);
	TextDrawBoxColor(PMDET[0], 50);
	TextDrawUseBox(PMDET[0], 1);
	TextDrawSetProportional(PMDET[0], 1);
	TextDrawSetSelectable(PMDET[0], 0);
	
	PMDET[1] = TextDrawCreate(387.000000, 134.000000, "LD_RACE:CBMESP");
	TextDrawFont(PMDET[1], 4);
	TextDrawLetterSize(PMDET[1], 0.600000, 2.000000);
	TextDrawTextSize(PMDET[1], 110.500000, 188.500000);
	TextDrawSetOutline(PMDET[1], 1);
	TextDrawSetShadow(PMDET[1], 0);
	TextDrawAlignment(PMDET[1], 1);
	TextDrawColor(PMDET[1], -1);
	TextDrawBackgroundColor(PMDET[1], 255);
	TextDrawBoxColor(PMDET[1], 50);
	TextDrawUseBox(PMDET[1], 1);
	TextDrawSetProportional(PMDET[1], 1);
	TextDrawSetSelectable(PMDET[1], 0);

	PMDET[2] = TextDrawCreate(387.000000, 134.000000, "LD_RACE:DETRAN");
	TextDrawFont(PMDET[2], 4);
	TextDrawLetterSize(PMDET[2], 0.600000, 2.000000);
	TextDrawTextSize(PMDET[2], 110.500000, 188.500000);
	TextDrawSetOutline(PMDET[2], 1);
	TextDrawSetShadow(PMDET[2], 0);
	TextDrawAlignment(PMDET[2], 1);
	TextDrawColor(PMDET[2], -1);
	TextDrawBackgroundColor(PMDET[2], 255);
	TextDrawBoxColor(PMDET[2], 50);
	TextDrawUseBox(PMDET[2], 1);
	TextDrawSetProportional(PMDET[2], 1);
	TextDrawSetSelectable(PMDET[2], 0);

	PMDET[3] = TextDrawCreate(387.000000, 134.000000, "LD_RACE:GCM");
	TextDrawFont(PMDET[3], 4);
	TextDrawLetterSize(PMDET[3], 0.600000, 2.000000);
	TextDrawTextSize(PMDET[3], 110.500000, 188.500000);
	TextDrawSetOutline(PMDET[3], 1);
	TextDrawSetShadow(PMDET[3], 0);
	TextDrawAlignment(PMDET[3], 1);
	TextDrawColor(PMDET[3], -1);
	TextDrawBackgroundColor(PMDET[3], 255);
	TextDrawBoxColor(PMDET[3], 50);
	TextDrawUseBox(PMDET[3], 1);
	TextDrawSetProportional(PMDET[3], 1);
	TextDrawSetSelectable(PMDET[3], 0);

	PMDET[4] = TextDrawCreate(387.000000, 134.000000, "LD_RACE:GOV");
	TextDrawFont(PMDET[4], 4);
	TextDrawLetterSize(PMDET[4], 0.600000, 2.000000);
	TextDrawTextSize(PMDET[4], 110.500000, 188.500000);
	TextDrawSetOutline(PMDET[4], 1);
	TextDrawSetShadow(PMDET[4], 0);
	TextDrawAlignment(PMDET[4], 1);
	TextDrawColor(PMDET[4], -1);
	TextDrawBackgroundColor(PMDET[4], 255);
	TextDrawBoxColor(PMDET[4], 50);
	TextDrawUseBox(PMDET[4], 1);
	TextDrawSetProportional(PMDET[4], 1);
	TextDrawSetSelectable(PMDET[4], 0);

	FMAR[0] = TextDrawCreate(407.000000, 184.000000, "LD_RACE:MAR");
	TextDrawFont(FMAR[0], 4);
	TextDrawLetterSize(FMAR[0], 0.600000, 2.000000);
	TextDrawTextSize(FMAR[0], 165.500000, 133.500000);
	TextDrawSetOutline(FMAR[0], 1);
	TextDrawSetShadow(FMAR[0], 0);
	TextDrawAlignment(FMAR[0], 1);
	TextDrawColor(FMAR[0], -1);
	TextDrawBackgroundColor(FMAR[0], 255);
	TextDrawBoxColor(FMAR[0], 50);
	TextDrawUseBox(FMAR[0], 1);
	TextDrawSetProportional(FMAR[0], 1);
	TextDrawSetSelectable(FMAR[0], 0);
	
	FMAR[1] = TextDrawCreate(407.000000, 184.000000, "LD_RACE:EB");
	TextDrawFont(FMAR[1], 4);
	TextDrawLetterSize(FMAR[1], 0.600000, 2.000000);
	TextDrawTextSize(FMAR[1], 165.500000, 133.500000);
	TextDrawSetOutline(FMAR[1], 1);
	TextDrawSetShadow(FMAR[1], 0);
	TextDrawAlignment(FMAR[1], 1);
	TextDrawColor(FMAR[1], -1);
	TextDrawBackgroundColor(FMAR[1], 255);
	TextDrawBoxColor(FMAR[1], 50);
	TextDrawUseBox(FMAR[1], 1);
	TextDrawSetProportional(FMAR[1], 1);
	TextDrawSetSelectable(FMAR[1], 0);
	
	FMAR[2] = TextDrawCreate(407.000000, 184.000000, "LD_RACE:AERO");
	TextDrawFont(FMAR[2], 4);
	TextDrawLetterSize(FMAR[2], 0.600000, 2.000000);
	TextDrawTextSize(FMAR[2], 165.500000, 133.500000);
	TextDrawSetOutline(FMAR[2], 1);
	TextDrawSetShadow(FMAR[2], 0);
	TextDrawAlignment(FMAR[2], 1);
	TextDrawColor(FMAR[2], -1);
	TextDrawBackgroundColor(FMAR[2], 255);
	TextDrawBoxColor(FMAR[2], 50);
	TextDrawUseBox(FMAR[2], 1);
	TextDrawSetProportional(FMAR[2], 1);
	TextDrawSetSelectable(FMAR[2], 0);

}
stock Module_Joel2(playerid)
{
	ButtonRad[playerid][0] = CreatePlayerTextDraw(playerid, 80.600021, 223.693359, "");
	PlayerTextDrawTextSize(playerid, ButtonRad[playerid][0], 13.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, ButtonRad[playerid][0], 1);
	PlayerTextDrawColor(playerid, ButtonRad[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, ButtonRad[playerid][0], 0);
	PlayerTextDrawFont(playerid, ButtonRad[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, ButtonRad[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, ButtonRad[playerid][0], 19382);
	PlayerTextDrawSetPreviewRot(playerid, ButtonRad[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);
 	PlayerTextDrawSetSelectable(playerid, ButtonRad[playerid][0], true);
  	PlayerTextDrawBoxColor(playerid,ButtonRad[playerid][0], 0);
  	PlayerTextDrawBackgroundColor(playerid, ButtonRad[playerid][0], 0);

	ButtonRad[playerid][1] = CreatePlayerTextDraw(playerid, 95.000022, 225.684448, "");
	PlayerTextDrawTextSize(playerid, ButtonRad[playerid][1], 13.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, ButtonRad[playerid][1], 1);
	PlayerTextDrawColor(playerid, ButtonRad[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, ButtonRad[playerid][1], 0);
	PlayerTextDrawFont(playerid, ButtonRad[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, ButtonRad[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, ButtonRad[playerid][1], 19382);
	PlayerTextDrawSetPreviewRot(playerid, ButtonRad[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);
 	PlayerTextDrawSetSelectable(playerid, ButtonRad[playerid][1], true);
  	PlayerTextDrawBoxColor(playerid,ButtonRad[playerid][1], 0);
 	PlayerTextDrawBackgroundColor(playerid, ButtonRad[playerid][1], 0);


	FCNH[playerid][0] = CreatePlayerTextDraw(playerid, 414.000000, 198.959991, "JOEL_WICTOR_ALVES_BATISTA"); // nome
	PlayerTextDrawLetterSize(playerid, FCNH[playerid][0], 0.150400, 0.718933);
	PlayerTextDrawAlignment(playerid, FCNH[playerid][0], 1);
	PlayerTextDrawColor(playerid, FCNH[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, FCNH[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, FCNH[playerid][0], 255);
	PlayerTextDrawFont(playerid, FCNH[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, FCNH[playerid][0], 1);

	FCNH[playerid][1] = CreatePlayerTextDraw(playerid, 476.399963, 213.893341, "7984215454"); // rg
	PlayerTextDrawLetterSize(playerid, FCNH[playerid][1], 0.150400, 0.718933);
	PlayerTextDrawAlignment(playerid, FCNH[playerid][1], 1);
	PlayerTextDrawColor(playerid, FCNH[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, FCNH[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, FCNH[playerid][1], 255);
	PlayerTextDrawFont(playerid, FCNH[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, FCNH[playerid][1], 1);

	FCNH[playerid][2] = CreatePlayerTextDraw(playerid, 518.000061, 228.328903, "11/11/2000"); // nascimento
	PlayerTextDrawLetterSize(playerid, FCNH[playerid][2], 0.150400, 0.718933);
	PlayerTextDrawAlignment(playerid, FCNH[playerid][2], 1);
	PlayerTextDrawColor(playerid, FCNH[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, FCNH[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, FCNH[playerid][2], 255);
	PlayerTextDrawFont(playerid, FCNH[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, FCNH[playerid][2], 1);

	FCNH[playerid][3] = CreatePlayerTextDraw(playerid, 473.600067, 243.759994, "josieldo~n~eliane"); // filiação
	PlayerTextDrawLetterSize(playerid, FCNH[playerid][3], 0.116800, 0.504888);
	PlayerTextDrawAlignment(playerid, FCNH[playerid][3], 1);
	PlayerTextDrawColor(playerid, FCNH[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, FCNH[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, FCNH[playerid][3], 255);
	PlayerTextDrawFont(playerid, FCNH[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, FCNH[playerid][3], 1);

	FCNH[playerid][4] = CreatePlayerTextDraw(playerid, 534.799865, 280.097778, "ab");
	PlayerTextDrawLetterSize(playerid, FCNH[playerid][4], 0.150400, 0.718933);
	PlayerTextDrawAlignment(playerid, FCNH[playerid][4], 1);
	PlayerTextDrawColor(playerid, FCNH[playerid][4], -16776961);
	PlayerTextDrawSetShadow(playerid, FCNH[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, FCNH[playerid][4], 255);
	PlayerTextDrawFont(playerid, FCNH[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, FCNH[playerid][4], 1);

	FCNH[playerid][5] = CreatePlayerTextDraw(playerid, 394.199890, 205.773345, "");
	PlayerTextDrawTextSize(playerid, FCNH[playerid][5], 87.000000, 85.000000);
	PlayerTextDrawAlignment(playerid, FCNH[playerid][5], 1);
	PlayerTextDrawColor(playerid, FCNH[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, FCNH[playerid][5], 0);
	PlayerTextDrawFont(playerid, FCNH[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, FCNH[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, FCNH[playerid][5], 0);
	PlayerTextDrawSetPreviewRot(playerid, FCNH[playerid][5], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawBackgroundColor(playerid, FCNH[playerid][5], 0);

	FPORTE[playerid][0] = CreatePlayerTextDraw(playerid, 409.199920, 209.911117, "JOEL_WICTOR_ALVES_BATISTA"); // nome
	PlayerTextDrawLetterSize(playerid, FPORTE[playerid][0], 0.151999, 0.574578);
	PlayerTextDrawAlignment(playerid, FPORTE[playerid][0], 1);
	PlayerTextDrawColor(playerid, FPORTE[playerid][0], 131327);
	PlayerTextDrawSetShadow(playerid, FPORTE[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, FPORTE[playerid][0], 255);
	PlayerTextDrawFont(playerid, FPORTE[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, FPORTE[playerid][0], 1);

	FPORTE[playerid][1] = CreatePlayerTextDraw(playerid, 409.599914, 219.866653, "soldado_-_policial_militar"); // cargo e org
	PlayerTextDrawLetterSize(playerid, FPORTE[playerid][1], 0.151999, 0.574578);
	PlayerTextDrawAlignment(playerid, FPORTE[playerid][1], 1);
	PlayerTextDrawColor(playerid, FPORTE[playerid][1], 131327);
	PlayerTextDrawSetShadow(playerid, FPORTE[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, FPORTE[playerid][1], 255);
	PlayerTextDrawFont(playerid, FPORTE[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, FPORTE[playerid][1], 1);

	FPORTE[playerid][2] = CreatePlayerTextDraw(playerid, 392.800018, 231.813323, "josieldo~n~eliane"); // filiação
	PlayerTextDrawLetterSize(playerid, FPORTE[playerid][2], 0.151999, 0.574578);
	PlayerTextDrawAlignment(playerid, FPORTE[playerid][2], 1);
	PlayerTextDrawColor(playerid, FPORTE[playerid][2], 131327);
	PlayerTextDrawSetShadow(playerid, FPORTE[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, FPORTE[playerid][2], 255);
	PlayerTextDrawFont(playerid, FPORTE[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, FPORTE[playerid][2], 1);

	FPORTE[playerid][3] = CreatePlayerTextDraw(playerid, 394.399993, 252.719970, "p.federal________________________________brasileiro"); // pf e naturalidade
	PlayerTextDrawLetterSize(playerid, FPORTE[playerid][3], 0.151999, 0.574578);
	PlayerTextDrawAlignment(playerid, FPORTE[playerid][3], 1);
	PlayerTextDrawColor(playerid, FPORTE[playerid][3], 131327);
	PlayerTextDrawSetShadow(playerid, FPORTE[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, FPORTE[playerid][3], 255);
	PlayerTextDrawFont(playerid, FPORTE[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, FPORTE[playerid][3], 1);

	FPORTE[playerid][4] = CreatePlayerTextDraw(playerid, 394.399902, 265.164489, "2526870___________________10/10/2021________10/12/2021"); // sinarm expedição validade
	PlayerTextDrawLetterSize(playerid, FPORTE[playerid][4], 0.151999, 0.574578);
	PlayerTextDrawAlignment(playerid, FPORTE[playerid][4], 1);
	PlayerTextDrawColor(playerid, FPORTE[playerid][4], 131327);
	PlayerTextDrawSetShadow(playerid, FPORTE[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, FPORTE[playerid][4], 255);
	PlayerTextDrawFont(playerid, FPORTE[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, FPORTE[playerid][4], 1);

	FPORTE[playerid][5] = CreatePlayerTextDraw(playerid, 443.999847, 279.600128, "joel_walker"); // assinatura
	PlayerTextDrawLetterSize(playerid, FPORTE[playerid][5], 0.151999, 0.574578);
	PlayerTextDrawAlignment(playerid, FPORTE[playerid][5], 1);
	PlayerTextDrawColor(playerid, FPORTE[playerid][5], 131327);
	PlayerTextDrawSetShadow(playerid, FPORTE[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, FPORTE[playerid][5], 255);
	PlayerTextDrawFont(playerid, FPORTE[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, FPORTE[playerid][5], 1);

	FRG[playerid][0] = CreatePlayerTextDraw(playerid, 427.599884, 202.444412, "JOEL_WICTOR_ALVES_BATISTA");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][0], 0.139599, 0.723911);
	PlayerTextDrawAlignment(playerid, FRG[playerid][0], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][0], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][0], 1);

	FRG[playerid][1] = CreatePlayerTextDraw(playerid, 451.199859, 221.360015, "josieldo_~n~eliane");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][1], 0.139599, 0.723911);
	PlayerTextDrawAlignment(playerid, FRG[playerid][1], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][1], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][1], 1);

	FRG[playerid][2] = CreatePlayerTextDraw(playerid, 452.399841, 251.724426, "11/11/2000");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][2], 0.139599, 0.723911);
	PlayerTextDrawAlignment(playerid, FRG[playerid][2], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][2], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][2], 1);

	FRG[playerid][3] = CreatePlayerTextDraw(playerid, 488.399780, 251.226623, "BRASILEIRO");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][3], 0.139599, 0.723911);
	PlayerTextDrawAlignment(playerid, FRG[playerid][3], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][3], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][3], 1);

	FRG[playerid][4] = CreatePlayerTextDraw(playerid, 462.399963, 263.173339, "ssp______________np");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][4], 0.139599, 0.723911);
	PlayerTextDrawAlignment(playerid, FRG[playerid][4], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][4], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][4], 1);

	FRG[playerid][5] = CreatePlayerTextDraw(playerid, 477.199920, 285.075561, "joel_walker");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][5], 0.139599, 0.723911);
	PlayerTextDrawAlignment(playerid, FRG[playerid][5], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][5], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][5], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][5], 1);

	FRG[playerid][6] = CreatePlayerTextDraw(playerid, 373.399932, 219.711059, "");
	PlayerTextDrawTextSize(playerid, FRG[playerid][6], 87.000000, 76.000000);
	PlayerTextDrawAlignment(playerid, FRG[playerid][6], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][6], 0);
	PlayerTextDrawFont(playerid, FRG[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, FRG[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][6], 0);
	PlayerTextDrawSetPreviewRot(playerid, FRG[playerid][6], -10.000000, 1.000000, 1.000000, 0.899999);

	FRG[playerid][7] = CreatePlayerTextDraw(playerid, 415.200225, 208.915496, "7845121324");
	PlayerTextDrawLetterSize(playerid, FRG[playerid][7], 0.139598, 0.723910);
	PlayerTextDrawAlignment(playerid, FRG[playerid][7], 1);
	PlayerTextDrawColor(playerid, FRG[playerid][7], 255);
	PlayerTextDrawSetShadow(playerid, FRG[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, FRG[playerid][7], 255);
	PlayerTextDrawFont(playerid, FRG[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, FRG[playerid][7], 1);

	FSAMU[playerid][0] = CreatePlayerTextDraw(playerid, 419.200103, 225.342254, "78454122145");
	PlayerTextDrawLetterSize(playerid, FSAMU[playerid][0], 0.079999, 0.504888);
	PlayerTextDrawAlignment(playerid, FSAMU[playerid][0], 1);
	PlayerTextDrawColor(playerid, FSAMU[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, FSAMU[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, FSAMU[playerid][0], 255);
	PlayerTextDrawFont(playerid, FSAMU[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, FSAMU[playerid][0], 1);

	FSAMU[playerid][1] = CreatePlayerTextDraw(playerid, 396.000244, 254.711196, "joel_walker");
	PlayerTextDrawLetterSize(playerid, FSAMU[playerid][1], 0.073199, 0.574577);
	PlayerTextDrawAlignment(playerid, FSAMU[playerid][1], 1);
	PlayerTextDrawColor(playerid, FSAMU[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, FSAMU[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, FSAMU[playerid][1], 255);
	PlayerTextDrawFont(playerid, FSAMU[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, FSAMU[playerid][1], 1);

	FSAMU[playerid][2] = CreatePlayerTextDraw(playerid, 396.000244, 263.173400, "socorrista");
	PlayerTextDrawLetterSize(playerid, FSAMU[playerid][2], 0.080799, 0.574577);
	PlayerTextDrawAlignment(playerid, FSAMU[playerid][2], 1);
	PlayerTextDrawColor(playerid, FSAMU[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, FSAMU[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, FSAMU[playerid][2], 255);
	PlayerTextDrawFont(playerid, FSAMU[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, FSAMU[playerid][2], 1);

	PMDETI[playerid][0] = CreatePlayerTextDraw(playerid, 383.400054, 177.897766, "");
	PlayerTextDrawTextSize(playerid, PMDETI[playerid][0], 68.000000, 55.000000);
	PlayerTextDrawAlignment(playerid, PMDETI[playerid][0], 1);
	PlayerTextDrawColor(playerid, PMDETI[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, PMDETI[playerid][0], 0);
	PlayerTextDrawFont(playerid, PMDETI[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, PMDETI[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, PMDETI[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, PMDETI[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, PMDETI[playerid][0], -10.000000, 0.000000, 0.000000, 1.000000);

	PMDETI[playerid][1] = CreatePlayerTextDraw(playerid, 396.799987, 243.760009, "joel_wictor_alves_batsta");
	PlayerTextDrawLetterSize(playerid, PMDETI[playerid][1], 0.108399, 0.679110);
	PlayerTextDrawAlignment(playerid, PMDETI[playerid][1], 1);
	PlayerTextDrawColor(playerid, PMDETI[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, PMDETI[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, PMDETI[playerid][1], 255);
	PlayerTextDrawFont(playerid, PMDETI[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, PMDETI[playerid][1], 1);

	PMDETI[playerid][2] = CreatePlayerTextDraw(playerid, 396.799987, 261.182220, "soldado_-_rota");
	PlayerTextDrawLetterSize(playerid, PMDETI[playerid][2], 0.108399, 0.679110);
	PlayerTextDrawAlignment(playerid, PMDETI[playerid][2], 1);
	PlayerTextDrawColor(playerid, PMDETI[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, PMDETI[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, PMDETI[playerid][2], 255);
	PlayerTextDrawFont(playerid, PMDETI[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, PMDETI[playerid][2], 1);

	PMDETI[playerid][3] = CreatePlayerTextDraw(playerid, 423.599884, 294.035644, "joel_walker");
	PlayerTextDrawLetterSize(playerid, PMDETI[playerid][3], 0.108399, 0.679110);
	PlayerTextDrawAlignment(playerid, PMDETI[playerid][3], 1);
	PlayerTextDrawColor(playerid, PMDETI[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, PMDETI[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, PMDETI[playerid][3], 255);
	PlayerTextDrawFont(playerid, PMDETI[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, PMDETI[playerid][3], 1);

	EMAR[playerid][0] = CreatePlayerTextDraw(playerid, 509.799896, 246.093338, "");
	PlayerTextDrawTextSize(playerid, EMAR[playerid][0], 65.000000, 60.000000);
	PlayerTextDrawAlignment(playerid, EMAR[playerid][0], 1);
	PlayerTextDrawColor(playerid, EMAR[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EMAR[playerid][0], 0);
	PlayerTextDrawFont(playerid, EMAR[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, EMAR[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, EMAR[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EMAR[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, EMAR[playerid][0], 0.000000, 0.000000, -15.000000, 1.000000);

	EMAR[playerid][1] = CreatePlayerTextDraw(playerid, 451.200103, 218.871047, "JOEL_WICTOR_ALVES_BATISTA");
	PlayerTextDrawLetterSize(playerid, EMAR[playerid][1], 0.119999, 0.778666);
	PlayerTextDrawAlignment(playerid, EMAR[playerid][1], 1);
	PlayerTextDrawColor(playerid, EMAR[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, EMAR[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EMAR[playerid][1], 255);
	PlayerTextDrawFont(playerid, EMAR[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, EMAR[playerid][1], 1);

	EMAR[playerid][2] = CreatePlayerTextDraw(playerid, 451.600097, 248.737731, "ten_coronel");
	PlayerTextDrawLetterSize(playerid, EMAR[playerid][2], 0.119999, 0.778666);
	PlayerTextDrawAlignment(playerid, EMAR[playerid][2], 1);
	PlayerTextDrawColor(playerid, EMAR[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, EMAR[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, EMAR[playerid][2], 255);
	PlayerTextDrawFont(playerid, EMAR[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, EMAR[playerid][2], 1);

	EMAR[playerid][3] = CreatePlayerTextDraw(playerid, 412.000091, 266.657623, "11/11/2000");
	PlayerTextDrawLetterSize(playerid, EMAR[playerid][3], 0.119999, 0.778666);
	PlayerTextDrawAlignment(playerid, EMAR[playerid][3], 1);
	PlayerTextDrawColor(playerid, EMAR[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, EMAR[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, EMAR[playerid][3], 255);
	PlayerTextDrawFont(playerid, EMAR[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, EMAR[playerid][3], 1);

	EMAR[playerid][4] = CreatePlayerTextDraw(playerid, 442.399963, 296.524322, "joel_walker");
	PlayerTextDrawLetterSize(playerid, EMAR[playerid][4], 0.119999, 0.778666);
	PlayerTextDrawAlignment(playerid, EMAR[playerid][4], 1);
	PlayerTextDrawColor(playerid, EMAR[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, EMAR[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, EMAR[playerid][4], 255);
	PlayerTextDrawFont(playerid, EMAR[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, EMAR[playerid][4], 1);

}