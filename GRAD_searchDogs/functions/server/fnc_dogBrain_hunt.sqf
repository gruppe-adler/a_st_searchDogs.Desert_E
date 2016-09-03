params ["_dog"];

_prey = _dog getVariable ["dogPrey", nil];

// todo : find right value for spotted
if (_dog distance _prey < 3) exitWith {
	_dog setVariable ["GRAD_dogs_nextTask","doBiteJump"];
	_dog setVariable ["GRAD_dogs_currentPriority",0];
};

/* 
// pant a lot, full of excitement
if (random 10 > 6) then {
	_dog say3d "dog_panting_advance";
};

*/

[_dog, getPosATL _prey] call fnc_dogBrain_doSprint;