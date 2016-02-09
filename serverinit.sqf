if (!isServer) exitWith {};

waitUntil { time > 0 };

vActiveMission=0; publicVariable "vActiveMission";
vActiveMarker="none"; publicVariable "vActiveMarker";
vActiveName="none"; publicVariable "vActiveName";

if (vVehicleLock == 0) then {
	vMissionScore=100; publicVariable "vMissionScore";
} else {
	vMissionScore=0; publicVariable "vMissionScore";
};
vDestroyMission=false; publicVariable "vDestroyMission";
vNewMissionTimer=0; publicVariable "vNewMissionTimer";
vMissionStartTime=0; publicVariable "vMissionStartTime";
vParadropCount=0; publicVariable "vParadropCount";
vArmorInArea=false; publicVariable "vArmorInArea";
vMortarInArea=false; publicVariable "vMortarInArea";
vHeliInArea=false; publicVariable "vHeliInArea";
vActiveRecruitsAI=0; publicVariable "vActiveRecruitsAI";
vClientRequestInfo="none"; publicVariable "vClientRequestInfo";
vEvacSpawned=false; publicVariable "vEvacSpawned";
vServerTime=date; publicVariable "vServerTime";

if (vSupplyEnable == 1) then {
	vSupplyTimer = time;
	publicVariable "vSupplyTimer";
	vSupplyDown = false;
	publicVariable "vSupplyDown";
};

if (vBunkerEnable == 1) then {
	vBunkerTimer = time;
	publicVariable "vBunkerTimer";
	vBunkerBuilt = false;
	publicVariable "vBunkerBuilt";
};


"vClientRequestInfo" addPublicVariableEventHandler {
	_id = 0;
	if (vClientRequestInfo == "PL1") then { _id = owner Player1; };
	if (vClientRequestInfo == "PL2") then { _id = owner Player2; };
	if (vClientRequestInfo == "PL3") then { _id = owner Player3; };
	if (vClientRequestInfo == "PL4") then { _id = owner Player4; };
	if (vClientRequestInfo == "PL5") then { _id = owner Player5; };
	if (vClientRequestInfo == "PL6") then { _id = owner Player6; };
	if (vClientRequestInfo == "PL7") then { _id = owner Player7; };
	if (vClientRequestInfo == "PL8") then { _id = owner Player8; };
	if (vClientRequestInfo == "PL9") then { _id = owner Player9; };
	if (vClientRequestInfo == "PL10") then { _id = owner Player10; };
	if (vClientRequestInfo == "PL11") then { _id = owner Player11; };
	if (vClientRequestInfo == "PL12") then { _id = owner Player12; };
	vClientRequestInfo="none";

	_id publicVariableClient "vMissionType";
	_id publicVariableClient "vMissionDone";
	_id publicVariableClient "vMissionSuccess";
	_id publicVariableClient "vMissionTargetType";
	
	_id publicVariableClient "vActiveMission";
	_id publicVariableClient "vActiveMarker";
	_id publicVariableClient "vActiveName";
	_id publicVariableClient "vRedInArea";
	_id publicVariableClient "vBlueInArea";
	_id publicVariableClient "vDetectedInArea";
	_id publicVariableClient "vMHQDead";
	_id publicVariableClient "vMissionScore";
	_id publicVariableClient "vArmorInArea";
	_id publicVariableClient "vMortarInArea";
	_id publicVariableClient "vHeliInArea";
	_id publicVariableClient "vActiveRecruitsAI";
	_id publicVariableClient "vEvacSpawned";
	vServerTime=date; _id publicVariableClient "vServerTime";

	if (vSupplyEnable == 1) then {
		_id publicVariableClient "vSupplyTimer";
		_id publicVariableClient "vSupplyDown";
	};

	if (vBunkerEnable == 1) then {
		_id publicVariableClient "vBunkerTimer";
		_id publicVariableClient "vBunkerBuilt";
	};
};

_CreateMission=false;
_CleanupTimer=time+300+floor(random 300);
vLastMission=0;

while {true} do {
	if (time > _CleanupTimer) then { nul = [] execVM "cleanup.sqf"; _CleanupTimer=time+300+floor(random 300); };
	if (vActiveMission == 0) then { vNewMissionTimer = time + 60; publicVariable "vNewMissionTimer"; vActiveMission=1000; publicVariable "vActiveMission"; };

	if ((time > vNewMissionTimer) && (vActiveMission == 1000)) then {
		while {true} do {
			scopeName "MissionGen";
			vActiveMission=1+floor(random 52); 
			if (vActiveMission != vLastMission) then { breakOut "MissionGen"; };
		};
		vLastMission=vActiveMission;
		publicVariable "vActiveMission";	
		vMissionStartTime=time; publicVariable "vMissionStartTime";
		vParadropCount=0;
		_CreateMission=true;
	};

	if (vMissionDone) then {
		{ player removeSimpleTask _x } forEach simpleTasks player;
		if (vMissionSuccess) then {
			nul = [ "MISSION COMPLETE:", vActiveName, 1.5, 3, "#00ff00", "#0000ff", "center", "center" ] execVM "mymessage.sqf";
			vMissionScore=vMissionScore+1; publicVariable "vMissionScore";
		} else {
			nul = [ "MISSION FAILED:", vActiveName, 1.5, 3, "#ff0000", "#0000ff", "center", "center" ] execVM "mymessage.sqf";	
		};
		playSound "FD_Finish_F";
		nul = [] execVM "destroymission.sqf"; 
		vDestroyMission=false; publicVariable "vDestroyMission";
		vActiveMission=0; publicVariable "vActiveMission";
		if (vVehicleLock == 1) then {
			systemChat format [ "Missions done: %1", vMissionScore ];
		} else {
			systemChat format [ "Missions done: %1", (vMissionScore - 100) ];
		};
	};
	
	if (_CreateMission) then {
		vServerTime=date; publicVariable "vServerTime";
		if (vActiveMission == 1) then { nul = [ "Frini" ] execVM "createmission.sqf" };
		if (vActiveMission == 2) then { nul = [ "Ifestiona" ] execVM "createmission.sqf" };
		if (vActiveMission == 3) then { nul = [ "Galati" ] execVM "createmission.sqf" };
		if (vActiveMission == 4) then { nul = [ "Syrta" ] execVM "createmission.sqf" };
		if (vActiveMission == 5) then { nul = [ "Kore" ] execVM "createmission.sqf" };
		if (vActiveMission == 6) then { nul = [ "Orino" ] execVM "createmission.sqf" };
		if (vActiveMission == 7) then { nul = [ "Koroni" ] execVM "createmission.sqf" };
		if (vActiveMission == 8) then { nul = [ "Negades" ] execVM "createmission.sqf" };
		if (vActiveMission == 9) then { nul = [ "Neri" ] execVM "createmission.sqf" };
		if (vActiveMission == 10) then { nul = [ "Panochori" ] execVM "createmission.sqf" };
		if (vActiveMission == 11) then { nul = [ "Therisa" ] execVM "createmission.sqf" };
		if (vActiveMission == 12) then { nul = [ "Poliakko" ] execVM "createmission.sqf" };
		if (vActiveMission == 13) then { nul = [ "Alikampos" ] execVM "createmission.sqf" };
		if (vActiveMission == 14) then { nul = [ "Lakka" ] execVM "createmission.sqf" };
		if (vActiveMission == 15) then { nul = [ "Stavros" ] execVM "createmission.sqf" };
		if (vActiveMission == 16) then { nul = [ "Anthrakia" ] execVM "createmission.sqf" };
		if (vActiveMission == 17) then { nul = [ "Rodopoli" ] execVM "createmission.sqf" };
		if (vActiveMission == 18) then { nul = [ "Charkia" ] execVM "createmission.sqf" };
		if (vActiveMission == 19) then { nul = [ "Kalochori" ] execVM "createmission.sqf" };
		if (vActiveMission == 20) then { nul = [ "Dorida" ] execVM "createmission.sqf" };
		if (vActiveMission == 21) then { nul = [ "Chalkeia" ] execVM "createmission.sqf" };
		if (vActiveMission == 22) then { nul = [ "PyrgosMil", "Pyrgos Military Base" ] execVM "createmission.sqf" };
		if (vActiveMission == 23) then { nul = [ "Sofia" ] execVM "createmission.sqf" };
		if (vActiveMission == 24) then { nul = [ "Molos" ] execVM "createmission.sqf" };
		if (vActiveMission == 25) then { nul = [ "Ioannina" ] execVM "createmission.sqf" };
		if (vActiveMission == 26) then { nul = [ "PowerPlant", "Power Plant" ] execVM "createmission.sqf" };
		if (vActiveMission == 27) then { nul = [ "Panagia" ] execVM "createmission.sqf" };
		if (vActiveMission == 28) then { nul = [ "Feres" ] execVM "createmission.sqf" };
		if (vActiveMission == 29) then { nul = [ "Selakano" ] execVM "createmission.sqf" };
		if (vActiveMission == 30) then { nul = [ "MilBase", "Military Base North" ] execVM "createmission.sqf" };
		if (vActiveMission == 31) then { nul = [ "FireBase", "Fire Base" ] execVM "createmission.sqf" };
		if (vActiveMission == 32) then { nul = [ "Zaros" ] execVM "createmission.sqf" };
		if (vActiveMission == 33) then { nul = [ "Factory" ] execVM "createmission.sqf" };
		if (vActiveMission == 34) then { nul = [ "Oreokastro" ] execVM "createmission.sqf" };
		if (vActiveMission == 35) then { nul = [ "Vikos" ] execVM "createmission.sqf" };
		if (vActiveMission == 36) then { nul = [ "Hill299", "Hill 299" ] execVM "createmission.sqf" };
		if (vActiveMission == 37) then { nul = [ "Hill234", "Hill 234" ] execVM "createmission.sqf" };
		if (vActiveMission == 38) then { nul = [ "Abdera" ] execVM "createmission.sqf" };
		if (vActiveMission == 39) then { nul = [ "AirstripNorth", "Airstrip North" ] execVM "createmission.sqf" };
		if (vActiveMission == 40) then { nul = [ "Mine" ] execVM "createmission.sqf" };
		if (vActiveMission == 41) then { nul = [ "AirstripSouth", "Airstrip South" ] execVM "createmission.sqf" };
		if (vActiveMission == 42) then { nul = [ "Crossroads" ] execVM "createmission.sqf" };
		if (vActiveMission == 43) then { nul = [ "Checkpoint" ] execVM "createmission.sqf" };
		if (vActiveMission == 44) then { nul = [ "FarosValley", "Faros Valley" ] execVM "createmission.sqf" };
		if (vActiveMission == 45) then { nul = [ "Dump" ] execVM "createmission.sqf" };
		if (vActiveMission == 46) then { nul = [ "Gori" ] execVM "createmission.sqf" };
		if (vActiveMission == 47) then { nul = [ "Aristi" ] execVM "createmission.sqf" };
		if (vActiveMission == 48) then { nul = [ "FriniWoods", "Frini Woods" ] execVM "createmission.sqf" };
		if (vActiveMission == 49) then { nul = [ "Nidasos" ] execVM "createmission.sqf" };
		if (vActiveMission == 50) then { nul = [ "Athira" ] execVM "createmission.sqf" };
		if (vActiveMission == 51) then { nul = [ "Paros" ] execVM "createmission.sqf" };
		if (vActiveMission == 52) then { nul = [ "Neochori" ] execVM "createmission.sqf" };
		_CreateMission = false;
	};

	sleep 1;
};
