module bullet.BulletCollision.BroadphaseCollision.btDbvtBroadphase;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btDbvtBroadphase.h>");

		btDbvtBroadphase.writeBindings(f);
	}
}

struct btDbvtBroadphase
{
	mixin classBasic!"btDbvtBroadphase";

	mixin opNew!();
}
