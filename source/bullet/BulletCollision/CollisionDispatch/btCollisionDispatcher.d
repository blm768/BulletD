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

module bullet.BulletCollision.CollisionDispatch.btCollisionDispatcher;

import bullet.bindings.bindings;
public import bullet.BulletCollision.BroadphaseCollision.btDispatcher;
public import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionDispatcher.h>");

		btCollisionDispatcher.writeBindings(f);
	}
}

struct btCollisionDispatcher
{
	mixin classChild!("btCollisionDispatcher", btDispatcher);

	mixin opNew!(ParamPtr!btCollisionConfiguration);
}
