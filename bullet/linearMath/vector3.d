module bullet.linearMath.vector3;

public import bullet.bindings.bindings;
public import bullet.linearMath.scalar;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btVector3.h>");

	btVector3.writeBindings(f);
}

struct btVector3 {
	mixin classBinding!("btVector3");

	mixin constructor;
	//this(btScalar, btScalar, btScalar) {}
	mixin constructor!(btScalar, btScalar, btScalar);

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
}

