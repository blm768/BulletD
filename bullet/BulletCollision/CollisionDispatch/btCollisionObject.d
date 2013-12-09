module bullet.BulletCollision.CollisionDispatch.btCollisionObject;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionObject.h>");

		btCollisionObject.writeBindings(f);
	}
}

struct btCollisionObject
{
	mixin classParent!"btCollisionObject";
}
