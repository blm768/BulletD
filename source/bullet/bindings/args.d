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

module bullet.bindings.args;

import bullet.bindings.bindings;

template argList(alias transform, size_t start, ArgTypes ...)
{
	static if(ArgTypes.length == 0)
		enum argList = "";
	else static if(ArgTypes.length == 1)
	{
		private alias transformed = transform!(ArgTypes[0]);
		enum argList = transformed ~ " a" ~ start.to!string();
	}
	else
		enum argList = argList!(transform, start, ArgTypes[0]) ~ ", " ~ argList!(transform, start + 1, ArgTypes[1 .. $]);
}

template argNames(size_t n)
{
	static if(n == 0)
		enum argNames = "";
	else static if(n == 1)
		enum argNames = "a" ~ (n - 1).to!string();
	else
		enum argNames = argNames!(n - 1) ~ ", a" ~ (n - 1).to!string();
}
