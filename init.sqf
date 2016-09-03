DEBUG = true;

call compile preprocessfile "SHK_pos\shk_pos_init.sqf";

GRAD_dog_create = {
	params ["_pos"];

	_dog = createAgent ["Alsatian_Sandblack_F", _pos, [], 5, "CAN_COLLIDE"];
	_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
	/*_grp = createGroup CIVILIAN;
	_dog = _grp createUnit ["Fin_random_F", _pos, [], 5, "CAN_COLLIDE"];*/
	
	_dog setVariable ["GRAD_dogs_taskDone",true];
	_dog
};

// build cage
GRAD_dog_createDogCar = {
	params ["_pos"];
	_veh = "C_Offroad_01_F" createVehicle _pos;

	_veh setVariable ["BIS_enableRandomization", false];
	_veh animate ["hideServices", 1];
	_veh animate ["hideDoor1", 1];
	_veh animate ["hideDoor2", 1];
	_veh animate ["hideDoor3", 1];
	_veh animate ["hideGlass1", 1];
	_veh animate ["hideGlass2", 1];
	_veh animate ["hideBackpacks", 0];
	_veh animate ["hideBumper1", 1];
	_veh lockCargo [2,true];
	_veh lockCargo [3,true];
	_veh lockCargo [4,true];
	_veh setObjectTextureGlobal [0,"a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa"];


	_cage = "Land_cages_EP1" createVehicle [0,0,0];
	_cage attachTo [_veh, [-0.05,-1.6,-0.1]];

	// rotate cage yaw and pitch
	_y = 90; _p = -90; _r = 0;
	_cage setVectorDirAndUp [
		[ sin _y * cos _p,cos _y * cos _p,sin _p],
		[ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
	];

	_veh
};

GRAD_dog_putInCar = {
	params ["_doggy","_car"];

	if (_car getVariable ["GRAD_dogCargo",0] == 0) exitWith {
		diag_log format ["cargo of %1 will get 1 dog", _car];
		_car setVariable ["GRAD_dogCargo",1,true];
		// _dog attachTo [_car,[0.2,-1.9,-0.7]]; 
		_doggy attachTo [_car,[0,-2.2,-0.7]]; 
		_doggy switchmove "Dog_Idle_Sit04"; 
		_doggy disableAI "ANIM";
		// _doggy setvectordirandup [[1,0,0],[0,0,1]];

		_y = 135; _p = 0; _r = 0;
		_doggy setVectorDirAndUp [
			[ sin _y * cos _p,cos _y * cos _p,sin _p],
			[ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
		];
	};

	if (_car getVariable ["GRAD_dogCargo",0] == 1) exitWith {
		diag_log format ["cargo of %1 will get 2nd dog", _car];
		_car setVariable ["GRAD_dogCargo",2,true];
		// _dog attachTo [_car,[0.2,-1.9,-0.7]]; 
		_doggy attachTo [_car,[0,-1.6,-0.7]]; 
		_doggy switchmove "Dog_Idle_Sit04"; 
		_doggy disableAI "ANIM";
		// _doggy setvectordirandup [[1,0,0],[0,0,1]];

		_y = -135; _p = 0; _r = 0;
		_doggy setVectorDirAndUp [
			[ sin _y * cos _p,cos _y * cos _p,sin _p],
			[ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
		];

	};

	if (_car getVariable ["GRAD_dogCargo",0] > 2) exitWith {
		diag_log format ["cargo of %1 is full of dogs already", _car];
	};
};






if (isServer) then {
	_car = [[getPos prey select 0,(getPos prey select 1) + 60,0]] call GRAD_dog_createDogCar;
	_car setVariable ["GRAD_dogCargo",0,true];

	_dog = [[getPos prey select 0,(getPos prey select 1) + 50,0]] call GRAD_dog_create;
	[_dog,_car] call GRAD_dog_putInCar;

	_dog2 = [[getPos prey select 0,(getPos prey select 1) + 40,0]] call GRAD_dog_create;
	[_dog2,_car] call GRAD_dog_putInCar;

	// 0 = [prey,dog] execVM "initDogs.sqf";
};