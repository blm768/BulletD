module bullet.collision.broadphase.dbvt;

import bullet.collision.broadphase.broadphaseInterface;

version(genBindings) {
	static void writeBindings(File f) {
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btDbvt.h>");

		btDbvt.writeBindings(f);
	}
}

struct btDbvt {
	mixin subclassBinding!("btDbvt", btBroadphaseInterface);

	mixin constructor!();
}

