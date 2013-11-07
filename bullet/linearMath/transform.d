module bullet.linearMath.transform;

import bullet.bindings.bindings;
public import bullet.linearMath.quaternion;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btTransform.h>");

		btTransform.writeBindings(f);
	}
}

struct btTransform
{
	mixin bindingData;

	mixin className!"btTransform";
	mixin classSize;
	mixin destructor;

	mixin opNew!(btQuaternion, btVector3);

	mixin method!(void, "getOpenGLMatrix", btScalar*);
}
