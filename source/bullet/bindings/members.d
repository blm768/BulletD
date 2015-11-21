// BulletD - a D binding for the Bullet Physics engine
// written in the D programming language
//
// Copyright: Ben Merritt 2012 - 2013,
//            MeinMein 2013 - 2014.
// License:   Boost License 1.0
//            (See accompanying file LICENSE_1_0.txt or copy at
//             http://www.boost.org/LICENSE_1_0.txt)
// Authors:   Ben Merrit,
//            Gerbrand Kamphuis (meinmein.com).

module bullet.bindings.members;

// Made to add getters & setters for member variables.
// Note: Will not work with classChild, because it uses
// _this, and no _this1 etc.
// Note: needs manual offset calculation.
mixin template member(T, string name, uint offset)
{
	import std.conv: to;

	//getter
	mixin(`@property ` ~ T.stringof ~ ` ` ~ name ~ `() { return (cast(` ~ T.stringof ~ `*)(_this[` ~ to!string(offset) ~ `..` ~ to!string(offset + T.sizeof) ~ `]))[0]; }`);
	// setter
	mixin(`@property void ` ~ name ~ `(` ~ T.stringof ~ ` t) { _this[` ~ to!string(offset) ~ `..` ~ to!string(offset + T.sizeof) ~ `] = (cast(ubyte*)([t]))[0..` ~ to!string(T.sizeof) ~ `]; }`);
}
