module bullet.collision.dispatch.defaultCollisionConfiguration;

import bullet.collision.dispatch.collisionConfiguration;

//To do: figure out why "static" makes this break.
version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h>");

	btDefaultCollisionConfiguration.writeBindings(f);
}

struct btDefaultCollisionConfiguration {
	mixin subclassBinding!("btDefaultCollisionConfiguration", btCollisionConfiguration);

	mixin constructor!();
}

