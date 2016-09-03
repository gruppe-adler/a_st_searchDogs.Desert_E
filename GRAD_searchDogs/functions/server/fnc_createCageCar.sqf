// needs vanilla offroad

params ["_pos"];

_veh = "C_Offroad_01_F" createVehicle _pos;

_veh setVariable ["BIS_enableRandomization", false];
_veh animate ["hideServices", 1];
_veh animate ["hideDoor1", 1];
_veh animate ["hideDoor2", 1];
_veh animate ["hideDoor3", 1];
_veh animate ["hideGlass1", 1];
_veh animate ["hideGlass2", 1];
_veh animate ["hideBackpacks", 0];
_veh animate ["hideBumper1", 1];
_veh lockCargo [2,true];
_veh lockCargo [3,true];
_veh lockCargo [4,true];
_veh setObjectTextureGlobal [0,"a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa"];


_cage = "Land_cages_EP1" createVehicle [0,0,0];
_cage attachTo [_veh, [-0.05,-1.6,-0.1]];

// rotate cage yaw and pitch
_y = 90; _p = -90; _r = 0;
_cage setVectorDirAndUp [
	[ sin _y * cos _p,cos _y * cos _p,sin _p],
	[ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
];

_veh

