module bullet.LinearMath.btMotionState;

import bullet.bindings.bindings;
public import bullet.LinearMath.btTransform;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <LinearMath/btMotionState.h>");

		btMotionState.writeBindings(f);
	}
}

struct btMotionState
{
	mixin classBasic!"btMotionState";

	mixin method!(void, "getWorldTransform", ParamRef!btTransform);
}
