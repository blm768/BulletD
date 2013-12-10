module bullet.BulletCollision.CollisionShapes.btSphereShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btConvexInternalShape;
import bullet.LinearMath.btScalar;
import bullet.LinearMath.btVector3;

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
	mixin method!(void, "calculateLocalInertia", btScalar, ParamRef!btVector3);
}
