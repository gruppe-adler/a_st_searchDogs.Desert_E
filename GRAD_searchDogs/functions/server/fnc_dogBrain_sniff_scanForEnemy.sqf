params ["_dog"];

_prey = _dog getVariable ["dogPrey", nil];

// todo : find right value for spotted
if (_dog knowsAbout _prey > 3 || _dog distance _prey < 100) then {
	_dog setVariable ["GRAD_dogs_nextTask","hunt"];
	_dog setVariable ["GRAD_dogs_currentPriority",0];
};