module bullet.BulletCollision.CollisionShapes.btConcaveShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btCollisionShape;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btConcaveShape.h>");

		btConcaveShape.writeBindings(f);
	}
}

struct btConcaveShape
{
	mixin classChild!("btConcaveShape", btCollisionShape);
}
