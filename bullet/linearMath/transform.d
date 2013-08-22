module bullet.linearMath.transform;

public import bullet.bindings.bindings;

public import bullet.linearMath.quaternion;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btTransform.h>");

	btTransform.writeBindings(f);
}

struct btTransform {
	mixin classBinding!"btTransform";

	mixin constructor _c0;
	alias _c0.opCall opCall;
	alias _c0.cppNew cppNew;
	mixin constructor!(btQuaternion, btVector3) _c1;
	alias _c1.opCall opCall;
	alias _c1.cppNew cppNew;
}
