module bullet.BulletCollision.CollisionShapes.btStaticPlaneShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btConcaveShape;
import bullet.LinearMath.btScalar;
import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btStaticPlaneShape.h>");

		btStaticPlaneShape.writeBindings(f);
	}
}

struct btStaticPlaneShape
{
	mixin classChild!("btStaticPlaneShape", btConcaveShape);

	mixin opNew!(ParamConst!btVector3, btScalar);

	mixin method!(btScalar, "getPlaneConstant");
}
