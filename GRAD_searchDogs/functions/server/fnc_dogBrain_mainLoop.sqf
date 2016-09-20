params ["_dog"];

_currentTask = _dog getVariable ["GRAD_dogs_currentTask","none"];
_nextTask = _dog getVariable ["GRAD_dogs_nextTask","none"];

// 0 is highest, means nextTask kicks in instantly
_currentPriority = _dog getVariable ["GRAD_dogs_currentPriority",0];

if (_currentPriority > 0) then {
	_dog setVariable ["GRAD_dogs_currentPriority",_currentPriority - 1];
};

if (_currentTask != _nextTask) then {
	_dog setVariable ["GRAD_dogs_currentTask",_nextTask];
	_currentTask = _nextTask; 

	case "none": 			{
		_dog setVariable ["GRAD_dogs_currentPriority",9999];
	};

	case "regroup": 		{
		_dog setVariable ["GRAD_dogs_currentPriority",9999];
	};

	case "sniff_advance": 	{
		_dog setVariable ["GRAD_dogs_currentPriority",20];
	};

	case "sniff_search": 	{
		_dog setVariable ["GRAD_dogs_currentPriority",180];
	};

	case "sniff_collect": 	{ 
		_dog setVariable ["GRAD_dogs_currentPriority",60];
	};

	case "idle": 			{ 
		_dog setVariable ["GRAD_dogs_currentPriority",9999];
	};

	case "hunt":			{
		_dog setVariable ["GRAD_dogs_currentPriority",20];
	};

	case "attack":			{
		_dog setVariable ["GRAD_dogs_currentPriority",20];
	};

	case "biteJump":			{
		_dog setVariable ["GRAD_dogs_currentPriority",1];
	};

	default 				{
		diag_log format ["NO NEXT TASK FOUND ... ERROR"];
	};
};

switch (_currentTask) do {

	case "none": 			{
		[_dog] call fnc_dogBrain_idle; 
		diag_log format ["SWITCH TASK DEFAULT... idle"];
	};

	case "regroup": 		{
		[_dog] call fnc_dogBrain_regroup; 
		diag_log format ["SWITCH TASK ... regrouping"];
	};

	case "sniff_search": 	{
		[_dog] call fnc_dogBrain_sniff_search; 
		diag_log format ["SWITCH TASK ... sniff search"];
	};

	case "sniff_advance": 	{
		[_dog] call fnc_dogBrain_sniff_advance; 
		diag_log format ["SWITCH TASK ... sniff advance"];
	};

	case "sniff_collect": 	{ 
		[_dog] call fnc_dogBrain_sniff_collect; 
		diag_log format ["SWITCH TASK ... sniff collect"];
	};

	case "idle": 			{ 
		[_dog] call fnc_dogBrain_idle; 
		diag_log format ["SWITCH TASK ... idle"];
	};

	case "hunt":			{
		[_dog] call fnc_dogBrain_hunt; 
		diag_log format ["SWITCH TASK ... hunt"];
	};

	case "attack":			{
		[_dog] call fnc_dogBrain_attack; 
		diag_log format ["SWITCH TASK ... attack"];
	};

	case "biteJump":			{
		[_dog] call fnc_dogBrain_doBiteJump; 
		diag_log format ["SWITCH TASK ... bitejump"];
	};

	default 				{ 
		diag_log format ["NO CURRENT TASK FOUND ... ERROR"];
	 };
};