DEBUG = true;

call compile preprocessfile "SHK_pos\shk_pos_init.sqf";

GRAD_dog_create = {
	params ["_pos"];

	_dog = createAgent ["Fin_random_F", _pos, [], 5, "CAN_COLLIDE"];
	_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
	_dog setVariable ["GRAD_dogs_taskDone",true];
	_dog
};


if (isServer) then {
	dog = [[getPos prey select 0,(getPos prey select 1) + 50,0]] call GRAD_dog_create;
	0 = [prey,dog] execVM "initDogs.sqf";
};