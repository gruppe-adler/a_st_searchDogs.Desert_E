// Settings
_trackingInterval = 0.5; // position of tracked guy is marked every X seconds
sniffingStrength = 20; // nose of the dog


/* 
*	preprocess functions
*/

fnc_createCageCar = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_createCageCar.sqf";
fnc_createDog = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_createDog.sqf";

fnc_dogBrain_addPFH = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_addPFH.sqf";

fnc_dogBrain_attack = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_attack.sqf";
fnc_dogBrain_doBiteJump = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_doBiteJump.sqf";
fnc_dogBrain_doSprint = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_doSprint.sqf";
fnc_dogBrain_hunt = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_hunt.sqf";
fnc_dogBrain_mainLoop = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_mainLoop.sqf";
fnc_dogBrain_regroup = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_regroup.sqf";
fnc_dogBrain_sniff_advance = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_sniff_advance.sqf";
fnc_dogBrain_sniff_collect = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_sniff_collect.sqf";
fnc_dogBrain_sniff_getNextPoint = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_sniff_getNextPoint.sqf";
fnc_dogBrain_sniff_idle = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_sniff_idle.sqf";
fnc_dogBrain_sniff_search = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_dogBrain_sniff_search.sqf";

fnc_getDogFromCar = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_getDogFromCar.sqf";
fnc_moveDogFromCar = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_moveDogFromCar.sqf";

fnc_victim_addPFH = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\server\fnc_victim_addPFH.sqf";
fnc_addInteractions = compile preprocessFileLineNumbers "GRAD_searchDogs\functions\player\fnc_addInteractions.sqf";

_cageCar = [[worldsize/2,worldSize/2]] call fnc_createCageCar;
[_cageCar] call fnc_addInteractions;
_dog1 = [_cageCar, dogPrey] call fnc_createDog;
_dog2 = [_cageCar, dogPrey] call fnc_createDog;
[dogPrey, _trackingInterval] call fnc_victim_addPFH;