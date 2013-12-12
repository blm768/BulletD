module bullet.BulletCollision.BroadphaseCollision.btDispatcher;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btDispatcher.h>");

		btDispatcher.writeBindings(f);
	}
}

struct btDispatcher
{
	mixin classBasic!"btDispatcher";
}
