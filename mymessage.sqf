_title = if (count _this > 0) then { _this select 0 } else { exit; };
_text = if (count _this > 1) then { _this select 1 } else { exit; };

_titlesize = if (count _this > 2) then { _this select 2 } else {1;};
_textsize = if (count _this > 3) then { _this select 3 } else {1;};

_titlecolor = if (count _this > 4) then { _this select 4 } else {"#ffffff";};
_textcolor = if (count _this > 5) then { _this select 5 } else {"#ffffff";};

_titlealign = if (count _this > 6) then { _this select 6 } else {"center";};
_textalign = if (count _this > 7) then { _this select 7 } else {"center";};

_silent = if (count _this > 8) then { _this select 8 } else {true;};


_titleout = Format ["<t color='%3' size='%2' align='%4'>%1</t><br/><br/>", _title, _titlesize, _titlecolor, _titlealign];
_textout = Format ["<t color='%3' size='%2' align='%4'>%1</t><br/><br/>", _text, _textsize, _textcolor, _textalign];

if (_silent) then { hint ""; hintSilent ""; };

hint parseText (_titleout + _textout);

sleep 10;

if (_silent) then { hint ""; hintSilent ""; };
