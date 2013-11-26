module bullet.BulletDynamics.ConstraintSolver.btSequentialImpulseConstraintSolver;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.h>");

		btSequentialImpulseConstraintSolver.writeBindings(f);
	}
}

struct btSequentialImpulseConstraintSolver
{
	mixin classBasic!"btSequentialImpulseConstraintSolver";

	mixin opNew!();
}
