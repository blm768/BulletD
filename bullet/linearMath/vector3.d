module bullet.linearMath.vector3;

import bullet.bindings.bindings;
public import bullet.linearMath.scalar;

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
	mixin bindingData;

	mixin className!"btVector3";
	mixin classSize;
	mixin destructor;

	mixin opNew!(btScalar, btScalar, btScalar);

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
}
