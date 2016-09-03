params ["_dog"];
_currentDestination = _dog getVariable ["GRAD_dogs_currentDestination",[0,0,0]];

// check for new point early and adjust target position
if (_dog distance _currentDestination < 3) then {
	_pos = getPosATL _dog;
	_nextSniffingPoint = [_dog, _pos] call fnc_dogBrain_sniff_getSearchPoint;
};

if (_pos == _nextSniffingPoint) exitWith {
	_dog setVariable ["GRAD_dogs_nextTask","regroup"];
	_dog setVariable ["GRAD_dogs_currentPriority",0];
};

[_dog] call fnc_dogBrain_sniff_scanForEnemy;

/* 

// pant a lot, full of excitement
if (random 10 > 6) then {
	_dog say3d "dog_panting_advance";
};

*/

diag_log format ["_nextSniffingPoint is %1", _nextSniffingPoint];
_target = "Sign_Arrow_Direction_F" createVehiclelocal _pos;
_target setPos _pos;
_target setDir (getDir _dog);

[_dog, _nextSniffingPoint] call fnc_dogBrain_doRun;