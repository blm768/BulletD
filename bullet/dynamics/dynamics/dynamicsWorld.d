module bullet.dynamics.dynamics.dynamicsWorld;

public import bullet.bindings.bindings;
import bullet.collision.dispatch.collisionWorld;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletDynamics/Dynamics/btDynamicsWorld.h>");

	btDynamicsWorld.writeBindings(f);
}

struct btDynamicsWorld {
	mixin subclassBinding!("btDynamicsWorld", btCollisionWorld);
}

