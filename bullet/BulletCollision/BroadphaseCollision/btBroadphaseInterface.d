module bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btBroadphaseInterface.h>");

		btBroadphaseInterface.writeBindings(f);
	}
}

struct btBroadphaseInterface
{
	mixin classBasic!"btBroadphaseInterface";
}
