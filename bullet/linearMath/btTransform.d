module bullet.LinearMath.btTransform;

import bullet.bindings.bindings;
import bullet.LinearMath.btQuaternion;
import bullet.LinearMath.btVector3;
import bullet.LinearMath.btScalar;

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

	mixin opNew!();
	mixin opNew!(ParamConst!btQuaternion, ParamConst!btVector3);

	mixin method!(void, "getOpenGLMatrix", ParamPtr!btScalar);
	mixin method!(ParamReturn!btVector3, "getOrigin");
}
