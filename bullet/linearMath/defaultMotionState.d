module bullet.linearMath.defaultMotionState;

import bullet.bindings.bindings;
public import bullet.linearMath.transform;

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
	mixin opNew!(RefParam!btTransform); // <- second "constructor" mixed in, without aliasing ala "alias _c1.cppNew cppNew", so cppNew is accessible

	mixin method!(void, "getWorldTransform", RefParam!btTransform);
}
