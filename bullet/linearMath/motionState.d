module bullet.linearMath.motionState;

public import bullet.bindings.bindings;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btMotionState.h>");

	btMotionState.writeBindings(f);
}

struct btMotionState {
	mixin classBinding!"btMotionState";
}

