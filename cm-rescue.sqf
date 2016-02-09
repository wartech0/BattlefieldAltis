if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_name = if (count _this > 1) then { _this select 1 } else { _this select 0 };

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_pats = if (count _this > 2) then { _this select 2 } else { 4+floor(random 16); };
_vehs = if (count _this > 3) then { _this select 3 } else { floor(random 4); };
_stats = if (count _this > 4) then { _this select 4 } else { 3+floor(random 8); };
_builds = if (count _this > 5) then { _this select 5 } else { 3+floor(random 7); };
_snips = if (count _this > 6) then { _this select 6 } else { 1+floor(random 3); };
_helich = if (count _this > 7) then { _this select 7 } else { 30; };
_detrad = if (count _this > 8) then { _this select 8 } else { 2000; };

_skill = vEnemySkill;
_pats = floor(_pats * vManRatio);
_vehs = floor(_vehs * vVehRatio);
_stats = floor(_stats * vStatRatio);
_builds = floor(_builds * vManRatio);
_snips = floor(_snips * vManRatio);
_helichance = _helich * vHeliChance;

_RedInArea = false;
_BlueInArea = false;
_DetectedInArea = false;
_ParadropTimer = 0;

_mtypes = [ "MHQ", "radio tower" ];
vMissionTargetType = _mtypes select (floor(random(count _mtypes)));
publicVariable "vMissionTargetType";

_marker call compile format ["%1=_This; PublicVariable '%1'","vActiveMarker"];
_name call compile format ["%1=_This; PublicVariable '%1'","vActiveName"];
_RedInArea call compile format ["%1=_This; PublicVariable '%1'","vRedInArea"];
_BlueInArea call compile format ["%1=_This; PublicVariable '%1'","vBlueInArea"];
_DetectedInArea call compile format ["%1=_This; PublicVariable '%1'","vDetectedInArea"];
_ParadropTimer call compile format ["%1=_This; PublicVariable '%1'","vParadropTimer"];
vMHQDead=false; publicVariable "vMHQDead";

nul = [ "RESCUE:", _name, 1.5, 3, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 

if (!isDedicated) then {
	{ player removeSimpleTask _x } forEach simpleTasks player;
	cTask = player createSimpleTask ["Rescue"];
	cTask setSimpleTaskDestination (getMarkerPos _marker);
	cTask setSimpleTaskDescription [ "Rescue friendly covert operative held captive in the marked area and escort him safely to base.", "Rescue", "Rescue"];
	player setCurrentTask cTask;
};

systemChat "OBJECTIVE: Rescue friendly covert operative held captive in the marked area and escort him safely to base.";
playSound "FD_CP_Not_Clear_F";

_marker setMarkerBrush "DiagGrid";
_marker setMarkerColor "ColorRed";

nul = [ _marker, _skill ] execVM "spawnrescue.sqf";
nul = [ _marker, _skill ] execVM "spawnmhq.sqf";
nul = [ _marker, _skill, _markrad, (3+floor(floor(random 4))) * vManRatio ] execVM "spawnpatrol.sqf";

if (vManRatio < 1) then {
	_counter = 0; while {( _counter < _pats )} do { nul = [ _marker, _skill, floor(_markrad*1.34), (3+floor(floor(random 4))) ] execVM "spawnpatrol.sqf"; _counter = _counter + 1; };
	_counter = 0; while {( _counter < _snips )} do { nul = [ _marker, _skill, floor(_markrad*1.34) ] execVM "spawnsniper.sqf"; _counter = _counter + 1; };
}; if (vManRatio == 1) then {
	_counter = 0; while {( _counter < _pats )} do { nul = [ _marker, _skill, floor(_markrad*2), (3+floor(floor(random 4))) ] execVM "spawnpatrol.sqf"; _counter = _counter + 1; };
	_counter = 0; while {( _counter < _snips )} do { nul = [ _marker, _skill, floor(_markrad*2) ] execVM "spawnsniper.sqf"; _counter = _counter + 1; };
}; if (vManRatio > 1) then {
	_counter = 0; while {( _counter < _pats )} do { nul = [ _marker, _skill, floor(_markrad*2.5), (3+floor(floor(random 4))) ] execVM "spawnpatrol.sqf"; _counter = _counter + 1; };
	_counter = 0; while {( _counter < _snips )} do { nul = [ _marker, _skill, floor(_markrad*2.5) ] execVM "spawnsniper.sqf"; _counter = _counter + 1; };
};

if (vVehRatio < 1) then {
	_counter = 0; while {( _counter < _vehs )} do { nul = [ _marker, _skill, floor(_markrad*1.5) ] execVM "spawnvehicle.sqf"; _counter = _counter + 1; };
}; if (vVehRatio == 1) then {
	_counter = 0; while {( _counter < _vehs )} do { nul = [ _marker, _skill, floor(_markrad*2) ] execVM "spawnvehicle.sqf"; _counter = _counter + 1; };
}; if (vVehRatio > 1) then {
	_counter = 0; while {( _counter < _vehs )} do { nul = [ _marker, _skill, floor(_markrad*2.5) ] execVM "spawnvehicle.sqf"; _counter = _counter + 1; };
};

vArmorInArea=false; publicVariable "vArmorInArea";
vMortarInArea=false; publicVariable "vMortarInArea";
vHeliInArea=false; publicVariable "vHeliInArea";

_counter = 0; while {( _counter < _stats )} do { nul = [ _marker, _skill ] execVM "spawnstatic.sqf"; _counter = _counter + 1; };
if ((1 + floor(random 100)) <= _helichance) then { nul = [ _marker, _skill ] execVM "spawnheli.sqf"; };
_counter = 0; while {( _counter < (2+floor(random (2*vStatRatio))))} do { nul = [ _marker, _skill, _markrad ] execVM "spawnbunker.sqf"; _counter = _counter + 1; };

_houses = nearestObjects [_markpos, ["house"], 300];
if ((count _houses) < _builds) then { _builds = (count _houses); };
_counter = 1; while {( _counter <= _builds )} do {
	_index = random (count _houses);
	nul = [ _houses select _index, _skill, floor((1+floor(random 3)) * vManRatio) ] execVM "spawninbuilding.sqf";
	_houses deleteAt _index;
	_counter = _counter + 1; 
};

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

tDetectedInArea = createTrigger ["EmptyDetector", _markpos];
tDetectedInArea setTriggerArea [_detrad, _detrad, 0, false];
tDetectedInArea setTriggerType "NONE";
tDetectedInArea setTriggerActivation ["WEST", "EAST D", true];
tDetectedInArea setTriggerStatements ["isServer && this && !vDetectedInArea && alive MainMHQ", "vDetectedInArea=true; publicVariable ""vDetectedInArea""; vParadropTimer=time; nul = [ ""DETECTED!"", format [ ""Enemy has detected you in the target area and will call in reinforcements until the %1 is destroyed."", vMissionTargetType ], 2, 1.2, ""#00ff00"", ""#ff0000"", ""center"", ""center"" ] execVM ""mymessage.sqf""; playSound ""Alarm_OPFOR""", ""];

tParadrop = createTrigger ["EmptyDetector", _markpos];
tParadrop setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tParadrop setTriggerType "NONE";
tParadrop setTriggerActivation ["NONE", "PRESENT", true];
tParadrop setTriggerStatements ["isServer && vDetectedInArea && alive MainMHQ && vParadropTimer > 0 && time > vParadropTimer && vParadropCount < vMaxParadrops", "nul = [ vActiveMarker, vParadropStrength, vEnemySkill ] execVM ""paradrop.sqf""; vParadropTimer=(time + vParadropDelay); vParadropCount = vParadropCount + 1;", ""];

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

tFCRescued = createTrigger ["EmptyDetector", _markpos];
tFCRescued setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tFCRescued setTriggerType "NONE";
tFCRescued setTriggerActivation ["NONE", "PRESENT", true];
tFCRescued setTriggerTimeout [1, 1, 1, false];
tFCRescued setTriggerStatements ["isServer && alive FriendlyCaptive && FriendlyCaptive distance HaloFlag < 50", "vMissionSuccess=true; publicVariable ""vMissionSuccess""; vMissionDone=true; publicVariable ""vMissionDone""", ""];

tFCDead = createTrigger ["EmptyDetector", _markpos];
tFCDead setTriggerArea [_marksize select 0, _marksize select 1, 0, false];
tFCDead setTriggerType "NONE";
tFCDead setTriggerActivation ["NONE", "PRESENT", true];
tFCDead setTriggerTimeout [10, 10, 10, false];
tFCDead setTriggerStatements ["isServer && !alive FriendlyCaptive", "vMissionSuccess=false; publicVariable ""vMissionSuccess""; vMissionDone=true; publicVariable ""vMissionDone""", ""];

sleep 1;
{ if ((side _x)==east) then { _x setDammage 0 } } forEach vehicles;
