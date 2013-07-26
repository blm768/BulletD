module bullet.dynamics.dynamics.discreteDynamicsWorld;

public import bullet.bindings.bindings;
public import bullet.collision.broadphase.broadphaseInterface;
public import bullet.collision.broadphase.dispatcher;
public import bullet.collision.dispatch.collisionConfiguration;
public import bullet.dynamics.constraintSolver.constraintSolver;
import bullet.dynamics.dynamics.dynamicsWorld;
public import bullet.linearMath.vector3;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h>");

	btDiscreteDynamicsWorld.writeBindings(f);
}

struct btDiscreteDynamicsWorld {
	mixin subclassBinding!("btDiscreteDynamicsWorld", btDynamicsWorld);

	mixin constructor!(btDispatcher*, btBroadphaseInterface*,
		btConstraintSolver*, btCollisionConfiguration*);

	//To do: handle default parameters?
	mixin method!(int, "stepSimulation", btScalar, btScalar, btScalar);

	mixin method!(void, "setGravity", btVector3);
}

