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

module bullet.LinearMath.btMotionState;

import bullet.bindings.bindings;
public import bullet.LinearMath.btTransform;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btMotionState.h>");

		btMotionState.writeBindings(f);
	}
}

struct btMotionState
{
	mixin classBasic!"btMotionState";

	mixin method!(void, "getWorldTransform", ParamRef!btTransform);
	mixin method!(void, "setWorldTransform", ParamRefConst!btTransform);
}
