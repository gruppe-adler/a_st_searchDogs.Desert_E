params ["_prey","_trackingInterval"];

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