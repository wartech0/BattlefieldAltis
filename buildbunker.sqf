waitUntil {!isNull player};
_exit = false;

if ((vBunkerLock == 2)&&(!isFormationLeader player)) then {
	systemChat "FORTIFICATION: Only team leader can build a bunker.";
	_exit = true;
};
if (_exit) exitWith {};

_isUnconscious = player getVariable "FAR_isUnconscious";
if (_isUnconscious == 1) then {
	systemChat "You cannot do this while unconscious.";
	_exit = true;
};
if (_exit) exitWith {};

if (time < vBunkerTimer) then {
	systemChat "FORTIFICATION: Bunker not available.";
	_exit = true;
};
if (_exit) exitWith {};

if ((player distance HaloFlag) < 100) then {
	systemChat "FORTIFICATION: Cannot build bunker in the base area.";
	_exit = true;
};
if (_exit) exitWith {};

systemChat "FORTIFICATION: Bunker built.";

vBunkerTimer = time + vBunkerCooldown;
publicVariable "vBunkerTimer";

vBunkerBuilt = false; 
publicVariable "vBunkerBuilt";

deleteVehicle BlueBunker;

_markpos = getPos player; 

_distance = 2;
_direction = direction player;

_spawnpos = [(_markpos select 0) + ((sin _direction) * _distance), (_markpos select 1) + ((cos _direction) * _distance), 0.01];

BlueBunker = createVehicle ["Land_BagBunker_Small_F", _spawnpos, [], 0, "FLY"];

BlueBunker setPosATL _spawnpos;
BlueBunker setDir _direction + 180; 
BlueBunker setVehicleVarName "BlueBunker";
BlueBunker call compile format ["%1=_This; PublicVariable '%1'","BlueBunker"];

vBunkerBuilt = true; 
publicVariable "vBunkerBuilt";

deleteMarker vBunkerMarker; vBunkerMarker = nil; deleteMarker "mBunkerMarker";
vBunkerMarker = createMarker [ "mBunkerMarker", getPos BlueBunker ];
vBunkerMarker setMarkerText "Bunker";
vBunkerMarker setMarkerShape "ICON";
vBunkerMarker setMarkerType "loc_Bunker";
vBunkerMarker setMarkerColor "ColorBlue";

