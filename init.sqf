DEBUG = true;

call compile preprocessfile "SHK_pos\shk_pos_init.sqf";

if (isServer) then {
	call compile preprocessFileLineNumbers "GRAD_searchDogs\initDogs.sqf";
};