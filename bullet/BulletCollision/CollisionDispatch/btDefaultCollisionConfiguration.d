module bullet.BulletCollision.CollisionDispatch.btDefaultCollisionConfiguration;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h>"
				~ "\n"~ "#include <BulletCollision/CollisionDispatch/btCollisionConfiguration.h>");

		btDefaultCollisionConstructionInfo.writeBindings(f);
		btDefaultCollisionConfiguration.writeBindings(f);
	}
}
struct btDefaultCollisionConstructionInfo
{
	mixin classBasic!"btDefaultCollisionConstructionInfo";

	mixin opNew!();
}

struct btDefaultCollisionConfiguration
{
	mixin classChild!("btDefaultCollisionConfiguration", btCollisionConfiguration);

	mixin opNew!();
	mixin opNew!(ParamConst!btDefaultCollisionConstructionInfo);
}
