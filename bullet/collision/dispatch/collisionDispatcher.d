module bullet.collision.dispatch.collisionDispatcher;

public import bullet.bindings.bindings;
import bullet.collision.dispatch.collisionConfiguration;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionDispatcher.h>");

	btCollisionDispatcher.writeBindings(f);
}

struct btCollisionDispatcher {
	mixin classBinding!"btCollisionDispatcher";

	mixin constructor!(btCollisionConfiguration*);
}

