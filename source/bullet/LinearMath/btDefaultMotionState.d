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

module bullet.LinearMath.btDefaultMotionState;

import bullet.bindings.bindings;
public import bullet.LinearMath.btTransform;
public import bullet.LinearMath.btMotionState;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btDefaultMotionState.h>");

		btDefaultMotionState.writeBindings(f);
	}
}

struct btDefaultMotionState
{
	mixin classChild!("btDefaultMotionState", btMotionState);

	mixin opNew!();
	mixin opNew!(ParamRefConst!btTransform);

	//mixin method!(void, "getWorldTransform", ParamRef!btTransform);
}
