if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_unitname = if (count _this > 1) then { _this select 1 } else { "MainEVAC"; };

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1))/2);

_radius = if (count _this > 2) then { _this select 2 } else { _markrad; };

_spawnpos = nil;
while {true} do {
	scopeName "SpawnPosGen";
	_randir = floor(random 360);
	_randis = floor(random (_radius * 1.5));
	_spawnpos = [(_markpos select 0) + ((sin _randir) * _randis), (_markpos select 1) + ((cos _randir) * _randis), 0.01];

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

_unit = "Flag_NATO_F" createVehicle _spawnpos;
_unit setPosATL _spawnpos;
_unit setDir floor(random 360);
_unit lock true;
_unit setVehicleVarName _unitname;
_unit call compile format ["%1=_This; PublicVariable '%1'",_unitname];

sleep 1;

vEvacSpawned=true;
publicVariable "vEvacSpawned";

removeAllActions _unit; 
_unit addAction["<t color='#ff9900'>EVAC to base</t>", "playerevac.sqf"];
_unit allowDamage false;
_unit addEventHandler ["HandleDamage", {false}];

deleteMarker vEvacMarker; vEvacMarker = nil; deleteMarker "mEvacMarker";
vEvacMarker = createMarker [ "mEvacMarker", getPos _unit ];
vEvacMarker setMarkerText "EVAC";
vEvacMarker setMarkerShape "ICON";
vEvacMarker setMarkerType "mil_triangle";
vEvacMarker setMarkerColor "ColorBlue";
