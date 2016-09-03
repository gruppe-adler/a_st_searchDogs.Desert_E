params ["_player","_offroad"];

[_player, _offroad] remoteExec ["fnc_getDogFromCar", 
	[2,0] select (isMultiplayer && isDedicated), 
false];