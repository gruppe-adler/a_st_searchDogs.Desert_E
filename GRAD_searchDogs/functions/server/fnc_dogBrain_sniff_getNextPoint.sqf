params ["_dog","_default"];
_foundSomething = false;
_foundThis = [0,0,0];

_sniffingStrength = _dog getVariable ["sniffingStrength", 20];

_timeStamps = [];

_sniffPoints = _pos nearObjects _sniffingStrength;

if (count _sniffPoints > 0) then {
	{
		if (_x isKindOf "Sign_Arrow_Large_Cyan_F" ) then {
			_timeStamps pushBack [_x,_x getVariable ["dropTime",0]];
		};
	} forEach _sniffPoints;

	if (count _timeStamps> 0) then {
		_foundSomething = true;
		// sort new to old
		_timeStamps sort false; 
		// diag_log format ["sorted: %1",_timeStamps];
		// hintSilent format ["saving arrow %1",str ((_timeStamps select 0) select 0) select 0];
		_foundThis = getPosATL ((_timeStamps select 0) select 0);
	};
};

if (!_foundSomething) then {
	_foundThis = _default;
	diag_log format ["sniff_getnextpoint falling back to %1", _foundThis];
};

_foundThis