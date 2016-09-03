params ["_dog"];

_owner = _dog getVariable ["dogOwner", nil];
if (isNil _owner || !alive _owner) then {
	 debugLog ("regroup: owner not found or dead");
};

if (_dog distance _owner < 2) exitWith {
	_dog setVariable ["GRAD_dogs_nextTask","idle"];
	_dog playMove "Dog_Idle";
};

_dog moveTo (getPosASL _owner);
_dog playMove "Dog_Run";