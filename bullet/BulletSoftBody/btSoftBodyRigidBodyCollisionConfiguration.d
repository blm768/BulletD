module bullet.BulletSoftBody.btSoftBodyRigidBodyCollisionConfiguration;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionDispatch.btDefaultCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.h>"//);
						~"\n"~ "#include <BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h>");

		btSoftBodyRigidBodyCollisionConfiguration.writeBindings(f);
	}
}

struct btSoftBodyRigidBodyCollisionConfiguration
{
	//mixin classChild!("btSoftBodyRigidBodyCollisionConfiguration", btDefaultCollisionConfiguration);
	mixin classBasic!("btSoftBodyRigidBodyCollisionConfiguration");

	mixin opNew!(ParamConst!btDefaultCollisionConstructionInfo);
}
