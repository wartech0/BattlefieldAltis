if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };
_radius = if (count _this > 2) then { _this select 2 } else { _markrad; };
_mindis = if (count _this > 3) then { _this select 3 } else { 0; };

_spawnpos = nil;
while {true} do {
	scopeName "SpawnPosGen";
	_randir = floor(random 360);
	_randis = _mindis + floor(random _radius);
	_spawnpos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 0.1];

	_houses = nearestObjects [_spawnpos, ["house","wall"], 50];
	_vehicles = nearestObjects [_spawnpos, ["LandVehicle", "Land_BagBunker_Large_F", "Land_TTowerBig_1_F"], 20];
	_isFlat = _spawnpos isFlatEmpty [ 5, 0, 0.3, 5, 0, false, HaloFlag ];	
	_danger = false;
	{ if (floor(_spawnpos distance getPos _x) < 20) then { _danger=true; }; } forEach _houses;
	{ if (floor(_spawnpos distance getPos _x) < 10) then { _danger=true; }; } forEach _vehicles;
	if (surfaceIsWater _spawnpos) then { _danger=true; };
	if (count _isFlat < 1 ) then { _danger=true; };
	if (!_danger) then { breakOut "SpawnPosGen" };
};

_types = [ "O_HMG_01_F", "O_HMG_01_high_F", "O_HMG_01_A_F", "O_GMG_01_F", "O_GMG_01_high_F", "O_GMG_01_A_F", "O_Mortar_01_F", "O_static_AA_F", "O_static_AT_F" ];

_grp = createGroup east;
_type = _types select (floor(random(count _types)));
_unit = _type createVehicle _spawnpos;
_unit setPosATL _spawnpos;
_unit setDir floor(random 360);
_unit lock false;
_crew = [ _unit, _grp ] call bis_fnc_spawncrew;
