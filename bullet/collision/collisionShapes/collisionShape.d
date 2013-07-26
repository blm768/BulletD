module bullet.collision.collisionShapes.collisionShape;

public import bullet.bindings.bindings;

public import bullet.linearMath.vector3;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletCollision/CollisionShapes/btCollisionShape.h>");

	btCollisionShape.writeBindings(f);
}

struct btCollisionShape {
	mixin classBinding!"btCollisionShape";
}

