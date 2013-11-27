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
	mixin classParent!"btCollisionWorld";

	mixin opNew!(ParamPtr!btDispatcher, ParamPtr!btBroadphaseInterface, ParamPtr!btCollisionConfiguration);

	mixin method!(int, "getNumCollisionObjects");
}
