module bullet.collision.collisionShapes.staticPlaneShape;

public import bullet.bindings.bindings;

import bullet.collision.collisionShapes.collisionShape;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionShapes/btStaticPlaneShape.h>");

	btStaticPlaneShape.writeBindings(f);
}

struct btStaticPlaneShape {
	mixin subclassBinding!("btStaticPlaneShape", btCollisionShape);

	mixin constructor!(btVector3, btScalar);
}

