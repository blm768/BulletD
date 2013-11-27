module bullet.BulletDynamics.Dynamics.btDiscreteDynamicsWorld;

import bullet.bindings.bindings;
public import bullet.BulletDynamics.Dynamics.btDynamicsWorld;
public import bullet.BulletCollision.BroadphaseCollision.btDispatcher;
public import bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;
public import bullet.BulletDynamics.ConstraintSolver.btConstraintSolver;
public import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;
public import bullet.LinearMath.btVector3;

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
	mixin classChild!("btDiscreteDynamicsWorld", btDynamicsWorld);

	mixin opNew!(ParamPtr!btDispatcher, ParamPtr!btBroadphaseInterface, ParamPtr!btConstraintSolver, ParamPtr!btCollisionConfiguration);

	mixin method2!(btVector3, "getGravity");
	mixin method!(void, "setGravity", ParamConst!btVector3);
}
