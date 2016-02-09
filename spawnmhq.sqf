if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };
_unitname = if (count _this > 2) then { _this select 2 } else { "MainMHQ"; };

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_radius = if (count _this > 3) then { _this select 3 } else { _markrad; };
_mindis = if (count _this > 4) then { _this select 4 } else { 0; };

_spawnpos = nil;
while {true} do {
	scopeName "SpawnPosGen";
	_randir = floor(random 360);
	_randis = _mindis + floor(random _radius);
	_spawnpos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 1];

	_houses = nearestObjects [_spawnpos, ["house","wall"], 50];
	_vehicles = nearestObjects [_spawnpos, ["LandVehicle", "Land_BagBunker_Large_F", "Land_TTowerBig_1_F"], 20];
	_isFlat = _spawnpos isFlatEmpty [ 10, 0, 0.3, 10, 0, false, HaloFlag ];
	_danger = false;
	{ if (floor(_spawnpos distance getPos _x) < 30) then { _danger=true; }; } forEach _houses;
	{ if (floor(_spawnpos distance getPos _x) < 20) then { _danger=true; }; } forEach _vehicles;
	if (surfaceIsWater _spawnpos) then { _danger=true; };
	if (count _isFlat < 1 ) then { _danger=true; };
	if (!_danger) then { breakOut "SpawnPosGen" };
};

if (vMissionTargetType == "MHQ") then {
	_unit = "O_APC_Wheeled_02_rcws_F" createVehicle _spawnpos;
	_unit setPosATL _spawnpos;
	_dir = floor(random 360);
	_unit setDir _dir;
	_unit lock true;
	_unit setVehicleVarName _unitname;
	_unit call compile format ["%1=_This; PublicVariable '%1'",_unitname];

	sleep 2;

	_camo = "CamoNet_OPFOR_big_F" createVehicle getPos _unit;
	_camo setPosATL getPos _unit;
	_camo setDir _dir;
	_camoname = Format ["%1%2", _unitname, "Camo" ];
	_camo setVehicleVarName _camoname;
	_camo call compile format ["%1=_This; PublicVariable '%1'",_camoname];
}; if (vMissionTargetType == "radio tower") then {
	_unit = "Land_TTowerBig_1_F" createVehicle _spawnpos;
	_unit setPosATL _spawnpos;
	_dir = floor(random 360);
	_unit setDir _dir;
	_unit lock true;
	_unit setVehicleVarName _unitname;
	_unit call compile format ["%1=_This; PublicVariable '%1'",_unitname];

	}];
};

{ if (_x != _unit) then { deleteVehicle _x } } forEach nearestObjects [_spawnpos, ["static","Land_Sea_Wall_F"], 10];

sleep 1;

_gspawnpos = [ (_spawnpos select 0) + 7, (_spawnpos select 1) + 7, 1 ];
_count = 3 + floor(random 6);

_types = [ "O_Soldier_AR_F", "O_medic_F", "O_engineer_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_Soldier_AA_F", "O_Soldier_AT_F", "O_soldier_repair_F", "O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_lite_F" ];
_grp = createGroup east;
_unit = _grp createUnit ["O_Soldier_SL_F", _gspawnpos, [], _skill, "NONE"];
_unit setPosATL _gspawnpos;
_unit allowFleeing 0;
_unit setSkill _skill;

_havenv = floor(random 100);

if (vEnemyNightVision <= _havenv) then {
	_unit unassignItem "NVGoggles_OPFOR";
	_unit removeItem "NVGoggles_OPFOR";
};

_randir = 0;
for "_x" from 1 to _count step 1 do {
	_type = _types select (floor(random(count _types)));
	_ranpos = [(_gspawnpos select 0) + ((sin _randir) * 3), (_gspawnpos select 1) + ((cos _randir) * 3), 1];
	_unit = _grp createUnit [_type, _ranpos, [], _skill, "NONE"];
	_unit setPosATL _ranpos;
	_unit allowFleeing 0;
	_unit setSkill _skill;
	if (vEnemyNightVision <= _havenv) then {
		_unit unassignItem "NVGoggles_OPFOR";
		_unit removeItem "NVGoggles_OPFOR";
	};
	_randir = _randir + 17;
};

_wp = nil;
for "_counter" from 1 to 10 step 1 do {
	_wppos = nil;
	while {true} do {
		scopeName "WpPosGen";	
		_randir = floor(random 360);
		_randis = floor(random 50);
		_wppos = [(_spawnpos select 0) + ((sin _randir) * _randis), (_spawnpos select 1) + ((cos _randir) * _randis), 1];
		_danger = false;
		if (surfaceIsWater _wppos) then { _danger=true; };
		if (!_danger) then { breakOut "WpPosGen" };
	};
	
	_wp = _grp addWaypoint [_wppos, 0, _counter];
	[_grp, _counter] setWaypointType "SAD";
	[_grp, _counter] setWaypointBehaviour "AWARE";
	[_grp, _counter] setWaypointCombatMode "RED";
	[_grp, _counter] setWaypointCompletionRadius 20;
	_timeout = floor(random 600);
	[_grp, _counter] setWaypointTimeout [ 1, floor(_timeout/2), _timeout];	
};
_wp setWaypointStatements ["true", "this setCurrentWaypoint [group this, 1]"];
