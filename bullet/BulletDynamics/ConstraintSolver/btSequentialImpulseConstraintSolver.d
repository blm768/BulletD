module bullet.BulletDynamics.ConstraintSolver.btSequentialImpulseConstraintSolver;

import bullet.bindings.bindings;
public import bullet.BulletDynamics.ConstraintSolver.btConstraintSolver;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.h>"
				~ "\n"~ "#include <BulletDynamics/ConstraintSolver/btConstraintSolver.h>");

		btSequentialImpulseConstraintSolver.writeBindings(f);
	}
}

struct btSequentialImpulseConstraintSolver
{
	mixin classChild!("btSequentialImpulseConstraintSolver", btConstraintSolver);

	mixin opNew!();
}
