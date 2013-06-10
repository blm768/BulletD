module bullet.dynamics.constraintSolver.sequentialImpulseConstraintSolver;

public import bullet.bindings.bindings;
public import bullet.dynamics.constraintSolver.constraintSolver;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.h>");

	btSequentialImpulseConstraintSolver.writeBindings(f);
}

struct btSequentialImpulseConstraintSolver {
	mixin classBinding!"btConstraintSolver";
}

