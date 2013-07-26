module bullet.linearMath.quaternion;

public import bullet.bindings.bindings;

public import bullet.linearMath.vector3;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btQuaternion.h>");

	btQuaternion.writeBindings(f);
}

struct btQuaternion {
	mixin classBinding!"btQuaternion";

	mixin constructor;
	mixin constructor!(btScalar, btScalar, btScalar, btScalar);
	mixin constructor!(btVector3, btScalar);
	mixin constructor!(btScalar, btScalar, btScalar);
}
