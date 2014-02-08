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

module bullet.LinearMath.btTransform;

import bullet.bindings.bindings;
import bullet.LinearMath.btQuaternion;
import bullet.LinearMath.btVector3;
import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btTransform.h>");

		btTransform.writeBindings(f);
	}
}

struct btTransform
{
	mixin classBasic!"btTransform";

	mixin opNew!();
	mixin opNew!(ParamRefConst!btQuaternion, ParamRefConst!btVector3);

	mixin method!(void, "getOpenGLMatrix", ParamPtr!btScalar);
	mixin method!(ParamReturn!btVector3, "getOrigin");
}
