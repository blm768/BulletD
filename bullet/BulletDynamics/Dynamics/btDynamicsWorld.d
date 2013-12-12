module bullet.BulletDynamics.Dynamics.btDynamicsWorld;

import bullet.bindings.bindings;
public import bullet.BulletCollision.CollisionDispatch.btCollisionWorld;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/Dynamics/btDynamicsWorld.h>");

		btDynamicsWorld.writeBindings(f);
	}
}

struct btDynamicsWorld
{
	mixin classChild!("btDynamicsWorld", btCollisionWorld);
}
