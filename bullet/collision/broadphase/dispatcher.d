module bullet.collision.broadphase.dispatcher;

public import bullet.bindings.bindings;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btDispatcher.h>");

	btDispatcher.writeBindings(f);
}

struct btDispatcher {
	mixin classBinding!"btDispatcher";
}

