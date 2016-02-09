waitUntil {!isNull player};

vUniform = uniform player;
vVest = vest player;
vHeadgear = headgear player;
vGoggles = goggles player;
vItems = items player;
vAssignedItems = assignedItems player;
vBackpack = backpack player;
vBackpackItems = backpackItems player;

vPriAmmo = primaryWeaponMagazine player;
vSecAmmo = secondaryWeaponMagazine player;
vHandAmmo = handgunMagazine player;

vPriItems = primaryWeaponItems player;
vSecItems = secondaryWeaponItems player;
vHandItems = handgunItems player;

vMagazines = magazines player;
vWeapons = weapons player;

vGearSaved = true;
systemChat "Gear saved.";
