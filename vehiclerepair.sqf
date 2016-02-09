if (!isServer) exitWith {};

_exit = false;
_unit = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

waitUntil {(getPosATL _unit select 2) < 2};
waitUntil {speed _unit < 2};
sleep 3;
if ((getPosATL _unit select 2) > 2) exitWith{};
if(speed _unit > 3) exitWith{};


vVehicleRepair = 1;
{ if (isPlayer _x) then { _id = owner _x; _id publicVariableClient "vVehicleRepair"; } } forEach crew _unit;
systemChat "MAINTENANCE: Repairing, refuelling and rearming ...";

sleep 10;

if ((getPosATL _unit select 2) > 2) exitWith{};
if(speed _unit > 3) exitWith{};

_unit setDammage 0;
_unit setFuel 1;

_unit setVehicleAmmo 1;
_unit setVehicleAmmoDef 1;

_emptyMagazines = [];
_fullMagazines = [];
{
	_magazine = _x select 0;
	_rounds = _x select 1;
	if (getNumber(configFile >> "CfgMagazines" >> _magazine >> "count") == _rounds) then {
		_fullMagazines = _fullMagazines + [_x select 0];
	} else {
		_emptyMagazines = _emptyMagazines + [_x select 0];
	};
} forEach (magazinesAmmo _unit);
{ _unit removeMagazineGlobal _x; } forEach (_emptyMagazines+_fullMagazines);
{ _unit addMagazineGlobal _x; } forEach _fullMagazines;
{ _unit addMagazineGlobal _x; } forEach _emptyMagazines;

vVehicleRepair = 2;
{ if (isPlayer _x) then { _id = owner _x; _id publicVariableClient "vVehicleRepair"; } } forEach crew _unit;
systemChat "MAINTENANCE: Finished.";

sleep 1;

vVehicleRepair = 0;
publicVariable "vVehicleRepair";

if(true) exitWith{};