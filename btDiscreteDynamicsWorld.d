module bullet.BulletDynamics.Dynamics.btDiscreteDynamicsWorld;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h>");

		btDiscreteDynamicsWorld.writeBindings(f);
	}
}

struct btDiscreteDynamicsWorld
{
	mixin classBasic!"btDiscreteDynamicsWorld";

	mixin opNew!(ParamPtr!btDispatcher, ParamPtr!btDbvtBroadphaseInterface, ParamPtr!btConstraintSolver, ParamPtr!btCollisionConfiguration);
}
