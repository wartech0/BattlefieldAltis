_exit = false;
if (!isFormationLeader player) then {
	systemChat "OFFICER: Only team leader can recruit AI for your team.";
	_exit = true;
};
if (_exit) exitWith {};

vActiveRecruitsAI = 0;
{ if (!isPlayer _x) then { vActiveRecruitsAI = vActiveRecruitsAI + 1; } } forEach units group player;

if (!(vActiveRecruitsAI < vMaxRecruitsAI)) then {
	systemChat format [ "OFFICER: You can only recruit %1 AI soldiers.", vMaxRecruitsAI ];
	_exit = true;
};

if (_exit) exitWith {};

_spawnpos = [ (getMarkerPos "recruit_west" select 0), (getMarkerPos "recruit_west" select 1), 1 ];
_unit = group player createUnit ["B_sniper_F", _spawnpos, [], 1, "PRIVATE"];
_unit setPosATL _spawnpos;
_unit setSkill 1;

vActiveRecruitsAI = vActiveRecruitsAI + 1;
publicVariable "vActiveRecruitsAI";