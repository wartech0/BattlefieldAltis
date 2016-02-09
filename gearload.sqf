waitUntil {!isNull player};

removeAllPrimaryWeaponItems player;
removeAllHandgunItems player;
removeAllWeapons player;
removeGoggles player;
removeHeadgear player;
removeAllAssignedItems player;
removeAllItems player;
{ player removeMagazine _x } forEach magazines player;
clearAllItemsFromBackpack player;
removeBackpack player;
removeUniform player;
removeVest player;

player addUniform vUniform;
player addVest vVest;
player addBackpack vBackpack;
player addHeadgear vHeadgear;
player addGoggles vGoggles;

{ player addItem _x } forEach vItems;
{ player linkItem _x } forEach vAssignedItems;

{ player addMagazine _x } forEach vPriAmmo;
{ player addMagazine _x } forEach vSecAmmo;
{ player addMagazine _x } forEach vHandAmmo;

{ player addWeapon _x } forEach vWeapons;
{ player addMagazine _x } forEach vMagazines;

{ player addPrimaryWeaponItem _x } forEach vPriItems;
{ player addSecondaryWeaponItem _x } forEach vSecItems;
{ player addHandgunItem _x } forEach vHandItems;
