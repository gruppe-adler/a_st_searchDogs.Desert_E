	/*
*
* GRAD_searchDogs
*

dog_die, dog_bark, dog_growl, dog_walk, dog_run, dog_sprint, dog_turnl, dog_turnr, dog_sit_01 thru 08
*/

if (!isServer) exitWith {};

params ["_prey","_dog"];

diag_log format ["found prey %1 and dog %2", _prey,_dog];

// Settings
_trackingInterval = 0.1; // position of tracked guy is marked every X seconds
_searchTime = 3; // how long the dog needs to find the next node
_dogBrainInterval = 2;


/* positions are rounded to full meters, so
subtle movements are not counted to the tracking stack */

trackedPersonPath = [];


fn_findLast = {
	/*
	File:			fn_findLast.sqf
	Author:			Heeeere's Johnny!	<<< Please do not edit or remove this line. Thanks. >>>
	Version:		1.0
	Description:	Finds the last occurance of an element in a string or array.
	Execution:		call
	
	Parameters:
		0 STRING or ARRAY	_hayStack	the string or array which should be searched
		1 ANYTHING			_needle		the element whose last appearance should be found

	Return:
		INTEGER				_indexLast	index of the last appearance of needle or -1 if needle wasn't found
	*/

	private ["_hayStackCount", "_hayStackTmpIndex", "_indexLast"];
	params [["_hayStack", [], ["", []]], "_needle"];

	_hayStackCount		= count _hayStack;
	_hayStackTmpIndex	= _hayStack find _needle;
	_indexLast			= -1;

	while {_hayStackTmpIndex > -1} do
	{
		_indexLast			= _indexLast + 1 + _hayStackTmpIndex;
		_hayStackTmp		= _hayStack select [_indexLast + 1, _hayStackCount];
		_hayStackTmpIndex	= _hayStackTmp find _needle;
	};

	_indexLast	
};



GRAD_dogs_vanishTrack = {
	_maxTrailLength = 1000;
	// make track disappear
	if (count trackedPersonPath > _maxTrailLength) then {
		trackedPersonPath resize _maxTrailLength;
	};
};

getPathSmell = {
	params ["_pos"];
	
};

GRAD_dog_createSniffingRange = {
	params ["_pos"];
	_sniffingPositions = [];
	_posX = floor (_pos select 0);
	_posY = floor (_pos select 1);
	_posZ = ceil (_pos select 2);
	// positions 10m radius around dog
	{
		// diag_log format ["position %1",[(_pos select 0) + _x, _pos select 1, 0]];
		_sniffingPositions pushBack [_posX + _x, _posY, _posZ];
		_sniffingPositions pushBack [_posX, _posY + _x, _posZ];
		_sniffingPositions pushBack [_posX + _x, _posY + _x, _posZ];
		_sniffingPositions pushBack [_posX - _x, _posY + _x, _posZ];
		_sniffingPositions pushBack [_posX + _x, _posY - _x, _posZ];
		_sniffingPositions pushBack [_posX - _x, _posY - _x, _posZ];


		if (DEBUG) then {

			_1 = "Sign_Pointer_F" createVehiclelocal [_posX + _x, _posY, _posZ];
			_2 = "Sign_Pointer_F" createVehiclelocal [_posX, _posY + _x, _posZ];
			_3 = "Sign_Pointer_F" createVehiclelocal [_posX + _x, _posY + _x, _posZ];
			_4 = "Sign_Pointer_F" createVehiclelocal [_posX - _x, _posY + _x, _posZ];
			_5 = "Sign_Pointer_F" createVehiclelocal [_posX + _x, _posY - _x, _posZ];
			_6 = "Sign_Pointer_F" createVehiclelocal [_posX - _x, _posY - _x, _posZ];
			[_1,_2,_3,_4,_5,_6] spawn {
				params ["_1","_2","_3","_4","_5","_6"];
				sleep 1;
				deleteVehicle _1;
				deleteVehicle _2;
				deleteVehicle _3;
				deleteVehicle _4;
				deleteVehicle _5;
				deleteVehicle _6;
			};
		};
	} forEach [-10,-9,-8,-7,-6,-5,-4,-3,-2,-2,-1,1,2,3,4,5,6,7,8,9,10];

	_sniffingPositions
};

GRAD_dog_findPositionsInRange = {
	
};

GRAD_dog_getNextPoint = {
	params ["_pos"];
	_foundSomething = false;
	_farthestReachablePosition = [0,0,0];

	_sniffingPositions = [_pos] call GRAD_dog_createSniffingRange;

	_timeStamps = [];

	{
		_timeStampFound = [trail, _x] call CBA_fnc_hashGet;
		if (_timeStampFound > 0) then {
			diag_log format ["found a trace from %1 s ago (%2)", time - _timeStampFound, _timeStampFound];
			hintSilent format ["found a trace from %1 s ago (%2)", time - _timeStampFound, _timeStampFound];
			_timeStamps pushBack [_timeStampFound,_x];
		};
		
	} forEach _sniffingPositions;	

	if (count _timeStamps > 0) then {
		// _farthestReachablePosition = (_timeStamps select 0 call BIS_fnc_sortNum) select (count _timeStamps - 1); // sort by oldest
		_farthestReachablePosition = (_timeStamps select 0) select 1;
		_foundSomething = true;
	};

	// diag_log format ["giving back %1",_foundSomething, _farthestReachablePosition];

	[_foundSomething,_farthestReachablePosition]
};

GRAD_dog_sniff_advance = {
	params ["_dog"];
	
	
   if (!alive _dog) exitWith {};
   
   _pos = getPosATL _dog;
   _nextSniffingArray = [_pos] call GRAD_dog_getNextPoint;
   _nextSniffingPoint = (_nextSniffingArray select 1);

	if (_nextSniffingArray select 0) exitWith { 

		diag_log format ["_nextSniffingPoint is %1", _nextSniffingPoint];
		
		// _dog setDir (_dog getRelDir _nextSniffingPoint);
		_dog stop false;
		_dog moveTo _pos;
		_dog playMove "Dog_Sprint";
		[_dog] spawn {
			params ["_dog"];
			sleep 5;
			_dog setVariable ["GRAD_dogs_taskDone",true];
		};
	};

	_randomSearchPos = [_pos,[2,10],random 360] call SHK_pos;
	_dog stop false;
	_dog moveTo _pos;
	_dog playMove "Dog_Run";
	[_dog] spawn {
			params ["_dog"];
			sleep 5;
			_dog setVariable ["GRAD_dogs_taskDone",true];
		};
};

GRAD_dog_regroup = {
	params ["_dog"];

	if (_dog distance prey < 2) exitWith {
		_dog setVariable ["GRAD_dogs_nextTask","idle"];
		_dog playMove "Dog_Idle_Stop";
		
	};

	// _dog setDir (_dog getRelDir player);
	_dog stop false;
	_dog moveTo (getPos prey);
	_dog playMove "Dog_Run";
	[_dog] spawn {
			params ["_dog"];
			sleep 5;
			_dog setVariable ["GRAD_dogs_taskDone",true];
		};
};

GRAD_dog_idle = {
	params ["_dog"];
	
	_dog playMove "Dog_Idle_Stop";
	_dog stop true;
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

	if (_dog getVariable ["GRAD_dogs_taskDone",false]) then {
		_dog setVariable ["GRAD_dogs_taskDone",false];
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
};

trail = []; // [] call CBA_fnc_hashCreate;

// TRAIL CREATION LOOP
[{
   (_this select 0) params ["_prey"];
   if (!alive _prey) exitWith {(_this select 1) call CBA_fnc_removePerFrameHandler;};
   _pos = [floor (getPosATL _prey select 0), floor (getPosATL _prey select 1), ceil (getPosATL _prey select 2)];

   // [trail, _pos, floor time] call CBA_fnc_hashSet;
    _sniffPoint = "Sign_Pointer_Cyan_F" createVehiclelocal _pos;
    _sniffPoint setVariable ["dropTime",time];
    _sniffPoint setVariable ["dropStrength",1];
    if (count trail > 0) then {
    	_oldSniffPoint = trail select (count trail - 1);
    	_posBefore = getPosATL _oldSniffPoint;
    	if (_posBefore isEqualTo _pos) then {
    		_sniffPoint setVariable ["dropStrength",(_oldSniffPoint getVariable ["dropStrength",2]) + 1];
    	diag_log format ["Prey was here before, strength is now %1", _sniffPoint getVariable ["dropStrength",0]];
    	};
    };

	trail pushBack _sniffPoint;
}, _trackingInterval, [_prey]] call CBA_fnc_addPerFrameHandler;




// DOG MAIN LOOP
[{
   (_this select 0) params ["_dog"];
   if (!alive _dog) exitWith {(_this select 1) call CBA_fnc_removePerFrameHandler;};
   
   [_dog] call GRAD_dogs_brainMainDecision;

}, _dogBrainInterval, [_dog]] call CBA_fnc_addPerFrameHandler;
