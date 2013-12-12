module bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionConfiguration.h>");

		btCollisionConfiguration.writeBindings(f);
	}
}

struct btCollisionConfiguration
{
	mixin classBasic!"btCollisionConfiguration";
}
