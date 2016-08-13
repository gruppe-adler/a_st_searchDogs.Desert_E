DEBUG = true;

call compile preprocessfile "SHK_pos\shk_pos_init.sqf";

GRAD_dog_create = {
	params ["_pos"];

	_dog = createAgent ["Fin_random_F", _pos, [], 5, "CAN_COLLIDE"];
	_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
	/*_grp = createGroup CIVILIAN;
	_dog = _grp createUnit ["Fin_random_F", _pos, [], 5, "CAN_COLLIDE"];*/
	
	_dog setVariable ["GRAD_dogs_taskDone",true];
	_dog
};

cage attachTo [car, [0,-1.6,0.3]];
cage setVectorDirAndUp [[1,0,0],[0,0,1]];

if (isServer) then {
	dog = [[getPos prey select 0,(getPos prey select 1) + 50,0]] call GRAD_dog_create;
	0 = [prey,dog] execVM "initDogs.sqf";
};