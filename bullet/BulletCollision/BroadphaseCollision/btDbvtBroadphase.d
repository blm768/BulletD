module bullet.BulletCollision.BroadphaseCollision.btDbvtBroadphase;

import bullet.bindings.bindings;
public import bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;

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
	mixin classChild!("btDbvtBroadphase", btBroadphaseInterface);

	mixin opNew!();
}
