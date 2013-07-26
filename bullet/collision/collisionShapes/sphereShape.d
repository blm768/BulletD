module bullet.collision.collisionShapes.sphereShape;

public import bullet.bindings.bindings;

import bullet.collision.collisionShapes.collisionShape;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionShapes/btSphereShape.h>");

	btSphereShape.writeBindings(f);
}

struct btSphereShape {
	mixin subclassBinding!("btSphereShape", btCollisionShape);

	mixin constructor!(btScalar);
}

