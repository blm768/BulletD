module bullet.BulletCollision.CollisionDispatch.btCollisionDispatcher;

import bullet.bindings.bindings;
public import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionDispatcher.h>" ~"\n"~ 
						"#include <BulletCollision/CollisionDispatch/btCollisionConfiguration.h>");

		btCollisionDispatcher.writeBindings(f);
	}
}

struct btCollisionDispatcher
{
	mixin classBasic!"btCollisionDispatcher";

	mixin opNew!(ParamPtr!btCollisionConfiguration);
}
