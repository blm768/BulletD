module bullet.linearMath.transform;

public import bullet.bindings.bindings;

public import bullet.linearMath.quaternion;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btTransform.h>");

	btTransform.writeBindings(f);
}

struct btTransform {
	mixin classBinding!"btTransform";

	mixin constructor;
	mixin constructor!(btQuaternion, btVector3);
}
