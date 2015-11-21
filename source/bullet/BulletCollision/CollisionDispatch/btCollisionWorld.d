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
import bullet.BulletCollision.CollisionDispatch.btCollisionObject;
import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionWorld.h>");

		btCollisionWorld.writeBindings(f);
		RayResultCallback.writeBindings(f);
		ClosestRayResultCallback.writeBindings(f);
	}
}

struct RayResultCallback
{
	mixin classBasic!"btCollisionWorld::RayResultCallback";

	mixin method!(void, "setCollisionFilterGroup", short);
	mixin method!(void, "setCollisionFilterMask", short);
	mixin method!(bool, "hasHit");
}

struct ClosestRayResultCallback
{
	mixin classChild!("btCollisionWorld::ClosestRayResultCallback", RayResultCallback);

	mixin opNew!(ParamRefConst!btVector3, ParamRefConst!btVector3);
	mixin method!(ParamReturn!btVector3, "getHitPointWorld");
	mixin method!(ParamReturn!btVector3, "getHitNormalWorld");

	mixin method!(ParamPtr!(btCollisionObject), "getCollisionObject");
}

struct btCollisionWorld
{
	mixin classBasic!"btCollisionWorld";

	mixin opNew!(ParamPtr!btDispatcher, ParamPtr!btBroadphaseInterface, ParamPtr!btCollisionConfiguration);

	mixin method!(int, "getNumCollisionObjects");
	mixin method!(void, "setForceUpdateAllAabbs", bool);
	mixin method!(void, "rayTest", ParamRefConst!btVector3, ParamRefConst!btVector3, ParamRef!RayResultCallback);
}
