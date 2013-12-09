module bullet.BulletCollision.CollisionShapes.btSphereShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btConvexInternalShape;
import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btSphereShape.h>");

		btSphereShape.writeBindings(f);
	}
}

struct btSphereShape
{
	mixin classChild!("btSphereShape", btConvexInternalShape);

	mixin opNew!(btScalar);

	mixin method!(btScalar, "getRadius");
}
