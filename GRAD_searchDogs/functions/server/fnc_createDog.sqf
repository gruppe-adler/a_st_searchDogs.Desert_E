params ["_offroad", "_prey"];

_dog = createAgent ["Fin_random_F", [0,0,0], [], 5, "CAN_COLLIDE"];
_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
_dog setVariable ["dogPrey", _prey];
_dog setVariable ["sniffingStrength", 20];

_dog disableAI "ANIM";


if (_offroad getVariable ["GRAD_dogCargo",0] == 0) exitWith {
	diag_log format ["cargo of %1 will get 1 dog", _offroad];
	_offroad setVariable ["GRAD_dogCargo",1,true];
	_offroad setVariable ["cageDog1",_dog];
	// _dog attachTo [_offroad,[0.2,-1.9,-0.7]]; 
	_dog attachTo [_offroad,[0,-2.2,-0.7]]; 
	_dog switchmove "Dog_Idle_Sit04"; 
	_dog disableAI "ANIM";
	// _dog setvectordirandup [[1,0,0],[0,0,1]];

	_y = 135; _p = 0; _r = 0;
	_dog setVectorDirAndUp [
		[ sin _y * cos _p,cos _y * cos _p,sin _p],
		[ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
	];
};

if (_offroad getVariable ["GRAD_dogCargo",0] == 1) exitWith {
	diag_log format ["cargo of %1 will get 2nd dog", _offroad];
	_offroad setVariable ["GRAD_dogCargo",2,true];
	_offroad setVariable ["cageDog2",_dog];
	// _dog attachTo [_offroad,[0.2,-1.9,-0.7]]; 
	_dog attachTo [_offroad,[0,-1.6,-0.7]]; 
	_dog switchmove "Dog_Idle_Sit04"; 
	_dog disableAI "ANIM";
	// _dog setvectordirandup [[1,0,0],[0,0,1]];

	_y = -135; _p = 0; _r = 0;
	_dog setVectorDirAndUp [
		[ sin _y * cos _p,cos _y * cos _p,sin _p],
		[ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
	];

};

if (_offroad getVariable ["GRAD_dogCargo",0] > 2) exitWith {
	diag_log format ["cargo of %1 is full of dogs already", _offroad];
};

_dog

