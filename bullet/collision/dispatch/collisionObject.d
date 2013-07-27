module bullet.collision.dispatch.collisionObject;

public import bullet.bindings.bindings;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionObject.h>");

	btCollisionObject.writeBindings(f);
}

struct btCollisionObject {
	mixin classBinding!"btCollisionObject";
}

