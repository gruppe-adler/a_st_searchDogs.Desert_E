params ["_player","_dog", "_dogsLeft", "_offroad"];

_dog setVariable ["dogOwner",_player,true];
_offroad setVariable ["GRAD_dogCargo", _dogsLeft - 1];

_pos = getPos _offroad;
detach _dog;
_dog setPos [(_pos select 0)  + 1.2, (_pos select 1), 0];

_dog enableAI "ANIM";

diag_log format ["GRAD_dogs: moving dog out of vehicle"];

[_dog, 1] call fnc_dogBrain_addPFH;