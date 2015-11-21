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

module bullet.BulletCollision.BroadphaseCollision.btDbvtBroadphase;

import bullet.bindings.bindings;
public import bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btDbvtBroadphase.h>");

		btDbvtBroadphase.writeBindings(f);
	}
}

struct btDbvtBroadphase
{
	mixin classChild!("btDbvtBroadphase", btBroadphaseInterface);

	mixin opNew!();
}
