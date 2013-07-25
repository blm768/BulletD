module bullet.linearMath.btVector3;

public import bullet.bindings.bindings;
public import bullet.linearMath.btScalar;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <bullet/LinearMath/btVector3.h>");

	btVector3.writeBindings(f);
}

struct btVector3 {
	mixin classBinding!("btVector3");

	mixin constructor;
	mixin constructor!(btScalar, btScalar, btScalar);

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
}

