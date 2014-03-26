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

module bullet.BulletCollision.CollisionDispatch.btCollisionWorld;

import bullet.bindings.bindings;
public import bullet.BulletCollision.BroadphaseCollision.btDispatcher;
public import bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;
public import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionWorld.h>");

		btCollisionWorld.writeBindings(f);
	}
}

struct btCollisionWorld
{
	mixin classBasic!"btCollisionWorld";

	mixin opNew!(ParamPtr!btDispatcher, ParamPtr!btBroadphaseInterface, ParamPtr!btCollisionConfiguration);

	mixin method!(int, "getNumCollisionObjects");
	mixin method!(void, "setForceUpdateAllAabbs", bool);
}
