if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };

_markpos = getMarkerPos _marker; 
_marksize = getMarkerSize _marker;
_markrad = floor(sqrt((_marksize select 0)*(_marksize select 1)));

_radius = if (count _this > 3) then { _this select 3 } else { _markrad; };

_spawnpos = nil;
while {true} do {
	scopeName "SpawnPosGen";
	_randir = floor(random 360);
	_randis = floor(random _radius);
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

_unitname = "EnemyOfficerHQ";
_unit = "Land_BagBunker_Large_F" createVehicle _spawnpos;
_unit setPosATL _spawnpos;
_vd = _spawnpos vectorDiff _markpos;
_tdir = (_vd select 0) atan2 (_vd select 1);
_tdir = 360 + _tdir;
_dir = _tdir + 180 - 45 + floor(random 90);
_unit setDir _dir;
_unit setVehicleVarName _unitname;
_unit call compile format ["%1=_This; PublicVariable '%1'",_unitname];

{ if (_x != _unit) then { deleteVehicle _x } } forEach nearestObjects [_spawnpos, ["static","Land_Sea_Wall_F"], 10];

sleep 1;

_grp = createGroup east;
_unitname = "EnemyOfficer";
_unit = _grp createUnit ["O_officer_F", getPosATL EnemyOfficerHQ, [], _skill, "NONE"];
_unit setDamage 0;
_randir = _dir + 40 + (floor(random 280));
_gspawnpos = [(getPosATL EnemyOfficerHQ select 0) + ((sin _randir) * 1), (getPosATL EnemyOfficerHQ select 1) + ((cos _randir) * 1), getPosATL EnemyOfficerHQ select 2];
_unit setDamage 0;
_unit setPosATL _gspawnpos;
_unit setDir floor(random 360); 
_unit setDamage 0;
_unit disableAI "FSM";
_unit setUnitPos "Middle";
removeAllWeapons _unit;
removeBackpack _unit;
removeVest _unit;
_unit allowFleeing 0;
_unit setSkill _skill;
_unit setRank "COLONEL";
_unit setVehicleVarName _unitname;
_unit call compile format ["%1=_This; PublicVariable '%1'",_unitname];
_unit unassignItem "NVGoggles";
_unit removeItem "NVGoggles";
_unit setDamage 0;

_havenv = floor(random 100);
_types = [ "O_Soldier_AR_F", "O_medic_F", "O_engineer_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_Soldier_AT_F", "O_soldier_repair_F", "O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_lite_F" ];
_count = 1 + floor(random 5);
_grp = createGroup east;
for "_x" from 1 to _count step 1 do {
	_type = _types select (floor(random(count _types)));
	_randir = _dir + 80 + (floor(random 200));
	_ranpos = [(getPosATL EnemyOfficerHQ select 0) + ((sin _randir) * (1+((random 300)/100))), (getPosATL EnemyOfficerHQ select 1) + ((cos _randir) * (1+((random 300)/100))), getPosATL EnemyOfficerHQ select 2];
	_unit = _grp createUnit [_type, _ranpos, [], _skill, "NONE"];
	doStop _unit;
	_unit setUnitPos "Middle";
	_unit setPosATL _ranpos;
	_unit setDir floor(random 360); 
	_unit allowFleeing 0;
	_unit setSkill _skill;
	if (vEnemyNightVision <= _havenv) then {
		_unit unassignItem "NVGoggles_OPFOR";
		_unit removeItem "NVGoggles_OPFOR";
	};
};
