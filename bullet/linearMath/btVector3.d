module bullet.LinearMath.btVector3;

import bullet.bindings.bindings;
public import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btVector3.h>");

		btVector3.writeBindings(f);
	}
}

struct btVector3
{
	mixin classBasic!"btVector3";

	mixin opNew!(btScalar, btScalar, btScalar);

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
}
