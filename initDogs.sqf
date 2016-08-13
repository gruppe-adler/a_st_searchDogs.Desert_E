	/*
*
* GRAD_searchDogs
*

dog_die, dog_bark, dog_growl, dog_walk, dog_run, dog_sprint, dog_turnl, dog_turnr, dog_sit_01 thru 08
*/

if (!isServer) exitWith {};

params ["_prey","_dog"];

// Settings
_trackingInterval = 0.5; // position of tracked guy is marked every X seconds
_searchTime = 3; // how long the dog needs to find the next node
_dogBrainInterval = 5;
sniffingStrength = 20; // nose of the dog


GRAD_dog_getNextPoint = {
	params ["_pos"];
	_foundSomething = false;
	_foundThis = [0,0,0];
	
	_timeStamps = [];

	_sniffPoints = _pos nearObjects sniffingStrength;

	if (count _sniffPoints > 0) then {

		
		{
			if (_x isKindOf "Sign_Arrow_Large_Cyan_F" ) then {
				_timeStamps pushBack [_x,_x getVariable ["dropTime",0]];
			};
		} forEach _sniffPoints;

		if (count _timeStamps> 0) then {
			_foundSomething = true;
			diag_log format ["unsorted: %1",_timeStamps];
			_timeStamps sort false; 
			diag_log format ["sorted: %1",_timeStamps];
			// hintSilent format ["saving arrow %1",str ((_timeStamps select 0) select 0) select 0];
			_foundThis = getPosATL ((_timeStamps select 0) select 0);
		};	
	};
	_foundThis
};

GRAD_dog_sprintOrder = {
	params ["_dog","_pos"];

	// _dog stop false;
	_dog playMove "Dog_Sprint";
	_dog forceSpeed 100; // (_dog getSpeed "FAST");
	_dog moveTo _pos;
	// _dog doMove _pos;


	 _target = "Sign_Arrow_Large_Pink_F" createVehiclelocal _pos;

	 _target setPos _pos;
	 /* [_target] spawn {
	 	sleep 1.5;
	 	deleteVehicle (_this select 0);
	};*/
};


GRAD_dog_sniff_advance = {
	params ["_dog"];
	
	
   if (!alive _dog) exitWith {};
   
   _pos = getPosATL _dog;
   _nextSniffingPoint = [_pos] call GRAD_dog_getNextPoint;

   
   // diag_log format ["_nextSniffingPoint is %1",_nextSniffingPoint];

	if (_nextSniffingPoint select 0 != 0) exitWith { 

		diag_log format ["_nextSniffingPoint is %1", _nextSniffingPoint];
		_target = "Sign_Arrow_Direction_F" createVehiclelocal _pos;
	    _target setPos _pos;
	    _target setDir (getDir _dog);
		
		// _dog setDir (_dog getRelDir _nextSniffingPoint);
		[_dog, _nextSniffingPoint] call GRAD_dog_sprintOrder;
		
	};

	/*
	_randomSearchPos = [_pos,[2,10],random 360] call SHK_pos;
	// _dog stop false;
	_dog moveTo _pos;
	_dog playMove "Dog_Run";
	[_dog] spawn {
			params ["_dog"];
			sleep 5;
			_dog setVariable ["GRAD_dogs_taskDone",true];
		};
	*/
};

GRAD_dog_regroup = {
	params ["_dog"];

	if (_dog distance prey < 2) exitWith {
		_dog setVariable ["GRAD_dogs_nextTask","idle"];
		_dog playMove "Dog_Idle_Stop";
		
	};

	// _dog setDir (_dog getRelDir player);
	// _dog stop false;
	_dog moveTo (getPos prey);
	_dog playMove "Dog_Run";
	
};

GRAD_dog_idle = {
	params ["_dog"];
	
	_dog playMove "Dog_Idle_Stop";
	// _dog stop true;
	 doStop _dog;
	_dog setVariable ["GRAD_dogs_taskDone",true];
	// _dog disableAI "MOVE";
};

GRAD_dogs_brainMainDecision = {
	params ["_dog"];

	_currentTask = _dog getVariable ["GRAD_dogs_currentTask","none"];
	_nextTask = _dog getVariable ["GRAD_dogs_nextTask","none"];

	if (_currentTask != _nextTask) then {
		_dog setVariable ["GRAD_dogs_currentTask",_nextTask];
		_currentTask = _nextTask; // also in local scope
	};

	
	switch (_currentTask) do {
		case "none": { [_dog] call GRAD_dog_idle; diag_log format ["SWITCH TASK DEFAULT... idle"]; };
		case "regroup": {  [_dog] call GRAD_dog_regroup; diag_log format ["SWITCH TASK ... regrouping"];};
		case "sniff_advance": {  [_dog] call GRAD_dog_sniff_advance; diag_log format ["SWITCH TASK ... sniff advance"];};
		case "sniff_return": { [_dog] call GRAD_dog_sniff_return; diag_log format ["SWITCH TASK ... sniff return"];};
		case "idle": { [_dog] call GRAD_dog_idle; diag_log format ["SWITCH TASK ... idle"];};
		case "attack": { [_dog] call GRAD_dog_attack; diag_log format ["SWITCH TASK ... attack"];};
		default { [_dog] call GRAD_dog_idle; diag_log format ["SWITCH TASK DEFAULT... idle"]; };
	};
	
};

trail = []; // [] call CBA_fnc_hashCreate;

// TRAIL CREATION LOOP
[{
   (_this select 0) params ["_prey"];
   if (!alive _prey) exitWith {(_this select 1) call CBA_fnc_removePerFrameHandler;};
   
   _pos = getPosATL _prey;

    _sniffPoint = "Sign_Arrow_Large_Cyan_F" createVehiclelocal _pos;
    _sniffPoint setPos _pos;
    _sniffPoint setVariable ["dropTime",time];
    _sniffPoint setVariable ["dropStrength",1];
   

	trail pushBack _sniffPoint;
}, _trackingInterval, [_prey]] call CBA_fnc_addPerFrameHandler;




// DOG MAIN LOOP
[{
   (_this select 0) params ["_dog"];
   if (!alive _dog) exitWith {(_this select 1) call CBA_fnc_removePerFrameHandler;};
   
   [_dog] call GRAD_dogs_brainMainDecision;

}, _dogBrainInterval, [_dog]] call CBA_fnc_addPerFrameHandler;
