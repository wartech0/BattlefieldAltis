waitUntil {!isNull player};

nul = [] execVM "refreshactions.sqf";

if (vGearSaved) then {
	nul = [] execVM "gearload.sqf"; 
};

nul = [] execVM "refreshfar.sqf";
