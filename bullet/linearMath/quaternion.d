module bullet.linearMath.quaternion;

import bullet.bindings.bindings;
public import bullet.linearMath.vector3;

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
	mixin bindingData;

	mixin className!"btQuaternion";
	mixin classSize;
	mixin destructor;

	mixin opNew!(btScalar, btScalar, btScalar, btScalar);

	mixin method!(btScalar, "getX");
	mixin method!(btScalar, "getY");
	mixin method!(btScalar, "getZ");
	mixin method!(btScalar, "getW");
}
