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

module bullet.LinearMath.btVector3;

import bullet.bindings.bindings;
public import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btVector3.h>");

		btVector3.writeBindings(f);
	}
}

struct btVector3
{
	mixin classBasic!"btVector3";

	mixin opNew!(btScalar, btScalar, btScalar);

	mixin method!(btScalar, "x");
	mixin method!(btScalar, "y");
	mixin method!(btScalar, "z");
	mixin method!(btScalar, "w");
}
