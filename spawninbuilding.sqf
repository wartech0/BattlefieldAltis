if (!isServer) exitWith {};

_exit = false;
_house = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_skill = if (count _this > 1) then { _this select 1 } else { 0.5; };
_count = if (count _this > 3) then { _this select 3 } else { (1+floor(random 5)); };

_hposarr = [_house] call BIS_fnc_buildingPositions; 
_havenv = floor(random 100);
_types = [ "O_Soldier_AR_F", "O_medic_F", "O_engineer_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_Soldier_AT_F", "O_soldier_repair_F", "O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_lite_F" ];

_grp = createGroup east;
if (_count > (count _hposarr)) then { _count = (count _hposarr); };
for "_x" from 0 to _count step 1 do {
	_type = _types select (floor(random(count _types)));
	_index = random (count _hposarr);
	_ranpos = _hposarr select _index;
	_hposarr deleteAt _index;
	_unit = _grp createUnit [_type, _ranpos, [], _skill, "NONE"];
	doStop _unit;
	_unit setPosATL _ranpos;
	_unit allowFleeing 0;
	_unit setSkill _skill;
	if (vEnemyNightVision <= _havenv) then {
		_unit unassignItem "NVGoggles_OPFOR";
		_unit removeItem "NVGoggles_OPFOR";
	};
};