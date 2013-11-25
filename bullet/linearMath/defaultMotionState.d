module bullet.linearMath.defaultMotionState;

import bullet.bindings.bindings;
public import bullet.linearMath.transform;
public import bullet.linearMath.motionState;

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
	mixin bindingData;

	mixin className!"btDefaultMotionState";
	mixin classSize;
	mixin destructor;

	mixin opNew!();
	mixin opNew!(RefParam!btTransform);

	mixin method!(void, "getWorldTransform", RefParam!btTransform);
}
