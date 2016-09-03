params ["_dog"];

_moves = [
	"Dog_Idle_Stop",
	"Dog_Sit"
];

_dog playMove (selectRandom _moves);

doStop _dog;