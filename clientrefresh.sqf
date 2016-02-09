if (isServer) exitWith {};
waitUntil {!isNull player};

"vActiveMarker" addPublicVariableEventHandler {
	if (vActiveMarker != "none") then {
		if (vMissionType == 1) then {
			vActiveMarker setMarkerBrush "DiagGrid";
			vActiveMarker setMarkerColor "ColorRed";
			{ player removeSimpleTask _x } forEach simpleTasks player;
			cTask = player createSimpleTask ["Capture"];
			cTask setSimpleTaskDestination (getMarkerPos vActiveMarker);
			cTask setSimpleTaskDescription [ format [ "Destroy enemy %1 and capture this area.", vMissionTargetType ], "Capture", "Capture"];
			player setCurrentTask cTask;
		};
		if (vMissionType == 2) then {
			vActiveMarker setMarkerBrush "DiagGrid";
			vActiveMarker setMarkerColor "ColorBlue";
			{ player removeSimpleTask _x } forEach simpleTasks player;
			cTask = player createSimpleTask ["Defend"];
			cTask setSimpleTaskDestination (getMarkerPos vActiveMarker);
			cTask setSimpleTaskDescription [ "Defend the area.", "Defend", "Defend"];
			player setCurrentTask cTask;
		};
		if (vMissionType == 3) then {
			vActiveMarker setMarkerBrush "DiagGrid";
			vActiveMarker setMarkerColor "ColorRed";
			{ player removeSimpleTask _x } forEach simpleTasks player;
			cTask = player createSimpleTask ["Assassinate"];
			cTask setSimpleTaskDestination (getMarkerPos vActiveMarker);
			cTask setSimpleTaskDescription [ "Assassinate the enemy officer in the marked area.", "Assassinate", "Assassinate"];
			player setCurrentTask cTask;
		};
		if (vMissionType == 4) then {
			vActiveMarker setMarkerBrush "DiagGrid";
			vActiveMarker setMarkerColor "ColorRed";
			{ player removeSimpleTask _x } forEach simpleTasks player;
			cTask = player createSimpleTask ["Rescue"];
			cTask setSimpleTaskDestination (getMarkerPos vActiveMarker);
			cTask setSimpleTaskDescription [ "Rescue friendly covert operative held captive in the marked area and escort him safely to base.", "Rescue", "Rescue"];
			player setCurrentTask cTask;
		};
	};
};

"vActiveName" addPublicVariableEventHandler {
	if (vActiveName != "none") then {
		if (vMissionType == 1) then {
			nul = [ "CAPTURE:", vActiveName, 1.5, 3, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 
			systemChat format [ "OBJECTIVE: Destroy the enemy %1 and capture the marked area.", vMissionTargetType ];
			playSound "FD_CP_Not_Clear_F";
		};
		if (vMissionType == 2) then {
			nul = [ "DEFEND:", vActiveName, 1.5, 3, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 
			systemChat format [ "OBJECTIVE: Move to the marked area, prepare your defences and defend the area for %1 minutes.", vDefMissTimer ];
			playSound "FD_CP_Not_Clear_F";
		};			
		if (vMissionType == 3) then {
			nul = [ "ASSASSINATE:", vActiveName, 1.5, 3, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 
			systemChat "OBJECTIVE: Assassinate the enemy officer in the marked area.";
			playSound "FD_CP_Not_Clear_F";
		};			
		if (vMissionType == 4) then {
			nul = [ "RESCUE:", vActiveName, 1.5, 3, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 
			systemChat "OBJECTIVE: Rescue friendly covert operative held captive in the marked area and escort him safely to base.";
			playSound "FD_CP_Not_Clear_F";
		};			
	};
};

"vArmorInArea" addPublicVariableEventHandler {
	if (vArmorInArea) then { 
		systemChat "MAGIC: Intel reports enemy armor in the target area.";
	};
};

"vMortarInArea" addPublicVariableEventHandler {
	if (vMortarInArea) then { 
		systemChat "MAGIC: Intel reports enemy mortars in the target area.";
	};
};

"vHeliInArea" addPublicVariableEventHandler {
	if (vHeliInArea) then { 
		systemChat "MAGIC: Intel reports enemy attack helicopter in the target area.";
	};
};

"vDetectedInArea" addPublicVariableEventHandler {
	if ((vDetectedInArea) && (!vJustConnected)) then { 
		nul = [ "DETECTED!", format [ "Enemy has detected you in the target area and will call in reinforcements until the %1 is destroyed.", vMissionTargetType ], 2, 1.2, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 
		playSound "Alarm_OPFOR";
	};
};

"vMHQDead" addPublicVariableEventHandler {
	if ((vMHQDead) && (!vJustConnected)) then { 
		nul = [ format [ "%1 DESTROYED!", vMissionTargetType ], format [ "The %1 was destroyed! The enemy will no longer be able to call in reinforcements. Good job!", vMissionTargetType ], 2, 1.2, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf"; 
		playSound "FD_Timer_F";
	};
};

"vMissionDone" addPublicVariableEventHandler {
	if (vMissionDone) then {
		{ player removeSimpleTask _x } forEach simpleTasks player;
		if (vMissionSuccess) then {
			nul = [ "MISSION COMPLETE:", vActiveName, 1.5, 3, "#00ff00", "#0000ff", "center", "center" ] execVM "mymessage.sqf";
		} else {
			nul = [ "MISSION FAILED:", vActiveName, 1.5, 3, "#ff0000", "#0000ff", "center", "center" ] execVM "mymessage.sqf";	
		};
		playSound "FD_Finish_F";
	};
}; 

"vSupplyDown" addPublicVariableEventHandler {
	if (vSupplyDown) then { 
		removeAllActions ResupplyBox;
		ResupplyBox addAction["<t color='#ff1111'>Virtual Ammobox</t>", "VAS\open.sqf"];
		ResupplyBox addAction["<t color='#ff1111'>Save gear</t>", "gearsave.sqf"];
		ResupplyBox allowDamage false;
		ResupplyBox addEventHandler ["HandleDamage", {false}];
	} else {
		removeAllActions ResupplyBox;
	};
}; 

//"vBunkerBuilt" addPublicVariableEventHandler {
//}; 

"vEvacSpawned" addPublicVariableEventHandler {
	if (vEvacSpawned) then { 
		removeAllActions MainEVAC; 
		MainEVAC addAction["<t color='#ff9900'>Teleport to base</t>", "playerevac.sqf"];
		MainEVAC allowDamage false;
		MainEVAC addEventHandler ["HandleDamage", {false}];
	} else {
		removeAllActions MainEVAC; 
	};
}; 

"vMissionScore" addPublicVariableEventHandler {
	if (!vJustConnected) then {
		if (vVehicleLock == 1) then {
			systemChat format [ "Missions done: %1", vMissionScore ];
		} else {
			systemChat format [ "Missions done: %1", (vMissionScore - 100) ];
		};
	};
}; 

"vServerTime" addPublicVariableEventHandler {
	setDate vServerTime;
}; 

"vVehicleRepair" addPublicVariableEventHandler {
	if (vVehicleRepair == 1) then {
		systemChat "MAINTENANCE: Repairing, refuelling and rearming ...";
	};
	if (vVehicleRepair == 2) then {
		systemChat "MAINTENANCE: Finished.";
	};
}; 

"vDefPrepCountdown" addPublicVariableEventHandler {
	if (vDefPrepCountdown > 0) then {
		nul = [ "ATTACK BEGINS IN:", format [ "%1 seconds", vDefPrepCountdown ], 1.5, 1.2, "#00ff00", "#ff0000", "center", "center", false ] execVM "mymessage.sqf"; 	
	} else {
		nul = [ "UNDER ATTACK!", format [ "Enemy is attacking %1! Defend the area for %2 minutes.", vActiveName, vDefMissTimer ], 2, 1.2, "#00ff00", "#ff0000", "center", "center" ] execVM "mymessage.sqf";
		playSound "Alarm_OPFOR";
	};
}; 

"vDefMissCountdown" addPublicVariableEventHandler {
	systemChat format [ "DEFEND: %1 minutes remaining.", (vDefMissCountdown/60) ];
}; 
