if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };
_radius = if (count _this > 2) then { _this select 2 } else { floor(_markrad*2); };
_mindis = if (count _this > 3) then { _this select 3 } else { 0; };

_spawnpos = nil;
while {true} do {
	scopeName "SpawnPosGen";
	_randir = floor(random 360);
	_randis = _mindis + floor(random _radius);
	_spawnpos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 1];

	_houses = nearestObjects [_spawnpos, ["house","wall"], 50];
	_vehicles = nearestObjects [_spawnpos, ["LandVehicle", "Land_BagBunker_Large_F", "Land_TTowerBig_1_F"], 20];
	_isFlat = _spawnpos isFlatEmpty [ 10, 0, 0.5, 10, 0, false, HaloFlag ];
	_danger = false;
	{ if (floor(_spawnpos distance getPos _x) < 20) then { _danger=true; }; } forEach _houses;
	{ if (floor(_spawnpos distance getPos _x) < 10) then { _danger=true; }; } forEach _vehicles;
	if (surfaceIsWater _spawnpos) then { _danger=true; };
	if (count _isFlat < 1 ) then { _danger=true; };	
	if (!_danger) then { breakOut "SpawnPosGen" };
};

_types = [ "O_MRAP_02_hmg_F", "O_APC_Tracked_02_cannon_F", "O_MBT_02_cannon_F", "O_APC_Tracked_02_AA_F" ];

_grp = createGroup east;
_type = _types select (floor(random(count _types)));
_unit = _type createVehicle _spawnpos;
_unit setPosATL _spawnpos;
_unit setDir floor(random 360);
_unit lock false;
_crew = [ _unit, _grp ] call bis_fnc_spawncrew;

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
	[_grp, _counter] setWaypointCompletionRadius 30;
	_timeout = floor(random 600);
	[_grp, _counter] setWaypointTimeout [ 1, floor(_timeout/2), _timeout];	
};
_wp setWaypointStatements ["true", "this setCurrentWaypoint [group this, 1]"];
