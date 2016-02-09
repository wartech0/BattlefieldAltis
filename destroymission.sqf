if (!isServer) exitWith {};
if (!isDedicated) then { { player removeSimpleTask _x } forEach simpleTasks player; };

vActiveMarker setMarkerBrush "Border"; 
vActiveMarker SetMarkerColor "ColorGrey";

_tmpmark = vActiveMarker;

vActiveMarker="none";
vActiveName="none";
vRedInArea=false;
vBlueInArea=false;
vDetectedInArea=false;
vParadropTimer=0;
vMHQDead=false;
vArmorInArea=false;
vMortarInArea=false;
vHeliInArea=false;
vMissionType = nil;
vMissionDone = nil;
vMissionSuccess = nil;
vMissionTargetType = nil;

publicVariable "vMissionType";
publicVariable "vMissionDone";
publicVariable "vMissionSuccess";
publicVariable "vMissionTargetType";
publicVariable "vActiveMission";
publicVariable "vActiveMarker";
publicVariable "vActiveName";
publicVariable "vRedInArea";
publicVariable "vBlueInArea";
publicVariable "vDetectedInArea";
publicVariable "vMHQDead";
publicVariable "vArmorInArea";
publicVariable "vMortarInArea";
publicVariable "vHeliInArea";

deleteVehicle tRedInArea;
deleteVehicle tRedNotInArea;
deleteVehicle tBlueInArea;
deleteVehicle tBlueNotInArea;
deleteVehicle tOccupiedByBlue;
deleteVehicle tDetectedInArea;
deleteVehicle tParadrop;
deleteVehicle tMHQSpawnError;
deleteVehicle tMHQDead;
deleteVehicle tFCRescued;
deleteVehicle tFCDead;
deleteVehicle tCapturedByBlue;

deleteVehicle MainMHQ;
deleteVehicle MainMHQCamo;
deleteVehicle EnemyOfficerHQ;
deleteVehicle FriendlyCaptive;
FriendlyCaptive = nil;

{ if (((side _x)==east) AND (_x isKindOf "LandVehicle")) then { deleteVehicle _x } } forEach vehicles;
{ if ((_x isKindOf "StaticWeapon")) then { deleteVehicle _x } } forEach vehicles;
{ if (((side _x)==east) AND (_x isKindOf "Air")) then { deleteVehicle _x } } forEach vehicles;
{ if (((side _x)==east) AND (_x isKindOf "Man")) then { deleteVehicle _x } } forEach allUnits;
{ if ((side _x)==east) then { deleteGroup _x } } forEach allGroups;
{ deleteVehicle _x } forEach allDead;
{ deleteVehicle _x } forEach nearestObjects [ getMarkerPos _tmpmark, ["WeaponHolder","GroundWeaponHolder","WeaponHolderSimulated","Default","Land_BagBunker_Large_F"], 2000];
{ deleteVehicle _x } forEach nearestObjects [ getMarkerPos respawn_west, ["WeaponHolder","GroundWeaponHolder","WeaponHolderSimulated","Default"], 2000];

if (vSpawnEvac == 1) then {
	vEvacSpawned=false;
	publicVariable "vEvacSpawned";
	sleep 1;
	deleteVehicle MainEVAC;
	nul = [ _tmpmark ] execVM "spawnevac.sqf";
};
