if (!isServer) exitWith {};

_exit = false;
_marker = if (count _this > 0) then { _this select 0 } else { _exit = true };
if (_exit) exitWith {};

_name = if (count _this > 1) then { _this select 1 } else { _this select 0 };

// 1 = capture
// 2 = defend
// 3 = assassinate
// 4 = rescue

vMissionType = 1 + floor(random 4);
vMissionDone = false;
vMissionSuccess = false;
vMissionTargetType = nil;

publicVariable "vMissionType";
publicVariable "vMissionDone";
publicVariable "vMissionSuccess";
publicVariable "vMissionTargetType";

if (vMissionType == 1) then {
	nul = [ _marker, _name ] execVM "cm-capture.sqf";
}; if (vMissionType == 2) then {
	nul = [ _marker, _name ] execVM "cm-defend.sqf";
}; if (vMissionType == 3) then {
	nul = [ _marker, _name ] execVM "cm-assassinate.sqf";
}; if (vMissionType == 4) then {
	nul = [ _marker, _name ] execVM "cm-rescue.sqf";
};

