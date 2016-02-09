waitUntil {!isNull player};
_exit = false;

if ((vSupplyDropLock == 2)&&(!isFormationLeader player)) then {
	systemChat "RESUPPLY: Only team leader can call supply drop.";
	_exit = true;
};
if (_exit) exitWith {};

_isUnconscious = player getVariable "FAR_isUnconscious";
if (_isUnconscious == 1) then {
	systemChat "You cannot do this while unconscious.";
	_exit = true;
};
if (_exit) exitWith {};

if (time < vSupplyTimer) then {
	systemChat "RESUPPLY: Resupply drop not available.";
	_exit = true;
};
if (_exit) exitWith {};

if ((player distance HaloFlag) < 100) then {
	systemChat "RESUPPLY: Cannot call resupply from the base area.";
	_exit = true;
};
if (_exit) exitWith {};

systemChat "RESUPPLY: Resupply drop on the way to your location.";

vSupplyTimer = time + vSupplyTimeout;
publicVariable "vSupplyTimer";

vSupplyDown = false; 
publicVariable "vSupplyDown";

deleteVehicle ResupplyBox;

_markpos = getPos player; 

_distance = 25;
_direction = floor(random 360);
_height = 500;

_spawnpos = [(_markpos select 0) + ((sin _direction) * _distance), (_markpos select 1) + ((cos _direction) * _distance), _height];
_boxpos = _spawnpos;

_timer = 20 + floor(random 40);
sleep _timer;

systemChat "RESUPPLY: Dropping supplies.";

ResupplyBox = createVehicle ["B_supplyCrate_F", _spawnpos, [], 0, "FLY"];

while { (((getPosATL ResupplyBox)select 2) > 50) && alive ResupplyBox } do {
	_boxpos = getPosATL ResupplyBox;
	sleep 0.1;
};

_para = createVehicle ["NonSteerable_Parachute_F", [_boxpos select 0,_boxpos select 1,((_boxpos select 2)-1)], [], floor(random 360), 'NONE'];
_para setPos _boxpos;

_parapos = getPosATL _para;
ResupplyBox attachTo [_para, [0,0,-1.6]];

while { (((getPosATL _para)select 2) > 2) && alive _para } do {
	_parapos = getPosATL _para;
	sleep 0.1;
};

_boxpos = [ _parapos select 0, _parapos select 1, 1 ];
detach ResupplyBox;
deleteVehicle _para;

ResupplyBox setPosATL _boxpos;
ResupplyBox setVehicleVarName "ResupplyBox";
ResupplyBox call compile format ["%1=_This; PublicVariable '%1'","ResupplyBox"];
removeAllActions ResupplyBox; 
ResupplyBox addAction["<t color='#ff1111'>Virtual Ammobox</t>", "VAS\open.sqf"];
ResupplyBox addAction["<t color='#ff1111'>Save gear</t>", "gearsave.sqf"]; this addAction["<t color='#00ff00'>Virtual Arsenal</t>", "arsenalbox.sqf"];
ResupplyBox allowDamage false;
ResupplyBox addEventHandler ["HandleDamage", {false}];

vSupplyDown = true; 
publicVariable "vSupplyDown";

sleep 5;

_smoke = "SmokeShell" createVehicle position ResupplyBox;

deleteMarker vSupplyMarker; vSupplyMarker = nil; deleteMarker "mSupplyMarker";
vSupplyMarker = createMarker [ "mSupplyMarker", getPos ResupplyBox ];
vSupplyMarker setMarkerText "Supply box";
vSupplyMarker setMarkerShape "ICON";
vSupplyMarker setMarkerType "mil_box";
vSupplyMarker setMarkerColor "ColorBlue";
