module bullet.collision.broadphase.dbvtBroadphase;

import bullet.collision.broadphase.broadphaseInterface;

version(genBindings) static void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btDbvtBroadphase.h>");

	btDbvtBroadphase.writeBindings(f);
}

struct btDbvtBroadphase {
	mixin subclassBinding!("btDbvtBroadphase", btBroadphaseInterface);

	@disable this();
	mixin newConstructor!();
}

