module bullet.LinearMath.btDefaultMotionState;

import bullet.bindings.bindings;
public import bullet.LinearMath.btTransform;
public import bullet.LinearMath.btMotionState;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btDefaultMotionState.h>");

		btDefaultMotionState.writeBindings(f);
	}
}

struct btDefaultMotionState
{
	mixin classBasic!"btDefaultMotionState";

	mixin opNew!();
	mixin opNew!(ParamConst!btTransform);

	mixin method!(void, "getWorldTransform", ParamRef!btTransform);
}
