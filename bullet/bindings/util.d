module bullet.bindings.util;

public import std.algorithm;
public import std.string;

string joinOverloads(mixins ...)() pure {
	foreach(mxn; mixins) {
		pragma(msg, mxn);
	}
	return "";
}

