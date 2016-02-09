if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };
_radius = if (count _this > 2) then { _this select 2 } else { floor(_markrad*3); };
_height = if (count _this > 3) then { _this select 3 } else { 200; };
_mindis = if (count _this > 4) then { _this select 4 } else { 0; };

_randir = floor(random 360);
_randis = _mindis + floor(random _radius);
_spawnpos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), _height];

_types = [ "O_Heli_Light_02_F", "O_Heli_Attack_02_F" ];
_grp = createGroup east;
_type = _types select (floor(random(count _types)));
_unit = createVehicle [_type, _spawnpos, [], 0, "FLY"];
_unit setPosATL _spawnpos;
_unit lock true;
_crew = [ _unit, _grp ] call bis_fnc_spawncrew;
_unit flyInHeight _height;

_wp = nil;
for "_counter" from 1 to 50 step 1 do {
	_randir = floor(random 360);
	_randis = floor(random _radius);
	_wppos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), _height];

	_wp = _grp addWaypoint [_wppos, 0, _counter];
	[_grp, _counter] setWaypointType "SAD";
	[_grp, _counter] setWaypointBehaviour "AWARE";
	[_grp, _counter] setWaypointCombatMode "RED";
	[_grp, _counter] setWaypointCompletionRadius 50;
};
_wp setWaypointStatements ["true", "this setCurrentWaypoint [group this, 1]"];
