params ["_dog"];

private ["_currentTask", "_nextTask", "_priority"];
_dog setVariable ["showDebugInfo",true];

while {_dog getVariable ["showDebugInfo",false]} do {
	_currentTask = _dog getVariable ["GRAD_dog_currentTask","none"];
	_nextTask = _dog getVariable ["GRAD_dog_currentTask","none"];
	_priority = _dog getVariable ["GRAD_dogs_currentPriority", 0];

	hintsilent format ["
		current Task is %1<br/>
		next Task is %2<br/>
		priority is %3
		",
		_currentTask,
		_nextTask,
		_priority
	];

	sleep 1;
};