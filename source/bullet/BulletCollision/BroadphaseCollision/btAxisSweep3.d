// BulletD - a D binding for the Bullet Physics engine
// written in the D programming language
//
// Copyright: Ben Merritt 2012 - 2013,
//            MeinMein 2013 - 2015.
// License:   Boost License 1.0
//            (See accompanying file LICENSE_1_0.txt or copy at
//             http://www.boost.org/LICENSE_1_0.txt)
// Authors:   Ben Merrit,
//            Gerbrand Kamphuis (meinmein.com),
//            Francesco Cattoglio (meinmein.com).

module bullet.BulletCollision.BroadphaseCollision.btAxisSweep3;

import bullet.bindings.bindings;
public import bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;
import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btAxisSweep3.h>");

		btAxisSweep3.writeBindings(f);
	}
}

struct btAxisSweep3
{
	mixin classChild!("btAxisSweep3", btBroadphaseInterface);

	mixin opNew!(ParamRefConst!btVector3, ParamRefConst!btVector3);
}
