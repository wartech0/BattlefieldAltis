if (isDedicated) exitWith {};
waitUntil {!isNull player};

_markpos = getMarkerPos "respawn_west";
player setPosATL [ _markpos select 0, _markpos select 1, 0.5 ];
player setDir 45;

_ttt = 1;
 
{ if ((isFormationLeader player)&&(!isPlayer _x)&&(_x distance MainEVAC < 100)) then {
	_x setPosATL [ ((getPos player)select 0) - _ttt, ((getPos player)select 1) - _ttt, 1];
	_ttt = _ttt + 1;
} } forEach units group player;	
 