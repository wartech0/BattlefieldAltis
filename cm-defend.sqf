if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_name = if (count _this > 1) then { _this select 1 } else { _this select 0 };

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_pats = if (count _this > 2) then { _this select 2 } else { 3+floor(random 6); };
_vehs = if (count _this > 3) then { _this select 3 } else { floor(random 3); };
_snips = if (count _this > 5) then { _this select 4 } else { 1+floor(random 3); };
_helich = if (count _this > 6) then { _this select 5 } else { 30; };

_skill = vEnemySkill;
_pats = floor(_pats * vManRatio);
_vehs = floor(_vehs * vVehRatio);
_snips = floor(_snips * vManRatio);
_helichance = _helich * vHeliChance;

_RedInArea = false;
_BlueInArea = false;
_ParadropTimer = 0;
_activemission = vActiveMission;

_marker call compile format ["%1=_This; PublicVariable '%1'","vActiveMarker"];
_name call compile format ["%1=_This; PublicVariable '%1'","vActiveName"];
_RedInArea call compile format ["%1=_This; PublicVariable '%1'","vRedInArea"];
_BlueInArea call compile format ["%1=_This; PublicVariable '%1'","vBlueInArea"];
_ParadropTimer call compile format ["%1=_This; PublicVariable '%1'","vParadropTimer"];

nul = [ "DEFEND:", _name, 1.5, 3, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 

if (!isDedicated) then {
	{ player removeSimpleTask _x } forEach simpleTasks player;
	cTask = player createSimpleTask ["Defend"];
	cTask setSimpleTaskDestination (getMarkerPos _marker);
	cTask setSimpleTaskDescription [ "Defend the area.", "Defend", "Defend"];
	player setCurrentTask cTask;
};

systemChat format [ "OBJECTIVE: Move to the marked area, prepare your defences and defend the area for %1 minutes.", vDefMissTimer ];
playSound "FD_CP_Not_Clear_F";

_marker setMarkerBrush "DiagGrid";
_marker setMarkerColor "ColorBlue";

tBlueInArea = createTrigger ["EmptyDetector", _markpos];
tBlueInArea setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tBlueInArea setTriggerType "NONE";
tBlueInArea setTriggerActivation ["WEST", "PRESENT", true];
tBlueInArea setTriggerStatements ["isServer && this", "vBlueInArea=true; publicVariable ""vBlueInArea""", ""];

_timer = 0;
while {true} do {
	scopeName "WaitForBlue";
	_timer = _timer + 1;
	if (vBlueInArea) then { breakOut "WaitForBlue" };
	if (_timer > 300) then { breakOut "WaitForBlue" };
	sleep 1;
};
if (_activemission != vActiveMission) exitWith {};

vDefPrepCountdown = vDefPrepTimer * 60;
publicVariable "vDefPrepCountdown";

while {true} do {
	scopeName "PrepareDefences";
	vDefPrepCountdown = vDefPrepCountdown - 1;
	publicVariable "vDefPrepCountdown";
	nul = [ "ATTACK BEGINS IN:", format [ "%1 seconds", vDefPrepCountdown ], 1.5, 1.2, "#00ff00", "#ff0000", "center", "center", false ] execVM "mymessage.sqf"; 
	sleep 1;
	if (vDefPrepCountdown == 0) then { breakOut "PrepareDefences" };
};

nul = [ "UNDER ATTACK!", format [ "Enemy is attacking %1! Defend the area for %2 minutes.", vActiveName, vDefMissTimer ], 2, 1.2, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf";
playSound "Alarm_OPFOR";

tBlueNotInArea = createTrigger ["EmptyDetector", _markpos];
tBlueNotInArea setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tBlueNotInArea setTriggerType "NONE";
tBlueNotInArea setTriggerActivation ["WEST", "NOT PRESENT", true];
tBlueNotInArea setTriggerStatements ["isServer && this", "vBlueInArea=false; publicVariable ""vBlueInArea""; vMissionSuccess=false; publicVariable ""vMissionSuccess""; vMissionDone=true; publicVariable ""vMissionDone""", ""];

// --- ENEMY SPAWN --------------------------------------------------------------------------------
vMissionTargetType = "MHQ";
publicVariable "vMissionTargetType";
vMHQDead=false;
publicVariable "vMHQDead";

nul = [ _marker, _skill, "MainMHQ", _markrad, _markrad ] execVM "spawnmhq.sqf";
nul = [ _marker, _skill, (_markrad/2), (3+floor(floor(random 4))) * vManRatio, (_markrad*2) ] execVM "spawnpatrol.sqf";

_counter = 0; while {( _counter < _pats )} do { nul = [ _marker, _skill, (_markrad/2), (3+floor(floor(random 4))), (_markrad*2) ] execVM "spawnpatrol.sqf"; _counter = _counter + 1; };
_counter = 0; while {( _counter < _snips )} do { nul = [ _marker, _skill, (_markrad/2), (_markrad*2) ] execVM "spawnsniper.sqf"; _counter = _counter + 1; };
_counter = 0; while {( _counter < _vehs )} do { nul = [ _marker, _skill, (_markrad/2), (_markrad*2) ] execVM "spawnvehicle.sqf"; _counter = _counter + 1; };
if ((1 + floor(random 100)) <= _helichance) then { nul = [ _marker, _skill ] execVM "spawnheli.sqf"; };

vArmorInArea=false; publicVariable "vArmorInArea";
vMortarInArea=false; publicVariable "vMortarInArea";
vHeliInArea=false; publicVariable "vHeliInArea";

sleep 5;

_counter = 0;
{ if (((side _x)==east) && (_x isKindOf "Tank")) then { _counter = _counter + 1; } } forEach vehicles;
if (_counter > 0) then { systemChat "MAGIC: Intel reports enemy armor in the target area."; vArmorInArea=true; publicVariable "vArmorInArea" };
_counter = 0;
{ if (((side _x)==east) && (_x isKindOf "StaticMortar")) then { _counter = _counter + 1; } } forEach vehicles;
if (_counter > 0) then { systemChat "MAGIC: Intel reports enemy mortars in the target area."; vMortarInArea=true; publicVariable "vMortarInArea" };
_counter = 0;
{ if (((side _x)==east) && (_x isKindOf "Helicopter")) then { _counter = _counter + 1; } } forEach vehicles;
if (_counter > 0) then { systemChat "MAGIC: Intel reports enemy attack helicopter in the target area."; vHeliInArea=true; publicVariable "vHeliInArea" };
// ------------------------------------------------------------------------------------------------
_ParadropTimer = time;
_ParadropTimer call compile format ["%1=_This; PublicVariable '%1'","vParadropTimer"];
// ------------------------------------------------------------------------------------------------
tParadrop = createTrigger ["EmptyDetector", _markpos];
tParadrop setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tParadrop setTriggerType "NONE";
tParadrop setTriggerActivation ["NONE", "PRESENT", true];
tParadrop setTriggerStatements ["isServer && alive MainMHQ && vParadropTimer > 0 && time > vParadropTimer && vParadropCount < vMaxParadrops", "nul = [ vActiveMarker, vParadropStrength, vEnemySkill ] execVM ""paradrop.sqf""; nul = [ vActiveMarker, vParadropStrength, vEnemySkill ] execVM ""paradrop.sqf""; vParadropTimer=(time + (vParadropDelay/2)); vParadropCount = vParadropCount + 1;", ""];

tMHQSpawnError = createTrigger ["EmptyDetector", _markpos];
tMHQSpawnError setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tMHQSpawnError setTriggerType "NONE";
tMHQSpawnError setTriggerActivation ["NONE", "PRESENT", true];
tMHQSpawnError setTriggerStatements ["isServer && time < (vMissionStartTime+30) && !alive MainMHQ", "deleteVehicle MainMHQ; deleteVehicle MainMHQCamo; nul = [ vActiveMarker ] execVM ""spawnmhq.sqf""", ""];

tMHQDead = createTrigger ["EmptyDetector", _markpos];
tMHQDead setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tMHQDead setTriggerType "NONE";
tMHQDead setTriggerActivation ["NONE", "PRESENT", true];
tMHQDead setTriggerTimeout [10, 10, 10, false];
tMHQDead setTriggerStatements ["isServer && time > (vMissionStartTime+30) && !alive MainMHQ", "deleteVehicle MainMHQ; deleteVehicle MainMHQCamo; { deleteVehicle _x } forEach nearestObjects [ getMarkerPos vActiveMarker, [""Land_TTowerBig_1_ruins_F""], 500 ]; nul = [ format [ ""%1 DESTROYED!"", vMissionTargetType ], format [ ""The %1 was destroyed! The enemy will no longer be able to call in reinforcements. Good job!"", vMissionTargetType ], 2, 1.2, ""#00ff00"", ""#ff0000"", ""center"", ""center"" ] execVM ""mymessage.sqf""; playSound ""FD_Timer_F""; vMHQDead=true; publicVariable ""vMHQDead"";", ""];
// ------------------------------------------------------------------------------------------------

vDefMissCountdown = vDefMissTimer * 60;
publicVariable "vDefMissCountdown";

_moartimer = time + 300 + floor(random 300);

while {true} do {
	scopeName "DefendTheArea";
	sleep 60;
	if (_activemission != vActiveMission) then { breakOut "DefendTheArea" };
	vDefMissCountdown = vDefMissCountdown - 60;
	if (vDefMissCountdown == 0) then { breakOut "DefendTheArea" };
	publicVariable "vDefMissCountdown";
	systemChat format [ "DEFEND: %1 minutes remaining.", (vDefMissCountdown/60) ];
	if (time > _moartimer) then {
		_moartimer = time + 300 + floor(random 300);
		_counter = 0; while {( _counter < ceil(_pats/3))} do { nul = [ _marker, _skill, (_markrad/2), (3+floor(floor(random 4))), (_markrad*2) ] execVM "spawnpatrol.sqf"; _counter = _counter + 1; };
		_counter = 0; while {( _counter < ceil(_snips/3))} do { nul = [ _marker, _skill, (_markrad/2), (_markrad*2) ] execVM "spawnsniper.sqf"; _counter = _counter + 1; };
		if (floor(random 100) > (vVehRatio*20)) then { nul = [ _marker, _skill, (_markrad/2), (_markrad*2) ] execVM "spawnvehicle.sqf"; };
	};
};
if (_activemission != vActiveMission) exitWith {};

vDefMissCountdown = 0;
publicVariable "vDefMissCountdown";
nul = [ "CLEAR THE AREA", "The area was successfully defended! Good job! Now clear the remaining enemy forces from the area.", 2, 1.2, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf";
playSound "FD_CP_Not_Clear_F";
deleteVehicle tBlueNotInArea;

sleep 15;

tRedInArea = createTrigger ["EmptyDetector", _markpos];
tRedInArea setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tRedInArea setTriggerType "NONE";
tRedInArea setTriggerActivation ["EAST", "PRESENT", true];
tRedInArea setTriggerStatements ["isServer && (east countside thislist) > 3", "vRedInArea=true; publicVariable ""vRedInArea""", ""];

tRedNotInArea = createTrigger ["EmptyDetector", _markpos];
tRedNotInArea setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tRedNotInArea setTriggerType "NONE";
tRedNotInArea setTriggerActivation ["EAST", "PRESENT", true];
tRedNotInArea setTriggerStatements ["isServer && (east countside thislist) < 4", "vRedInArea=false; publicVariable ""vRedInArea""", ""];

tCapturedByBlue = createTrigger ["EmptyDetector", _markpos];
tCapturedByBlue setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tCapturedByBlue setTriggerType "NONE";
tCapturedByBlue setTriggerActivation ["NONE", "PRESENT", true];
tCapturedByBlue setTriggerTimeout [10, 10, 10, false];
tCapturedByBlue setTriggerStatements ["isServer && !vRedInArea && vBlueInArea", "vMissionSuccess=true; publicVariable ""vMissionSuccess""; vMissionDone=true; publicVariable ""vMissionDone""", ""];
