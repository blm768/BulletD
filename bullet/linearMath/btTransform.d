module bullet.LinearMath.btTransform;

import bullet.bindings.bindings;
public import bullet.LinearMath.btQuaternion;

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
	mixin classBasic!"btTransform";

	mixin opNew!(ParamConst!btQuaternion, ParamConst!btVector3);

	mixin method!(void, "getOpenGLMatrix", ParamPtr!btScalar);
}
