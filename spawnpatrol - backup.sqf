if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };
_radius = if (count _this > 2) then { _this select 2 } else { floor(_markrad*2); };
_count = if (count _this > 3) then { _this select 3 } else { (1+floor(random 7)); };
_mindis = if (count _this > 4) then { _this select 4 } else { 0; };

_spawnpos = nil;
while {true} do {
	scopeName "SpawnPosGen";
	_randir = floor(random 360);
	_randis = _mindis + floor(random _radius);
	_spawnpos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 1];

	_houses = nearestObjects [_spawnpos, ["house","wall"], 50];
	_vehicles = nearestObjects [_spawnpos, ["LandVehicle", "Land_BagBunker_Large_F"], 20];
	_danger = false;
	{ if (floor(_spawnpos distance getPos _x) < 20) then { _danger=true; }; } forEach _houses;
	{ if (floor(_spawnpos distance getPos _x) < 10) then { _danger=true; }; } forEach _vehicles;
	if (surfaceIsWater _spawnpos) then { _danger=true; };
	if (!_danger) then { breakOut "SpawnPosGen" };
};

_types = [ "O_Soldier_AR_F", "O_medic_F", "O_engineer_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_Soldier_AA_F", "O_Soldier_AT_F", "O_soldier_repair_F", "O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_lite_F" ];
_grp = createGroup east;
_unit = _grp createUnit ["O_Soldier_SL_F", _spawnpos, [], _skill, "NONE"];
_unit setPosATL _spawnpos;
_unit setDir floor(random 360);
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
	_ranpos = [(_spawnpos select 0) + ((sin _randir) * 3), (_spawnpos select 1) + ((cos _randir) * 3), 1];
	_unit = _grp createUnit [_type, _ranpos, [], _skill, "NONE"];
	_unit setPosATL _ranpos;
	_unit setDir floor(random 360);
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
		_randis = (_radius/2) + floor(random _radius);
		_wppos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 1];
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
