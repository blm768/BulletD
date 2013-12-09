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

		btRigidBody.btRigidBodyConstructionInfo.writeBindings(f);
		btRigidBody.writeBindings(f);
	}
}


struct btRigidBody
{
	struct btRigidBodyConstructionInfo
	{
		mixin classBasic!"btRigidBody::btRigidBodyConstructionInfo";

		mixin opNew!(btScalar, ParamPtr!btMotionState, ParamPtr!btCollisionShape, ParamConst!btVector3);
	}

	mixin classChild!("btRigidBody", btCollisionObject);

	//mixin opNew!(ParamConst!(ParamTmp!(btRigidBodyConstructionInfo)));
	mixin opNew!(ParamConst!(ParamTmp!(btRigidBodyConstructionInfo)));
}
