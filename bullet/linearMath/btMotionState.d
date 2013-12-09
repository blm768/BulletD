module bullet.LinearMath.btMotionState;

import bullet.bindings.bindings;

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
	mixin classParent!"btMotionState";
}
