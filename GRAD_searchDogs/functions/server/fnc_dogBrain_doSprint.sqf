params ["_dog","_pos"];

_dog playMove "Dog_Sprint";
_dog forceSpeed 100; // (_dog getSpeed "FAST");
_dog moveTo _pos;

_speed = 0.5;

// push it, because its so slow mo
_dog setVelocity [
	(velocity _dog select 0)+(sin direction _dog*_speed),
	(velocity _dog select 1)+(cos direction _dog*_speed),
	(velocity _dog select 2)
];

if (!isNil "DEBUG") then {
	_target = "Sign_Arrow_Large_Pink_F" createVehiclelocal _pos;
	_target setPos _pos;
};