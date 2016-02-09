if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true; };

_players = 0; 
{ if (isPlayer _x) then { _players = _players + 1 } } forEach allUnits;
if (_players < 1) then { _exit = true; };

if (_exit) exitWith {};

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_parano = if (count _this > 1) then { _this select 1 } else { 6; };
_skill = if (count _this > 2) then { _this select 2 } else { 0.5; };
_radius = if (count _this > 3) then { _this select 3 } else { floor(_markrad*1.67); };
_distance = if (count _this > 4) then { _this select 4 } else { 3000; };
_direction = if (count _this > 5) then { _this select 5 } else { floor(random 360); };
_height = if (count _this > 6) then { _this select 6 } else { 150; };
_delay = if (count _this > 7) then { _this select 7 } else { 0.5; };

_spawnpos = [(_markpos select 0) + ((sin _direction) * _distance), (_markpos select 1) + ((cos _direction) * _distance), _height];
_randir = floor(random 360);
_randis = floor(random _markrad);
_droppos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), _height];

_grph = createGroup east;
_unit = createVehicle ["O_Heli_Light_02_unarmed_F", _spawnpos, [], 0, "FLY"];
_unit setPosATL _spawnpos;
_unit setVehicleVarName "ParadropSQF";
_unit call compile format ["%1=_This; PublicVariable '%1'","ParadropSQF"];
_unit lock true;
_crew = [ _unit, _grph ] call bis_fnc_spawncrew;
_unit setCaptive true;
_unit flyInHeight _height;

_wp1 = _grph addWaypoint [_droppos, 0, 1];
[_grph,1] setWaypointBehaviour "CARELESS";
[_grph,1] setWaypointCompletionRadius 0;
_wp2 = _grph addWaypoint [_spawnpos, 0, 2];
[_grph,2] setWaypointBehaviour "CARELESS";
[_grph,2] setWaypointCompletionRadius 50;
_wp2 setWaypointStatements ["true", "{ deleteVehicle _x; } forEach units group this; deleteVehicle ParadropSQF;"];

_grph setCurrentWaypoint [_grph, 1];
waitUntil { ([(getPos _unit)select 0, (getPos _unit)select 1] distance [_droppos select 0, _droppos select 1]) < ((_parano * 10) * (_delay * 6)) };
_grph setCurrentWaypoint [_grph, 2];

_grpp = createGroup east;
for "_x" from 1 to _parano step 1 do {
	_specnaz = _grpp createUnit ["O_soldier_PG_F", [(getPos _unit)select 0,(getPos _unit)select 1, ((getPos _unit)select 2) - 20], [], _skill, "NONE"];
	_specnaz setPos [(getPos _unit) select 0,(getPos _unit) select 1, ((getPos _unit) select 2) - 20];
	_specnaz allowFleeing 0;
	_specnaz setSkill _skill;
	_para = createVehicle ["NonSteerable_Parachute_F", position _specnaz, [], (((getDir _unit)-25)+(random 50)), 'NONE'];
	_para setPos (getPos _specnaz);
	_specnaz moveInDriver _para;
	sleep _delay;
};

_wp = nil;
for "_counter" from 1 to 10 step 1 do {
	_randir = floor(random 360);
	_randis = floor(random _radius);
	_wppos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 1];

	_wp = _grpp addWaypoint [_wppos, 0, _counter];
	[_grpp, _counter] setWaypointType "SAD";
	[_grpp, _counter] setWaypointBehaviour "AWARE";
	[_grpp, _counter] setWaypointCombatMode "RED";
	[_grpp, _counter] setWaypointCompletionRadius 20;
	_timeout = floor(random 600);
	[_grpp, _counter] setWaypointTimeout [ 1, floor(_timeout/2), _timeout];	
};
_wp setWaypointStatements ["true", "this setCurrentWaypoint [group this, 1]"];
