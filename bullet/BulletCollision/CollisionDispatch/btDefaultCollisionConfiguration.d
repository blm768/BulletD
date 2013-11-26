module bullet.BulletCollision.CollisionDispatch.btDefaultCollisionConfiguration;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h>");

		btDefaultCollisionConfiguration.writeBindings(f);
		
		btDefaultCollisionConstructionInfo.writeBindings(f);
	}
}

struct btDefaultCollisionConfiguration
{
	mixin classChild!("btDefaultCollisionConfiguration", btCollisionConfiguration);

	mixin opNew!();
}

struct btDefaultCollisionConstructionInfo
{
	mixin classBasic!"btDefaultCollisionConstructionInfo";

	mixin opNew!();
}