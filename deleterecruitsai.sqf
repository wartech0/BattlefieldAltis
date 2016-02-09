_exit = false;
if (!isFormationLeader player) then {
	systemChat "OFFICER: Only team leader can delete AI recruited for your team.";
	_exit = true;
};
if (_exit) exitWith {};

if (isNil "FriendlyCaptive") then {
	{ if (!isPlayer _x) then { deleteVehicle _x } } forEach units group player;
} else {
	{ if ((!isPlayer _x) && (_x != FriendlyCaptive)) then { deleteVehicle _x } } forEach units group player;
};

vActiveRecruitsAI = 0;
publicVariable "vActiveRecruitsAI";