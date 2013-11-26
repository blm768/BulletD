module bullet.LinearMath.btQuaternion;

import bullet.bindings.bindings;
public import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btQuaternion.h>");

		btQuaternion.writeBindings(f);
	}
}

struct btQuaternion
{
	mixin classBasic!"btQuaternion";

	mixin opNew!(btScalar, btScalar, btScalar, btScalar);

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
	mixin method!(btScalar, "getW");
}
