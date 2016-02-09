vTime = ParamsArray select 0;
vEnemySkill = ((ParamsArray select 1) / 100);
vManRatio = ((ParamsArray select 2) / 100);
vVehRatio = ((ParamsArray select 3) / 100);
vStatRatio = ((ParamsArray select 4) / 100);
vHeliChance = ((ParamsArray select 5) / 100);
vParadropDelay = (ParamsArray select 6);
vParadropStrength = (ParamsArray select 7);
vMaxParadrops = (ParamsArray select 8);
vAllowRecruitingAI = (ParamsArray select 9);
vMaxRecruitsAI = (ParamsArray select 10);
vHaloEnable = ParamsArray select 11;
vHaloCooldown = ParamsArray select 12;
vSupplyEnable = ParamsArray select 13;
vSupplyTimeout = ParamsArray select 14;
vReviveEnable = ParamsArray select 15;
vBonusRespawn = ParamsArray select 16;
vSpawnEvac = ParamsArray select 17;
vAllowVD = ParamsArray select 18;
vSupplyDropLock = ParamsArray select 19;
vStartingWeather = ParamsArray select 20;
vTimeAcc = ParamsArray select 21;
vBunkerEnable = ParamsArray select 22;
vBunkerCooldown = ParamsArray select 23;
vBunkerLock = ParamsArray select 24;
vEnemyNightVision = ParamsArray select 25;
vDefPrepTimer = ParamsArray select 26;
vDefMissTimer = ParamsArray select 27;

setDate [2031, 5, 17, vTime, 0];
setTimeMultiplier vTimeAcc;

vEvacSpawned=false;



van_support_options = 
[
	["Supply Drop",
		[
			["Ifrit Light Armor", "scripts\van_support\van_support_ifrit.sqf", 2],
 			["Tactical Quadbike", "scripts\van_support\van_support_quadbike.sqf", 2],
 			["Ammobox", "scripts\van_support\van_support_ammo.sqf", 2]
		]
 	], 
 	["CAS",
 		[
			["CBU-100 Cluster", "scripts\van_support\van_support_cluster.sqf", 30]
 		]
	],
	["Artillery",
		[
			["Illumination", "scripts\van_support\van_support_illumination.sqf", 20], 
			["Smoke", "scripts\van_support\van_support_smoke.sqf", 20],
			["HE Barrage", "scripts\van_support\van_support_he.sqf", 25]
		]
	]
];

createMarkerLocal ["SupportMarker", [0, 0, 0]];

if(isNil "van_fn_compiled") then
{
	call compile preprocessFileLineNumbers "scripts\van_support\Dialogs\van_dialog_functions.sqf";
};

van_client_setup = 
{
	player addAction ["<t color='#9900CC'>Vanquish Command</t>", "scripts\van_support\van_act_command_menu.sqf"];
	player addEventHandler ["respawn", 
	{
		player addAction ["<t color='#9900CC'>Vanquish Command</t>", "scripts\van_support\van_act_command_menu.sqf"];
	}];
};

publicVariable "van_client_setup";
[[], "van_client_setup", true, true] call BIS_fnc_MP;

[] spawn {
while{not isnull MHQ1} do {"respawn_west2" setmarkerpos getpos MHQ1; sleep 0.5;};
};

[] spawn {
while{not isnull MHQ2} do {"respawn_west3" setmarkerpos getpos MHQ2; sleep 0.5;};
};

nul = [] execVM "briefing.sqf";
nul = [] execVM "randomWeather2.sqf";

if (isServer) then { nul = [] execVM "serverinit.sqf"; };
if (isDedicated) exitWith {};
waitUntil {!isNull player};
[nil,["B_Heli_Light_01_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F"]] execVM "scripts\lift_init.sqf";

vHaloTimer = time;
vGearSaved = false;
vSupplyMarker = nil;
vVehicleRepair = nil;
vMissionType = nil;
vMissionDone = nil;
vMissionSuccess = nil;
vMissionTargetType = nil;
vBunkerBuilt = false; 
vBunkerMarker = nil;
FriendlyCaptive = nil;
vDefPrepCountdown = 0;
vDefMissCountdown = 0;

nul = [] execVM "refreshactions.sqf";

if (!isServer) then {
	vJustConnected = true;
	nul = [] execVM "clientrefresh.sqf";

	sleep 5 + floor(random 10);

	if (player == Player1) then { vClientRequestInfo = "PL1" };
	if (player == Player2) then { vClientRequestInfo = "PL2" };
	if (player == Player3) then { vClientRequestInfo = "PL3" };
	if (player == Player4) then { vClientRequestInfo = "PL4" };
	if (player == Player5) then { vClientRequestInfo = "PL5" };
	if (player == Player6) then { vClientRequestInfo = "PL6" };
	if (player == Player7) then { vClientRequestInfo = "PL7" };
	if (player == Player8) then { vClientRequestInfo = "PL8" };
	if (player == Player9) then { vClientRequestInfo = "PL9" };
	if (player == Player10) then { vClientRequestInfo = "PL10" };
	if (player == Player11) then { vClientRequestInfo = "PL11" };
	if (player == Player12) then { vClientRequestInfo = "PL12" };
	publicVariableServer "vClientRequestInfo";

	sleep 15;
	vJustConnected = false;
};