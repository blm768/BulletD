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
