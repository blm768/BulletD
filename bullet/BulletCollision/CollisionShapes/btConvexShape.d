module bullet.BulletCollision.CollisionShapes.btConvexShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btCollisionShape;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btConvexShape.h>");

		btConvexShape.writeBindings(f);
	}
}

struct btConvexShape
{
	mixin classChild!("btConvexShape", btCollisionShape);
}
