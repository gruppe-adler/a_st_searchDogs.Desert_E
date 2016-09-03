params ["_dog","_pos"];

_dog playMove "Dog_Run";
_dog forceSpeed 100; // (_dog getSpeed "FAST");
_dog moveTo _pos;

if (!isNil "DEBUG") then {
	_target = "Sign_Arrow_Large_Pink_F" createVehiclelocal _pos;
	_target setPos _pos;
};