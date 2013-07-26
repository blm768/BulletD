module bullet.linearMath.transform;

public import bullet.bindings.bindings;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <LinearMath/btTransform.h>");

	btTransform.writeBindings(f);
}

struct btTransform {
	mixin classBinding!"btTransform";

	mixin constructor;
}
