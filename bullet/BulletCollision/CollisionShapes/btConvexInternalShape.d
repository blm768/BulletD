module bullet.BulletCollision.CollisionShapes.btConvexInternalShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btConvexShape;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btConvexInternalShape.h>");

		btConvexInternalShape.writeBindings(f);
	}
}

struct btConvexInternalShape
{
	mixin classChild!("btConvexInternalShape", btConvexShape);
}
