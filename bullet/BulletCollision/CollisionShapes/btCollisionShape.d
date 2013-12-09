module bullet.BulletCollision.CollisionShapes.btCollisionShape;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btCollisionShape.h>");

		btCollisionShape.writeBindings(f);
	}
}

struct btCollisionShape
{
	mixin classParent!"btCollisionShape";
}
