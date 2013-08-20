module bullet.linearMath.quaternion;

public import bullet.bindings.bindings;

public import bullet.linearMath.vector3;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btQuaternion.h>");

	btQuaternion.writeBindings(f);
}

struct btQuaternion {
	mixin classBinding!"btQuaternion";

	mixin(joinOverloads!(
		"constructor",
		"constructor!(btScalar, btScalar, btScalar, btScalar)",
		"constructor!(btVector3, btScalar)",
		"constructor!(btScalar, btScalar, btScalar)",
	)());
}
