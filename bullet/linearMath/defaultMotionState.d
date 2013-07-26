module bullet.linearMath.defaultMotionState;

public import bullet.bindings.bindings;

public import bullet.linearMath.motionState;
public import bullet.linearMath.transform;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btDefaultMotionState.h>");

	btDefaultMotionState.writeBindings(f);
}

struct btDefaultMotionState {
	mixin subclassBinding!("btDefaultMotionState", btMotionState);

	mixin constructor!(btTransform);
}

