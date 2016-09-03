params ["_dog"];

_owner = _dog getVariable ["dogOwner", nil];

if (_dog distance _owner < 5) then {
	_dog setVariable ["GRAD_dogs_nextTask","sniff_advance"];
	_dog setVariable ["GRAD_dogs_currentPriority",0];
	// _dog say3d "dog_bark_collect";
};

/* 

if (random 10 > 7) then {
	_dog say3d "dog_whimper_collect";
};

*/
_dog moveTo (getPos _owner);
_dog playMove "Dog_Run";