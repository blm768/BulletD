module bullet.BulletDynamics.ConstraintSolver.btConstraintSolver;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/ConstraintSolver/btConstraintSolver.h>");

		btConstraintSolver.writeBindings(f);
	}
}

struct btConstraintSolver
{
	mixin classParent!"btConstraintSolver";
}
