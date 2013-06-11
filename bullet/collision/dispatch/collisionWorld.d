module bullet.collision.dispatch.collisionWorld;

public import bullet.bindings.bindings;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionWorld.h>");

	btCollisionWorld.writeBindings(f);
}

struct btCollisionWorld {
	mixin classBinding!"btCollisionWorld";
}

