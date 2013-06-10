module bullet.collision.dispatch.collisionConfiguration;

public import bullet.bindings.bindings;

version(genBindings) static void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionConfiguration.h>");

	btCollisionConfiguration.writeBindings(f);
}

struct btCollisionConfiguration {
	mixin classBinding!"btCollisionConfiguration";
}

