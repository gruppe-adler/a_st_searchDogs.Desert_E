params ["_dog","_dogBrainInterval"];

// DOG MAIN LOOP

[{
   (_this select 0) params ["_dog"];
   if (!alive _dog) exitWith {(_this select 1) call CBA_fnc_removePerFrameHandler;};
   if (isNil (_dog getVariable ["dogOwner",nil])) exitWith {(_this select 1) call CBA_fnc_removePerFrameHandler;};
  
   [_dog] call fnc_dogBrain_mainLoop;

}, _dogBrainInterval, [_dog]] call CBA_fnc_addPerFrameHandler;