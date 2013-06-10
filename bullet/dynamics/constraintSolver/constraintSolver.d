module bullet.dynamics.constraintSolver.constraintSolver;

public import bullet.bindings.bindings;

version(genBindings) void writeBindings(File f) {
	f.writeIncludes("#include <BulletDynamics/ConstraintSolver/btConstraintSolver.h>");

	btConstraintSolver.writeBindings(f);
}

struct btConstraintSolver {
	mixin classBinding!"btConstraintSolver";
}

