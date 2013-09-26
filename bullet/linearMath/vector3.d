module bullet.linearMath.vector3;

public import bullet.bindings.bindings;
public import bullet.linearMath.scalar;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btVector3.h>");

	btVector3.writeBindings(f);
}

struct btVector3 {
	mixin classBinding!("btVector3");

	mixin constructor _c0;
	alias _c0.cppNew cppNew;
	mixin constructor!(btScalar, btScalar, btScalar) _c1;
	alias _c1.cppNew cppNew;

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
}

