waitUntil {time > 0};

_markpos = getMarkerPos "respawn_west";
_spawnpos = [ _markpos select 0, _markpos select 1, 1];
_list = nearestObjects [_spawnpos, ["static"], 100];

{ _x allowDamage false; _x addEventHandler ["HandleDamage", {false}]; } forEach _list;
