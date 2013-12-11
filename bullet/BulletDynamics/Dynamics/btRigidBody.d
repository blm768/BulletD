module bullet.BulletDynamics.Dynamics.btRigidBody;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionDispatch.btCollisionObject;
import bullet.BulletCollision.CollisionShapes.btCollisionShape;
import bullet.LinearMath.btMotionState;
import bullet.LinearMath.btVector3;
import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/Dynamics/btRigidBody.h>");

		btRigidBodyConstructionInfo.writeBindings(f);
		btRigidBody.writeBindings(f);
	}
}

// In c++ this is nested in btRigidBody, but doing that in D is more trouble than it is worth.
// Instead, just set the cppName to A::B
struct btRigidBodyConstructionInfo
{
	mixin classBasic!"btRigidBody::btRigidBodyConstructionInfo";

	mixin opNew!(btScalar, ParamPtr!btMotionState, ParamPtr!btCollisionShape, ParamConst!btVector3);
}

struct btRigidBody
{
	mixin classChild!("btRigidBody", btCollisionObject);

	mixin opNew!(ParamConst!(btRigidBodyConstructionInfo));

	mixin method!(ParamReturn!(btMotionState*), "getMotionState");
}
