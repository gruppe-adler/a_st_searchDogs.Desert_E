params ["_dog"];

_prey = _dog getVariable ["dogPrey",nil];

//The below calculates the players target jump height, direction and velocity.  These numbers attempt to simulate slight realisim.
_height = 5;   //"5-" is the starting upwards acceleration. Keep between 4-7. Higher numbers means more altitude.  
									//"*4.25" is the weight penalty curve.  Keep between 0-15.  Higher numbers means more penalty for having weight.
_speed = 0.5; 	//This is the added forward velocity during the jump. 
				//0 will cause the person jumping to rely on their forward momentum.  Adding to it "pushes" them forward during the jump.  Numbers past 5 cause injury.
_relDir = [_dog, _prey] call BIS_fnc_relativeDirTo;
_dog setDir _relDir;

//Math!
_dog setVelocity [
	(velocity _dog select 0)+(sin direction _dog*_speed),
	(velocity _dog select 1)+(cos direction _dog*_speed),
	(velocity _dog select 2)+_height
];

// todo: find right animation
_dog playMoveNow "jumpMove";

// todo: right sound
// _dog say3d (selectRandom ["dog_lacerate_attack_01", "dog_lacerate_attack_01", "dog_lacerate_attack_03", "dog_lacerate_attack_04"]);


// todo: set damage to prey, obviously legs

if (random 2 > 1) then {
	// damage
};

_dog setVariable ["GRAD_dogs_nextTask","hunt"];
_dog setVariable ["GRAD_dogs_currentPriority",0];