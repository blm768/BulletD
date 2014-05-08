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

module bullet.LinearMath.btQuaternion;

import bullet.bindings.bindings;
public import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btQuaternion.h>");

		btQuaternion.writeBindings(f);
	}
}

struct btQuaternion
{
	mixin classBasic!"btQuaternion";

	mixin opNew!(btScalar, btScalar, btScalar, btScalar);

	mixin method!(btScalar, "x");
	mixin method!(btScalar, "y");
	mixin method!(btScalar, "z");
	mixin method!(btScalar, "w");
	mixin method!(btVector3, "getAxis");
	mixin method!(btScalar, "getAngle");
}
