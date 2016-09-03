// add interaction to get dog from car

params ["_offroad"];

// todo: how to inject _offroad into _getDog?

_getDog =
[
	'Get Dog','Get Dog','',
	{[player,_offroad] call fnc_getDogFromCar;},
	{_offroad getVariable ["GRAD_dogCargo",0] > 0}
] call ace_interact_menu_fnc_createAction;

[
	_offroad,
	1,
	["ACE_SelfActions"],
	_getDog
] call ace_interact_menu_fnc_addActionToObject;