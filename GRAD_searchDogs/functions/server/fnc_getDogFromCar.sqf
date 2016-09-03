params ["_player","_offroad"];

_dogsLeft = _offroad getVariable ["GRAD_dogCargo",0];

switch (_dogsLeft) do {
	case 0: {};
	case 1: { 
		_dog = _offroad getVariable ["cageDog1",nil];
		[_player, _dog, _dogsLeft, _offroad] call fnc_moveDogFromCar;
 		};
 	case 2: {
 		_dog = _offroad getVariable ["cageDog2",nil];
 		[_player, _dog, _dogsLeft, _offroad] call fnc_moveDogFromCar;
 		};
	default {};	
};