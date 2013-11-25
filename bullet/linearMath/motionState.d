module bullet.linearMath.motionState;

import bullet.bindings.bindings;
public import bullet.linearMath.transform;

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
	mixin bindingData;

	mixin className!"btMotionState";
	mixin classSize;
	mixin destructor;

	//mixin opNew!();
	//mixin opNew!(RefParam!btTransform); // <- second "constructor" mixed in, without aliasing ala "alias _c1.cppNew cppNew", so cppNew is accessible

	//mixin method!(void, "getWorldTransform", RefParam!btTransform);
}
